# Attendee lab sheet

Run all commands from the repository root. Use branch `workshop/00-start` unless the facilitator tells you to start from a later checkpoint.

The running challenge is the same in every lab:

> Add a search box and a room filter to the Registered Teams section. Users can type text that matches a team name or topic, choose a room, and see how many teams match. Show a message when nothing matches.

## Lab 1 — Baseline and audit

Goal: see the failure before you add guidance.

### Steps

1. Open the repository in VS Code.
2. Confirm that you are on `workshop/00-start`.
3. Open Copilot Chat in agent mode.
4. Paste Prompt 1A.
5. Run the app.
6. Look at the result.
7. Do not fix the result.
8. Paste Prompt 1B.
9. Save the audit output for discussion.

### Prompt 1A — baseline

```text
Add a search box and a room filter to the Registered Teams section of the
dashboard. Users must be able to type text that matches a team name or topic,
pick a room from a dropdown, and see a count of matching teams. Show a message
when nothing matches.
```

Run the app after the agent stops.

```sh
npm run dev
```

Record what went wrong. Look for undeclared classes, lost `$ ` labels, added dependencies, and invented validation commands.

### Prompt 1B — audit

```text
You are auditing this repository for AI readiness. Do not change any files.

Answer these questions with file and line evidence:
1. Which CSS framework does this project use? Prove it from package.json.
2. List every class name used in src/App.jsx that is NOT declared in src/App.css.
3. src/index.css and src/App.css both set :root. Which values conflict, and
   which file wins at runtime? Explain why.
4. Which command runs the tests?
5. Does the value of `base` in vite.config.js match the repository name?
6. Name three statements in README.md that the code contradicts.
7. Run `npm run lint`. Does it pass on a clean checkout? If not, quote each
   error. Were these errors caused by your change, or were they already there?

Return a table: Question | Answer | Evidence | Risk to an AI agent.
```

### Discussion

- Did Copilot use CSS classes that do not exist?
- Did it keep the `$ ` label prefix?
- Did it add a dependency?
- Did it invent a test command?
- Did lint fail before your change?

A validation command must be green before you tell an agent to trust it. This is a general AI-readiness rule. If the baseline is red, the agent cannot know whether it caused the error.

## Lab 2 — Instructions

Goal: remove confusing noise, then add stable repository facts.

### Part A — reduce noise

Do these edits by hand.

1. Fix `base` in `vite.config.js` to `'/hackathon-dashboard-lab/'`.
2. Delete `src/assets/react.svg`.
3. Correct the three false statements in `README.md`.
4. Make `npm run lint` pass. Remove the unused `createRoot` import in `src/App.jsx`, and change `catch (error)` to `catch` in `useKV` where the binding is unused.

Run lint after the edits.

```sh
npm run lint
```

Do not add an instruction that says to trust lint until lint is green.

### Part B — create repo-wide instructions

Create `.github/copilot-instructions.md`.

```markdown
# Hackathon Dashboard

A single-page React dashboard that tracks hackathon teams and a countdown
timer. It is built as a static site and deployed to GitHub Pages.

## Stack

- React 19 with plain JavaScript and JSX. There is no TypeScript here.
- Vite 7 for the dev server and the build.
- `@phosphor-icons/react` for all icons.
- Hand-written CSS in `src/App.css`. There is no Tailwind, no CSS framework,
  and no CSS-in-JS.

## Commands

- `npm install` installs the dependencies.
- `npm run dev` starts the dev server.
- `npm run build` writes the static site to `dist/`.
- `npm run lint` runs ESLint. Always run it before you finish.

There is no test runner in this repository. Do not add a test command and do
not import a test library unless you are asked to set up testing.

## Layout

- `src/main.jsx` mounts the application.
- `src/App.jsx` holds every component: `useKV`, `formatTime`,
  `CountdownTimer`, `TeamForm`, and `App`.
- `src/App.css` holds all application styling and all design tokens.
- `src/index.css` holds leftover Vite template styles. Do not add rules to it.
- `docs/design-system.md` describes the visual language. Read it before you
  change the interface.
- `.github/workflows/deploy.yml` builds and deploys to GitHub Pages.

## Styling rules

The utility class names in `src/App.css` look like Tailwind, but Tailwind is
not installed. Only the classes declared in `src/App.css` exist. Any other
utility class renders with no style.

Confirm that a class is declared in `src/App.css` before you use it. Add a new
utility or component style to `src/App.css` first if you need one.

## Product conventions

- The interface uses a CRT terminal look. Keep it.
- Button labels start with a shell prompt, for example `$ new-team`.
- Every control has visible text or an `aria-label`.
- Persist state with the `useKV` hook in `src/App.jsx`. Do not add a second
  storage helper.

## Constraints

- Do not edit `package-lock.json` by hand. Change dependencies with npm.
- Do not edit `.github/workflows/deploy.yml`, `CODEOWNERS`, or `LICENSE`.
- Give a reason in your summary before you add a dependency.
```

