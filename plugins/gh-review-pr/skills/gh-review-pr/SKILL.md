---
name: gh-review-pr
description: Review GitHub pull requests on the first pass or after updates, identify evidence-backed defects and risks, and prepare precise inline or summary review comments. Use when the user asks to review a PR, review code changes, perform a second review, verify whether prior feedback was addressed, or comment on review findings. Inspect the full PR on an initial review and combine prior review-thread verification with new-diff analysis on a re-review. Do not post comments, approve, or request changes without explicit user confirmation.
---

# GitHub Pull Request Reviewer

Review a GitHub pull request for correctness, regressions, security, data integrity, performance, concurrency, error handling, test coverage, maintainability, and scope discipline. Support both initial reviews and re-reviews in one workflow.

Prefer an available GitHub connector for repository, pull request, patch, commit, check, and top-level comment data. Use local `git` and `gh` only where the active product supports them and the connector cannot provide sufficient context, particularly for current-branch PR discovery, thread-aware review state, exact diff inspection, or local test execution.

When CLI access is needed, check `gh auth status` first. If authentication fails, tell the user that GitHub CLI authentication is required and ask them to run `gh auth login`. If neither a GitHub connector nor authenticated CLI access is available, identify that exact limitation and do not invent repository state.

## Review Modes

Determine the mode from the PR state and the user's request.

### Initial review

Use initial-review mode when there is no earlier review to verify, or when the user asks for a full review from scratch.

Inspect:

- the PR title, description, linked issue, acceptance criteria, and stated scope
- the complete merge-base diff, not only the latest commit
- affected call sites, interfaces, schemas, migrations, configuration, and tests
- relevant repository conventions and nearby implementation patterns
- CI or test results when available

Do not infer correctness from a green CI result alone. CI can demonstrate that selected checks passed; it does not prove that behavior, requirements, or edge cases are correct.

### Re-review

Use re-review mode when the PR has changed after review feedback, the user asks for another review, or previous review threads exist.

Inspect both:

1. previous actionable review findings and whether each was addressed; and
2. all changes introduced since the relevant prior review, including newly created regressions.

Classify each earlier actionable finding as:

- `resolved`: the implementation now addresses the underlying issue
- `partially resolved`: some of the issue was fixed, but a material risk remains
- `unresolved`: the issue is still present
- `superseded`: later design changes made the original finding irrelevant
- `cannot verify`: available code or runtime evidence is insufficient

Do not mark a finding resolved merely because code changed near the commented line. Verify the behavior that motivated the original comment.

When thread resolution state or inline anchors matter, use a thread-aware GitHub GraphQL query or an available bundled comment-fetching workflow. Flat issue or PR comments are not a complete substitute for review-thread state.

## Workflow

### 1. Resolve the pull request

Use a repository and PR number or PR URL supplied by the user.

For requests referring to “this PR,” “the current branch,” or similar local context:

1. inspect the local Git repository and current branch;
2. use `gh pr view --json number,url,baseRefName,headRefName` when needed;
3. if multiple or no matching PRs exist, report the ambiguity rather than guessing.

If neither the request nor the local checkout identifies a PR, ask for the repository and PR number or URL.

### 2. Establish review scope

Read the PR description, linked issue, and repository guidance such as `AGENTS.md`, `CONTRIBUTING.md`, coding standards, architecture documents, or test instructions.

Derive the intended behavior and acceptance criteria before judging implementation details. Distinguish:

- defects relative to the stated requirements
- repository-policy violations
- plausible risks that require clarification
- optional improvements and personal preferences

Only the first two categories normally justify blocking review findings.

### 3. Gather the complete change context

Inspect the full PR diff against the merge base. Also inspect enough surrounding code to understand behavior across file boundaries.

Pay particular attention to:

- public API or contract changes
- database schemas, migrations, transactions, and rollback behavior
- authorization, authentication, secret handling, and input validation
- asynchronous processing, retries, idempotency, ordering, and race conditions
- error propagation, partial failure, cleanup, and observability
- compatibility with existing callers, stored data, clients, and deployments
- tests that should fail before the fix and pass afterward
- generated files, lockfiles, vendored code, and configuration changes

Do not review only filenames or isolated hunks when the behavior depends on surrounding code.

### 4. Inspect prior review state for re-reviews

Collect prior reviews, unresolved threads, author replies, and commits made after the relevant review.

For each prior actionable finding:

1. restate the underlying failure mode, not merely the old wording;
2. locate the current implementation;
3. inspect related tests and callers;
4. assign a resolution classification;
5. retain the original severity unless evidence justifies changing it.

Avoid reposting an unresolved issue as a new duplicate comment. Prefer replying to or summarizing the existing thread when possible.

### 5. Analyze findings

A review finding must identify a concrete, user-relevant or system-relevant failure mode. Before reporting it, verify all of the following:

- the behavior is introduced or materially affected by this PR
- the relevant code path is reachable under realistic conditions
- the impact is more than stylistic preference
- the claim is supported by the diff and surrounding implementation
- the proposed correction does not conflict with stated requirements

Use these severity levels:

