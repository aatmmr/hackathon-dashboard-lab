#!/usr/bin/env bash
# Build the seven workshop checkpoint branches.
#
# Each branch adds one customization layer on top of the previous one, so a
# facilitator can jump to any lab if the room falls behind.
#
# Usage, from a clean clone:
#   bash docs/workshop/create-checkpoints.sh [COMPLETE_REF] [BASE_REF]
#
#   COMPLETE_REF  the commit that holds the finished repository. Default: HEAD.
#   BASE_REF      the commit that holds the unprepared repository. Default: main.
#
# The script refuses to run when the working tree is dirty, and it refuses to
# overwrite branches that already exist. Delete them yourself first.

set -euo pipefail

SRC="${1:-HEAD}"
BASE="${2:-main}"

SRC_SHA="$(git rev-parse --verify "$SRC^{commit}")"
BASE_SHA="$(git rev-parse --verify "$BASE^{commit}")"

if [ -n "$(git status --porcelain)" ]; then
  echo "error: working tree is not clean. Commit or stash first." >&2
  exit 1
fi

BRANCHES=(
  workshop/00-start
  workshop/01-instructions
  workshop/02-prompt
  workshop/03-skill
  workshop/04-agent
  workshop/05-hooks
  workshop/complete
)

for b in "${BRANCHES[@]}"; do
  if git show-ref --verify --quiet "refs/heads/$b"; then
    echo "error: branch $b already exists. Delete it first:" >&2
    echo "  git branch -D ${BRANCHES[*]}" >&2
    exit 1
  fi
done

START_REF="$(git rev-parse --abbrev-ref HEAD)"
cleanup() { git checkout -q "$START_REF" 2>/dev/null || true; }
trap cleanup EXIT

take() { git checkout -q "$SRC_SHA" -- "$@"; }

step() {
  local branch="$1" parent="$2"
  git checkout -q -b "$branch" "$parent"
  echo "==> $branch"
}

# --- workshop/00-start -------------------------------------------------------
# The unprepared repository, exactly as it was. Lint is red here, and the JSX
# uses three classes that the CSS never declares.
git checkout -q -b workshop/00-start "$BASE_SHA"
echo "==> workshop/00-start (from $BASE)"

# --- workshop/01-instructions ------------------------------------------------
# Noise removed, and the three instruction files added.
step workshop/01-instructions workshop/00-start
take .github/copilot-instructions.md .github/instructions README.md vite.config.js
git rm -q --ignore-unmatch src/assets/react.svg

# Apply only the lint fix to src/App.jsx. The search feature stays out until the
# final branch, so this cannot simply copy the finished file.
perl -0pi -e 's/^import \{ createRoot \} from "react-dom\/client";\n//m' src/App.jsx
perl -0pi -e 's/\} catch \(error\) \{\n(\s*)return defaultValue;/} catch {\n$1return defaultValue;/' src/App.jsx

if grep -q 'createRoot' src/App.jsx; then
  echo "error: lint fix did not remove the createRoot import" >&2
  exit 1
fi

git add -A
git commit -q -m "workshop: add repository and path-specific instructions

Remove context noise and record the repository facts that Copilot needs on
every request."

# --- workshop/02-prompt ------------------------------------------------------
step workshop/02-prompt workshop/01-instructions
take .github/prompts
git commit -q -m "workshop: add the add-dashboard-feature prompt file"

# --- workshop/03-skill -------------------------------------------------------
step workshop/03-skill workshop/02-prompt
take .github/skills docs/design-system.md
git commit -q -m "workshop: add the extract-ui-design skill and the design system"

# --- workshop/04-agent -------------------------------------------------------
step workshop/04-agent workshop/03-skill
take .github/agents
git commit -q -m "workshop: add the design-system-reviewer custom agent"

# --- workshop/05-hooks -------------------------------------------------------
step workshop/05-hooks workshop/04-agent
take .github/hooks scripts
git commit -q -m "workshop: add the preToolUse repository policy hook"

# --- workshop/complete -------------------------------------------------------
# The finished state: the search feature, the CSS fixes, and the materials.
step workshop/complete workshop/05-hooks
take src docs .devcontainer
git commit -q -m "workshop: add team search and filter, and the workshop materials"

git checkout -q "$START_REF"
trap - EXIT

echo
echo "Created:"
for b in "${BRANCHES[@]}"; do
  printf '  %-28s %s\n' "$b" "$(git rev-parse --short "$b")"
done
echo
echo "Push them with:"
echo "  git push origin ${BRANCHES[*]}"
