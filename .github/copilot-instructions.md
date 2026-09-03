# Hackathon Dashboard

A single-page React dashboard tracks hackathon teams and a countdown timer. It builds as a static site and deploys to GitHub Pages.

## Stack

- Use React 19 with plain JavaScript and JSX. Do not add TypeScript.
- Use Vite 7 for the dev server, build, and preview.
- Import all icons from `@phosphor-icons/react`.
- Use hand-written CSS in `src/App.css`.
- Do not add Tailwind, a CSS framework, CSS-in-JS, a CSS preprocessor, or a PostCSS plugin.

## Commands

- `npm install` installs dependencies.
- `npm run dev` starts the dev server.
- `npm run build` writes the static site to `dist/`.
- `npm run lint` runs ESLint.
- `npm run preview` serves the built site locally.
- Run `npm run lint` before finishing code changes.
- There is no test runner and no test script.
- Do not add a test command or import a test library unless you are asked to set up testing.

## Layout

- `src/main.jsx` mounts the application.
- `src/App.jsx` is one large file. It defines `useKV`, `formatTime`, `CountdownTimer`, `TeamForm`, and `App`.
- `src/App.css` holds all application styling and design tokens.
- `src/index.css` is leftover Vite template CSS that conflicts with `src/App.css` on `:root`.
- Leave `src/index.css` unchanged. Add all new styling to `src/App.css`.
- `docs/design-system.md` describes the visual language for interface changes.
- Read `docs/design-system.md` before changing the interface.
- `.github/workflows/deploy.yml` builds and deploys to GitHub Pages.

## Styling rules

- `src/App.css` declares a partial hand-written utility set.
- The utility class names look like Tailwind, but Tailwind is not installed.
- Only classes declared in `src/App.css` exist.
- Any undeclared class renders with no style.
- Check `src/App.css` before using any `className` value.
- Add a new utility or component style to `src/App.css` before using a new class.
- Do not assume Tailwind semantics.
- `.rounded-lg` means `border-radius: 0` in this repository.
- `.h-48` means `height: 20rem` in this repository.

## Design tokens

- Use `#000000` and `#001100` for backgrounds.
- Use `#00ff41` for primary text and borders.
- Use `#00cc33` for secondary text.
- Use `#00ffff` for accents.
- Use `#ff0040` and `#ff2060` for danger states.
- Use monospace font stacks only.
- Keep `border-radius: 0` on new UI.

## Product conventions

- Keep the CRT terminal look.
- Start button labels with a shell prompt prefix, such as `$ new-team`, `$ cancel`, `$ set-time`, `$ create`, `$ update`, and `$ delete`.
- Give every interactive control visible text or an `aria-label`.
- Give icon-only buttons an `aria-label`.
- Use a `.dialog-overlay` that closes on click and wraps a `.dialog` that calls `event.stopPropagation()`.
- Persist state with the `useKV` hook in `src/App.jsx`.
- Do not add a second storage helper.

## Constraints

- Do not edit `package-lock.json` by hand.
- Change dependencies with npm.
- Do not edit `.github/workflows/deploy.yml`.
- Do not edit `CODEOWNERS`.
- Do not edit `LICENSE`.
- Explain why a dependency is needed before adding it.
