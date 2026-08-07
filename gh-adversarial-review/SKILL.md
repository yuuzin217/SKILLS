---
name: gh-adversarial-review
description: Adversarial verification of a GitHub PR by falsifying claims and invariants with realistically reachable counterexamples. Normally use as a second-pass review after a normal review. It may run without a prior normal review only when the user explicitly requests adversarial-only analysis and accepts that the result is not comprehensive. Use only when the user explicitly asks for adversarial review, red-team review, assumption falsification, or counterexample analysis. Generic initial review, generic re-review, and prior-feedback verification belong to gh-review-pr.
---

# GitHub Adversarial PR Review

Falsify claims; do not run a full defect hunt. For PR resolution, diffs, and GitHub auth/CLI mechanics, follow `../gh-review-pr/SKILL.md`. Both skills default to report-only; post to GitHub only on explicit user request.

**Goal:** Test whether implementation, tests, PR text, and prior-review conclusions survive realistic counterexamples.

**Not goals:** Style nits, personal criticism, exhaustive coverage, or inventing issues to look thorough.

## When to use

Use this skill **only** when the user explicitly requests adversarial review, red-team review, assumption falsification, counterexample analysis, or clear synonyms.

Use this skill after a normal review has been completed.

If no normal review is available in the conversation or PR history, run `gh-review-pr` normal-review analysis as a prerequisite—bypassing its routing and posting steps, and without re-invoking adversarial routing. After analysis, return here for adversarial verification.

If the user explicitly requests adversarial-only analysis without a normal review, proceed only after clearly stating that the result is not a comprehensive PR review.

Route to `gh-review-pr` for:

- generic initial review
- generic re-review
- prior feedback verification / “were comments addressed?”

Do not modify code unless asked.

## Principles

- Seek falsification, not confirmation.
- Treat PR text, comments, tests, and green CI as claims.
- Report only realistically reachable failure scenarios.
- Actively look for guards or evidence that defeat each hypothesis.
- Challenge assumptions, not the developer; use neutral language.
- Prefer few surviving findings; zero formal findings is a valid result.

## Workflow

1. **Identify claims and invariants** — Prefer prior-review conclusions, then PR/issue text and tests.
2. **Trace paths those claims depend on** — Entry points, trust boundaries, ownership, async handoffs, side effects.
3. **Select checklist sections (≤3)** — See below; construct one reachable counterexample per material claim.
4. **Hunt defeating guards** — Constraints, transactions, locks, idempotency, flags, or tests that already block the scenario.
5. **Validate narrowly** — Focused test or precise static evidence. Green CI alone does not prove a claim.
6. **Keep only survivors** — Formal findings: `confirmed` or `strongly supported`.
7. **Park the rest** — `plausible but unverified`, `disproved`, and `out of scope` stay out of formal findings and out of GitHub comments. Unexplored surfaces go under Residual risk.

## Finding gates

Classify by whether **material premises** are established: reachability, absence of a defeating guard, incorrect behavior / broken guarantee, impact, and (for formal findings) that the PR introduced or materially affected the issue.

- **`confirmed`** — Reproduced, or entailed by inspected code under stated conditions (decisive; no material premise left open).
- **`strongly supported`** — Reachability, missing/ineffective guard, incorrect behavior, and impact are all evidenced; only non-essential confirmation (e.g. live reproduction) is missing.
- **`plausible but unverified`** — Credible, but at least one material premise is open: reachability, guard absence, production behavior, impact, or PR causation (never a formal finding).
- **`disproved`** — Guard or test defeats the counterexample.
- **`out of scope`** — Not introduced or materially affected by this PR.

Optional severity: reuse `gh-review-pr` P0–P3; do not inflate.

## Checklist reading (staged)

Open [references/adversarial-checklist.md](references/adversarial-checklist.md) only as follows:

1. From surfaces present in the PR, pick **at most three** sections.
2. Prioritize by **impact**, **reachability**, **irreversibility**, and **uncertainty**—not by topical resemblance alone.
3. Read the content of only the selected sections. Within each selected section, use only prompts relevant to the material claims under review. Never read the whole file by default or apply every prompt mechanically.
4. Read **additional** sections only if initial analysis reveals a concrete cross-cutting risk, or a material claim cannot be tested with the first set.
5. Do **not** widen scope because a section “might be related.” Record unread/unverified areas under **Residual risk**.

Section map (selection aid, not a mandate to open all):

| Risk surface | Section |
| --- | --- |
| Strong guarantees in PR/prior review | Requirements and invariants |
| Time, money, quota, encoding, edges | Boundary values and representations |
| Lifecycle or destructive transitions | State transitions |
| Races, queues, event order | Concurrency and ordering |
| Retries, idempotency, async jobs | Retries and idempotency |
| External side effects / multi-step commits | Partial failures |
| Authz or tenant isolation | Authorization and tenant isolation |
| Transactions or integrity constraints | Data integrity and transactions |
| Schema, deploy, compatibility, rollback | Compatibility, migrations, deployment, and rollback |
| Hot paths, batch size, shared pools | Resource exhaustion and performance |
| Detectability or repair/replay | Observability and recovery |
| Tests used as proof of safety | Test validity |

If the file is missing, continue with this skill and note the gap.

## Output format

```text
## Adversarial review result
<verdict: what was challenged; what survived>

## Claims and invariants examined
- <claim>: <how challenged>

## Formal findings
### confirmed | strongly supported — <title>
`<path>:<line>`
Claim under test: ...
Counterexample: ...
Why guards fail: ...
Impact: ...
Correction direction: ...

## Unverified hypotheses
- plausible but unverified — <hypothesis; missing premise>
- out of scope — <item; why>

## Disproved hypotheses
- disproved — <hypothesis; defeating guard/test>

## Verification
- `<command>`: passed | failed | not run (<reason>)

## Residual risk
- <unread checklist sections, untested claims, or untestable remainder>
```

Omit empty formal-finding templates when none survive.

### GitHub posting

Default: report to the user only. Post to GitHub **only** when the user explicitly asks. Never post `plausible but unverified`, `disproved`, or `out of scope` items—formal findings only. For API/CLI comment mechanics when posting, follow `gh-review-pr`.
