---
name: project-breakdown
description: Break down a software project from raw client inputs (RFPs, briefs, emails, call notes, meeting transcripts, wireframes, feature lists, existing-system descriptions) into a structured set of high-level components and requirements ready to be estimated. Use this skill whenever the user wants to scope, decompose, size, or prepare an estimate or quote for a software project, build a work breakdown structure (WBS), turn a client brief into requirements, figure out "what we'd need to build", prepare for a pre-sales or discovery call, or identify gaps and questions for a client — even if they don't say "breakdown" or "estimate" explicitly.
---

# Project Breakdown for Estimation

Turn messy client inputs into a traceable, estimation-ready breakdown: components → requirements → sizing signals, plus the assumptions, risks and open questions that will move the number.

The goal is not to produce the estimate itself (unless asked). The goal is to give whoever estimates a complete, honest picture of the work, so nothing important is missed and every uncertainty is visible. Most bad estimates come from forgotten work (auth, admin screens, migrations, environments, QA, launch) and unstated assumptions, not from bad arithmetic — so completeness and explicitness matter more than precision here.

## Workflow

Follow these steps in order. Steps 1–3 are about understanding; 4–6 build the breakdown; 7–8 make it usable for estimation.

### 1. Inventory the inputs

List every source you were given (e.g. "S1: RFP v2 PDF", "S2: kickoff call notes 12 Mar", "S3: wireframes"). Give each a short ID; you'll use these IDs for traceability later. Note the apparent date and author if known, and flag contradictions between sources early — later sources usually supersede earlier ones, but say so rather than silently choosing.

If the inputs are very thin (a paragraph or two), still proceed — just expect a larger assumptions and questions section. Don't stall waiting for more information; a breakdown with clearly marked assumptions is more useful than no breakdown.

### 2. Extract the project context

Pull out, with source references:

- **Business goals** — why the client wants this, what success looks like.
- **Users and roles** — who uses the system (end users, admins, internal staff, external partners). Roles drive permissions, screens and test effort.
- **Platforms and channels** — web, iOS, Android, desktop, API-only, kiosk, etc.
- **Scope signals** — features, workflows, content, reports explicitly mentioned.
- **Integrations** — every external system named (payment, CRM, ERP, SSO, email/SMS, maps, analytics, AI APIs, legacy databases).
- **Data** — what data exists, what must be migrated, volumes, sensitivity (PII, health, financial).
- **Non-functional expectations** — performance, scale, availability, security, compliance (GDPR, HIPAA, SOC 2, PCI, accessibility/WCAG), localisation.
- **Constraints** — deadlines, budget hints, mandated tech stack, hosting, team/vendor constraints, existing systems to keep.
- **Out of scope** — anything the client explicitly excluded.

### 3. Classify every requirement by certainty

Tag each item as one of:

- **Explicit** — the client stated it.
- **Implied** — not stated, but the stated scope can't work without it (e.g. "users can view their order history" implies authentication, user accounts and an orders data model).
- **Assumed** — your professional default where the client is silent (e.g. "assume English only", "assume the client provides content").

This distinction is the most valuable thing the breakdown gives an estimator: explicit items are firm, implied items are where hidden cost lives, and assumed items are where the estimate can be challenged. Never present an assumption as if the client said it.

### 4. Decompose into high-level components

Group the work into components — coherent chunks that could plausibly be estimated, owned and delivered as a unit (e.g. "Customer Web App", "Admin Portal", "Payments Integration", "Notification Service", "Data Migration", "Infrastructure & DevOps").

Read `references/component-checklist.md` before finalising the component list. It contains a taxonomy of component types and a list of commonly forgotten work. Walk through it deliberately and ask of each item: "does this project need this?" Include cross-cutting and delivery components (QA, security, DevOps, project management, UAT support, launch, documentation, training, warranty) — they're real effort and are the most frequently omitted.

Aim for roughly 6–20 components. Fewer usually means components are too coarse to estimate; more usually means you've drifted into task-level detail. Keep it high-level — features within a component are requirements, not separate components.

### 5. Define requirements per component

For each component, list its requirements at capability level (what it must do), not task level (how to build it). Use this shape for each:

