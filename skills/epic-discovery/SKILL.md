---
name: epic-discovery
description: Turn a greenfield project's early docs (requirements / estimate breakdown, architecture notes listing actors and external services) into a sharpened architecture document plus a set of fully specified epics, by grilling the user with the docs as the starting point. Use when the user wants to identify or specify epics, define high-level architectural components, go "from estimate to backlog", prepare a project for user-story breakdown, or improve an architecture file before development starts — even if they don't say "epic" explicitly.
---

# Epic Discovery

Take the project's early documents, interrogate them with the user, and leave behind three things that a later story/task breakdown can build on:

1. An **improved architecture file** (the user's own file, sharpened in place).
2. A **glossary and ADRs** (written by the `domain-modeling` discipline as decisions crystallise).
3. A **specified epic set**: one file per epic, plus an index with coverage and dependencies.

The method is grill-with-docs: load the `grilling` and `domain-modeling` skills and use them throughout. (`grill-with-docs` itself is user-invocable only; it is nothing more than those two skills loaded together, so load them directly with the Skill tool. If they can't be loaded, ask the user to run `/grill-with-docs` and then continue with this skill's workflow.)

## Ground rules

- **The docs are the starting point, not the truth.** The estimate breakdown was built to price the work, not to design it. Its components are a hint about the architecture, never the architecture itself. Reconcile, don't copy.
- **Facts are your job, decisions are the user's.** Anything answerable from the provided docs, you look up; never ask the user what a document already says. Ask only about decisions, conflicts between docs, and genuine gaps.
- **Never invent scope.** Anything you infer is labelled `Assumption` and goes to the user for confirmation. Unresolved items stay visibly `Open`, never silently filled.
- **Write as you go.** Update the architecture file, glossary and discovery log the moment something settles, exactly as `domain-modeling` does for the glossary. Nothing important should live only in the chat.
- **Stay at epic altitude.** Do not write user stories, tasks or implementation detail. Story *seeds* (one-line themes) are the lowest you go.
- **Don't pick technologies for the user.** Propose with a recommendation (that's how `grilling` works), but technology choices with lock-in are decisions, and usually ADR-worthy.
- **Use the glossary's language** in every document you write. If a source doc uses a term the glossary rejects, the new docs use the canonical term.

## Files

Respect `domain-modeling`'s conventions (`GLOSSARY.md` at the root, `docs/adr/`), and add:

```
/
├── GLOSSARY.md                        ← domain-modeling
├── docs/
│   ├── adr/                           ← domain-modeling
│   ├── <user's architecture file>     ← improved IN PLACE, wherever it already lives
│   ├── discovery/
│   │   ├── source-inventory.md        ← every source requirement/estimate line with a stable ID
│   │   └── DISCOVERY-LOG.md           ← phase, open frontier, decision log (enables resume)
│   └── epics/
│       ├── README.md                  ← index, dependency graph, coverage, estimate reconciliation
│       ├── EP-01-<slug>.md
│       └── ...
```

Never modify the user's source documents other than the architecture file. If the user keeps their docs elsewhere, ask once where outputs should go and record it in the log.

## Workflow

Five phases. Each ends with a **gate**: summarise what changed, confirm with the user, record it in `DISCOVERY-LOG.md`, then move on. Phases can be revisited: if epic work exposes an architectural hole, go back, fix the architecture file, and come forward again.

### Phase 0 — Locate inputs and check for a resume

1. If `docs/discovery/DISCOVERY-LOG.md` exists, read it and resume from the recorded phase and frontier. Tell the user where you are picking up.
2. Otherwise find the inputs: the requirements/estimate breakdown, the architecture data-points file, and anything else the user mentions or that is clearly relevant (briefs, contracts, API docs of external services). Search the workspace first; ask only for what you can't find.
3. Read every input fully. Use the right reader for the format (spreadsheets, Word, PDF): an estimate in a spreadsheet often hides scope in comments, hidden columns, assumptions tabs and notes.

### Phase 1 — Inventory and gap analysis (no questions yet)

Build `docs/discovery/source-inventory.md`:

- Give every requirement / estimate line a stable ID (`R-001`…), keep its original wording and a pointer to the source (file + row/section), and carry its estimate figure if one exists.
- Extract into lists: actors, external systems, components named anywhere, non-functional requirements, constraints, stated assumptions.

Then analyse and write a **gap list** into the discovery log, grouped as:

