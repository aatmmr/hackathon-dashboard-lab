# Hackathon Dashboard

This project is a single-page hackathon dashboard.
It tracks registered teams and runs a countdown timer.
It builds as a static site and deploys to GitHub Pages.

## Stack

- React 19 with plain JavaScript and JSX.
- Vite 7 for the dev server and production build.
- `@phosphor-icons/react` for icons.
- ESLint 9 with a flat config in `eslint.config.js`.
- Hand-written CSS in `src/App.css`.

There is no TypeScript.
There is no CSS framework.
The utility class names in `src/App.css` look like Tailwind, but Tailwind is not installed.
Only classes declared in `src/App.css` exist.
Do not add Tailwind-style class names unless you also declare them in `src/App.css`.

## Scripts

Run these from the repository root.

- `npm run dev` starts the Vite dev server.
- `npm run build` builds the static site into `dist/`.
- `npm run lint` runs ESLint.
- `npm run preview` serves the production build locally.

There is no test script and no test runner.

## Project structure

- `index.html` — the root Vite HTML entry point.
- `public/` — static files copied as-is. It contains `hd-icon.svg`.
- `src/main.jsx` — imports global CSS and mounts the React app.
- `src/App.jsx` — contains the dashboard components, `useKV`, and the timer and team logic.
- `src/App.css` — contains the app styles, design tokens, and declared utility classes.
- `src/index.css` — contains global CSS loaded before the app.
- `eslint.config.js` — defines the ESLint 9 flat config.
- `vite.config.js` — defines the Vite config and the GitHub Pages base path.
- `.github/` — holds GitHub automation and Copilot configuration for the workshop.
- `.github/workflows/deploy.yml` — builds and deploys the site to GitHub Pages.

## Deployment

GitHub Actions deploys the site automatically.
The workflow runs on every push to `main` and on manual dispatch.
It uses Node 20, installs dependencies with `npm ci`, and builds with `npm run build`.
It configures Pages with `actions/configure-pages`.
It uploads `dist/` with `actions/upload-pages-artifact`.
It publishes the site with `actions/deploy-pages`.

The Vite base path is `'/hackathon-dashboard-lab/'`.
That lets assets load correctly at `https://aatmmr.github.io/hackathon-dashboard-lab/`.
