# Slice gate and commit templates

## Gate summary

Show this summary at the end of each slice.

```
## Slice <N>: <title>   [mode: hitl|afk]

### What was built
- <file>: <what was added or changed>

### Test evidence
- RED: `<test command>` fails: <one-line reason>
- GREEN: `<test command>`: <N> passed
- REFACTOR: <what changed, or "none">
- Checks: lint <pass|fail> / slice tests <N> passed / related tests <N> passed

### Inner review
- Rounds: <N>
- Fixed: <Critical and Warning items fixed, or "none">
- Leftovers: <items not fixed, with reason, or "none">

### Deviations
- <auto-fixes and decisions, or "none">

### Proposed commit
<TICKET>: <what the slice delivers>

<why the change is needed: the problem, the context, the reason>

<co-author trailer>
```

## Commit

Stage the slice files by name. Never use `git add -A`.

```bash
git status
git add <slice files>
git commit -m "$(cat <<'EOF'
<TICKET>: <what the slice delivers>

<why the change is needed>

<co-author trailer from the session git attribution instructions>
EOF
)"
```

- The body is always present, also for a small change.
- Use the short ticket slug when no ticket key exists.
- Record the short sha in the progress file.

## Correction to an earlier slice

```bash
git add <files>
git commit --fixup=<that slice sha>
```

Fixups stay in the history. The user squashes them with `git rebase -i --autosquash <base>`.

## Coder brief

A brief must be self-contained. The coder has not seen the conversation. Include these items:

1. Slice goal and test list.
2. Relevant acceptance criteria and plan excerpts.
3. Deviations so far.
4. Setup facts: test command, lint command, factories or fixtures, style notes, likely files.
5. TDD rules: red for the right reason, minimum code to green, refactor only on green.
6. Rules about tests and the test layout (happy path first, then error cases in each `describe`).
7. The deviation rules.
8. Do not commit. Run the linter on changed files.
9. Return: tests added as `file:line`, files changed, the red command and its one-line failure reason, the green output, refactor notes, deviations, open questions.
