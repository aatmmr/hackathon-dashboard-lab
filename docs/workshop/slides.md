# Architecting the AI-ready repo

- 2 h 30 min workshop.
- Sample: `hackathon-dashboard-lab`.
- Goal: better Copilot output.

### Speaker notes

Welcome the room. Say that this is not a prompt-writing class. It is a repository architecture class for AI tools.

---

# Outcomes

- Add stable instructions.
- Package repeat work.
- Use skills for context.
- Use agents for roles.
- Use hooks for rules.

### Speaker notes

Set the promise. Attendees will leave with files that live next to the code and can be reviewed in pull requests.

---

# The challenge

- Add team search.
- Add room filter.
- Show match count.
- Show empty state.

### Speaker notes

Use one small task all day. It is visible in the browser. It fails when the agent guesses the design system.

---

# How Copilot gets context

- User prompt.
- Open files.
- Repository files.
- Instructions.
- Skills, agents, hooks.

### Speaker notes

Explain that agents do not magically know local conventions. We make the important facts easy to find and hard to ignore.

---

# Why this repo works

- It builds.
- It is small.
- It hides strict rules.
- It rewards grounding.

### Speaker notes

The repository is intentionally hostile to an ungrounded model. It looks familiar, but the details differ from common defaults.

---

# Lab 1: baseline

- Start from `workshop/00-start`.
- Paste the task.
- Run the app.
- Do not fix it.

### Speaker notes

Let attendees see variation. Some models may do well. Keep a broken screenshot ready so the lesson does not depend on one run.

---

# Repository audit

- 1 No Copilot config.
- 2 Fake Tailwind.
- 3 Global style conflicts.
- 4 Wrong base path.
- 5 Inaccurate README.
- 6 One large file.
- 7 Design system not written.
- 8 No tests.
- 9 Dead asset.
- 10 Lint is red at start.
- 11 Three classes used but never declared.

### Speaker notes

Point to the files: `package.json`, `src/App.jsx`, `src/App.css`, `src/index.css`, `vite.config.js`, `.github/workflows/deploy.yml`, and `README.md`. Finding 10 is a general AI-readiness rule. A validation command must be green before you tell an agent to trust it. If lint is already red, the agent cannot know whether it broke the code. Finding 11 is the one to dwell on. `flex-col`, `min-h-[80vh]`, and `mt-1` appear in the JSX but in no stylesheet. The Lab 4 skill finds all three automatically.

---

# The Tailwind that is not there

- `flex-col` is used. It is not declared.
- The upload area renders in a row.
- Tailwind is not installed.
- Only declared classes exist.
- `.rounded-lg` means radius `0`.
- `.h-48` means height `20rem`.

### Speaker notes

`package.json` has React, Vite, ESLint, and Phosphor icons. It has no Tailwind package. Do not use a hypothetical example here. Open `src/App.jsx` at line 266: the upload area says `className="flex flex-col items-center gap-2 text-neutral-11"`. `.flex` is declared. `.flex-col` is not. So the icon and the label sit side by side instead of stacked. This bug is already shipped. It compiles, it passes lint, it builds, and it deploys. Show the running page.

---

# Principle: green first

- Build succeeds.
- Lint fails on start.
- Fix baseline noise.
- Then trust lint.

### Speaker notes

This is not a quirk of this repo. A red validation command trains the agent to ignore checks or spend time on unrelated errors. Make checks green before you make them mandatory.

---

# Instructions

- Store stable facts.
- Keep them near code.
- Avoid conflicts.
- Review them like code.

### Speaker notes

Instructions are good for facts that should apply across many tasks: stack, commands, layout, design rules, and constraints.

---

# Lab 2: reduce noise

- Fix Vite base.
- Remove dead SVG.
- Correct README.
- Make lint green.

### Speaker notes

This is repo hygiene before AI configuration. The new lint step removes `createRoot` from `App.jsx` and changes `catch (error)` to `catch` where the value is unused.

---

# Repo-wide instructions

- Stack facts.
- Valid commands.
- File map.
- Product rules.
- Dependency rule.

### Speaker notes

Call out two lines: there is no Tailwind, and there is no test runner. These lines prevent common and costly guesses.

---

# Path-specific instructions

- JSX rules for components.
- CSS rules for styles.
- `applyTo` selects files.
- All matches are sent.

### Speaker notes

Path-specific instructions are useful when a repo has different rules for different parts. Here, JSX and CSS need separate rules.

---

# Prompt files

- Reusable task prompt.
- Manual `/name` run.
- VS Code only here.
- Use `agent`, not `mode`.

### Speaker notes

Prompt files make a good workflow repeatable. They do not replace instructions because they must be invoked by the user.

---

# Lab 3: feature prompt

- Create one prompt file.
- Ask for class checks.
- Ask for design tokens.
- Finish with lint and build.

