# Sizing Guide

Use relative sizing so the breakdown stays useful regardless of team, rates or velocity. The estimator converts sizes to effort using their own calibration.

## T-shirt scale

Sizes describe a component's overall relative effort. Indicative ranges assume a single experienced developer and are only for orientation — do not present them as the estimate unless the user asks for effort figures.

| Size | Meaning | Indicative effort |
|---|---|---|
| XS | Trivial, well-understood, config or a single simple screen/endpoint | < 3 days |
| S | Small, few moving parts, standard patterns | 3–10 days |
| M | Moderate, several screens/endpoints or one non-trivial integration | 2–5 weeks |
| L | Large, many features or complex business rules | 5–10 weeks |
| XL | Very large or poorly understood — consider splitting or a discovery spike | > 10 weeks |

If a component comes out XL, check whether it should be split into smaller components. If it's XL mainly because of uncertainty, say so and recommend a spike rather than just sizing it big.

## Complexity drivers

Look for these in the inputs and name them explicitly in the breakdown — they justify the size:

**Increases size**
- Number of distinct user roles and permission rules
- Number of screens / entities / workflows
- Complex business rules, calculations, state machines, approval flows
- Real-time or offline-capable behaviour
- Multiple platforms or a wide device/browser matrix
- Integrations — especially two-way sync, legacy, or undocumented APIs
- Data migration volume and data quality problems
- Compliance, security or accessibility requirements
- Localisation (languages, currencies, regions)
- High performance / scale / availability targets
- Mandated or unfamiliar technology

**Decreases size**
- Off-the-shelf services or SaaS that cover the need (auth providers, payments, CMS)
- Client supplies designs, content and test data
- Existing codebase or design system to reuse
- Clear, stable, well-documented requirements

## Uncertainty rating

| Level | When to use | Implication for the estimator |
|---|---|---|
| Low | Requirements clear, standard patterns, team has done it before | Narrow range is fine |
| Medium | Some details missing or some unfamiliar elements | Moderate range, note key assumptions |
| High | Major unknowns, undocumented integration, novel tech, vague scope | Wide range, discovery spike, or exclude/price separately |

Always give the reason for the rating — "High: legacy ERP, no API docs provided" is actionable; "High" alone is not.

## If asked to produce effort figures

- Use a three-point estimate per component: Optimistic (O), Most likely (M), Pessimistic (P).
- PERT expected value = (O + 4M + P) / 6. Report the range as well as the expected value.
- Add delivery overheads as separate lines, not hidden inside components: project management, QA (if not already per-component), and contingency.
- Scale contingency with uncertainty rather than applying a flat percentage everywhere.
- State the conversion basis (e.g. "1 day = 6 productive hours", team composition, rates supplied by the user).
