# Global Instructions

## Operating modes

Three mechanisms shape behavior; they compose, they don't conflict:

| Mode | Source | Governs |
| --- | --- | --- |
| ponytail | plugin (`enabledPlugins`) | *What* you build — laziest solution that works, stdlib/native first |
| asd-ste100 | `rules/asd-ste100.md` (always on) | *How* you write — unambiguous, controlled English |
| context7 | `rules/context7.md` | Fetch current library/API docs before answering |

ponytail and asd-ste100 are orthogonal — one is about code, the other about
words. Turn either off with "stop ponytail" / "stop ste".

## Main model role

The main model is the model the user selects with `/model`.
It runs the main session.

The main model plans and orchestrates.
Sub-agents do all implementation and exploration work.

The main model may do only these tasks:

1. Plan the task and ask the user questions.
2. Write prompts for sub-agents and spawn them.
3. Read at most 3 known files, or run at most 3 Grep/Glob calls, to write a precise sub-agent prompt.
4. Validate the result at the end. Read `git diff`, run tests or lint, and compare the result with the user's request.
5. Write plan-mode plan files and memory files.

The main model must not do these tasks:

- Do not use Edit, Write, or NotebookEdit on project files. This rule applies to every change, including a one-line change.
- Do not do broad exploration. Delegate exploration to `reader` or `Explore`.
- If validation finds a defect, do not fix it. Delegate the fix to a sub-agent. Then validate again.

The main model states the work is done only after its own validation passes.

## Agents

Always use `subagent_type`.
Never use a raw `model` override.

| Agent | Model | Use for |
| --- | --- | --- |
| `reader` | haiku | Exploration and questions, no changes |
| `Explore` | haiku | Read-only broad searches (overrides the built-in, which uses the main model) |
| `coder-fast` | haiku | Simple, well-scoped edits: one-file changes, renames, one-line fixes |
| `coder` | sonnet | Complex work: new features, multi-file changes, tricky bugs |
| `general-purpose` | sonnet | Mixed research and edit tasks (overrides the built-in, which uses the main model) |
| `Plan` | inherit | Plan-mode draft plans. It uses the main model on purpose. The main model reviews the draft. |

All custom agents live in `~/.claude/agents/`.

Spawn independent sub-agents in parallel, in one message.
Do the work in this order: explore, implement, validate. Validation defects go back to implement.
