---
description: Add a dashboard feature that matches the implemented design system.
agent: agent
argument-hint: Describe the feature, for example "filter teams by room"
---

# Goal

Add this feature to the hackathon dashboard:

${input:feature:Describe the feature to add}

# Before you write code

1. Read [src/App.jsx](../../src/App.jsx). Name the component that owns the state you need.
2. Read [docs/design-system.md](../../docs/design-system.md). List the design tokens, utility classes, and component classes you will reuse.
3. Grep [src/App.css](../../src/App.css) for every `className` you intend to use. Confirm each class is declared. Report any class you must create before using it.

# Constraints

- Use React JSX and the existing `useKV` hook in [src/App.jsx](../../src/App.jsx) when state must persist.
- Reuse declared classes from [src/App.css](../../src/App.css). Add CSS there only when a class is missing.
- Do not add dependencies, frameworks, CSS-in-JS, or a second storage helper.
- Keep the CRT terminal look, square corners, monospace type, phosphor palette, and `$ command` button labels.
- Import icons only from `@phosphor-icons/react`.
- Give every new control visible text or an `aria-label`.

# Finish with

1. Run `npm run lint`. Fix everything it reports.
2. Run `npm run build`. Confirm that it succeeds.
3. Summarize the changed files, classes you added, and any work you could not complete.