- `P0 — Critical`: immediate and broadly destructive, exploitable, or release-blocking failure
- `P1 — High`: likely production defect, security issue, data loss, serious regression, or broken primary flow
- `P2 — Medium`: real defect or reliability problem with narrower conditions or impact
- `P3 — Low`: minor correctness, maintainability, or test gap worth fixing but normally non-blocking

Do not inflate severity to make a comment more noticeable.

### 6. Validate with tests and tools

Run the narrowest relevant tests, linters, type checks, static analysis, or build commands available in the repository when local execution is possible.

Start with tests closest to the changed behavior, then widen only when justified. Do not claim a command passed unless it was actually executed successfully.

If tests cannot be run, state the exact limitation. Continue with static review, but distinguish verified behavior from inference.

### 7. Prepare review output

Present findings before any GitHub write action. Order findings by severity, then by file and line.

Each finding should contain:

- severity and concise title
- file and current line or a precise code location
- the triggering condition
- the resulting incorrect behavior or risk
- a concise explanation of why the current implementation permits it
- a correction direction, without prescribing an unnecessarily large redesign

For re-reviews, include a separate prior-feedback status section before new findings.

If no material findings remain, say so directly and mention any residual verification limitations. Do not invent comments to appear thorough.

## Comment Quality

Write comments that are concise, specific, and actionable.

A good inline comment explains the failure mode in a few sentences and points to the smallest relevant line range. It should make sense without requiring the author to reconstruct the reviewer’s entire investigation.

Prefer wording such as:

> `P1 — Retry can apply the balance update twice`
>
> If the database commit succeeds but the acknowledgement fails, this job is retried and executes the increment again. Because the operation has no idempotency key or uniqueness guard, a transient worker failure can duplicate the user's balance update. Please make the write idempotent before acknowledging the job.

Avoid:

- vague statements such as “this looks wrong”
- comments based only on naming or formatting preferences
- long tutorials unrelated to the defect
- speculative claims without a reachable scenario
- duplicating an existing unresolved thread
- requesting broad refactors when a localized fix is sufficient
- praising routine code in inline review comments

When a finding spans multiple files, place the inline comment at the clearest causal location and explain the cross-file effect. Use a summary comment only when no single line is an appropriate anchor.

## GitHub Write Safety

Treat review analysis and GitHub writes as separate phases.

Before posting, show the user:

- the exact repository and PR
- the proposed inline comments and their locations
- the proposed summary review body
- the intended review action: comment only, approve, or request changes

Do not submit inline comments, a review, replies, thread resolutions, approvals, or change requests until the user explicitly confirms the write action.

Default behavior after confirmation is `COMMENT` only.

Use `APPROVE` only when the user explicitly asks for approval and no blocking findings remain.

Use `REQUEST_CHANGES` only when the user explicitly asks for it and at least one unresolved blocking finding is supported by evidence.

Never approve a PR authored by the authenticated GitHub account when GitHub disallows self-approval. Report the platform limitation instead.

Do not resolve another reviewer's thread unless the user explicitly asks and the available evidence shows the underlying issue is resolved.

Immediately before a write, re-check that the PR head commit has not changed. If it changed after the review was prepared, stop and inspect the new diff before posting stale comments.

## Output Format

Use this structure for an initial review:

```text
## Review findings

### P1 — <title>
`path/to/file.ts:<line>`

<failure condition and impact>

<recommended correction direction>

## Verification

- `<command>`: passed/failed/not run

## Proposed GitHub review

- Action: COMMENT
- Inline comments: <count>
- Summary: <brief conclusion>
```

Use this structure for a re-review:

```text
## Previous feedback status

- Resolved: <count>
- Partially resolved: <count>
- Unresolved: <count>
- Superseded: <count>
- Cannot verify: <count>

### <status> — <previous finding>
<verification result and evidence>

## New review findings

<new findings, or "No new material findings.">

## Verification

- `<command>`: passed/failed/not run

## Proposed GitHub review

- Action: COMMENT
- Inline comments: <count>
- Summary: <brief conclusion>
```

When there are no findings, do not include empty finding templates. State that no material defects were found in the reviewed scope and list any tests or areas that were not verifiable.

## Relationship to Other Skills

Use this skill to review code and prepare or submit review feedback.

When the user wants to modify code in response to review feedback, switch to an available review-comment implementation workflow or edit the code directly only after the user authorizes that separate task.

When diagnosing failing GitHub Actions becomes the primary task, switch to an available CI-debugging workflow or inspect checks and logs directly with GitHub CLI where supported.

When the user asks to commit, push, or create a pull request, switch to an available Git publishing workflow.

Do not silently expand a review request into code modification. A reviewer can propose a correction, but changing the branch is a separate user-authorized task.

## Fallbacks

If the connector lacks thread-level review context, use `gh api graphql` when authentication and repository access permit it.

If the PR diff is too large to inspect reliably in one pass:

1. review high-risk files and interfaces first;
2. group the remaining files by subsystem;
3. clearly disclose the portions reviewed and not yet verified;
4. do not present a partial review as complete.

If repository access, PR context, local checkout, authentication, or required generated artifacts are unavailable, identify the exact blocker and continue with any independently verifiable parts rather than guessing.
