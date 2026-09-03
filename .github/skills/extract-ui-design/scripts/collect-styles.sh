#!/usr/bin/env bash
set -uo pipefail

ROOT="$(git rev-parse --show-toplevel)"

declared_selectors() {
  grep -hoE '^[[:space:]]*\.[a-zA-Z0-9_\\:-]+' "$ROOT"/src/*.css \
    | sed -E 's/^[[:space:]]*//; s/::?(before|after)$//; s/:(hover|focus|active|disabled|focus-within|focus-visible|not)$//' \
    | sort -u
}

declared_classes() {
  declared_selectors \
    | sed 's/^\.//' \
    | sed 's/\\:/:/g' \
    | sort -u
}

used_classes() {
  grep -hoE "className=(\"[^\"]*\"|'[^']*')" "$ROOT"/src/*.jsx \
    | sed -E "s/^className=[\"']//; s/[\"']$//" \
    | tr '[:space:]' '\n' \
    | sed '/^$/d' \
    | sort -u
}

echo "== Declared class selectors =="
declared_selectors

echo
echo "== Colour values, most used first =="
grep -hoE '#[0-9a-fA-F]{3,8}' "$ROOT"/src/*.css | sort | uniq -c | sort -rn

echo
echo "== Font stacks =="
grep -Hn 'font-family' "$ROOT"/src/*.css | sed "s#$ROOT/##"

echo
echo "== Classes used in JSX =="
used_classes

echo
echo "== JSX classes missing from CSS =="
missing="$(comm -23 <(used_classes) <(declared_classes))"
if [ -n "$missing" ]; then
  printf '%s\n' "$missing"
else
  echo "(none)"
fi