### Part C — create JSX instructions

Create `.github/instructions/jsx-components.instructions.md`.

```markdown
---
applyTo: "src/**/*.jsx"
---

- Use function components and hooks. Do not add class components.
- Import icons from `@phosphor-icons/react`. Do not add a second icon package.
- Compute derived values, such as a filtered list, during render. Do not copy
  them into `useState`.
- Give every interactive element an accessible name. Use visible text, or
  `aria-label` when the control shows only an icon.
- Follow the dialog pattern already in the file: a `.dialog-overlay` that
  closes on click, wrapping a `.dialog` that calls `stopPropagation()`.
- Use only `className` values that are declared in `src/App.css`.
```

### Part D — create CSS instructions

Create `.github/instructions/styles.instructions.md`.

```markdown
---
applyTo: "src/**/*.css"
---

- Add new rules to `src/App.css`. Leave `src/index.css` unchanged.
- Use the existing colours: `#00ff41` for primary text and borders, `#00cc33`
  for secondary text, `#00ffff` for the accent, `#ff0040` for danger,
  `#000000` and `#001100` for backgrounds.
- Keep `border-radius: 0`. The design uses square corners.
- Use monospace font stacks only.
- Follow the existing names: layout utilities such as `.gap-2`, and component
  classes such as `.card`, `.btn`, `.dialog`.
- Do not add a CSS framework, a preprocessor, or a PostCSS plugin.
```

### Prompt 2C — re-run the challenge as a plan

```text
Read the repository instructions first. Then plan, but do not yet write, the
search box and room filter for the Registered Teams section.

List:
1. The file and the component that will own the filter state.
2. Every className you will use, and the line in src/App.css that declares it.
3. Every class you must add, with the CSS you will write.
4. How each new control gets an accessible name.
5. The commands you will run to validate the change.

Stop after the plan.
```

Expected result: the plan names `App.css` classes and lines, keeps the `$ ` prefix, adds no dependency, and cites `npm run lint`.

## Lab 3 — Prompt files

Goal: turn a repeated feature request into a reusable prompt.

This lab is for VS Code. Prompt files do not run on GitHub.com or in Copilot CLI.

### Steps

1. Create `.github/prompts/add-dashboard-feature.prompt.md`.
2. Paste the file content below.
3. Save the file.
4. Run Prompt 3A in Copilot Chat.
5. Check whether the agent confirms class existence before it writes code.

### File content

````markdown
---
description: Add a feature to the hackathon dashboard so that it matches the existing design system.
agent: agent
argument-hint: Describe the feature, for example "filter teams by room"
---

# Goal

Add this feature to the hackathon dashboard:

${input:feature:Describe the feature to add}

# Before you write code

1. Read [../../src/App.jsx](../../src/App.jsx). Name the component that owns
   the state you need.
2. Read [../../docs/design-system.md](../../docs/design-system.md). List the
   tokens and component classes you will reuse.
3. Search `src/App.css` for every `className` you intend to use. Confirm that
   each one is declared. Report every class you must create.

# Constraints

- Reuse the existing classes and the `useKV` hook. Do not add a dependency.
- Keep the CRT terminal look and the `$ command` label style.
- Give every new control an accessible name.
- Add new CSS to `src/App.css` only.

# Finish with

1. Run `npm run lint`. Fix everything it reports.
2. Run `npm run build`. Confirm that it succeeds.
3. A summary that lists the changed files, the classes you added, and any work
   you could not complete.
````

### Prompt 3A — run the prompt file

```text
/add-dashboard-feature a search box and a room filter for the Registered Teams section, with a live count of matching teams
```

### Check

`docs/design-system.md` does not exist yet. That is deliberate. The model should report the missing file. This sets up Lab 4.

## Lab 4 — Build the `extract-ui-design` skill

Goal: make Copilot extract the implemented design system from the code.

### Steps

1. Create this directory tree.
2. Add each file below.
3. Run Prompt 4A.
4. Start a new chat.
5. Run Prompt 4B.
6. Confirm that Copilot selects the skill from its description.

```text
.github/skills/extract-ui-design/
├── SKILL.md
├── references/
│   ├── token-categories.md
│   └── design-system-template.md
└── scripts/
    └── collect-styles.sh
