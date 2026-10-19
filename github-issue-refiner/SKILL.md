---
name: github-issue-refiner
description: Investigate, update, and standardize existing GitHub Issues while preserving requirements, decisions, progress, and metadata. Use for an identified issue or explicit issue set when asked to align content with current implementation, normalize format, or clean up issues. Keep consultation and draft-only requests read-only.
---

# GitHub Issue Refiner

## Purpose

Bring existing GitHub Issues up to date with repository evidence while keeping their intent, history, progress, and untouched fields intact. Support single-issue content updates, format normalization, and explicitly scoped batches.

## When to use

Use when the user asks to update an existing Issue, align it with current implementation, standardize its format, or clean up a specified group of Issues.
Use `github-issue-creator` for new Issues, requirement-to-Issue drafting, or splitting work for filing.

## Authorization boundary

- Research, consultation, improvement proposals, and draft-only requests authorize reads and a plan only.
  「案を出して」「相談したい」「まだ反映しないで」 means no GitHub write.
- An explicit update request plus an identified repository and Issue scope authorizes safe body changes in that scope.
  An explicitly scoped batch authorizes all safe in-scope updates; do not ask for per-Issue approval.
- Do not expand the requested set. “All OPEN Issues” means only OPEN Issues in the identified repository.
  If the repository or scope is ambiguous, stay read-only and ask a focused question.
- Changing title, labels, assignees, milestone, state, or repository requires a separate explicit instruction.
  Do not infer closure, reopening, deletion, or comment edits. Comments and discussion history are read-only.
  This skill does not create Issues; use `github-issue-creator` for new Issues.
- A material requirements or scope change beyond the user's request needs separate authorization.
  Classify it as `REVIEW_REQUIRED` until authorized.

## Workflow

1. **Resolve scope and collect targets.** Identify the repository, operation (content update, format
   normalization, or batch), and exact Issue scope. Read applicable repository guidance, issue templates,
   and current default branch. For batches and number ranges, finish collecting candidates before any write:
   - Follow REST `Link: rel="next"` pages (up to 100 items per page), GraphQL cursors until
     `hasNextPage=false`, or the available tool's equivalent. Confirm CLI/tool results are not capped.
   - Exclude REST results with a `pull_request` key. Inspect every number in an explicit range and skip PRs.
     Deduplicate by repository and number, then freeze the qualifying Issue list, count, requested state,
     and range.
   - If a page fails or completeness is uncertain, do not start batch writes. Report retrieved and processed
     counts plus the uncollected count or range; say when it cannot be determined.
   Do not infer a repository or broaden the target set.
2. **Capture current state.** Fetch each target Issue's latest body, title, state, closure reason, labels, assignees,
   milestone, and other available metadata. Read linked Issues, pull requests, and discussion for context.
3. **Check current evidence.** Inspect only relevant code, documentation, pull requests, tests, and design decisions
   from the latest default branch. Distinguish confirmed facts, assumptions, and unknowns.
   Code presence, a merged PR, a passing test, and production behavior are different evidence.
4. **Classify each target.** Assign one outcome before writing:
   - `UPDATE`: a material, authorized change is supported by evidence.
   - `NO_CHANGE`: the Issue is accurate and clear; do not rewrite for whitespace or preference alone.
   - `REVIEW_REQUIRED`: a requirement, status, or decision cannot be resolved from available evidence.
   - `BLOCKED`: access, a conflict, or a tool failure prevents a safe update.
5. **Prepare minimal changes.** Change only requested content and confirmed inaccuracies.
   For format-only requests, preserve meaning and status; do not invent requirements or progress.
   For batches, share the frozen target count and planned changes before the first write. If scope is explicit, proceed
   without waiting for additional approval. Process only `UPDATE` Issues in small, sequential units.
   Do not include related but out-of-scope Issues. Re-running an already aligned Issue should yield `NO_CHANGE`.
