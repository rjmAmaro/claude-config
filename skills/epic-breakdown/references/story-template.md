# Stories file template

File: `docs/stories/EP-NN-stories.md`. If the project already has a stories file for another epic, copy its conventions. Consistency between epics matters more than this template.

```md
# EP-NN — Stories and major tasks

Epic: [EP-NN — <title>](../epics/EP-NN-<slug>.md)

<One paragraph: the build order, the size scale (S ≤ 1 day, M ≤ 3 days, L must be split), and what "agent-ready" means.>

## Summary
| ID | Type | Title | Size | Depends on | Agent-ready |
|---|---|---|---|---|---|

## Items

### EPNN-T1 — <title>
**Type:** Task · **Size:** S/M · **Depends on:** — · **Agent-ready:** yes/no (reason)
**Goal:** <one sentence: what this task makes possible>
**Scope:**
- <what to build. Name the gems or packages, framework modules and configuration values from the decisions>
**Acceptance criteria:**
- Given … When … Then …
**Out of scope:**
- <item> — lives in <ID or epic>
**Decisions applied:** EPNN-D3, EPNN-D8 · <source IDs such as C1-R4, G11>
**Notes for the implementer:**
- <test approach, edge cases, gotchas>

### EPNN-S1 — <title>
**Type:** Story · **Size:** … · **Depends on:** EPNN-T4, EPNN-T5 · **Agent-ready:** …
**Story:** As a <actor>, I want <capability>, so that <benefit>.
**Scope:** …
**Acceptance criteria:** (main path, error paths, and the security or business rule of the item. Each one must be checkable by an automated test.)
**Out of scope:** …
**Decisions applied:** …
**Notes for the implementer:** …

## Requirement coverage
| Req ID | Items |
|---|---|
<every requirement in the epic's "Requirements covered" table>

## Open items
- <question> — owner, blocking or not
```

## Writing rules

- Use glossary terms. Do not use an `_Avoid_` term.
- Label every inference `Assumption` and keep a list of them for the final report.
- Point to existing docs and ADRs. Never ask the implementer to write a doc that the breakdown already writes.