- **Conflicts** — the docs disagree (e.g. the estimate assumes an integration the architecture file doesn't mention).
- **Orphans** — estimate lines with no architectural home; architectural elements with no requirement behind them.
- **Ambiguities** — overloaded or fuzzy terms, unclear ownership, unclear direction of integrations.
- **Missing concerns** — areas from [references/design-tree.md](references/design-tree.md) that no document addresses.
- **Hidden assumptions** — things the estimate silently relies on (e.g. "auth via existing SSO").

Present a short summary of the inventory and the gap list. Gate: the user confirms the inventory is complete (or adds missing sources).

### Phase 2 — Grill the architecture

Load `grilling` and `domain-modeling`. Seed the design tree from [references/design-tree.md](references/design-tree.md), **pruned and ordered by the gap list**: settled facts from the docs are not questions; conflicts and gaps are. Work it in rounds exactly as `grilling` prescribes (whole frontier per round, numbered, recommended answer, "yes" accepts).

While grilling:

- Update the architecture file inline as decisions settle. Use the structure in [references/architecture-template.md](references/architecture-template.md), but **preserve the user's existing structure and content**: merge into it, don't replace it. Tag uncertain content `Assumption` or `Open`.
- Let `domain-modeling` maintain `GLOSSARY.md` and offer ADRs (only when hard to reverse + surprising + a real trade-off).
- Append each decision to the log's decision table with where it was recorded.

Gate: the architecture frontier is empty or every remaining item is explicitly parked as `Open` with an owner. The user confirms shared understanding.

### Phase 3 — Identify epics

Read [references/epic-heuristics.md](references/epic-heuristics.md). Then propose a **candidate epic map** in one message, as a table:

| ID | Epic | One-line outcome | Actors | Components | Requirements | Est. |

Below it, show the coverage check: any `R-xxx` not covered by an epic, any component or external system no epic touches, any requirement covered by several epics (fine if deliberate, but say so). Also flag every heuristic smell you see in your own proposal.

Then grill the map: epic boundaries, merges/splits, enabler epics, sequencing and dependencies, MVP / release cut. Again rounds, recommendations, the user decides.

Gate: the user accepts the epic list. Write `docs/epics/README.md` with the list (status `Draft`).

### Phase 4 — Specify each epic

For each epic, in dependency order, write `docs/epics/EP-NN-<slug>.md` using [references/epic-template.md](references/epic-template.md).

- Fill everything you can from the inventory, architecture file, glossary and decisions.
- Collect what's still undecided for that epic and run a short, targeted grilling round on it. Batch several epics into one round when their questions are independent, to keep the session moving.
- What remains unresolved goes into the epic's `Open questions`, never into invented content.
- Reconcile the estimate: list the source estimate lines the epic absorbs, their total, and whether the discussed scope looks bigger or smaller, and why. Don't re-estimate; surface the drift.
- Set status to `Specified`, or `Ready for breakdown` when the epic passes its Definition of Ready.

If specifying an epic reveals an architectural change, update the architecture file (and ADR if warranted) before continuing.

### Phase 5 — Validate and hand off

Run these checks and fix or report every failure:

1. Every `R-xxx` in the inventory maps to at least one epic, or is explicitly marked out of scope with a reason.
2. Every component in the architecture file is touched by at least one epic; every epic's components exist in the architecture file.
3. Every external system has an owning component and at least one epic that integrates it.
4. Every actor appears in at least one epic.
5. The dependency graph has no cycles; enabler epics come before what they enable.
6. Terms used in the architecture file and epics match `GLOSSARY.md` (no `_Avoid_` terms).
7. The architecture file's ADR index matches `docs/adr/`.
8. Estimate reconciliation totals in `README.md` add up to the source estimate total (plus/minus documented deltas).

Finalise `docs/epics/README.md`: epic table with status, a Mermaid dependency graph, the coverage matrix (requirement → epics), the estimate reconciliation, and a list of everything still `Open` across all docs.

Close with a short summary: what changed in the architecture file, ADRs created, number of epics and their readiness, top risks and open items. Suggest the next step: breaking `Ready for breakdown` epics into user stories and tasks one epic at a time (for example with a ticket-splitting skill such as `to-tickets`, feeding it the epic file).

## DISCOVERY-LOG.md format

```md
# Discovery Log

**Phase:** 2 — Grill the architecture
**Outputs:** architecture file at `docs/architecture.md`; epics at `docs/epics/`

## Open frontier
- Q: Is the payment provider called synchronously at checkout or via async confirmation? (blocks: Order lifecycle, EP payment)

## Gaps (from Phase 1)
- [x] Conflict: estimate assumes SMS notifications, architecture file lists email only → resolved, see decisions #4
- [ ] Missing: no backup / retention requirement

## Decisions
| # | Decision | Recorded in |
|---|----------|-------------|
| 1 | Modular monolith, one deployable | ADR-0001, architecture §4 |

## Parked (Open, with owner)
- Data residency requirement — owner: client legal, needed before EP-05
```

Keep it current; it's what makes the session resumable across days.
