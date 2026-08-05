---
name: gh-adversarial-review
description: Second-pass adversarial verification of a GitHub PR after a normal review. Falsify claims and invariants in the implementation, tests, PR description, and prior review by constructing realistically reachable counterexamples. Use for adversarial review, assumption falsification, or second-pass scrutiny—not for the initial comprehensive review (use gh-review-pr).
---

# GitHub Adversarial PR Review

Second-pass only: falsify claims; do not repeat a full defect hunt. For PR resolution, diffs, auth, and GitHub posting mechanics, follow `../gh-review-pr/SKILL.md`.

**Goal:** Test whether implementation, tests, PR text, and prior-review conclusions survive realistic counterexamples.

**Not goals:** Style nits, personal criticism, exhaustive first-pass coverage, or inventing issues to look thorough.

## Principles

- Seek falsification, not confirmation.
- Treat PR text, comments, tests, and green CI as claims.
- Report only realistically reachable failure scenarios.
- Actively look for guards or evidence that defeat each hypothesis.
- Challenge assumptions, not the developer; use neutral language.
- Prefer few surviving findings; zero formal findings is a valid result.

## Relationship to gh-review-pr

`gh-review-pr` finds defects and checks prior feedback. This skill runs after that and attacks the claims those conclusions rest on. If the user needs a full review and none exists, route to `gh-review-pr` first. Do not modify code unless asked.

## Workflow

1. **Identify claims and invariants** — Prefer prior-review conclusions, then PR/issue text and tests: what does the change claim to guarantee?
2. **Trace paths those claims depend on** — Entry points, trust boundaries, ownership, async handoffs, side effects.
3. **Construct reachable counterexamples** — One realistic scenario per material claim that would break it. For high-risk surfaces, use matching checklist prompts (below).
4. **Hunt defeating guards** — Constraints, transactions, locks, idempotency, feature flags, or tests that already block the scenario.
5. **Validate narrowly** — Focused test or precise static evidence. Green CI alone does not prove a claim.
6. **Keep only survivors** — Formal findings: `confirmed` or `strongly supported`.
7. **Park the rest** — `plausible but unverified`, `disproved`, and `out of scope` stay out of formal findings and out of any GitHub comments.

## Finding gates

Formal findings need all of: a claim under test; a reachable trigger; a broken guarantee; evidence from diff, surrounding code, or executed checks; and a failed search for an existing guard.

- **`confirmed`** — reproduced or statically unavoidable
- **`strongly supported`** — well evidenced, not fully reproduced
- **`plausible but unverified`** — credible but under-evidenced (never a formal finding)
- **`disproved`** — guard or test defeats it
- **`out of scope`** — not introduced or materially affected by this PR

Optional severity: reuse `gh-review-pr` P0–P3; do not inflate.

## When to read the checklist

Open [references/adversarial-checklist.md](references/adversarial-checklist.md) **only** for risk surfaces present in the PR, and **only** the matching section headings—never the whole file by default, never every prompt.

| If the PR involves… | Read section |
| --- | --- |
| Strong guarantees in PR/prior review | Requirements and invariants |
| Time, money, quota, encoding, or edge values | Boundary values and representations |
| Lifecycle or destructive transitions | State transitions |
| Races, queues, or event order | Concurrency and ordering |
| Retries, idempotency, or async jobs | Retries and idempotency |
| External side effects or multi-step commits | Partial failures |
| Authz or tenant isolation | Authorization and tenant isolation |
| Transactions or integrity constraints | Data integrity and transactions |
| Schema, deploy, compatibility, or rollback | Compatibility, migrations, deployment, and rollback |
| Hot paths, batch size, or shared pools | Resource exhaustion and performance |
| Detectability or repair/replay | Observability and recovery |
| Tests used as proof of safety | Test validity |

If the file is missing, continue with this skill and note the gap.

## Output format

```text
## Adversarial review result
<verdict: what was challenged; what survived>

## Claims and invariants examined
- <claim>: <how challenged>

## Confirmed findings
### confirmed | strongly supported — <title>
`<path>:<line>`
Claim under test: ...
Counterexample: ...
Why guards fail: ...
Impact: ...
Correction direction: ...

## Unverified hypotheses
- plausible but unverified — <hypothesis; missing evidence>
- out of scope — <item; why>

## Disproved hypotheses
- disproved — <hypothesis; defeating guard/test>

## Verification
- `<command>`: passed | failed | not run (<reason>)

## Residual risk
- <untested or untestable remainder>
```

Omit empty formal-finding templates when none survive. Report to the user by default; post to GitHub only if explicitly requested, and only formal findings.
