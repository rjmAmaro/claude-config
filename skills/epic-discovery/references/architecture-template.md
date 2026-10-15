# Architecture file structure

The target shape for the user's architecture file. **Merge into the existing file**: keep the user's headings and content where they exist, add missing sections, move content only if the user agrees. Lightweight C4 + arc42 spirit: enough to draw epics and onboard an engineer, not a thesis.

Every non-trivial statement carries a status when it isn't settled: `Assumption` (inferred, awaiting confirmation) or `Open` (undecided, with owner). Unmarked means confirmed.

Use Mermaid for diagrams so they live in the repo as text.

```md
# {Project} — Architecture

> Status: {Draft | Baseline} · Last updated: {date} · Glossary: [GLOSSARY.md](../GLOSSARY.md)

## 1. Purpose and scope
What the system does, for whom, success measures. Explicitly out of scope.

## 2. System context
### Actors
| Actor | Type (human/system) | Goals | Notes |
### External systems
| System | Purpose | Direction | Protocol | Criticality | When unavailable | Owner of contract | Status |
### Context diagram
(Mermaid flowchart: system in the middle, actors and external systems around it)

## 3. Domain overview
Bounded contexts / modules, one or two lines each, and how they relate. Link to GLOSSARY.md; don't redefine terms here.

## 4. Building blocks
| Component | Responsibility | Owns data | Exposes | Depends on | Epics |
(Mermaid diagram of components and their dependencies, including external systems)

## 5. Key runtime flows
The 2–5 flows that matter most (highest risk, most integrations, core value). One Mermaid sequence diagram each, plus a sentence on failure handling.

## 6. Data
Main entities by owning component, storage choice, PII flags, retention.

## 7. Cross-cutting concerns
Identity & access · Security & compliance · Observability · Error handling · i18n · other relevant concerns. One short paragraph each, linking ADRs.

## 8. Deployment and environments
Hosting target, environments, deployment unit(s), CI/CD outline.

## 9. Quality attributes
| Attribute | Target (measurable) | Rationale | Affected epics |

## 10. Decisions
Index of ADRs: number, title, one-line summary.

## 11. Constraints and assumptions
Constraints imposed from outside (budget, client, regulation, existing contracts). Assumptions still awaiting confirmation.

## 12. Risks and open questions
| Item | Type (risk/open) | Impact | Owner | Needed by |

## 13. Traceability
Component ↔ epic matrix (filled during Phase 3–5).
```

What does **not** belong here: glossary definitions (GLOSSARY.md), decision rationale beyond one line (ADRs), story-level behaviour (epics/stories), technology minutiae that are easy to reverse.
