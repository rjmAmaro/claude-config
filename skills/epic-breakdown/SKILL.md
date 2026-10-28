---
name: epic-breakdown
description: Break one specified epic into user stories and major tasks that are ready to hand to a developer or a coding agent, by grilling the user on the epic's open questions and on every high- and medium-level decision (libraries, data model, access rules, lifetimes, thresholds, ownership), then writing a stories file and updating the epic, glossary, architecture, ADRs and any affected epics. Works from a clean session by rebuilding context from the project's docs (GLOSSARY.md, docs/architecture.md, docs/adr/, docs/epics/, docs/discovery/). Use whenever the user asks to break down, split, slice, decompose or "storify" an epic (e.g. "let's break down EP-03", "turn EP-07 into stories", "what are the tasks for the audit epic"), or continues after epic-discovery — even if they don't say "user story".
---

# Epic Breakdown

Turn one epic into a list of **user stories** and **major tasks** that someone can either split further or give straight to an agent for implementation. All high- and medium-level decisions are made here, with the user, so nobody has to make them later in the code.

The method is grill-with-docs. Load the `grilling` and `domain-modeling` skills with the Skill tool and follow their discipline throughout. For the layout of each question round, [references/grilling-format.md](references/grilling-format.md) takes precedence. It adds IDs and blocks that this workflow needs.

## Why this skill exists

An epic says *what* outcome the business wants. An implementer needs to know *how*: which library, which table holds which field, who may see what, how long a session lives, what happens on failure. If these decisions are left open, an agent will pick something at random and the choices will drift between stories. This skill moves every such decision into a conversation with the user, records it once, and makes the stories cite it.

## Ground rules

- **Facts are your job. Decisions are the user's.** Look up anything that a doc, the code or the library documentation can answer. Ask only about decisions, conflicts and real gaps. Before you recommend a library or a configuration, check its current documentation (Context7 MCP if available, else web docs). Your training data can be out of date, and the user may know the library better than you.
- **Recommend, then accept the answer.** Every question has a recommended answer. When the user overrides it (for example "use Devise, not the Rails generator"), adopt the override without argument and re-check what it changes downstream.
- **The docs are the source of truth between sessions.** Write decisions down as soon as they settle. Nothing important may live only in the chat.
- **Use the glossary's terms.** Never use a term the glossary marks `_Avoid_`. When a decision changes the meaning of a term (for example "manager" now points to a login account), update the glossary.
- **Never invent scope.** Anything you infer is labelled `Assumption` and shown to the user at the end.
- **Watch for ripple effects.** A decision in this epic often changes another epic. Example from practice: "the password reset email is sent in the background" moved the job runner setup from a later epic to this one. Track every ripple and fix the affected docs in the same session.

## Workflow

### Step 0 — Locate the artifacts (clean-session safe)

Read the project first. Open a reference file of this skill only when a step points to it, because loading all of them up front costs time and adds nothing to the first read.

The project may keep its docs under a sub-folder (for example `breakdown 2 _ epic discovery/`). Find them with a search for `GLOSSARY.md` and `docs/epics/README.md`, and work relative to that root. Read, in this order:

1. The target epic file `docs/epics/EP-NN-*.md`, in full.
2. `docs/epics/README.md`: status, dependency graph, open items.
3. `GLOSSARY.md`, in full.
4. `docs/architecture.md`: the sections for the epic's components, the platform services, the access model and the ADR index.
5. Every ADR in `docs/adr/`.
6. The epics in the target's "Blocked by" and "Blocks" lists. Read the scope and footprint sections of each "Blocked by" epic in full, to find the interfaces this epic uses. For the "Blocks" list, read in full when it has up to 3 epics. When it is longer (an enabler that blocks most of the project), search each blocked epic for this epic's topics, read only the matching sections, and say in the "What I found" preface that you did so.
7. Every existing `docs/stories/EP-*-stories.md`. They set the conventions (ID format, size scale, item template) and show what earlier epics already built, such as platform services, base models and access rules. Do not plan work twice.
8. `docs/discovery/DISCOVERY-LOG.md`. If it has a section for this epic's breakdown, or the stories file already exists, **resume**: tell the user where you are picking up and continue from there. Also note the last question-round letter and the decision IDs that earlier breakdowns used. You need them for Step 1.

If the epic status is `Specified` (not `Ready for breakdown`), its blocking open questions go first in round 1. Tell the user this before you start.

### Step 1 — Grill: open questions and design decisions

Build the frontier from two sources:

- The epic's **Open questions** section.
- The **design decisions** the stories will need. Use [references/decision-checklist.md](references/decision-checklist.md) to find them. Skip anything that the docs already settle.

Before you ask, run a **cross-epic sweep**. For each topic on the frontier (a date rule, a visibility rule, a shared entity, a notification, a library), search *all* other epic files, the glossary and the architecture file for that topic. Rules often live in two epics at once. Example: a birthday post on 29 February (Slack epic) and a "birthday off" on 29 February (policies epic) need the same answer. A clash or a shared rule found this way is a question, or a fact to cite in a question.

Then sort the frontier:

- **Open decisions** become questions.
- **Assumptions the epic already states** do not need a question each. List them in one block, "Accepted unless you object", one line each. The user can veto any line by its number.
- **Small decisions with an obvious default** also go into that block, marked "(default)". A decision is small when it is easy to change later, affects one item only, and has one clearly conventional answer. Example: "store timestamps in UTC and show them in Europe/Lisbon". If you have to explain a trade-off, it is not small. Ask it as a question.
- **One decision, one question.** Before you send the round, check that no two questions (or sub-parts) decide the same thing. Merge any duplicates.
- **Questions that depend on another answer in this round** wait for the next round.

