# Rails testing reference

Read this when building the test list (step 3) and whenever you are unsure which kind of test should drive a change.

## Contents
- Choosing the test type
- Test layout
- Commands
- Failing for the right reason
- Test data
- Time, jobs, mail and external services
- Migrations in a TDD loop
- Habits that keep the suite healthy

## Choosing the test type

| What you're building | Test that drives it | Notes |
|---|---|---|
| Model behavior: validations, associations, scopes, callbacks, instance/class methods | Model spec (`spec/models`) / model test | Use shoulda-matchers one-liners for associations/validations only if the project already does. Test scopes against real records, including ones that must be excluded. |
| Service, form, query or other plain Ruby objects | Unit spec / test | Prefer `build` / `build_stubbed` over `create` when persistence isn't the point. |
| Controller actions, API endpoints, routes | Request spec (`spec/requests`) / integration test | Assert status, body or JSON, and the resulting state change. Don't write new controller specs — request specs replaced them. |
| Authorization (Pundit, CanCanCan, hand-rolled) | Policy spec, plus one request spec per denial path | The request spec proves the policy is actually wired in. |
| Browser behavior: JavaScript, Turbo/Stimulus, multi-step flows | System spec / system test | Slow and brittle: one per meaningful flow. Push edge cases down to request and unit tests. |
| Views/partials without logic | Covered by request or system tests | Use view or component specs only if the project already has them. |
| ViewComponent | Component spec with `render_inline` | |
| Background jobs | Job spec for `perform`, plus `have_enqueued_job` / `assert_enqueued_with` where they're enqueued | Test what the job does and, separately, that the caller enqueues it with the right arguments. |
| Mailers | Mailer spec (recipients, subject, key body content), plus `have_enqueued_mail` / `assert_enqueued_emails` where they're triggered | |
| Rake tasks, data backfills | Extract the logic into a class and unit-test it. Keep the task a one-liner | |
| API clients for external services | Unit spec with WebMock stubs or VCR cassettes | Mock at this boundary in higher-level tests. |

## Test layout

In each `describe` block, put happy-path behaviors first. Put error and edge cases after them. Error and edge cases are invalid input, authorization, boundaries, idempotency, and side effects.

```ruby
RSpec.describe Projects::Archive do
  describe "#call" do
    context "when the project is active" do
      it "sets archived_at"
      it "enqueues the owner notification"
    end

    context "when the project is already archived" do
      it "keeps the original archived_at"
    end

    context "when the user is not an admin" do
      it "raises NotAuthorized"
    end
  end
end
```

The same order applies to Minitest tests in a class. Put the happy-path tests first and the error tests after them.

## Commands

The setup script prints the right binstub (`bin/rspec` vs `bundle exec rspec`). Common forms:

**RSpec**
- One example: `bundle exec rspec spec/models/project_spec.rb:42`
- One file or directory: `bundle exec rspec spec/models/project_spec.rb`, `bundle exec rspec spec/requests`
- Stop at first failure: `--fail-fast`
- Re-run only failures: `--only-failures` (needs `example_status_persistence_file_path` configured)
- Order-dependent failure: re-run with the reported `--seed N`
- Readable output while working: `--format documentation`

**Minitest**
- One test: `bin/rails test test/models/project_test.rb:42`
- One file or directory: `bin/rails test test/models`
- System tests: `bin/rails test:system` (not included in `bin/rails test`)
- Stop at first failure: `bin/rails test --fail-fast`

**Database**
- `bin/rails db:migrate` updates `db/schema.rb`. `maintain_test_schema!` in the helper usually syncs the test DB. If it does not, run `bin/rails db:test:prepare`.
- `bin/rails db:rollback` then `bin/rails db:migrate` to check reversibility.

If tests behave as though they run old code, Spring may be stale. Run `bin/spring stop`.

## Failing for the right reason

Accept a red only when the failure is about the behavior you're adding:

- An expectation mismatch about that behavior ("expected 403, got 200", "expected archived_at to be present")
- `NameError` / `NoMethodError` for the class or method the test is deliberately driving into existence
- A routing error when the test is deliberately driving a new route
- An `ActiveRecord` error about a missing column or table the test is deliberately driving into a migration

Fix the test (not the code) when the failure is about the test itself:

- `NameError` / `NoMethodError` from the test's own code — a typo, a missing `let`, a helper that isn't included
- A missing or invalid factory, or `ActiveRecord::RecordInvalid` raised from setup
- `ActiveRecord::PendingMigrationError` or a stale test schema
- A request spec getting a 302 to the login page because authentication isn't set up in the test
- CSRF or host-authorization errors in request specs
- A system spec that can't find a JavaScript driver
- A failure that disappears when the test runs alone (order dependence, leaked state)

## Test data

- Use the project's existing approach. Don't introduce FactoryBot into a fixtures project, or the other way round.
- Add traits to existing factories rather than new factories for variants.
- Create only what the test needs. In unit tests prefer `build` / `build_stubbed`. Use `create_list` sparingly.
- Make the data that matters visible in the test itself. For example, if the example is about archiving a project, set `archived_at` explicitly. Do not rely on a factory default.

## Time, jobs, mail and external services

- **Time:** `travel_to` / `freeze_time` from `ActiveSupport::Testing::TimeHelpers` (include it in the config if the project hasn't).
- **HTTP:** WebMock `stub_request` or VCR cassettes — never the real network. If a test would need a new cassette recorded with real credentials, stop and ask.
- **Active Job:** with the `:test` adapter, use `have_enqueued_job` / `assert_enqueued_with` to check enqueuing and `perform_enqueued_jobs` to run them inline. For Sidekiq, follow the project's `Sidekiq::Testing` mode.
- **Mail:** Use `have_enqueued_mail` / `assert_enqueued_emails` for `deliver_later`. Use `ActionMailer::Base.deliveries` for `deliver_now`.

## Migrations in a TDD loop

1. A test fails because a column or table doesn't exist — that's the right reason.
2. Generate the migration with `bin/rails g migration ...` so the timestamp and naming are right.
3. Write it reversible (`change` with reversible operations, or explicit `up`/`down`). Add the database constraints integrity needs — `null: false`, defaults, foreign keys, unique indexes — alongside the model validations.
4. Run `bin/rails db:migrate`, check the `db/schema.rb` diff contains only your change (unrelated diff noise usually means the local DB is out of sync with `main`), and re-run the test.
5. Never edit a merged migration or a migration that ran elsewhere. Write a new one.
6. If `strong_migrations` is in the bundle, follow its advice rather than wrapping things in `safety_assured`.

Data migrations and backfills over existing records are destructive enough to ask the user first (see the skill's "Deviation rules").

## Habits that keep the suite healthy

- Assert on outcomes — state, response, enqueued job, sent mail — not on which private methods the code called. Mock at boundaries you own (an API client), not ActiveRecord internals.
- One behavior per example, named so the output reads as a spec: `it "rejects names longer than 100 characters"`.
- When you add a column used in lookups, consider an index. When you add an association, decide `dependent:`. When you add a query inside a loop, check for N+1 (Bullet if present, or `includes`).
- Avoid `sleep` in tests. In system specs, rely on Capybara's waiting matchers (`have_content`, `have_css`).
- Keep system tests few and focused on flows. The bulk of coverage belongs in fast unit and request tests.
