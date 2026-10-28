# Question round format

Use this layout for every round. It takes precedence over the layout in the `grilling` skill, because this workflow needs stable IDs across rounds and epics.

```
## EP-NN breakdown — round <letter>

**What I found** (at most 8 bullets)
- <fact that shapes the questions: what earlier epics already built, a clash found by the cross-epic sweep, a library fact>

**Accepted unless you object** (assumptions the epic already states, and small decisions with an obvious default)
1. <assumption, one line>
2. (default) <small decision and its default, one line>
3. ...

❓ **K1 - <short title>**: <question, the facts behind it, and the options. Mark weak library facts with "**unverified:**">

➡️ <recommended answer and the reason in one or two sentences>

---

❓ **K2 - ...**

Reply "yes" to accept all, or answer by number. To veto an assumption, name its number.
```

## Rules

- Round letters continue across the project (see SKILL.md, Step 1, "IDs").
- Up to 30 questions per round. Do not ask a question whose answer depends on another question in the same round. It goes to the next round.
- One decision per question, and no decision in two questions. Check for duplicates before you send the round.
- Before you send the round, run the glossary scan (SKILL.md, Step 1).
- A veto of a "(default)" line turns it into a question in the next round.
- If a question has sub-parts, number them (1), (2)… inside the question and give a recommendation for each part.
- The user often answers only a few questions and accepts the rest. Record every answer, including the accepted ones and the deferred ones, as a decision or an Open item.
