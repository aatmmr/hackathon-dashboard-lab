# Hackathon Dashboard design system

## Read this first

`src/App.css` is the source of truth for the app design.

The utility classes imitate Tailwind, but Tailwind is not installed. Only the
classes declared in the CSS exist. Any other class renders unstyled. Some names
also do not mean what Tailwind users expect:

| Class | Value in this repository |
|---|---|
| `.rounded-lg` | `border-radius: 0` |
| `.h-48` | `height: 20rem` |

Check `src/App.css` or run
`bash .github/skills/extract-ui-design/scripts/collect-styles.sh` before you use
a class.

## Known defects

This repository already proves the core workshop lesson. The code uses class
names that imitate a framework that is not installed. The code compiles, ESLint
passes, the build succeeds, and the UI is silently wrong.

Run `bash .github/skills/extract-ui-design/scripts/collect-styles.sh` and read
the "JSX classes missing from CSS" section. It currently reports:

| Class | Used at | Real consequence |
|---|---|---|
| `flex-col` | `src/App.jsx:266` — `<div className="flex flex-col items-center gap-2 text-neutral-11">` | **Visible bug.** This is the drag-and-drop upload area in `TeamForm`. `.flex` applies, `.flex-col` does not, so the Upload icon and the "Drag and drop team logo here" text lay out in a row instead of a column. |
| `min-h-[80vh]` | The main `.container` div in `App` | No minimum height is applied. The Tailwind arbitrary-value syntax `[80vh]` was never going to work without Tailwind. |
| `mt-1` | `src/App.jsx:184` — the progress-bar label row | No top margin. |

`flex-col` is the defect with a user-visible consequence. The correct fix is to
declare the three classes in `src/App.css`. Do not rename the JSX just to match
Tailwind. Add rules such as `.flex-col { flex-direction: column; }`,
`.mt-1 { margin-top: 0.25rem; }`, and a `min-height: 80vh` rule for
`min-h-[80vh]`.

## Palette

| Role | Value | Declared by |
|---|---|---|
| Background base | `#000000` | `.bg-neutral-1`, `:root`, `body`, `.header`, `.card`, `.btn`, `.input`, `.progress-bar` |
| Background raised | `#001100` | `.bg-neutral-2`, `body` radial gradient |
| Primary text and border | `#00ff41` | `.text-neutral-12`, `.border-neutral-6`, `:root`, `.header`, `.btn`, `.input`, `.progress-fill` |
| Secondary text | `#00cc33` | `.text-neutral-11`, `.card::before`, `.progress-fill` |
| Accent cyan | `#00ffff` | `.text-mint-11`, `.btn-primary`, `.input:focus`, `.textarea:focus` |
| Danger | `#ff0040` | `.text-red-9`, `.btn-danger` |
| Danger hover | `#ff2060` | `.text-red-10`, `.hover\:text-red-10` |

Other declared legacy colours still exist in CSS: `#1a1a1a`, `#525252`,
`#262626`, `#737373`, `#2563eb`, `#646cff`, `#535bf2`, `#747bff`, `#242424`,
`#213547`, `#ffffff`, and `#f9f9f9`.

## Typography

The winning global font stack is:

```css
'Courier New', 'Monaco', 'Menlo', 'Consolas', monospace
```

It is declared in `src/App.css` on `:root`.

Text uses a terminal style:

| Selector | Value |
|---|---|
| `:root` | `line-height: 1.4`, `font-weight: 400`, `text-rendering: optimizeSpeed` |
| `.font-mono` | `ui-monospace, SFMono-Regular, "SF Mono", Consolas, "Liberation Mono", Menlo, monospace` |
| `.text-sm` | `font-size: 0.875rem` |
| `.text-lg` | `font-size: 1.125rem` |
| `.text-xl` | `font-size: 1.25rem` |
| `.text-2xl` | `font-size: 1.5rem` |
| `.text-4xl` | `font-size: 2.25rem` |
| `.font-bold` | `font-weight: 700` |

Buttons, inputs, and textareas use `'Courier New', monospace`.

## Spacing

| Selector | Value |
|---|---|
| `.gap-2` | `gap: 0.5rem` |
| `.gap-4` | `gap: 1rem` |
| `.mb-2` | `margin-bottom: 0.5rem` |
| `.mb-4` | `margin-bottom: 1rem` |
| `.mb-6` | `margin-bottom: 1.5rem` |
| `.p-4` | `padding: 1rem` |
| `.p-8` | `padding: 2rem` |
| `.w-20` | `width: 5rem` |
| `.max-h-32` | `max-height: 8rem` |
| `.h-48` | `height: 20rem` |
| `.space-y-4` | `margin-top: 1rem` between children |

`#root` adds `padding: 2rem`. `.container` adds `padding: 1rem`.

## Borders

Corners are square. Keep them square.

| Selector | Value |
|---|---|
| `.rounded-lg` | `border-radius: 0` |
| `.border` | `border-width: 1px` |
| `.border-2` | `border-width: 2px` |
| `.border-dashed` | `border-style: dashed` |
| `.border-neutral-6` | `border-color: #00ff41` |

