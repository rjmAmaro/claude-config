#!/usr/bin/env bash
# Scan lines added on this branch (committed, staged, unstaged and untracked) for
# debugging and focus leftovers: focused or skipped tests, debuggers, stray output.
# Only added lines are checked, so existing code elsewhere doesn't produce noise.
# Portable to macOS (BSD) and Linux (GNU) tools.
#
# Usage: check_leftovers.sh [base_ref]     (default: merge-base with origin/HEAD, main, master...)
# Exit:  0 = nothing found, 1 = findings to review, 2 = could not run

set -uo pipefail

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a git repository." >&2; exit 2; }
cd "$(git rev-parse --show-toplevel)" || exit 2

base="${1:-}"
if [ -z "$base" ]; then
  for b in origin/HEAD origin/main origin/master main master origin/develop develop; do
    if git rev-parse --verify -q "$b" >/dev/null; then base="$b"; break; fi
  done
fi

mb=""
if [ -n "$base" ]; then mb=$(git merge-base HEAD "$base" 2>/dev/null || true); fi
if [ -n "$mb" ]; then
  echo "Checking lines added since $base (merge-base $(printf '%.10s' "$mb")), plus uncommitted and untracked files."
else
  mb="HEAD"
  echo "No base branch found; checking uncommitted and untracked changes only."
fi

paths=('*.rb' '*.rake' '*.erb' '*.haml' '*.slim' '*.js' '*.ts' '*.jsx' '*.tsx')

# Each added line becomes "path:line:content".
added=$(
  {
    # Working tree vs merge-base covers committed, staged and unstaged changes.
    git diff --no-color -U0 "$mb" -- "${paths[@]}" 2>/dev/null | awk '
      /^\+\+\+ / { f = substr($0, 7); next }
      /^@@ /     { match($0, /\+[0-9]+/); n = substr($0, RSTART + 1, RLENGTH - 1) + 0; next }
      /^\+/      { if (f != "dev/null") print f ":" n ":" substr($0, 2); n++; next }
    '
    # Untracked files are entirely new.
    git ls-files --others --exclude-standard -z -- "${paths[@]}" |
      while IFS= read -r -d '' f; do grep -nH '' "$f" 2>/dev/null; done
  }
)

if [ -z "$added" ]; then
  echo "No added lines to check."
  exit 0
fi

W='[^[:alnum:]_]'          # word boundary character (content is always preceded by ":")
pre='^[^:]+:[0-9]+:'       # the "path:line:" prefix
found=0

# check LABEL START_PATTERN ANY_PATTERN
#   START_PATTERN matches at the start of the line's content (after indentation); '' to skip
#   ANY_PATTERN matches anywhere in the content; '' to skip
check() {
  local label="$1" start="$2" any="$3" re="" hits
  [ -n "$start" ] && re="${pre}[[:space:]]*(${start})"
  [ -n "$any" ] && re="${re:+$re|}${pre}.*(${any})"
  hits=$(printf '%s\n' "$added" | grep -E -- "$re" || true)
  if [ -n "$hits" ]; then
    found=1
    echo
    echo "## $label"
    printf '%s\n' "$hits" | sed 's/^/  /'
  fi
}

check "Debuggers" \
  "(byebug|debugger)(${W}|$)" \
  "binding\.(pry|irb|b)(${W}|$)|save_and_open_(page|screenshot)"

check "Focused tests" \
  "(fit|fdescribe|fcontext|fspecify|fexample|fscenario|ffeature)([[:space:]]|\()" \
  "focus:[[:space:]]*true|,[[:space:]]*:focus(${W}|$)|${W}(it|describe|context|test)\.only\("

check "Skipped or pending tests" \
  "(xit|xdescribe|xcontext|xspecify|xscenario|skip|pending)(${W}|$)" \
  "skip:[[:space:]]*true|${W}(it|describe|test)\.skip\("

check "Stray output" \
  "(puts|pp|p|print)([[:space:]]|\()" \
  "console\.(log|debug)\("

check "Sleeps (prefer Capybara waiting matchers or time helpers)" \
  "sleep([[:space:]]|\()" ''

check "Unsafe-migration escapes (confirm they are intended)" '' "safety_assured"

if [ "$found" -eq 0 ]; then
  echo "Clean: no leftovers on added lines."
  exit 0
fi
echo
echo "Review each finding: remove leftovers; keep intentional ones (e.g. output in a rake task) and mention them in the report."
exit 1
