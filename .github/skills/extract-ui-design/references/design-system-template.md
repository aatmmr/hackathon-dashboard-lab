# Design system template

Use this template for `docs/design-system.md`. Replace prompts with facts from
`src/App.css`, `src/index.css`, and `src/App.jsx`.

## Source of truth

- State that `src/App.css` is the source for app styling.
- State that utility names look like Tailwind, but Tailwind is not installed.
- State that only declared CSS classes exist.

## Palette

List colour tokens, values, roles, and selectors that declare them.

## Typography

List the winning font stack, sizes, weights, and text rendering behaviour.

## Spacing

List declared spacing, size, and dimension utilities.

## Borders

List border widths, styles, colours, and radius.

## Layout utilities

List declared layout, grid, position, and object-fit utilities.

## Component classes

List component selectors and the visible pattern each one creates.

## Motion

List animations, transitions, and where they run.

## Conventions

List unwritten JSX conventions: labels, icons, dialogs, accessibility, and empty
states.

## Known conflicts

List conflicts between `src/index.css` and `src/App.css`. Explain which values
win at runtime and why.

## Change check

Explain how to review a UI change. Every `className` in a diff must be marked
`declared` or `missing`; every missing class is a defect.
