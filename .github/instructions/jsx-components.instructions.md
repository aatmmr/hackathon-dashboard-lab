---
applyTo: "src/**/*.jsx"
---

- Use function components and hooks. Do not add class components.
- Import icons from `@phosphor-icons/react`. Do not add a second icon package.
- Persist new localStorage-backed state through the `useKV` hook in `src/App.jsx`.
- Do not add another storage helper.
- Compute derived values, such as a filtered list, during render.
- Do not copy derived values into `useState`.
- Give every interactive element an accessible name.
- Use visible text when possible.
- Add `aria-label` to controls that show only an icon.
- Keep button labels in the `$ command` format.
- Follow the existing dialog pattern.
- Use a `.dialog-overlay` that closes on click and wraps a `.dialog` that calls `event.stopPropagation()`.
- Use only `className` values declared in `src/App.css`.
- Check `src/App.css` before using a class name.
