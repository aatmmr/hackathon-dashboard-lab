# Facilitator guide

Use this guide to run the 2 h 30 min workshop **Architecting the AI-Ready Repo: Preparing Codebases for Optimal GitHub Copilot Performance**.

The sample repository is `aatmmr/hackathon-dashboard-lab`. It is a React 19 and Vite 7 dashboard with plain JSX and a CRT terminal theme.

## Documents

- [Slide deck](slides.md)
- [Attendee lab sheet](labs.md)
- [Reference card](reference-card.md)
- Source plan: `/Users/aatmmr/.copilot/session-state/e3b7bdfe-6bf8-4224-a9b1-aabdf67ad547/plan.md`

## Outcomes

By the end, attendees can:

- Put stable repository facts into instructions.
- Turn repeated tasks into prompt files.
- Use skills for progressive disclosure.
- Use custom agents for role and tool limits.
- Use hooks for deterministic guardrails.
- Keep validation commands green before agents trust them.

## Agenda

| Time | Min | Block |
|---|---:|---|
| 00:00-00:07 | 7 | Welcome, outcomes, and the running challenge |
| 00:07-00:15 | 8 | How Copilot gets repository context |
| 00:15-00:25 | 10 | **Lab 1** — Baseline task and repository audit |
| 00:25-00:35 | 10 | Repo-wide and path-specific instructions |
| 00:35-00:48 | 13 | **Lab 2** — Add instructions and remove noise |
| 00:48-00:56 | 8 | Reusable prompt files |
| 00:56-01:06 | 10 | **Lab 3** — Build and run a prompt file |
| 01:06-01:16 | 10 | Break |
| 01:16-01:26 | 10 | Agent skills and progressive disclosure |
| 01:26-01:38 | 12 | **Lab 4** — Build the `extract-ui-design` skill |
| 01:38-01:48 | 10 | Custom agents and delegation |
| 01:48-02:00 | 12 | **Lab 5** — Build the design-system reviewer |
| 02:00-02:10 | 10 | Hooks, lifecycle events, and guardrails |
| 02:10-02:20 | 10 | **Lab 6** — Add a `preToolUse` hook |
| 02:20-02:25 | 5 | Integrated challenge |
| 02:25-02:30 | 5 | Distribution, governance, and close |

## Running challenge

Use the same task in every lab:

> Add a search box and a room filter to the Registered Teams section. Users can type text that matches a team name or topic, choose a room, and see how many teams match. Show a message when nothing matches.

The task is small. The result is visible. The failure is easy to explain.

## Room setup

- Use one large display for the facilitator machine.
- Open the repository in VS Code before the session starts.
- Keep a terminal open at the repository root.
- Sign in to GitHub Copilot before attendees arrive.
- Install GitHub Copilot CLI before Lab 6.
- Prepare a Codespace for attendees whose local setup fails.
- Prepare a screenshot of the broken baseline.
- Prepare a screenshot of the correct final result.
- Provide power and stable Wi-Fi.

## Attendee prerequisites

- A GitHub account with a Copilot licence.
- VS Code with current Copilot extensions.
- Git.
- Node.js 20 or later.
- GitHub Copilot CLI for Lab 6.
- A terminal.
- Basic React and JavaScript knowledge.

## Checkpoint branches

| Branch | Contains | Facilitator note |
|---|---|---|
| `workshop/00-start` | Current `main`. The app builds and runs. It has no Copilot configuration. | `npm run lint` is red on a clean checkout. It reports the unused `createRoot` import and the unused `error` catch binding in `src/App.jsx`. |
| `workshop/01-instructions` | Noise fixes plus `.github/copilot-instructions.md` and two path-specific instruction files. | Lint is green here. Use this branch if Lab 2 runs long. |
| `workshop/02-prompt` | The `add-dashboard-feature.prompt.md` prompt file. | Use VS Code. Prompt files do not run on GitHub.com or in Copilot CLI. |
| `workshop/03-skill` | The `extract-ui-design` skill plus generated `docs/design-system.md`. | The skill extracts tokens from `src/App.css` and `src/App.jsx`. Its `collect-styles.sh` script reports three classes the JSX uses but the CSS never declares: `flex-col`, `min-h-[80vh]`, and `mt-1`. Demonstrate the `flex-col` layout bug live in the upload dialog. |
| `workshop/04-agent` | The `design-system-reviewer.agent.md` custom agent. | It has read and search tools only. |
| `workshop/05-hooks` | The `repo-policy.json` hook and `protect-paths.sh` script. | Use Copilot CLI. Restart the CLI after hook changes. |
| `workshop/complete` | Search and room filter implemented, plus all configuration. | Use this branch for the final comparison. It declares `flex-col`, `mt-1`, and `min-h-screen-80` in `src/App.css`, and replaces the unusable `min-h-[80vh]` class in the JSX. |

## Repository audit at a glance

| # | Finding | Evidence | Teaching point |
|---:|---|---|---|
| 1 | No Copilot configuration | `.github/copilot-instructions.md` was deleted in commit `bf0c85b`. | The agent gets no stable repo facts. |
| 2 | Fake Tailwind | `src/App.css` declares only a small utility subset. | A model can use classes that do not exist. |
| 3 | Conflicting global styles | `src/index.css` and `src/App.css` both set `:root`. | `src/App.css` wins because `src/main.jsx` imports `src/index.css` before `src/App.jsx`. |
| 4 | Wrong deploy base path | `vite.config.js` uses `'/hackathon-dashboard/'`. | The repo name is `hackathon-dashboard-lab`. |
| 5 | Inaccurate README | It places `index.html` in `public/`, suggests `gh-pages`, and claims `.github/` has Copilot config. | Bad docs become bad prompts. |
| 6 | One large file | `src/App.jsx` holds `useKV`, `formatTime`, `CountdownTimer`, `TeamForm`, and `App`. | The agent must reason across concerns. |
| 7 | Undocumented design system | The palette, `$ ` labels, square corners, and scanlines live only in code. | Extract repeated rules into stable context. |
| 8 | No tests | `package.json` has no test script. | Do not let an agent invent commands. |
| 9 | Dead file | `src/assets/react.svg` is unused. | Remove noise before adding guidance. |
| 10 | Clean start lint is red | `workshop/00-start` has unused `createRoot` and unused `error` in `src/App.jsx`. | A validation command must be green before an agent can trust it. |
| 11 | Three classes used but never declared | `flex-col` (`src/App.jsx:266`), `min-h-[80vh]` (the `.container` div), `mt-1` (`src/App.jsx:184`). | **The strongest demo in the workshop.** `flex-col` breaks the upload area layout: the icon and label sit side by side instead of stacked. Lint passes, the build succeeds, and the bug ships. The Lab 4 skill finds all three automatically. |

## Facilitation notes

- Labs 1, 2, and 4 are the core path.
- Lab 3 can become a demonstration if time is short.
- Lab 5 can become a demonstration if time is short.
- Drop the integrated challenge first if the room falls behind.
- Say clearly that configuration syntax changes over time.
- Tell attendees to use the reference card instead of memory.
- Repeat the validation rule: a red baseline teaches agents the wrong lesson.
