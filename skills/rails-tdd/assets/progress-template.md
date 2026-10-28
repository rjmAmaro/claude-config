# <TICKET-KEY> — <ticket title>

- **Plan source:** <this conversation / path / Jira ticket>
- **Branch:** <branch name>
- **Test command:** <e.g. bundle exec rspec>  **Lint:** <e.g. bundle exec rubocop>
- **Baseline:** <green | known failures, see below> at <short sha> on <date>
- **Mode:** hitl | afk

## Acceptance criteria → tests
- [ ] AC1: <criterion> → <spec file / example>
- [ ] AC2: <criterion> → <spec file / example>

## Slices

### Slice 1 — <name> — status: <todo | in progress | done>
Goal: <one line: what works after this slice>
Outer test: <spec path, or "unit only">
Commit: <short sha, or none>
- [ ] <behavior>
- [ ] <behavior>

### Slice 2 — <name> — status: todo
Goal:
Outer test:
Commit:
- [ ] <behavior>

## Deviations from the plan
- <what changed, why, decided by me or by the user>

## Existing tests changed
- <test, why: intentional behavior change or test was wrong>

## Known baseline failures
- <only if the user agreed to proceed with them>

## Follow-ups and open questions
- <item>

## Final review
Final review GATE: <CLEARED | BLOCKED, or pending>
