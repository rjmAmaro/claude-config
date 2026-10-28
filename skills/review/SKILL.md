---
name: review
description: >
  Review a GitLab MR or the code changes on the current branch. Use this skill when
  the user asks to "review my branch", "check my changes", "code review", or
  "review this PR". Also use it for "review !123", "review this MR", or "what
  did I change". Use it for any variation of reviewing uncommitted or unmerged
  work. Trigger when the user says "can you check this branch" or "look at my
  changes".
---

# Review Skill

This skill is a thin wrapper. The `reviewer` subagent holds the rules, the frames, and the output format. Do not copy them here. Do not review in the main context.

## Step 1: Pick the scope

- **PR** — the request has an MR number or `!NNN`.
- **slice** — the user asks to review the current slice only.
- **branch** (default) — all other cases.

## Step 2: Spawn the reviewer

Spawn the `reviewer` subagent (`subagent_type: reviewer`). Name the scope in the prompt. For example:

- `Scope: branch`
- `Scope: slice`
- `Scope: PR !123`

The reviewer gets the diff and the rules itself.

## Step 3: Print the report

Print the reviewer's report unchanged. Include the GATE line. Write no artifact file.

## PR mode only: post comments

After the report, offer to post selected findings as MR comments. Post only the 🧑 half of each finding. Use:

```bash
glab mr note <NNN> -m "<text>"
```

Post only after the user says yes in this conversation. Ask again for each later batch.