```

The skill `name` must match the directory name `extract-ui-design`.

### `SKILL.md`

````markdown
---
name: extract-ui-design
description: Extracts the design system of this repository from its CSS and JSX, and writes or refreshes docs/design-system.md. Use when asked to document the UI design, extract design tokens, list the colour palette, check whether a change matches the design, or add a new visible component to the dashboard.
license: MIT
---

# Extract the UI design

Use this skill to turn the implemented styling into a written design system,
and to check new interface work against it.

## When to use this skill

- Someone asks for the design system, the design tokens, the colour palette,
  or the UI conventions.
- Someone adds or changes a visible component.
- `docs/design-system.md` is missing, or `src/App.css` changed after that
  document was last written.

## Step 1 — Collect the evidence

Run the helper script from the repository root:

```bash
bash .github/skills/extract-ui-design/scripts/collect-styles.sh
```

Read the output together with `src/App.css` and `src/index.css`. Then read
`src/App.jsx` to see which classes the components actually use.

## Step 2 — Classify what you found

Sort the results into the categories in
[references/token-categories.md](references/token-categories.md): colour,
typography, spacing, border and radius, layout utility, component class,
motion, and state.

## Step 3 — Record the unwritten conventions

Read the JSX and write down the rules that the code follows but never states.
For this repository, look for at least:

- The shell prompt prefix on button labels.
- The icon package and the default icon sizes.
- The dialog overlay and stop-propagation pattern.
- The `aria-label` rule for icon-only buttons.
- The empty-state pattern.

## Step 4 — Report conflicts

`src/index.css` and `src/App.css` both set `:root`. Record every token that
the two files define differently. State which value wins at runtime, and why.

## Step 5 — Write the document

Write `docs/design-system.md` from
[references/design-system-template.md](references/design-system-template.md).

Every token and every class you list must exist in the CSS. Do not invent a
value. Do not copy values from a public design system.

## Step 6 — Check a change

When this skill is used to review a change, list every `className` in the
diff. Mark each one `declared` or `missing` against `src/App.css`. Report
every `missing` class as a defect, because it renders with no style.
````

### `references/token-categories.md`

```markdown
# Token categories

Use these categories when you extract the design system.

- Colour: hex values and semantic class names.
- Typography: font families, sizes, weights, and line heights.
- Spacing: margin, padding, gap, width, height, and max size utilities.
- Border and radius: border width, style, colour, and radius.
- Layout utility: flex, grid, alignment, position, and responsive utilities.
- Component class: app, container, card, button, input, dialog, upload area, and progress bar classes.
- Motion: keyframes, animation names, durations, and transitions.
- State: hover, focus, disabled, active, and empty-state patterns.
```

### `references/design-system-template.md`

```markdown
# Hackathon dashboard design system

## Palette

List each colour, its purpose, and its source selector.

## Typography

List font families, sizes, weights, and line-height rules.

## Spacing

List spacing utilities and component spacing rules.

## Borders

List border widths, colours, and radius rules.

## Layout utilities

List flex, grid, alignment, position, and responsive utilities.

