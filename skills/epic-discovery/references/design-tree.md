# Design tree seed

The areas a greenfield architecture must settle before epics can be drawn well. Use it two ways:

- **Phase 1:** as a checklist to find *missing concerns* (areas no input document addresses).
- **Phase 2:** as the seed of the `grilling` design tree. Drop branches the docs already settle, keep conflicts and gaps, and respect the prerequisites: a question belongs on the frontier only when the decisions it depends on are settled.

Not every branch applies to every project. Skip what's irrelevant, but say you skipped it so the user can object.

## L1 — Scope and context (no prerequisites)

- **Purpose and success** — what problem the system solves, for whom, and how success is measured.
- **Boundary** — what is explicitly out of scope; what existing systems (if any) this replaces or sits beside.
- **Actors** — each human role and each system actor; who is the primary user; roles that differ only in permissions vs genuinely different actors.
- **External services** — for each: purpose, direction (we call / it calls us / both), protocol, who owns the contract, criticality, behaviour when it is down, rate limits or cost per call, sandbox availability.
- **Release horizon** — MVP vs later phases; hard dates; what the estimate was scoped to.

## L2 — Domain (after L1)

- **Core concepts** — the main nouns and their lifecycles/states (glossary candidates).
- **Bounded contexts / modules** — natural groupings of concepts; where the same word means different things.
- **Ownership** — which context owns each concept's data; others reference by ID.
- **Key business rules** — the invariants that would hurt most if wrong.

## L3 — Architectural shape (after L2)

- **Decomposition** — monolith, modular monolith, services; why.
- **Clients** — web, mobile, public API, back-office; shared or separate backends.
- **Integration style** — sync vs async between internal modules and with each external service; events vs calls.
- **Data storage** — store per context or shared; relational vs other; reporting/analytics needs.
- **Tenancy** — single vs multi-tenant, isolation level.
- **Hosting / deployment target** — cloud, provider, on-prem constraints; environments.

## L4 — Cross-cutting concerns (after L3)

- **Identity and access** — authentication (own vs external IdP / SSO), authorisation model (roles, ownership, attributes), service-to-service auth.
- **Security and compliance** — PII inventory, regulations (e.g. GDPR, sector rules), data residency, retention, audit trail.
- **Quality attributes** — measurable targets for performance, availability, scalability, recovery (RPO/RTO).
- **Observability** — logging, metrics, tracing, alerting; who is on call.
- **Operability** — backups, migrations, configuration, feature flags, admin tooling.
- **Other** — i18n/l10n, accessibility, offline support, notifications channels, file storage.

## L5 — Delivery shape (after L3–L4; feeds Phase 3)

- **Slicing strategy** — by user journey, by actor, by capability; what the first end-to-end slice is.
- **Enabler work** — platform, CI/CD, environments, integration foundations, auth: what must exist before the first feature epic.
- **Team topology** — number of teams and how epics would map onto them (Conway's law).
- **Integration risk ordering** — which external integrations to de-risk first (spikes).
