---
name: extract-ui-design
description: Extracts this repository's UI design system from CSS and JSX, then writes or refreshes docs/design-system.md. Use when asked to document UI design, extract design tokens, list colours, fonts, spacing, palette, component classes, conventions, review visible UI changes, or check whether a new dashboard component matches the design system.
license: MIT
---

# Extract the UI design

Use this skill to turn the implemented styling into a written design system, and
to check new interface work against it.

Workshop note: this skill intentionally does **not** set `allowed-tools`. Running
the helper script should remain an explicit terminal approval, so attendees see
the safety prompt instead of pre-approving shell access.

## When to use this skill

- Someone asks for the design system, design tokens, colour palette, typography,
  spacing, component classes, or UI conventions.
- Someone adds or changes a visible component.
- `docs/design-system.md` is missing, or `src/App.css` changed after that
  document was last written.

## Step 1 — Collect the evidence

Run the helper script from the repository root:

```bash
bash .github/skills/extract-ui-design/scripts/collect-styles.sh
```

Read the output together with `src/App.css` and `src/index.css`. Then read
`src/App.jsx` to see which classes the components actually use.

The script extracts literal `className` strings and computes JSX classes that do
not have a matching CSS class selector. It does not fully evaluate dynamic
`className={...}` expressions or template literal branches, so inspect those by
hand when they appear.

## Step 2 — Classify what you found

Sort the results into the categories in
[references/token-categories.md](references/token-categories.md): colour,
typography, spacing, border and radius, layout utility, component class, motion,
and state.

## Step 3 — Record the unwritten conventions

Read the JSX and write down the rules that the code follows but never states.
For this repository, look for at least:

- The shell prompt prefix on button labels.
- The icon package and the default icon sizes.
- The dialog overlay and stop-propagation pattern.
- The `aria-label` rule for icon-only buttons.
- The empty-state pattern.

## Step 4 — Report conflicts

`src/index.css` and `src/App.css` both set `:root`. Record every token that the
two files define differently. State which value wins at runtime, and why.

## Step 5 — Write the document

Write `docs/design-system.md` from
[references/design-system-template.md](references/design-system-template.md).

Every token and every class you list must exist in the CSS. Do not invent a
value. Do not copy values from a public design system.

## Step 6 — Check a change

When this skill is used to review a change, list every `className` in the diff.
Mark each one `declared` or `missing` against `src/App.css`. Report every
`missing` class as a defect, because it renders with no style. The fastest
check is to run `collect-styles.sh` and read its "JSX classes missing from CSS"
section.
