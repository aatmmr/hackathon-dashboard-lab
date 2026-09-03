#!/usr/bin/env bash
# Deny agent edits to protected repository files.
# preToolUse command hooks fail closed: if this script crashes or exits non-zero,
# Copilot denies the tool call even if stdout says allow. For that reason this
# script does not use set -e and always exits 0 on normal paths.
# Hook timeouts fail open, so keep timeoutSec low in the hook config.
#
# Limitation: this hook only inspects file-path arguments. A bash tool call such
# as sed -i or rm could still change protected files because this script does not
# parse command strings. A production policy should also check toolName == "bash"
# and inspect the command string.

allow='{"permissionDecision":"allow"}'

if ! command -v node >/dev/null 2>&1; then
  printf '%s' "$allow"
  exit 0
fi

decision="$(
node -e '
const allow = { permissionDecision: "allow" };

function output(value) {
  process.stdout.write(JSON.stringify(value));
}

function normalizeSlashes(value) {
  return value.replace(/^file:\/\//, "").replace(/\\/g, "/").replace(/\/+/g, "/");
}

function pathCandidates(value, cwd) {
  const normalized = normalizeSlashes(value.trim()).replace(/\/+$|^\s+|\s+$/g, "");
  const candidates = new Set([normalized, normalized.replace(/^\.\//, "")]);
  const root = normalizeSlashes(cwd || process.cwd()).replace(/\/+$|^\s+|\s+$/g, "");

  if (root && normalized.startsWith(root + "/")) {
    candidates.add(normalized.slice(root.length + 1));
  }

  return Array.from(candidates);
}

function isProtected(candidate) {
  const value = candidate.replace(/^\.\//, "");
  return /(^|\/)(package-lock\.json|CODEOWNERS|LICENSE)$/.test(value) ||
    /(^|\/)\.github\/workflows(\/|$)/.test(value);
}

function collectPaths(args) {
  const pathKeys = new Set(["path", "file_path", "filePath", "target", "old_path", "new_path"]);
  const paths = [];
  const seen = new Set();

  function add(value) {
    if (typeof value !== "string") return;
    const trimmed = value.trim();
    if (!trimmed || seen.has(trimmed)) return;
    seen.add(trimmed);
    paths.push(trimmed);
  }

  function addStrings(value) {
    if (typeof value === "string") {
      add(value);
      return;
    }
    if (Array.isArray(value)) {
      value.forEach(addStrings);
      return;
    }
    if (value && typeof value === "object") {
      Object.values(value).forEach(addStrings);
    }
  }

  function looksPathLike(value) {
    if (typeof value !== "string") return false;
    const trimmed = value.trim();
    if (!trimmed || /\s/.test(trimmed)) return false;
    return trimmed.startsWith("/") ||
      trimmed.startsWith("./") ||
      trimmed.startsWith("../") ||
      trimmed.startsWith("~") ||
      trimmed.includes("/") ||
      trimmed.includes("\\") ||
      ["package-lock.json", "CODEOWNERS", "LICENSE"].includes(trimmed);
  }

  function walk(value, key = "") {
    if (pathKeys.has(key)) {
      addStrings(value);
      return;
    }
    if (typeof value === "string") {
      if (looksPathLike(value)) add(value);
      return;
    }
    if (Array.isArray(value)) {
      value.forEach(item => walk(item, key));
      return;
    }
    if (value && typeof value === "object") {
      for (const [childKey, childValue] of Object.entries(value)) {
        walk(childValue, childKey);
      }
    }
  }

  walk(args);
  return paths;
}

let raw = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", chunk => { raw += chunk; });
process.stdin.on("end", () => {
  let event;
  try {
    event = JSON.parse(raw);
  } catch {
    output(allow);
    return;
  }

  const argsList = [];
  if (event && typeof event === "object") {
    if (event.toolArgs !== undefined) argsList.push(event.toolArgs);
    if (event.tool_input !== undefined) argsList.push(event.tool_input);
  }

  const cwd = event && typeof event.cwd === "string" ? event.cwd : process.cwd();
  const paths = argsList.flatMap(collectPaths);

  for (const path of paths) {
    for (const candidate of pathCandidates(path, cwd)) {
      if (isProtected(candidate)) {
        output({
          permissionDecision: "deny",
          permissionDecisionReason: `Repository policy protects ${path}. Ask a maintainer.`
        });
        return;
      }
    }
  }

  output(allow);
});
' 2>/dev/null
)"

if [ $? -ne 0 ] || [ -z "$decision" ]; then
  printf '%s' "$allow"
else
  printf '%s' "$decision"
fi

exit 0
