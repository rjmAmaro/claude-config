# Slicing guidance

## Size

- Every item must be S or M. An L item must be split before anyone can give it to an agent.
- Split along a security rule, an actor, a failure path or a channel. Do not split along a layer (model, then controller, then view). An item cut by layer cannot be tested end to end.
- Small items are fine when each one has a different rule to test. *Example: login, emailed code, lockout, password reset and timeout are five items. Each has its own security behaviour and its own tests.*

## Major tasks

- Use a task only for work with no direct user value: the app skeleton, platform services, base models, the access rule framework, the translation base, and **verification spikes** for library facts marked "unverified" (for example "confirm that gem X supports Rails 8.1 and the scopes we need"). Put a spike before the items that rely on it.
- A task must unblock at least one story. If it does not, remove it.
- Put the tasks first in the build order only when stories depend on them. Otherwise interleave them.

## Order and dependencies

- List the items in build order. Each "Depends on" must point to an earlier item in this epic or to an item in an earlier epic, by ID.
- Make the first path end to end early. *Example: skeleton → model → access rules → the first login story.*

## Agent-ready

An item is agent-ready when:

- every decision it needs is in the decision list,
- its acceptance criteria can be checked by automated tests,
- it names the concrete libraries and configuration values,
- it says what is out of scope and where that lives.

If any of these is missing, set Agent-ready to "no" and give the reason.
