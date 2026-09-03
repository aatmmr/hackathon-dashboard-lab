# AI-ready repo reference card

Use this card when you add Copilot configuration. Do not invent syntax.

## File locations

| Feature | Location | Trigger |
|---|---|---|
| Repo-wide instructions | `.github/copilot-instructions.md` | Automatic |
| Path-specific instructions | `.github/instructions/*.instructions.md` | Automatic on `applyTo` match |
| Agent instructions | `AGENTS.md` (nearest in tree wins), or `CLAUDE.md`/`GEMINI.md` at root | Automatic |
| Prompt files | `.github/prompts/*.prompt.md` | Manual, `/name` in chat |
| Agent skills | `.github/skills/<name>/SKILL.md` | Automatic, chosen from `description` |
| Custom agents | `.github/agents/<name>.agent.md` | Manual pick or inferred |
| Hooks | `.github/hooks/*.json` | Automatic at lifecycle events |

## Surface support

| Feature | VS Code | GitHub.com | Copilot CLI |
|---|:--:|:--:|:--:|
| Custom instructions | yes | yes | yes |
| Prompt files | yes | **no** | **no** |
| Agent skills | yes | yes | yes |
| Custom agents | yes | yes | yes |
| Hooks | preview | yes | yes |

## Precedence

Highest first: personal → path-specific instructions → repo-wide instructions → agent instructions (`AGENTS.md`) → organization instructions. All applicable sets are sent.

## Frontmatter quick syntax

### Instructions

`.github/copilot-instructions.md` takes no frontmatter.

```yaml
---
applyTo: "src/**/*.jsx"
---
```

Use commas for several patterns: `applyTo: "src/**/*.jsx,src/**/*.css"`.

Optional: `excludeAgent: "code-review"` or `excludeAgent: "cloud-agent"`.

### Skill

```yaml
---
name: extract-ui-design
description: Extracts the design system from CSS and JSX. Use when asked to document UI tokens or check visible UI changes.
license: MIT
allowed-tools: shell
---
```

Required: `name` and `description`.

`name` is lowercase with hyphens. Max 64 characters. It must match the directory name, or the skill silently fails to load.

`description` is max 1024 characters. Say what the skill does and when to use it.

Optional: `license`, `allowed-tools`.

`allowed-tools` is a space-separated string. Security warning: pre-approving `shell` or `bash` removes the confirmation step and enables prompt injection.

Keep `SKILL.md` under 500 lines. Put detail in `references/`.

### Custom agent

```yaml
---
name: design-system-reviewer
description: Reviews interface changes against the implemented design system.
tools: ["read", "search"]
target: github-copilot
disable-model-invocation: false
user-invocable: true
---
```

`description` is required.

Optional: `name`, `tools`, `model`, `target`, `disable-model-invocation`, `user-invocable`.

`target` can be `vscode` or `github-copilot`.

Tool aliases: `execute` (`shell`, `Bash`), `read`, `edit`, `search` (`Grep`, `Glob`), `agent`, `web`, `todo`.

`tools: ["*"]` allows all tools. `tools: []` allows none. Body max: 30,000 characters.

### Prompt file

```yaml
---
description: Add a dashboard feature that follows the design system.
name: add-dashboard-feature
argument-hint: Describe the feature
agent: agent
model: gpt-5.4
tools: ["read", "edit", "search"]
---
```

Fields: `description`, `name`, `argument-hint`, `agent`, `model`, `tools`.

`agent` can be `ask`, `agent`, `plan`, or a custom agent name.

`mode:` is obsolete. Use `agent:`.

Variables: only `${input:name}`, `${input:name:placeholder}`, `${selection}`.

## Hooks

Hook config lives in `.github/hooks/*.json`.

### GitHub CLI and Copilot cloud agent dialect

Use camelCase events, `bash` or `powershell` keys, `"version": 1`, camelCase payload fields such as `toolName` and `toolArgs`, and a flat decision object.

```json
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      { "type": "command", "bash": "bash scripts/copilot-hooks/protect-paths.sh", "timeoutSec": 5 }
    ]
  }
}
```

Events: `sessionStart`, `sessionEnd`, `userPromptSubmitted`, `preToolUse`, `postToolUse`, `postToolUseFailure`, `agentStop`, `subagentStop`, `subagentStart`, `errorOccurred`, `preCompact`, `notification`, `permissionRequest`, `userPromptTransformed`.

`preToolUse` stdin:

```json
{ "sessionId": "...", "timestamp": "...", "cwd": "...", "toolName": "...", "toolArgs": {} }
```

Stdout is exactly one object:

```json
{ "permissionDecision": "allow", "permissionDecisionReason": "..." }
```

Shape: `{"permissionDecision":"allow"|"deny"|"ask","permissionDecisionReason":"..."}`.

Reason is required when denying.

Command `preToolUse` hooks fail closed on non-zero exit. They fail open on timeout.

Multi-hook merge: most restrictive wins. `deny` > `ask` > `allow`.

### VS Code dialect

Use PascalCase events, such as `PreToolUse`. Note the different words: `UserPromptSubmit` and `Stop`.

Use `command`, `windows`, `linux`, and `osx` keys. Do not use `version`.

Payload fields are snake_case. The decision is nested in `hookSpecificOutput`.

The event-name casing determines the payload field naming.

## Caveats

- Prompt files are public preview.
- Prompt files are not read on GitHub.com or by Copilot CLI.
- The VS Code Agent Host does not use prompt files. Convert them to skills.
- Custom agents are public preview in JetBrains, Eclipse, and Xcode.
- VS Code renamed "chat modes" to "custom agents" in 1.106.
- `.github/chatmodes/*.chatmode.md` still works, but it is legacy.
- GitHub renamed "Copilot coding agent" to "Copilot cloud agent".
- During pull-request review, Copilot reads instructions and skills from the head branch. Test configuration changes in the same PR.
