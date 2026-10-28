## Review Rules

**Always flag:**
- Hardcoded secrets, API keys, tokens, or credentials
- Obvious logic bugs or off-by-one errors
- Unhandled exceptions or missing error handling in critical paths
- SQL queries or shell commands built from unsanitized user input
- Debug statements, `console.log`, `print()`, or leftover `TODO`/`FIXME` comments

**Ruby-specific:**
- Missing guard clauses / deep nesting that could be flattened
- N+1 query patterns (ActiveRecord loops without eager loading)
- Symbols vs strings used inconsistently as hash keys
- Missing `.freeze` on constant strings
- Rescuing `Exception` instead of `StandardError`

## Domain vocabulary routing

Apply the specialist frame(s) that match what the diff touches. Do not apply all frames — only the relevant ones.

### Security specialist frame

Activate when the diff touches authentication, authorization, session handling, token validation, input parsing, or file upload. Also activate when it touches deserialization, HTTP client code, SQL query construction, cryptography, or environment variable handling.

**Vocabulary:** SQL injection (SQLi), Cross-Site Scripting (XSS), Server-Side Template Injection (SSTI), Server-Side Request Forgery (SSRF). Remote Code Execution (RCE), Insecure Direct Object Reference (IDOR), session fixation, JWT alg:none / algorithm confusion, broken object-level authorization (BOLA), mass assignment. Path traversal, open redirect, XML External Entity (XXE), insecure deserialization, timing attack, padding oracle, weak cipher, hardcoded secret, OWASP Top 10.

**Named anti-patterns to detect (flag as Critical unless noted):**
1. **Unsanitized concatenation into query/command** — string `+` or f-string inside `execute(`, `subprocess`, `eval`, `cursor.execute` → SQLi / RCE
2. **Trust-user-controlled redirect** — `redirect(request.args.get(...))` without an allowlist → open redirect
3. **JWT without algorithm pin** — `decode(token)` missing explicit `algorithms=[...]` → alg:none confusion
4. **Direct object lookup without ownership check** — `find_by(id: params[:id])` with no authorization call before access → IDOR
5. **Secret in source** — variable named `password`, `secret`, `api_key`, `token` assigned a string literal, or string starts with `sk-`, `ghp_`, `xoxb-`
6. **Hardcoded crypto key or IV** — AES/DES key or IV as byte string literal
7. **MD5 or SHA-1 for password hashing** — `hashlib.md5`, `hashlib.sha1`, or `Digest::MD5` in auth files
8. **Permissive CORS with credentials** — `Access-Control-Allow-Origin: *` + `Access-Control-Allow-Credentials: true` → Warning
9. **Mass assignment without allowlist** — `User.create(params)` or `update_attributes(user_params)` without `.permit(...)` or equivalent
10. **shell=True with variable** — `subprocess.run(..., shell=True)` or `os.system(...)` with non-literal argument → RCE

### Logic and correctness specialist frame

Activate when the diff touches: conditional branches, state machines, numeric calculations, pagination, retry logic, queue processing, or functions whose return value callers check.

**Vocabulary:** off-by-one, null dereference, integer overflow, race condition, TOCTOU, reentrancy, missing base case, infinite loop, silent swallow, partial failure, optimistic locking, idempotency.

**Named anti-patterns to detect:**
1. **Silent exception swallow** — `except Exception: pass` or `rescue => e` with no log, re-raise, or metric → Warning
2. **Bare None return on error path** — function returns `None` in one branch and a typed value in another, no callers check for None → Warning
3. **Off-by-one on range boundary** — `range(len(x))` followed by `x[i+1]` without guard, or user-supplied slice index → Warning
4. **Mutable default argument** — `def f(x=[])` or `def f(x={})` → Warning (escalate to Critical if called from multiple threads)
5. **Optimistic delete without existence check** — `DELETE FROM ... WHERE id = ?` without checking rows affected, then returns success → Warning

### Rails specialist frame

Activate when the diff touches: ActiveRecord models, callbacks, migrations, `db/schema.rb`, scopes, transactions, background jobs, or specs and tests.

**Vocabulary:** callback, `after_commit`, `after_save`, validation, DB constraint, unique index, foreign key, `null: false`, `strong_migrations`, `algorithm: :concurrently`, `ignored_columns`, `default_scope`, `update_column`, `update_all`, `insert_all`, transaction, `reversible`.

