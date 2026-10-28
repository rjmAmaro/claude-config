# Doc updates and validation

## Update checklist

Merge changes into the existing structure of each file. Do not rewrite whole files, because other sessions and people edit them too.

1. **The epic** (`docs/epics/EP-NN-*.md`)
   - Status: `Broken down`.
   - Scope, footprint, acceptance criteria, risks: apply the decisions. Remove assumptions that a decision resolved.
   - Open questions: remove the answered ones. Add new non-blocking ones with an owner.
   - Replace "Story seeds" with `## Stories`: an index table (ID, type, title, depends on) and a link to the stories file.
   - Add `## Breakdown decisions`: `EPNN-D1`…, one line each, with the question ID.
   - Add the deferred decisions to Open questions, with owner and "needed by".
2. **GLOSSARY.md**: add new terms and redefine changed ones. Glossary only, no implementation detail.
3. **docs/architecture.md**: the module sections the decisions touch, the platform services (which epic sets each one up), the access model, and the ADR index.
4. **docs/adr/**: a new ADR for each hard-to-reverse decision, in the format of the existing ADRs.
5. **Rippled epics**: every epic whose scope, dependencies or assumptions a decision changed. Typical ripples:
   - A platform service moves to an earlier epic.
   - A reference changes target (for example, "manager" now points to a login account).
   - A visibility rule changes.
   - A screen now starts in this epic and a later epic extends it.
6. **docs/epics/README.md**: the epic status, the blocked-by lists, the graph edges, the coverage rows that changed, and the open items.
7. **docs/discovery/DISCOVERY-LOG.md**: a section `## EP-NN breakdown (<date>)` with a table: decision ID, question ID, decision, where it is recorded. Start the section after the first round is answered, and append to it after each round, so an interrupted session can resume. If a decision supersedes an older log entry, add a "Superseded by …" note to that entry. Do not delete it.

## Validation

Run these checks with grep or a short script, not by eye.

1. **Coverage:** every requirement ID in the epic's "Requirements covered" table appears in the stories file's coverage table.
2. **Size:** no item is L.
3. **Dependencies:** each item's "Depends on" points to an existing ID. The dependency graph in README.md has no cycles (`tsort` on the edges).
4. **Glossary:** no `_Avoid_` term appears in the stories file, the epic or the architecture file, except in lines that name the avoided term on purpose.
5. **Stale wording:** for each decision that reversed an earlier statement, grep all docs for the old wording. *Example: after "no automatic block", grep for "leaver … blocked" and "leaving date … block".*
6. **Self-reference:** the stories file must not ask the implementer to write a doc or ADR that already exists.
7. **Status:** the epic says `Broken down`, and README.md agrees.
8. **Assumptions:** collect every `Assumption` in the stories file for the final report.
9. **Unverified facts:** every fact marked "unverified" has a verification task in the stories file, or the user accepted the risk.
10. **IDs:** the decision IDs use the `EPNN-D` prefix and do not collide with other epics.
