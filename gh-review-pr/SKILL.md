---
name: gh-review-pr
description: Review GitHub pull requests on the first pass or after updates, identify evidence-backed defects and risks, and report findings to the user. Use when the user asks to review a PR, review code changes, perform a re-review after code changes, verify whether prior feedback was addressed, or review newly changed code after a previous review. Inspect the full PR on an initial review and combine prior review-thread verification with new-diff analysis on a re-review. Post to GitHub only when the user explicitly requests it.
---

# GitHub Pull Request Reviewer

Default: **review analysis only** — report to user; **no GitHub write**.

**Goal:** Confirm the implementation meets requirements and find concrete defects or regressions **introduced or materially affected** by this PR.

**Not goals:** Style nits, vague concerns, speculative findings, unrelated pre-existing issues, routine praise, or inventing issues to appear thorough.

## Routing

**Use this skill:** generic initial PR review; re-review after code changes; prior-feedback verification; review of newly changed code after a previous review; generic PR code review.

**Route to `gh-adversarial-review`** only on **explicit** request for adversarial review, red-team review, assumption falsification, counterexample analysis, or clear synonyms.

Do **not** route generic re-review (“review again,” “fixed—re-review,” “were comments addressed?”) to adversarial review.

## Principles

- Report defects, not suspicions. Review behavior, not isolated syntax.
- Prefer few well-supported findings over many speculative ones.
- Zero findings is valid. Green CI alone does not prove correctness.
- Do not invent findings to appear thorough.

**Not formal findings:** naming/formatting/style preferences; vague concerns; unreachable hypotheses; unrelated pre-existing issues; unproven large refactors; routine praise.

## Review modes

### Initial review

Review the **full PR** (complete merge-base diff), not only the latest commit.

Minimum: PR title/description; linked issue / acceptance criteria when relevant; surrounding implementation; affected callers/interfaces/contracts; relevant schema/migration/config; relevant tests; CI when available.

Center on changed code; widen only as needed. Do not read the entire repository.

### Re-review

When implementation changed after feedback, user asks for another normal review, or prior findings need verification.

**Always:** (1) verify each previous actionable finding; (2) check for new defects since the prior review.

| Status | Meaning |
| --- | --- |
| `resolved` | Original failure mode no longer holds |
| `partially resolved` | Material risk remains |
| `unresolved` | Issue still present |
| `superseded` | Later design made finding irrelevant |
| `cannot verify` | Insufficient evidence |

`resolved` = failure mode gone—not merely code changed near the comment. Per finding: original failure mode → current implementation → guards/callers/tests → status.

Do not duplicate unresolved threads as new findings for the same failure mode.

## Workflow

