# Epic heuristics

## What an epic is here

A cohesive, independently deliverable chunk of **business capability** that:

- produces an observable outcome for at least one actor (or, for enablers, unblocks such outcomes);
- is too big for one story but small enough to finish in a handful of iterations;
- can be described in one sentence without "and also";
- has a clear "done" that someone outside the team could verify.

Epics are the level at which scope, budget and sequencing are discussed with stakeholders. Stories come later, inside them.

## Where epics come from

Work from several angles and reconcile; each catches what the others miss:

1. **Actor goals** — for each actor, what they need to accomplish end-to-end. Journeys are the strongest epic boundaries.
2. **Domain contexts** — a bounded context with its own lifecycle often maps to one or two epics.
3. **Estimate groupings** — the estimate's sections show how scope was priced; useful as a cross-check, not as the boundary.
4. **External integrations** — usually part of the capability epic that needs them. Give an integration its own epic only when it is large, risky, or shared by several capabilities.
5. **Enablers** — platform, environments, CI/CD, identity, observability foundations, data migration. Keep them thin and justified: each must name the feature epics it unblocks.

## Shape

- **Vertical over horizontal.** Prefer epics that cut through UI, logic, data and integration for one capability over epics per layer.
- **First slice end-to-end.** One early epic (or a walking-skeleton enabler) should exercise the main architectural path, including the riskiest integration, as soon as possible.
- **Balanced size.** Epics within roughly the same order of magnitude make planning honest.
- **Clear ownership.** Ideally one team can own an epic without constant hand-offs.

## Smells — call these out, even in your own proposal

| Smell | Usually means | Typical fix |
|---|---|---|
| Named after a layer or tech ("Backend", "Database", "API") | Horizontal slicing | Redistribute into capability epics |
| No actor and not a justified enabler | Unclear value | Find the actor or merge into the epic it serves |
| CRUD-per-entity epics ("Manage Customers", "Manage Products") with no journey | Data-model thinking | Re-cut around what actors actually do |
| Touches nearly every component | Too broad | Split by journey or by actor |
| Holds more than ~25% of the total estimate | Too big to plan or track | Split; find the MVP core |
| Story-sized (one or two obvious stories) | Too small | Merge into a neighbour |
| Two epics that are useless without each other | Wrong boundary | Merge, or redraw so each delivers value |
| Many "and"s in the goal | Several epics in one | Split along the "and"s |
| Cross-cutting concern as a late epic ("Security", "Performance") | Concern bolted on | Make it NFRs inside each epic plus a thin enabler if needed |
| "Misc" / "Other" / "Phase 2 stuff" | Unsorted scope | Sort it or mark it explicitly out of scope |

## Numbering and naming

- IDs `EP-01`, `EP-02`… in proposed delivery order; don't renumber later, just mark retired IDs as `Retired`.
- Titles are outcome-flavoured noun phrases in glossary language: "Customer self-service onboarding", not "Onboarding module".