| Field | Content |
|---|---|
| ID | e.g. `C3-R2` (component 3, requirement 2) |
| Requirement | One-sentence capability, ideally "[Role] can [do thing]" or "System [does thing]" |
| Type | Functional / Non-functional |
| Certainty | Explicit / Implied / Assumed |
| Priority | MoSCoW: Must / Should / Could / Won't (this phase) |
| Source | Source IDs, or "—" for assumed |
| Notes | Business rules, edge cases, acceptance hints |

Non-functional requirements that apply everywhere (e.g. "WCAG 2.1 AA", "99.9% uptime") belong in a cross-cutting section rather than repeated under each component — but note which components they materially affect, because they multiply effort there.

If the client hasn't prioritised, propose MoSCoW priorities based on the stated goals and mark them as proposed. This lets the estimator produce an MVP vs. full-scope figure.

### 6. Capture sizing signals

For each component, give the estimator what they need to size it without doing the estimate for them. Read `references/sizing-guide.md` for the complexity scale and the drivers to look for.

- **Relative size** — T-shirt size (XS / S / M / L / XL).
- **Complexity drivers** — the specific things that make it bigger (e.g. "4 user roles with distinct permissions", "real-time sync", "undocumented legacy API").
- **Uncertainty** — Low / Medium / High, with the reason. High uncertainty should push toward a wider range or a discovery spike, not a padded single number.
- **Dependencies** — other components, client deliverables (content, API access, designs), or third parties.
- **Suggested skills** — the roles likely needed (frontend, backend, mobile, data, DevOps, QA, design).

Only convert sizes into hours, days or cost if the user asks, or if they supply their own rates/velocity. If they do, present ranges (best / likely / worst, or a three-point PERT estimate) rather than single numbers, and state the conversion basis.

### 7. Assumptions, risks and exclusions

Consolidate:

- **Assumptions** — every Assumed item, plus general delivery assumptions (who provides content, designs, hosting accounts, test data; environments; review turnaround times).
- **Risks** — things that could blow up the estimate, each with likelihood (L/M/H), impact (L/M/H) and a suggested mitigation (spike, prototype, contingency, contractual exclusion).
- **Exclusions** — what this breakdown deliberately does not cover. Explicit exclusions protect the estimate.

### 8. Open questions for the client

List the questions that need answers, **ranked by impact on the estimate** — the questions whose answers could swing the number most go first. For each, note which components/requirements it affects and what you've assumed in the meantime. This turns the breakdown into the agenda for the next client conversation.

Keep questions concrete and answerable ("Do admins need to edit orders after they're placed, or only view them?") rather than open-ended ("Tell us more about admin needs").

## Output

Produce the breakdown using the structure in `references/output-template.md`. Default to a single well-structured Markdown document. If the user wants something to load into a spreadsheet or estimation tool, also produce a flat table (CSV or XLSX) with one row per requirement and columns: Component, Req ID, Requirement, Type, Certainty, Priority, Size, Uncertainty, Source, Notes.

Start the document with a short executive summary (3–6 sentences): what the project is, the component count, the overall size impression, the biggest uncertainties, and the top 2–3 questions to resolve. Busy estimators and account managers often read only this part.

## Principles

- **Traceability over polish.** Every explicit requirement should point to a source. If someone challenges the estimate, they should be able to see where each item came from.
- **Surface, don't bury, uncertainty.** A clearly flagged unknown is useful; a confident guess that turns out wrong damages trust with the client.
- **Capability level, not tasks.** "Customer can reset their password via email" — not "build reset-password endpoint, email template, token table".
- **Don't invent scope.** Implied requirements must be genuinely necessary for the stated scope to work. Nice-to-have ideas you think of can go in a separate "Suggestions / potential upsell" list, clearly marked, so they don't inflate the estimate.
- **Respect stated constraints.** If the client mandates a stack, hosting provider or deadline, design the breakdown around it and flag any tension (e.g. scope vs. deadline) as a risk.
- **Iterate.** When the user provides answers to open questions or new inputs, update the breakdown in place: move items from Assumed to Explicit, adjust sizes, close questions, and note what changed.