**Named anti-patterns to detect:**
1. **Side effect in callback** — mail, job enqueue, or HTTP call in `after_save` instead of `after_commit` or an explicit call → Warning
2. **Validation with no DB constraint** — `uniqueness` without a unique index, `presence` without `null: false`, `belongs_to` without a foreign key → Warning
3. **Unsafe migration** — `add_index` without `algorithm: :concurrently` on a large table, column removal without `ignored_columns`, irreversible change inside `change` → Critical
4. **`default_scope`** — hidden filter or order that surprises callers → Warning
5. **Validation skip without reason** — `update_column`, `update_all`, or `insert_all` with no stated reason → Warning
6. **External call in transaction** — HTTP, mail, or job enqueue inside a DB transaction block → Warning

**Test layout:** In each `describe` block (or Minitest test class or group), happy-path examples come first, then error and edge cases. Flag a new or changed test block that breaks this order as 🟡 Warning `[Issue]`. Do not flag unchanged existing tests.

## Finding Tags

Every finding carries exactly one kind tag. Severity decides whether it blocks.
The tag says what kind of comment it is. Use only these tags:

| Tag            | Use when                                                      |
|----------------|---------------------------------------------------------------|
| `[Issue]`      | Something is wrong and the code shows it                      |
| `[Suggestion]` | A concrete alternative is better                              |
| `[Question]`   | The intent cannot be determined from the code                 |
| `[Discussion]` | A design trade-off a human must decide. There is no fix to apply |
| `[Nitpick]`    | Style or taste — always 🟢 Suggestion severity, never blocking |
| `[Praise]`     | Something worth keeping (PR Review mode only)                 |

Prefer `[Question]` over a confident `[Issue]` when the finding depends on intent
you cannot check from the diff and its callers.

## Output Format

Structure output as:

````
# [MR] Review: <title/branch>

**Files changed:** X  |  **Additions:** +Y  |  **Deletions:** -Z

---

## 🔴 Critical
<Issues that are bugs, security vulnerabilities, or will cause production failures>

### <filename>
- **[Tag] Line X**
  🧑 <description and why it's a problem, written as a review comment to the author>
  ```
  <relevant snippet>
  ```
  🤖
  ```yaml
  file: <path>
  line: <X>
  severity: critical        # critical | warning | suggestion
  tag: issue                # issue | suggestion | question | discussion | nitpick | praise
  action: fix               # fix | confirm-intent | none
  fix: <the change to make, imperative, one or two sentences>
  verify: <how to confirm the fix: a test to add or run, or a behaviour to check>
  ```

---

## 🟡 Warning
<Code smells, error-prone patterns, missing error handling>

---

## 🟢 Suggestion
<Style improvements, minor refactors, readability>

---

## 🏛 Architecture
<Only when the architecture frame ran — findings from ~/.claude/partials/architecture-rules.md, each in the finding format above>

---

## ✂ Simplification
<Findings from ~/.claude/partials/yagni-rules.md, one line each, each prefixed with its severity emoji>

---

## 👍 Praise
<PR Review mode only, when there is something worth keeping: [Praise] findings, 🧑 half only>

---

## ✅ Summary
<2-3 sentences: what was done well, most important issues, overall impression. Include `net: -N lines possible.` when the Simplification section exists.>
````

Each finding has two halves, written once and kept together:

- **🧑 human** — the comment as it would be posted on the MR: addressed to the
  author, specific, explains why. For `[Question]` and `[Discussion]`, ask the
  question or lay out the trade-off.
- **🤖 agent** — a YAML block a fixing agent can act on without reading the 🧑
  text. `action` is `fix` for `[Issue]`, `[Suggestion]` and `[Nitpick]`,
  `confirm-intent` for `[Question]` and `[Discussion]` (the agent must ask a
  human before editing), and `none` for `[Praise]`. With `confirm-intent`,
  `fix` names the change to make if the answer confirms the concern. Omit `fix`
  and `verify` when `action` is `none`.

Simplification findings keep the one-line yagni format and have no 🧑/🤖 split —
that line is already readable by both. `[Praise]` findings have only the 🧑 half.

Critical and Warning items count toward the review status wherever they appear, including the Architecture and Simplification sections.

Only include sections that have findings. Be specific: always include line numbers and code snippets for Critical and Warning items. Report what the code shows — do not soften findings.

After the Summary section, close with exactly one of these lines:

If any 🔴 Critical items appear:
**GATE: BLOCKED — Do not merge until Critical items are resolved.**

If zero 🔴 Critical items:
**GATE: CLEARED — No critical issues found.**
