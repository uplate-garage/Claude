#!/bin/sh
# The journal's keeper has eaten an entry heading four times with the same
# insert-edit. This check has caught it every time a resolve did not.
# Run after any edit to JOURNAL.md, before any commit.
#   usage: tools/check-journal.sh <expected-heading-count>
set -e
J="$(dirname "$0")/../JOURNAL.md"
count=$(grep -c '^## ' "$J")
if [ -n "$1" ] && [ "$count" -ne "$1" ]; then
  echo "FAIL: $count headings, expected $1 — an insert has eaten its anchor" >&2
  exit 1
fi
# dates must run strictly downward (newest first)
dates=$(grep '^## ' "$J" | sed 's/^## \([0-9-]*\).*/\1/')
sorted=$(printf '%s\n' "$dates" | sort -r)
if [ "$dates" != "$sorted" ]; then
  echo "FAIL: entry dates are not in newest-first order" >&2
  exit 1
fi
echo "ok: $count nights, dates descending"