Ask in the format in [references/grilling-format.md](references/grilling-format.md). Start with a short "What I found" preface: at most 8 bullets with the facts that shape the questions (what earlier epics already built, clashes found by the sweep, library facts). Then ask **up to 30 questions** in the round. Uncertainty costs more the later it is found, so ask every open decision now rather than spread them thin over many rounds. Give every question a recommended answer.

**Library and framework facts.** Check current docs before you recommend. Every library or framework fact that you did not check in this session gets "**unverified:**" next to it in the question. This includes framework behaviour you know well (for example the Active Job retry options or a Devise default), because versions change. Mark weak evidence the same way: a low rating from the docs source, a version that is not confirmed, or a library the docs source does not have. If the user accepts a recommendation that rests on an unverified fact, add a short verification task (a spike) to the story map.

**IDs.**
- Question IDs are a letter plus a number (`K1`, `K2`…). The letter is the same for the whole round. Never use plain numbers.
- Round letters continue across the whole project. Find the last letter used: search the discovery log, every epic's "Breakdown decisions" section and every stories file for question IDs such as `H3` or `J5`. Take the next letter. EP-01 used H, I and J, so the next round is K. If nothing uses a letter yet, start at A, and skip any letter that the discovery log already uses for another series (for example G and E there).
- Decision IDs carry the epic prefix: `EP02-D1`, `EP02-D2`… They are numbered in the order the decisions settle. Each decision cites the question that settled it (`EP02-D4 ← K7`). A question with several sub-parts can produce several decisions. An older epic that used bare `D1` is cited as `EP-01 D1`.

**Glossary scan.** Before you send the round, scan it for every `_Avoid_` word in the glossary. Replace each hit that uses the avoided sense. Code names in backticks (for example a column `otp_secret`) and canonical terms that contain an avoided word (for example "Slack user", "Team channel") are fine.

**Deferred decisions.** If the user says a decision will be made later, do not ask it again. Record it as Open, with an owner and a "needed by" date. Every item that depends on it gets `Agent-ready: no`, with the reason.

When the user asks a question back (for example "wouldn't library X be better?"), answer it with researched facts, then fold the answer into the next round. After each round, append the answers to the discovery log (see Step 5) so a later session can resume. Repeat until no design question is open or every remaining one is deferred.

### Step 2 — Propose the story map

Propose the whole breakdown in one table, in build order:

| ID | Type | Title | Summary | Depends on |

- **Major tasks** (`EPNN-T#`) are foundations with no direct user value: skeletons, models, frameworks, platform services. Keep them few and justified. Each one must unblock a story.
- **User stories** (`EPNN-S#`) deliver something an actor can see or do.
- Apply the slicing guidance in [references/slicing.md](references/slicing.md).
- **Dependency on an epic that is not broken down yet.** Cite the epic ID and the capability you need from it (for example "EP-06: a query for the bookings of a date"). Do not invent its interface. If the item cannot be built without that interface, set `Agent-ready: no` with the reason, and add a ripple note for that epic so its own breakdown provides the interface.

Then ask a short round about the breakdown itself: anything to split or merge, edge rules the stories exposed (dates, blocking, failure), where the stories live and how they are sized. Defaults if the project has no convention yet: `docs/stories/EP-NN-stories.md`, and sizes S (up to 1 day), M (up to 3 days), L (must be split).

### Step 3 — Write the decision brief

Write all accepted decisions (`EPNN-D1`…, each citing its question ID and the source requirement or decision it changes) and the accepted story list into one brief. If you delegate the writing to sub-agents, give each of them this brief, so they share one source of truth and cannot contradict each other. Writing the brief also forces you to check that every decision is stated without ambiguity.

### Step 4 — Write the stories file

Create `docs/stories/EP-NN-stories.md` with the structure in [references/story-template.md](references/story-template.md). Each item says what to build, names the concrete libraries, modules and configuration values, gives Given/When/Then acceptance criteria that an automated test can check, and cites its decisions. It also carries an **Agent-ready** flag: "yes" means an agent can implement it with no further decision.

### Step 5 — Update the other docs

Use the checklist in [references/doc-updates.md](references/doc-updates.md):

- The epic: set status `Broken down`, replace "Story seeds" with a story index that links to the stories file, and add a "Breakdown decisions" section.
- `GLOSSARY.md`: new and changed terms.
- `docs/architecture.md`: the module sections, platform services and access model. Add any new ADR to the ADR index.
- New ADRs, only for decisions that are hard to reverse, surprising, and the result of a real trade-off. A base stack or a choice of authentication library usually qualifies.
- Every other epic that a ripple touches. Do not wait for the user to notice.
- `docs/epics/README.md`: status, graph edges and open items.
- `docs/discovery/DISCOVERY-LOG.md`: a section "EP-NN breakdown (date)" with the decision table and where each decision is recorded.

### Step 6 — Validate

Run the checks in [references/doc-updates.md](references/doc-updates.md#validation). Fix each failure and validate again. Typical failures from practice:

- A writer copied an outdated statement.
- A stories file tells the implementer to create a doc that already exists.
- An old log entry contradicts a new decision and has no "superseded by" note.

### Step 7 — Report

Close with a short summary:

- The number of items and their sizes, and the build order.
- The decisions made.
- The docs changed.
- **Every Assumption the writer added.** The user must see these, because they are decisions nobody asked about.
- What is still open, and which epic is next for breakdown.
