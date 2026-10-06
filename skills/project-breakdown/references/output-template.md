# Output Template

Use this structure for the breakdown document. Keep headings as-is so breakdowns are consistent across projects. Omit a section only if it genuinely has no content, and say "None identified" rather than deleting it when absence is itself informative (e.g. no integrations).

```markdown
# [Project Name] — Project Breakdown

**Prepared:** [date]  **Version:** [v0.1]  **Status:** Draft for estimation

## 1. Executive summary
3–6 sentences: what the project is, number of components, overall size impression,
biggest uncertainties, top 2–3 questions to resolve before estimating.

## 2. Sources
| ID | Source | Date | Notes |
|---|---|---|---|
| S1 | Client RFP v2 | 2026-03-10 | Primary scope document |
| S2 | Kickoff call notes | 2026-03-12 | Supersedes S1 on mobile scope |

Contradictions between sources: [list, with which one was followed and why]

## 3. Project context
- **Goals:**
- **Users & roles:**
- **Platforms:**
- **Key integrations:**
- **Data:**
- **Constraints:** (deadline, budget, stack, hosting)
- **Explicitly out of scope:**

## 4. Component overview
| # | Component | Description | Size | Uncertainty | Key drivers | Depends on |
|---|---|---|---|---|---|---|
| C1 | Customer Web App | ... | M | Low | 12 screens, 2 roles | C4, C5 |

## 5. Component details
### C1 — [Component name]
**Purpose:** one or two sentences.
**Size:** M  **Uncertainty:** Medium — [reason]
**Complexity drivers:** ...
**Dependencies:** ...
**Suggested skills:** frontend, QA

| ID | Requirement | Type | Certainty | Priority | Source | Notes |
|---|---|---|---|---|---|---|
| C1-R1 | Customer can register with email and password | F | Explicit | Must | S1 §3.2 | Email verification implied |
| C1-R2 | Customer can reset password via email link | F | Implied | Must | — | Required for any password-based auth |

(repeat per component)

## 6. Cross-cutting non-functional requirements
| ID | Requirement | Certainty | Affects | Notes |
|---|---|---|---|---|
| NFR-1 | WCAG 2.1 AA compliance | Explicit (S1) | C1, C2 | Increases UI + QA effort |

## 7. Assumptions
| ID | Assumption | Affects | Impact if wrong |
|---|---|---|---|
| A1 | English only at launch | All UI | +i18n work, M-size |

## 8. Risks
| ID | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| R1 | Legacy ERP API undocumented | H | H | 5-day discovery spike before committing |

## 9. Exclusions
- ...

## 10. Open questions for the client (ranked by estimate impact)
| # | Question | Affects | Current assumption |
|---|---|---|---|
| Q1 | ... | C3, C6 | A4 |

## 11. Suggestions / potential upsell (not included in scope)
- ...

## 12. Change log
| Version | Date | Change |
|---|---|---|
| v0.1 | ... | Initial breakdown |
```

## Flat export (when a spreadsheet is requested)

One row per requirement (including NFRs), columns:

`Component ID, Component, Req ID, Requirement, Type, Certainty, Priority, Size, Uncertainty, Source, Notes`

Component-level fields (Size, Uncertainty) repeat on each requirement row so the sheet can be filtered and pivoted.