Component classes also use `border-radius: 0`: `.card`, `.btn`, `.input`,
`.input-group`, `.textarea`, `.dialog`, `.progress-bar`, and `.progress-fill`.

## Layout utilities

Declared layout utilities:

- `.flex`
- `.justify-between`
- `.justify-center`
- `.items-center`
- `.items-start`
- `.text-center`
- `.grid`
- `.grid-cols-1`
- `.md\:grid-cols-2`
- `.lg\:grid-cols-3`
- `.absolute`
- `.relative`
- `.top-2`
- `.right-2`
- `.z-10`
- `.w-full`
- `.object-cover`
- `.mx-auto`
- `.cursor-pointer`

The responsive grid classes are declared inside media queries at `768px` and
`1024px`.

## Component classes

| Selector | Pattern |
|---|---|
| `.app` | Full-page app wrapper with the scanline overlay from `.app::before` |
| `.container` | Centered content column with terminal text shadow |
| `.header` | Black terminal header with green border and glow |
| `.card` | Black bordered surface with green glow and hover lift |
| `.btn` | Uppercase terminal command button |
| `.btn-primary` | Cyan action button |
| `.btn-danger` | Red destructive button |
| `.btn-plain` | Icon-only transparent button |
| `.input` | Green terminal text input |
| `.input-group` | Icon plus input row |
| `.textarea` | Green terminal textarea |
| `.upload-area` | Drag-and-drop upload surface |
| `.dialog-overlay` | Fixed overlay that centers a dialog |
| `.dialog` | Square modal panel |
| `.dialog-header` | Modal heading block |
| `.dialog-title` | Modal title text |
| `.dialog-description` | Modal help text |
| `.dialog-footer` | Right-aligned modal actions |
| `.teams-grid` | Team card grid spacing and mobile override |
| `.progress-container` | Countdown progress wrapper |
| `.progress-bar` | Bordered progress track |
| `.progress-fill` | Green animated progress fill |

## Motion

| Motion | Where it runs |
|---|---|
| `crt-flicker` | `body` uses `animation: crt-flicker 0.15s infinite linear alternate` |
| `terminal-glow` | `.header` uses `animation: terminal-glow 3s ease-in-out infinite alternate` |
| `terminal-progress-glow` | `.progress-fill:not([style*="width: 0"])` uses `animation: terminal-progress-glow 1s ease-in-out infinite alternate` |

Cards, buttons, inputs, textareas, upload areas, and progress fills use short
CSS transitions.

## Conventions

- Button labels use a shell prompt prefix, such as `$ new-team`, `$ cancel`,
  `$ set-time`, `$ start`, `$ pause`, `$ create`, `$ update`, and `$ delete`.
- Dialog titles read like terminal commands, such as `$ set-timer --duration`,
  `$ create-team --new`, and `$ delete-team --name`.
- Icons come from `@phosphor-icons/react`. The header icon uses `size={24}`.
  The upload icon uses `size={32}`. Other icons use the package default size.
- Icon-only buttons use `aria-label`.
- Dialogs use a `.dialog-overlay` click handler to close, then a `.dialog`
  click handler with `stopPropagation()` to keep inner clicks open.
- Empty states use plain terminal copy. The team list says
  "No teams registered yet" and then points to `'$ new-team'`.

## Known conflicts

`src/index.css` and `src/App.css` both set `:root`. `src/main.jsx` imports
`./index.css` first. It then imports `./App.jsx`, and `src/App.jsx` imports
`./App.css`. The selectors have the same specificity, so the later `App.css`
rules win at runtime.

| Token | `src/index.css` | `src/App.css` | Runtime winner |
|---|---|---|---|
| `font-family` | `system-ui, Avenir, Helvetica, Arial, sans-serif` | `'Courier New', 'Monaco', 'Menlo', 'Consolas', monospace` | `src/App.css` |
| `line-height` | `1.5` | `1.4` | `src/App.css` |
| `color-scheme` | `light dark` | `dark` | `src/App.css` |
| `color` | `rgba(255, 255, 255, 0.87)` | `#00ff41` | `src/App.css` |
| `background-color` | `#242424` | `#000000` | `src/App.css` |
| `text-rendering` | `optimizeLegibility` | `optimizeSpeed` | `src/App.css` |
| `-webkit-font-smoothing` | `antialiased` | `auto` | `src/App.css` |
| `-moz-osx-font-smoothing` | `grayscale` | `auto` | `src/App.css` |

The light-mode `:root` block in `src/index.css` also sets `color: #213547` and
`background-color: #ffffff`, but it still appears before `src/App.css` in the
cascade. The terminal colours from `src/App.css` win even when the user prefers
a light colour scheme.

Generic `button` styles from `src/index.css` still exist. App buttons use `.btn`,
which is more specific and loaded later.

## Change check

For every visible UI change:

1. Run `bash .github/skills/extract-ui-design/scripts/collect-styles.sh`.
2. List every `className` in the diff.
3. Mark each class `declared` or `missing` against `src/App.css`.
4. Treat every missing class as a defect, because it renders with no style.
