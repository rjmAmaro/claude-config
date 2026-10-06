# Component Checklist

Walk through every section. For each item, decide: needed / not needed / unknown (→ open question). Not every project needs every item, but every item should be consciously considered.

## Contents
1. Product components (what users touch)
2. Platform components (what makes it work)
3. Integration components
4. Data components
5. Cross-cutting non-functional work
6. Delivery components (how it gets shipped)
7. Commonly forgotten work — quick scan

---

## 1. Product components

- **Customer / end-user app(s)** — web, iOS, Android, desktop. Separate component per platform if built separately; one component if cross-platform (React Native, Flutter) but note per-platform testing and store submission.
- **Admin / back-office portal** — almost always needed even when not mentioned. Who manages users, content, orders, settings, refunds?
- **Partner / vendor / B2B portal** — if third parties interact with the system.
- **Public marketing site / landing pages** — often assumed to exist; confirm who builds it.
- **Reporting & dashboards** — standard reports, exports (CSV/PDF), analytics views.
- **Content management** — CMS or custom content editing; who enters the content?
- **Search** — basic filtering vs. full-text vs. faceted/relevance-tuned search are very different sizes.
- **Onboarding flows** — sign-up, KYC/verification, tutorials, empty states.

## 2. Platform components

- **Authentication** — email/password, social login, SSO (SAML/OIDC), MFA, magic links, password reset, account lockout.
- **Authorisation / roles & permissions** — count distinct roles; row-level access (e.g. "users only see their company's data") is a significant driver.
- **Backend API / services** — core business logic; split by domain if large.
- **Notifications** — email, SMS, push, in-app; templates, preferences, unsubscribe.
- **File handling** — uploads, storage, image processing, virus scanning, document generation.
- **Background jobs & scheduling** — imports, recurring billing, reminders, cleanup.
- **Real-time features** — chat, live updates, collaboration, presence.
- **Payments & billing** — one-off vs. subscriptions, invoicing, tax, refunds, multi-currency, payouts/marketplace splits.
- **Audit logging** — who changed what, when; often required by compliance.
- **Configuration / feature flags** — settings admins can change without a deploy.

## 3. Integration components

Treat each significant external system as its own component or clearly separated requirement set. For each, find out:

- Does a documented API exist? Sandbox/test environment available?
- Direction: read, write, or two-way sync? Real-time or batch?
- Who owns the account and credentials? Who pays for it?
- Error handling and reconciliation when it's down or data conflicts.

Typical: payment gateways, CRM, ERP/accounting, SSO/identity providers, email/SMS providers, maps/geolocation, analytics/tracking, AI/LLM APIs, shipping/logistics, calendar, legacy internal systems.

Legacy or undocumented integrations are one of the highest-uncertainty items in any estimate — flag them High uncertainty and consider recommending a discovery spike.

## 4. Data components

- **Data model & database design**
- **Data migration** — from which systems? Volume? Data quality? Who validates? Number of trial migrations? Cutover plan?
- **Seed / reference data** — product catalogues, lookup tables, initial content.
- **Data retention & deletion** — GDPR right-to-erasure, archival policies.
- **Backups & restore** — frequency, retention, tested restore.
- **Analytics / data warehouse feeds** — does data need to flow to BI tools?

## 5. Cross-cutting non-functional work

These rarely appear as features but multiply effort across components:

- **Security** — OWASP hardening, penetration test (who pays, who fixes findings?), secrets management, encryption at rest/in transit.
- **Compliance** — GDPR, HIPAA, PCI-DSS, SOC 2, industry-specific rules. Compliance can add 15–40% to affected components.
- **Accessibility** — WCAG level; affects every UI component and QA.
- **Localisation / internationalisation** — languages, RTL, currencies, time zones, date formats.
- **Performance & scalability** — expected users, concurrency, data volumes, response-time targets, load testing.
- **Availability & resilience** — uptime SLA, failover, disaster recovery.
- **Browser / device support matrix** — older browsers or wide device ranges increase QA effort.
- **Observability** — logging, monitoring, alerting, error tracking.

## 6. Delivery components

- **Discovery / inception** — workshops, requirements refinement, technical spikes.
- **UX / UI design** — research, wireframes, visual design, design system, prototyping. Confirm whether the client supplies designs.
- **Infrastructure & DevOps** — cloud setup, environments (dev / test / staging / prod), CI/CD pipelines, infrastructure-as-code, domain/DNS/SSL.
- **Quality assurance** — test planning, manual testing, automated tests, regression, device testing.
- **UAT support** — supporting the client's acceptance testing and fixing findings.
- **Project management & ceremonies** — typically 10–20% of delivery effort.
- **Documentation** — technical docs, API docs, user guides, admin guides, runbooks.
- **Training & handover** — client staff training, knowledge transfer to an internal team.
- **Launch / go-live** — app store submission and review, cutover, hypercare period.
- **Warranty / post-launch support** — bug-fix period, SLA, ongoing maintenance.

## 7. Commonly forgotten work — quick scan

Before finalising, confirm you've considered each of these:

- [ ] Admin screens for every entity end users create
- [ ] Password reset, email verification, account deletion
- [ ] Email templates (and who writes the copy)
- [ ] Empty, loading and error states
- [ ] Legal pages, cookie consent, terms acceptance
- [ ] App store accounts, listings, screenshots, review delays
- [ ] Multiple environments and their hosting cost
- [ ] Data migration trial runs and validation
- [ ] Third-party account setup and credential handover
- [ ] Pen test and remediation
- [ ] Analytics/tracking setup
- [ ] Time-zone and currency handling
- [ ] Rate limiting and abuse prevention for public endpoints
- [ ] Client review/feedback cycles on designs and builds
- [ ] Hypercare after launch