6. **Protect information and progress.** Prepare each edit from the captured Issue body; do not rebuild it from a blank template.
   Preserve unrequested requirements, decisions, scope, exclusions, constraints, dependencies, links, checklist states,
   title, labels, assignees, milestone, and metadata. Move content only if its meaning, conditions, and exceptions remain intact.
   - Distinguish implemented, verified, and incomplete work. Code presence, a merged PR, or a test for only part of a
     criterion does not prove completion.
   - Preserve captured checkbox states. Change a state only on an explicit request to change it or with objective
     evidence. If an AC has no state to preserve and its status is unknown, leave it unchecked. Explain obsolete work
     rather than deleting it when its history matters.
7. **Use the standard format.** A required template in the target repository takes precedence.
   Otherwise, reuse the canonical `github-issue-creator/references/issue-template.md` from this SKILLS package when accessible.
   If the refiner is installed alone and that file is unavailable, use these headings without creating another template file
   or adding example placeholders:
   1. 目的
   2. 前提
   3. 対象範囲
   4. 対象外
   5. 実装方針
   6. 実行順序 / サブタスク
   7. 完了条件（Acceptance Criteria）
   8. 検証方法
   9. 依存関係・リスク
   Keep required repository fields, preserve all information, and retain this order where compatible.
8. **Review before writing.** Check the goal, context, scope, evidence, work order, verifiable acceptance criteria,
   verification method, preserved information, checkbox states, readability, and authorization.
   Keep prose concise, each bullet to one point, and implementation steps separate from completion criteria.
   Apply `github-issue-creator` quality guidance when available; the shared rules below are the standalone fallback.
9. **Update safely.** Immediately before writing, fetch the target again and verify it is an Issue (for REST,
   `pull_request` is absent) and still matches the frozen repository, range, and requested state. Skip PRs and
   targets that left the requested scope, and record them as excluded. Compare every field being changed with
   the captured state. Reconcile non-conflicting edits against the latest version. If a safe merge is unclear,
   leave that Issue unchanged and classify it as `BLOCKED` or `REVIEW_REQUIRED`. Use conditional updates when
   supported and send only authorized fields.
   If the result is uncertain, fetch and compare before deciding whether to retry; never resend blindly.
10. **Verify and report.** Fetch each updated Issue again and confirm the requested changes and preservation of unrelated body
    content, checklist states, title, labels, assignees, milestone, and metadata.
    If one Issue fails, continue independent updates; stop remaining writes for systemic failures or unsafe tool behavior.
    Do not report a failed or unverified update as successful.

## Batch reporting

Report the requested scope, frozen unique Issue count, excluded PR count, processed and unprocessed counts,
and counts for `UPDATE`, `NO_CHANGE`, `REVIEW_REQUIRED`, and `BLOCKED`. List each target and its outcome;
link and summarize updates, and give a reason for each excluded, skipped, or blocked item. If collection was
incomplete, report the retrieved count and uncollected range/count (or that it is unknown).
Do not count a planned change as completed until it has been fetched back and verified.

## Shared quality rules

- State what outcome is needed, why it matters, important constraints, and observable completion conditions.
- Under `## 完了条件（Acceptance Criteria）` (or the required equivalent), use GitHub task-list checkboxes (`- [ ]` or
  `- [x]`), one objectively verifiable AC per box. Do not use plain bullets for ACs or mix work steps with outcomes.
- For content updates, use checkboxes for new or changed ACs and leave out-of-scope text and AC formatting untouched.
  During explicit format normalization, convert plain AC bullets to `- [ ]`, preserve existing checked states and all
  conditions/exceptions, and remove only duplicate equivalent criteria with compatible checked states. If duplicate
  states conflict, preserve them for review. Do not merge distinct ACs or add/remove criteria without a request or
  confirmed evidence.
- Apply these rules only to explicitly targeted `UPDATE` Issues in a batch. Do not rewrite `NO_CHANGE` Issues or start
  bulk edits solely for checkbox style unless normalization was requested.
- Keep each bullet to one point; remove repetition and filler without losing conditions, exceptions, or decision rationale.
- Keep subtasks actionable and acceptance criteria verifiable. Leave unknown facts and unverified progress explicit.
- Do not invent labels, milestones, priorities, requirements, or implementation results.
