# Decision checklist

Use this list to find the high- and medium-level decisions that an epic's stories need. Ask only about the items that apply to this epic and that the docs do not already settle. Each item gives the kind of question and an example from a real breakdown.

## High level (hard to reverse — consider an ADR)

- **Base stack, if this is the first epic.** Language and framework version, database, front-end approach, test framework. *Example: Rails 8.1, PostgreSQL, Hotwire, Tailwind, RSpec.*
- **Libraries for a whole concern.** Authentication, authorisation, background jobs, file storage, search, PDF. Compare the framework's built-in feature with the established library, and check current docs before you recommend. *Example: the user preferred Devise over the Rails authentication generator because they knew it and it covers OAuth, lockout, reset and timeout in one place.*
- **Data model and ownership.** Which entity holds which field. One source for each fact (*example: the email lives only on the login account*). How actors without a domain record are modelled (*example: a super admin account with no employee record that can still be a manager*).
- **Access and visibility.** Who sees and who acts on what. Direct relation or the whole tree. Visibility that changes over time (*example: during a review cycle only the final reviewer works on the review. After the review is finished, every manager above the employee can read it*).
- **Integration direction and failure behaviour.** Synchronous or background. What the user sees on failure. Retries. Where failed work stays visible.

## Medium level (shape the stories)

- **Lifetimes and thresholds.** Session timeout per actor kind, token or code validity, lockout attempts and duration, rate limits. *Example: 5 failed attempts lock the account for 15 minutes. A super admin session ends after 2 hours without activity.*
- **Manual or automatic.** A state that a date or a job could set, or that a person sets by hand. *Example: the user rejected "block a leaver automatically the day after the leaving date" and asked for an "access blocked" checkbox.*
- **How records come to exist.** A screen, a command-line task, an import, or seed data. Who may create them. *Example: super admins are created only by a command-line task, which emails a "set your password" link.*
- **The minimum that makes the epic testable end to end.** If a later epic owns the full screen, does this epic need a thin version now? *Example: a minimal employee list in the sign-in epic, so login can be tested before the profile epic.*
- **Platform service first use.** If this epic is the first that needs background jobs, email, file storage or an external API, it sets up the bare minimum. Check which earlier stories already did.
- **Language, time zone and format rules** that apply to this epic's screens and messages.
- **Audit and data export.** Which changes this epic must log, and which data it adds to any export.
- **Edge cases in time.** Past dates, a year boundary, 29 February, a change while a session is open, overlaps.

## After each answer

Ask yourself: does this decision change another epic, a glossary term, or the architecture file? If it does, add it to the ripple list for Step 5.