### Speaker notes

The prompt references `docs/design-system.md`. That file is missing at this point. The missing file sets up the next lab.

---

# Prompt file limits

- Public preview.
- Not on GitHub.com.
- Not in Copilot CLI.
- Agent Host ignores them.

### Speaker notes

If a rule must apply automatically, use instructions or a skill. If a VS Code prompt becomes important, convert it to a skill.

---

# Skills

- Automatic selection.
- Chosen by description.
- Keep `SKILL.md` short.
- Put detail in `references/`.

### Speaker notes

A skill is progressive disclosure. The model sees the description first, then reads the skill only when it fits the task.

---

# Skill structure

- `.github/skills/<name>/SKILL.md`.
- `name` must match folder.
- `description` says what and when.
- Scripts need user care.

### Speaker notes

Stress the silent failure if the skill name does not match the directory. Warn that `allowed-tools: shell` removes a confirmation step.

---

# Lab 4: extract UI design

- Collect CSS classes.
- Extract colours and fonts.
- Record conventions.
- Write design docs.
- Check changed UI.

### Speaker notes

This is the headline lab. It turns code evidence into durable context. It also detects undeclared classes in future changes.

---

# The skill pays for itself in one run

```text
== JSX classes missing from CSS ==
flex-col
min-h-[80vh]
mt-1
```

- Found on the first execution.
- No linter finds these.
- No type checker finds these.
- The build stays green.

### Speaker notes

The skill was written to document the design system. On its first run it also found three latent defects. `flex-col` breaks the upload area layout. `min-h-[80vh]` is Tailwind arbitrary-value syntax that can never work here. `mt-1` does nothing. This is the difference between an instruction and a skill. An instruction asks the model to be careful. A skill encodes a procedure that inspects the code. Ask the room which of their own repositories would pass this check.

---

# Skill safety

- Trust the description.
- Keep scripts small.
- Avoid broad tool grants.
- Review generated docs.

### Speaker notes

A skill can make agents much more effective. It can also run commands if allowed. Treat skills as code, not as notes.

---

# Custom agents

- Role plus rules.
- Tool limits.
- Optional model.
- Manual or inferred use.

### Speaker notes

A custom agent is stronger than a prompt when you need a narrow role. Tool limits are structural controls.

---

# Design-system reviewer

- Reads design docs.
- Checks classes.
- Checks conventions.
- Reports evidence.
- Does not edit.

### Speaker notes

The reviewer catches the key defect: class names in JSX that are not declared in CSS. It also checks accessible names and no new framework.

---

# Lab 5: reviewer agent

- Add the agent file.
- Use read and search only.
- Review the broken change.
- Fix only proven defects.

### Speaker notes

Compare an instruction that says "do not edit" with `tools: ["read", "search"]`. The second one makes editing unavailable.

---

# Hooks

- Run at lifecycle events.
- Enforce deterministic policy.
- Live under `.github/hooks/`.
- Use them for hard rules.

### Speaker notes

Instructions guide. Hooks gate. Use hooks for rules that must not depend on model judgment.

---

# Hook dialects

- CLI and cloud: camelCase.
- VS Code: PascalCase.
- Payload naming changes.
- Decisions differ too.

### Speaker notes

Do not mix dialects. GitHub CLI and the cloud agent use `version`, `bash`, camelCase payload, and a flat decision. VS Code uses `command`, OS keys, snake_case payload, and nested output.

---

# `preToolUse` contract

- Read JSON on stdin.
- Write one JSON object.
- Allow, ask, or deny.
- Deny needs a reason.
- Most restrictive wins.

### Speaker notes

State the failure modes. Command `preToolUse` hooks fail closed on non-zero exit. They fail open on timeout. A slow hook is not a security control.

---

# Lab 6: policy hook

- Protect lock files.
- Protect workflows.
- Restart Copilot CLI.
- Test allow and deny.

### Speaker notes

The sample hook checks file path arguments. Be honest about the limit. A production hook also inspects shell command strings.

---

# Integrated challenge

- Use all layers.
- Implement the filter.
- Run lint and build.
- Review with the agent.
- Fix Critical findings.

### Speaker notes

Use this only if time remains. It proves that instructions, prompt files, skills, agents, and hooks can work together.

---

# Distribution and governance

- Personal files.
- Repository `.github/`.
- Organization rules.
- Machine policy.
- CODEOWNERS.

### Speaker notes

Configuration must have owners. Put `.github/` under review. Use a fixed example task as a regression test for AI readiness.

---

# Close

- Put facts next to code.
- Keep checks green.
- Package repeat work.
- Gate hard rules.
- Review all config.

### Speaker notes

Close with the core message: put stable knowledge and deterministic controls next to the code. That makes the repository easier for both humans and AI agents.
