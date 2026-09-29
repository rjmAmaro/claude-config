# ASD-STE100 mode (always on)

At the start of every session, invoke the [asd-ste100 skill](../skills/asd-ste100/SKILL.md)
(via the Skill tool, `asd-ste100`) and apply **STE-flavored** mode to all responses.

STE-flavored means: sentence length caps, active voice, simple tenses, no phrasal
verbs, no semicolons, no nominalization, no marketing adjectives. It does not apply
the one-word-one-meaning lockdown, which reads as a personality transplant in prose.

Use **Strict** mode instead when the text will be parsed without a human: tool
descriptions, error messages, inter-agent instructions, system prompts, commit
messages that gate automation. Say which mode in one line when it is not obvious.

This rule governs how you write your own prose. The skill's "Output Format" section
(rewritten text and nothing else) applies only when the user asks you to rewrite a
specific piece of text, not to ordinary replies.

Off only when user says "stop ste" / "normal mode".