## Component classes

List app, header, card, button, input, dialog, upload, team grid, and progress classes.

## Motion

List animations and transitions.

## Conventions

List conventions that appear in JSX but not in CSS.

## Known conflicts

List conflicts between `src/index.css` and `src/App.css`.
```

### `scripts/collect-styles.sh`

```bash
#!/usr/bin/env bash
set -uo pipefail
ROOT="$(git rev-parse --show-toplevel)"

echo "== Declared class selectors =="
grep -hoE '^\.[a-zA-Z0-9_\\:-]+' "$ROOT"/src/*.css | sort -u

echo
echo "== Colour values, most used first =="
grep -hoE '#[0-9a-fA-F]{3,8}' "$ROOT"/src/*.css | sort | uniq -c | sort -rn

echo
echo "== Font stacks =="
grep -hn 'font-family' "$ROOT"/src/*.css

echo
echo "== Classes used in JSX =="
grep -hoE 'className="[^"]*"' "$ROOT"/src/*.jsx \
  | sed 's/className="//; s/"$//' | tr ' ' '\n' | sort -u
```

Make the script executable.

```sh
chmod +x .github/skills/extract-ui-design/scripts/collect-styles.sh
```

### Prompt 4A — run the skill

```text
Use the /extract-ui-design skill to write docs/design-system.md for this repository.
```

### Prompt 4B — prove automatic selection

Start a new chat. Paste this prompt.

```text
What colours and fonts does this dashboard use? I need to add a new card that matches.
```

### Prompt 4C — find the real defects

This is the payoff. Run the skill's checker in a terminal.

```text
Use the /extract-ui-design skill to list every CSS class that the JSX uses but the stylesheet never declares.
```

Or run the script directly:

```bash
bash .github/skills/extract-ui-design/scripts/collect-styles.sh
```

Read the `== JSX classes missing from CSS ==` section. On the start branch it reports:

```text
flex-col
min-h-[80vh]
mt-1
```

Now see the bug with your own eyes:

1. Open `src/App.jsx` and go to line 266. The upload area uses
   `className="flex flex-col items-center gap-2 text-neutral-11"`.
2. Confirm `.flex` is declared in `src/App.css` and `.flex-col` is not.
3. Run `npm run dev`. Click `$ new-team`.
4. Look at the drag-and-drop area. The icon and the label sit side by side.
   They should be stacked.

`npm run lint` passes. `npm run build` succeeds. The bug still ships.

### Prompt 4D — fix them

```text
Declare the three missing classes in src/App.css so the JSX renders as intended. Follow the existing style of the file. Then run the checker again and confirm nothing is missing.
```

### Discussion

- `description` decides selection. Write it as what plus when.
- Keep `SKILL.md` short. Push detail into `references/`.
- `allowed-tools: shell` removes a confirmation step. Only pre-approve commands you wrote and trust.
- The skill `name` must match its directory name, or the skill silently fails to load.
- A skill can carry a script. An instruction cannot.
- Instructions ask a model to be careful. A skill runs a procedure that checks.

## Lab 5 — Build the design-system reviewer agent

Goal: create a reviewer that can read and search, but cannot edit.

### Steps

1. Create `.github/agents/design-system-reviewer.agent.md`.
2. Paste the content below.
3. Run Prompt 5A against the broken Lab 1 output.
4. Read the severity table.
5. Fix only findings that are proven by file evidence.

### Agent file

```markdown
---
name: design-system-reviewer
description: Reviews interface changes in this repository against the implemented design system. Use when a change touches src/App.jsx, src/App.css, or any visible component.
tools: ["read", "search"]
---

You review interface changes in the hackathon dashboard. You do not write code
and you do not edit files.

## Method

1. Read `docs/design-system.md`. If it is missing, or older than
   `src/App.css`, say so and use `src/App.css` as the source of truth.
2. Collect every `className` value in the changed JSX.
3. Confirm that `src/App.css` declares each class. An undeclared class is a
   Critical finding, because it renders with no style.
4. Check the conventions: the `$ ` label prefix, square corners, the phosphor
   palette, monospace type, and icons from `@phosphor-icons/react`.
5. Check that every interactive element has an accessible name.
6. Check that no dependency, framework, or inline colour was added.

## Rules

- Report only what you can prove from a file. Quote the file and the line.
- Do not comment on formatting or naming taste. ESLint already covers that.
- Do not propose a redesign. Propose the smallest change that restores the
  convention.
- If you find nothing, say so in one sentence.

## Output

A Markdown table, most severe first:

| Severity | Finding | Evidence | Impact | Correction |

Severity is Critical, High, Medium, or Low.
```

### Prompt 5A — run the reviewer

```text
Use the design-system-reviewer agent to review the search and filter change on
this branch against the design system.
```

### Discussion

`tools: ["read", "search"]` makes the agent unable to edit. That is stronger than an instruction that says "do not edit".

## Lab 6 — Hooks

Goal: add a deterministic guardrail for protected files.

This lab uses Copilot CLI. Restart Copilot CLI after you add or change hooks.

### Steps

1. Create `.github/hooks/repo-policy.json`.
2. Create `scripts/copilot-hooks/protect-paths.sh`.
3. Make the script executable.
4. Restart Copilot CLI in the repository.
5. Run Prompt 6A.
6. Run Prompt 6B.
7. Read the denial message.
8. Optionally add `src/index.css` to the protected pattern.

### `.github/hooks/repo-policy.json`

```json
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "type": "command",
        "bash": "bash scripts/copilot-hooks/protect-paths.sh",
        "timeoutSec": 5
      }
    ]
  }
}
```

### `scripts/copilot-hooks/protect-paths.sh`

```bash
#!/usr/bin/env bash
# Deny agent edits to protected repository files.
# preToolUse command hooks are fail-closed, so always exit 0.
set -uo pipefail

PROTECTED='(^|/)(package-lock\.json|CODEOWNERS|LICENSE)$|(^|/)\.github/workflows/'

paths="$(node -e '
let raw = "";
process.stdin.on("data", d => raw += d);
process.stdin.on("end", () => {
  let event;
  try { event = JSON.parse(raw); } catch { process.exit(0); }
  const args = event.toolArgs ?? event.tool_input ?? {};
  const keys = ["path", "file_path", "filePath", "target", "old_path", "new_path"];
  const out = keys.filter(k => typeof args[k] === "string").map(k => args[k]);
  process.stdout.write(out.join("\n"));
});
')"

while IFS= read -r p; do
  [ -z "$p" ] && continue
  if printf '%s' "$p" | grep -Eq "$PROTECTED"; then
    printf '{"permissionDecision":"deny","permissionDecisionReason":"Repository policy protects %s. Ask a maintainer."}' "$p"
    exit 0
  fi
done <<< "$paths"

printf '{"permissionDecision":"allow"}'
```

Make the script executable.

```sh
chmod +x scripts/copilot-hooks/protect-paths.sh
```

### Prompt 6A — confirm normal work is allowed

```text
Add a short comment above the formatTime helper in src/App.jsx that explains its input and output.
```

### Prompt 6B — confirm the policy denies

```text
Bump the node-version in .github/workflows/deploy.yml from 20 to 22.
```

### Discussion

This hook inspects file-path arguments. An agent could still reach a protected file through a `bash` tool call. A production policy also matches on `toolName == "bash"` and inspects the command string.

Command `preToolUse` hooks fail closed on a non-zero exit. They fail open on timeout. A slow hook is not a security control.

## Integrated challenge

Goal: use the full AI-ready repo stack.

### Prompt

```text
Implement the team search and room filter for the Registered Teams section.
Follow the repository instructions, use any relevant skill, run npm run lint
and npm run build, then have the design-system-reviewer agent review your own
change. Fix every Critical finding it reports and summarise what is left.
```

### Check

| Layer | Evidence |
|---|---|
| Instructions | Only declared classes were used. |
| Prompt file | The class-existence check ran before code. |
| Skill | `docs/design-system.md` supplied tokens. |
| Agent | A severity table was returned. |
| Hook | Protected paths stayed unchanged. |
