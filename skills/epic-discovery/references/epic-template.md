# Epic template

One file per epic: `docs/epics/EP-NN-<slug>.md`. Every section is there to make the later story/task breakdown possible without re-interviewing the user. If a section doesn't apply, write "n/a" and why, rather than deleting it, so absence is visibly deliberate.

```md
# EP-NN — {Title}

> Status: Draft | Specified | Ready for breakdown | Retired · Type: Feature | Enabler · Release: {MVP | R2 | ...}

## Goal
1–3 sentences: the outcome, for whom, and why it matters. No implementation.

## Actors
Which actors (from the architecture file) are involved and in what role.

## Scope
**In:** bullet list of capabilities included.
**Out:** what a reader might expect here but is excluded (and where it lives instead, if anywhere).

## Requirements covered
| Req ID | Summary | Coverage (full / partial) |
(IDs from docs/discovery/source-inventory.md)

## Architectural footprint
- **Components:** new / changed, with the responsibility this epic adds to each.
- **External integrations:** which, what operations, sync/async, failure behaviour.
- **Data:** entities created or changed, owning component, PII.
- **Decisions:** relevant ADRs.

## Domain language
Glossary terms central to this epic (linked), plus any term this epic is likely to stretch.

## Epic acceptance criteria
Outcome-level, testable statements describing what is true when the epic is done. Not story-level detail.
- [ ] {An actor can … / The system guarantees …}

## Non-functional requirements
Targets from the architecture file's quality attributes that this epic must meet, plus epic-specific ones (security, performance, accessibility, audit).

## Dependencies
- **Blocked by:** EP-xx (why)
- **Blocks:** EP-yy (why)
- **External:** contracts, credentials, sandboxes, third-party decisions, and who provides them.

## Estimate reconciliation
| Source line (R-xxx) | Original estimate |
**Total from source:** … · **Scope drift since estimate:** bigger / smaller / same — why.

## Risks and assumptions
| Item | Type | Impact | Mitigation / owner |

## Open questions
- {question} — owner, needed by

## Story seeds
One-line themes to start the story breakdown from. Not stories: no acceptance criteria, no sizing.
- {e.g. "First-time registration with email verification"}

## Definition of Ready (for story breakdown)
- [ ] Goal and scope (in/out) agreed with the user
- [ ] All covered requirements traced
- [ ] Components and integrations exist in the architecture file
- [ ] No blocking open questions (non-blocking ones listed with owners)
- [ ] Dependencies identified
- [ ] Epic acceptance criteria are testable
```
