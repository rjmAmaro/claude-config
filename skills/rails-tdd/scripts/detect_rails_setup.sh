#!/usr/bin/env bash
# Summarize a Rails project's test setup so the TDD loop uses the right commands.
# Read-only: inspects files and git state, runs no tests and changes nothing.
#
# Usage: detect_rails_setup.sh [project_root]

set -uo pipefail

root="${1:-.}"
cd "$root" 2>/dev/null || { echo "Cannot cd into: $root" >&2; exit 1; }

lock="Gemfile.lock"

# Top-level specs in Gemfile.lock are indented by exactly four spaces: "    rspec-rails (6.1.3)"
has_gem() { [ -f "$lock" ] && grep -qE "^    $1 \(" "$lock"; }
gem_version() { [ -f "$lock" ] && sed -nE "s/^    $1 \(([^)]+)\)$/\1/p" "$lock" | head -n1; }
binstub_or() { if [ -x "bin/$1" ]; then echo "bin/$1"; else echo "bundle exec $2"; fi; }
# Portable (BSD/GNU) listing of immediate subdirectory names.
list_dirs() { local d out=""; for d in "$1"/*/; do [ -d "$d" ] && out="$out$(basename "$d") "; done; echo "$out"; }

echo "== Project =="
if [ -f config/application.rb ]; then echo "Rails app: yes"; else echo "Rails app: NOT DETECTED (no config/application.rb)"; fi
v=$(gem_version rails); [ -n "${v:-}" ] && echo "Rails: $v"
[ -f .ruby-version ] && echo "Ruby: $(tr -d '[:space:]' < .ruby-version)"
[ -f "$lock" ] || echo "Gemfile.lock: missing (run bundle install before testing)"
for f in CLAUDE.md AGENTS.md .claude/CLAUDE.md CONTRIBUTING.md docs/CONTRIBUTING.md; do
  [ -f "$f" ] && echo "Conventions file: $f (read it)"
done

echo
echo "== Test framework =="
rspec=no; minitest=no
if has_gem rspec-rails || { [ -d spec ] && [ -f spec/rails_helper.rb -o -f spec/spec_helper.rb ]; }; then rspec=yes; fi
if [ -f test/test_helper.rb ]; then minitest=yes; fi

if [ "$rspec" = yes ]; then
  cmd=$(binstub_or rspec rspec)
  echo "RSpec: yes"
  echo "  run all:   $cmd"
  echo "  run one:   $cmd spec/path/to/thing_spec.rb:LINE"
  [ -f .rspec ] && echo "  .rspec:    $(tr '\n' ' ' < .rspec)"
  [ -d spec/support ] && echo "  spec/support: $(ls spec/support | tr '\n' ' ')"
  [ -d spec ] && echo "  spec dirs: $(list_dirs spec)"
fi
if [ "$minitest" = yes ]; then
  echo "Minitest: yes"
  echo "  run all:   bin/rails test   (system tests: bin/rails test:system)"
  echo "  run one:   bin/rails test test/path/to/thing_test.rb:LINE"
  [ -d test ] && echo "  test dirs: $(list_dirs test)"
fi
if [ "$rspec" = yes ] && [ "$minitest" = yes ]; then
  echo "WARNING: both RSpec and Minitest present. Check which one new tests go into (look at recent commits)."
fi
if [ "$rspec" = no ] && [ "$minitest" = no ]; then
  echo "No test framework detected. Ask the user before setting one up."
fi

echo
echo "== Test data =="
if has_gem factory_bot_rails || has_gem factory_bot; then
  echo "FactoryBot: yes"
  for d in spec/factories test/factories; do [ -d "$d" ] && echo "  factories: $d"; done
fi
has_gem fabrication && echo "Fabrication: yes"
for d in spec/fixtures test/fixtures; do
  if [ -d "$d" ] && ls "$d"/*.yml >/dev/null 2>&1; then echo "YAML fixtures: $d"; fi
done

echo
echo "== Test helpers in bundle =="
helpers=""
for g in shoulda-matchers capybara selenium-webdriver cuprite webmock vcr timecop \
         database_cleaner-active_record database_cleaner simplecov parallel_tests \
         rspec-sidekiq pundit-matchers rails-controller-testing climate_control; do
  has_gem "$g" && helpers="$helpers $g"
done
echo "${helpers:- (none of the common ones)}"

echo
echo "== App libraries that change how you test =="
libs=""
for g in pundit cancancan devise sidekiq good_job solid_queue resque view_component \
         turbo-rails stimulus-rails graphql strong_migrations bullet paper_trail \
         discard acts_as_paranoid aasm; do
  has_gem "$g" && libs="$libs $g"
done
echo "${libs:- (none of the common ones)}"

echo
echo "== Lint =="
if has_gem standard; then echo "standardrb: $(binstub_or standardrb standardrb) <files>"; fi
if has_gem rubocop; then
  echo "rubocop: $(binstub_or rubocop rubocop) <files>"
  ext=""
  for g in rubocop-rails rubocop-rspec rubocop-performance rubocop-factory_bot rubocop-capybara; do
    has_gem "$g" && ext="$ext $g"
  done
  [ -n "$ext" ] && echo "  extensions:$ext"
fi
has_gem erb_lint && echo "erb_lint: bundle exec erb_lint <files>"
has_gem rubocop || has_gem standard || echo "No Ruby linter in bundle."

echo
echo "== Database =="
[ -f db/schema.rb ] && echo "Schema: db/schema.rb"
[ -f db/structure.sql ] && echo "Schema: db/structure.sql"
if [ -f config/database.yml ]; then
  adapter=$(grep -m1 -E '^\s*adapter:' config/database.yml | awk '{print $2}')
  [ -n "${adapter:-}" ] && echo "Adapter: $adapter"
fi
if [ -d db/migrate ]; then
  latest=$(ls db/migrate 2>/dev/null | sort | tail -n1)
  [ -n "${latest:-}" ] && echo "Latest migration: $latest"
fi

echo
echo "== Git =="
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  echo "Branch: $branch"
  default=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')
  if [ -z "${default:-}" ]; then
    for b in main master develop; do git rev-parse --verify -q "$b" >/dev/null && { default=$b; break; }; done
  fi
  [ -n "${default:-}" ] && echo "Default branch: $default"
  [ -n "${default:-}" ] && [ "$branch" = "$default" ] && echo "  -> on the default branch: create a feature branch before changing code"
  dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [ "$dirty" -gt 0 ]; then
    echo "Uncommitted changes: $dirty path(s)"
    git status --short | head -n 15 | sed 's/^/  /'
  else
    echo "Working tree: clean"
  fi
  echo "Recent branches: $(git for-each-ref --sort=-committerdate --count=5 --format='%(refname:short)' refs/heads 2>/dev/null | tr '\n' ' ')"
else
  echo "Not a git repository."
fi