1. **Resolve PR** — repo/PR number/URL, or local branch via `gh pr view --json number,url,baseRefName,headRefName`. Report ambiguity; do not guess.
2. **Requirements** — PR description, linked issue, acceptance criteria, relevant repo guidance. Distinguish defects from preferences.
3. **Change context (staged)** — [Staged context acquisition](#staged-context-acquisition). Complete merge-base diff on initial review.
4. **Prior state (re-review)** — prior reviews, unresolved threads, replies, post-review commits. Thread-aware data required; flat comments alone are insufficient.
5. **Analyze** — [Formal finding gate](#formal-finding-gate); checklist sections as needed ([Checklist staged reading](#checklist-staged-reading)).
6. **Validate** — narrowest useful check: focused test → reproduction → typecheck → lint/static → build → broader suite. Record `passed` / `failed` / `not run (<reason>)`; never claim unrun commands passed.
7. **Report** — [Output](#output). GitHub write only on explicit request ([GitHub posting](#github-posting)).

## Evidence acquisition

Prefer structured GitHub data: metadata, changed files, patches/diff, commits, review threads, check status.

Use `git` / `gh` / GraphQL when insufficient: branch→PR resolution, local source inspection, test execution, thread state, connector gaps.

Networked `gh` with elevated access. Check `gh auth status`; on failure, ask user to run `gh auth login`.

Unavailable thread state → `cannot verify`; do not guess.

## Staged context acquisition

Expand in order; stop when sufficient:

1. PR metadata / requirements → 2. changed files / complete diff → 3. surrounding changed code → 4. callers/callees/contracts → 5. guards/tests/schema for candidate findings → 6. checklist sections (≤3) → 7. extra context only for concrete cross-cutting risk.

**Forbidden:** whole-repo reads; unrelated architecture bulk; reads “for understanding”; unrelated deep caller trees; full checklist before code; mechanical checklist scan.

**Required:** read context needed to establish reachability, guard absence, incorrect behavior, and impact for any candidate finding.

**Narrow first, widen on evidence.**

## Checklist staged reading

Prompts: [references/review-checklist.md](references/review-checklist.md). **Do not read the full file by default.**

| Changed surface | Section |
| --- | --- |
| requirements / contracts / API | Requirements and contracts |
| control flow / business logic | Correctness and control flow |
| auth / permissions | Authorization and authentication |
| input / trust boundaries | Input validation and trust boundaries |
| SQL / persistence / transaction | Data integrity and transactions |
| schema / migration | Schema and migrations |
| async / queue / event | Concurrency and ordering |
| retry / job / webhook | Retries and idempotency |
| errors / multi-step work | Error handling and partial failures |
| API / client / stored shape | Compatibility and API changes |
| deploy-sensitive | Deployment and rollback |
| hot path / batch / limits | Resource usage and performance |
| logs / metrics / recovery | Observability and recovery |
| tests | Test validity and coverage |
| config / generated / lockfiles | Configuration and generated artifacts |

**≤3 sections initially** — prioritize impact, changed surface, uncertainty, irreversibility.

**Add sections only for:** concrete cross-cutting risk; material finding needing another section; PR clearly spanning multiple high-risk areas.

**Forbidden:** “just in case”; topical resemblance; full scan; all sections every time. No DB → skip migrations; no async → skip retries; no auth change → skip auth; no deploy risk → skip deployment.

Checklist supplements reasoning; does not replace complete diff inspection.

## Formal finding gate

Formal finding requires all premises:

| Premise | Requirement |
| --- | --- |
| PR causation | Introduced or materially affected by this PR |
| Reachability | Realistic production/runtime path |
| Guard absence | Not blocked by validation, caller guarantees, DB constraints, transactions, locks, uniqueness, idempotency, auth, lifecycle rules, framework guarantees |
| Incorrect behavior | Violates requirement, contract, invariant, or expected behavior |
| Impact | Beyond style; worth reporting |
| Correction viability | Fix does not contradict requirements |

Actively search for defeating guards before reporting. Unconfirmed premises → **unsupported hypothesis** or **residual risk**, not a formal finding. Do not use low severity as a weak-evidence substitute.

## Severity

Impact/urgency only—not confidence.

- `P0 — Critical` — immediate, broadly destructive, exploitable, release-blocking
- `P1 — High` — likely production defect, security, data loss, serious regression, broken primary flow
- `P2 — Medium` — real defect, narrower conditions/impact
- `P3 — Low` — minor gap; normally non-blocking

Do not inflate severity.

## Large PRs

Prioritize high-risk files/interfaces; group remainder by subsystem; disclose reviewed vs unverified scope; never present partial review as complete. Still use staged checklist—not full upfront.

## Output

Concise only. Omit praise, file inventories, investigation narrative, checklist-completion notes, redundant summaries.

### Initial review

```text
## Review result
<brief overall assessment>

## Findings
### P1 — <title>
`path:line`
Trigger: ... | Behavior: ... | Why it occurs: ... | Impact: ... | Correction direction: ...

## Verification
- `<command>`: passed | failed | not run (<reason>)

## Residual risk
- <important unverified area only>
```

No findings: `## Review result` → “No material defects found in the reviewed scope.” + Verification + Residual risk.

### Re-review

```text
## Previous feedback status
- Resolved/Partially resolved/Unresolved/Superseded/Cannot verify: <counts>
### <status> — <previous finding>
<verification + evidence>

## New findings
<findings or "No new material findings.">

## Verification / Residual risk
```

## GitHub posting

**Default:** report only; no write. Review request ≠ posting authorization.

**Post on explicit request only** (“post to GitHub,” “submit review,” “approve,” “request changes”).

**Formal findings only**—not hypotheses, speculation, disproved candidates, pre-existing issues, or residual risk as defects.

When posting: smallest causal inline anchor; no duplicate unresolved threads; summary only if no anchor; re-check PR head before submit and re-verify if changed.

Actions: `COMMENT` (non-blocking); `REQUEST_CHANGES` (supported unresolved P0/P1 blocking safe merge); `APPROVE` (explicit request or clearly appropriate and permitted).

Do not resolve others' threads unless user asks and failure mode is confirmed resolved. Analysis and write are separate steps.

## Other skills

| Skill | Role |
| --- | --- |
| **gh-review-pr** | Initial review, re-review, prior-feedback verification |
| **gh-adversarial-review** | Falsify claims/invariants via counterexamples—explicit intent only |
| **gh-address-comments** | Code changes for review feedback |
| **gh-fix-ci** | CI failure investigation/fix |
| **yeet** | Commit, push, PR publication |

Do not expand review requests into code modification.

## Fallback

Missing evidence (threads, artifacts, runtime, tests, repo context): state limitation; review verifiable scope only; use `cannot verify`; note gaps under Residual risk. Do not guess.
