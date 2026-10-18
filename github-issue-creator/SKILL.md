---
name: github-issue-creator
description: Research a repository and turn requirements into concise, implementation-ready GitHub Issues. Use when asked to create or update an issue, turn a requirement or plan into issues, split development work, or organize existing issues. Keep consultation and draft-only requests read-only.
---

# GitHub Issue Creator

## Purpose

Turn a user's request into a clear, verifiable GitHub Issue grounded in the target repository's current code, documentation, issues, and pull requests. Optimize for correctness, actionable scope, concise writing, readability, and reuse across technology stacks.

## When to use

Use for requests such as:

- “Create/file a GitHub Issue for this.” / 「GitHub Issueを作成して」「Issueを起票して」
- “Turn this requirement into an issue.” / 「この要件をIssueにまとめて」
- “Split this work into issues.” / 「開発タスクをIssueに分割して」
- “Organize the existing issues.” / 「既存Issueを整理して」
- “Register this implementation plan as issues.” / 「実装計画をIssueとして登録して」

An activation phrase does not by itself authorize a write. Follow the authorization boundary below.

## Authorization boundary

- Consultation, proposals, and requests to prepare or organize a draft authorize research and presenting an issue proposal only.
- Create issues only when the user clearly asks to create, file, open, or register them in GitHub. A direct request such as 「この機能をGitHub Issueにして」 counts as a creation request when it is not qualified as a draft or proposal. A request to split work without a clear creation request produces drafts only.
- Requests for an 「Issue案」, 「提案」, or 「まだ起票しないで」 are draft-only. If wording such as 「Issueにまとめて」 leaves publication intent unclear, present a draft rather than writing.
- Update an existing issue only when the user explicitly asks for an update and the target issue is identified.
- Never infer the target repository. Resolve it from the request, a supplied URL, or unambiguous task context. If it is unclear, ask; never default to this skill's repository.
- If essential requirements or the target issue are ambiguous, present the unresolved point or ask a focused question before writing.

## Workflow

1. **Resolve the repository.** Identify its default branch and available read/write access. Inspect any applicable `AGENTS.md`, contribution guidance, issue templates, and repository-specific issue conventions.
2. **Investigate current state.** Read the latest default branch and only the code and documentation relevant to the request. Search open and closed issues and pull requests for the same behavior, error, feature, or plan. Follow relevant links when needed.
3. **Classify implementation status.** Distinguish implemented, partially implemented, not implemented, obsolete, and unverified. Support claims with repository evidence; label assumptions and unknowns instead of presenting them as facts.
4. **Check overlap.** If an existing issue already covers the request, do not create a duplicate. Report or link it. If coverage is partial, describe the remaining gap and propose an update or a separate issue only when its scope is distinct.
5. **Shape the work.** State what outcome is needed and why. Set scope, exclusions, constraints, and dependencies. Split only independently reviewable outcomes; avoid tiny follow-up issues, keep prerequisites ordered, and make independent work parallelizable. Base priority on confirmed impact, dependencies, user priorities, and repository conventions; leave it unset when evidence is insufficient. Do not invent numbers, behavior, or technical decisions.
6. **Draft the issue.** Use [the standard template](references/issue-template.md), adapting it to any compatible repository template. Keep the heading order unless repository conventions require a different one. Use the user's or repository's language.
7. **Review quality.** Confirm that the title names the outcome, the body explains What/Why/Done, and implementation guidance is limited to important constraints and a recommended approach. Verify that subtasks describe work and acceptance criteria describe observable results.
8. **Choose the authorized action.** For consultation or draft-only requests, show the proposal and stop before any GitHub write. For explicit create/update requests, proceed only after the repository, scope, and target are unambiguous.
9. **Write safely.** Recheck for duplicates immediately before creation. Reuse only existing applicable labels and milestones; do not create repository settings. On retry, search for an issue created by the prior attempt before trying again. Use the available authenticated GitHub tool or CLI without exposing credentials.
10. **Verify and report.** After a write, fetch the issue again and verify its title, body, labels, and milestone. Report the result, issue URL, and any unresolved assumptions. If no write was authorized, clearly label the response as a draft.

## Issue quality

- Keep the standard headings in this order: 目的, 前提, 対象範囲, 対象外, 実装方針, 実行順序 / サブタスク, 完了条件（Acceptance Criteria）, 検証方法, 依存関係・リスク. If the repository has a required template, preserve its required fields and fit these details into it.
- Keep each bullet to one point. Remove repeated context, generic advice, filler, and unnecessary implementation detail. Use short paragraphs, lists for parallel details, numbered checkboxes for ordered work, and checkboxes for acceptance criteria. Include only necessary subtasks; remove template examples that do not apply. Do not optimize for a character count.
- Make requirements concrete and testable without inventing unsupported numeric limits or behavior. Mark confirmed facts, assumptions, and unknowns distinctly. Write 「なし」 only when a whole section has no relevant item; do not add it as a filler bullet to a section that already has content.
- State exclusions so the implementation boundary is clear. Keep implementation steps separate from outcome-based acceptance criteria.
- Add issue-type details under the relevant standard headings without creating a complex taxonomy:
  - **Bug:** reproduction conditions, expected behavior, actual behavior, and impact.
  - **Feature:** user or system use case and expected behavior.
  - **Refactoring:** behavior and interfaces to preserve, plus regression coverage.
  - **Security:** threat, affected surface, mitigation, and verification. Follow repository private vulnerability-reporting guidance; do not expose sensitive exploit details in a public issue.
  - **Infrastructure:** operational impact, availability, monitoring, and rollback where relevant.
  - **Documentation:** intended audience, information to clarify, and source of truth.

## Safe GitHub operations

- Research and GitHub writes are separate. A request to discuss, propose, investigate, or draft is not permission to create or update an issue.
- Do not write when repository, issue target, or material requirements cannot be resolved safely.
- Before create/update, search for duplicates and preserve existing repository conventions. Never invent labels or milestones.
- After a failed or uncertain create call, search before retrying to avoid duplicate issues.
- Do not merge pull requests, release, deploy, change permissions, or perform destructive operations as part of issue authoring.
- Do not create real issues as part of examples, simulations, or validation.

## Completion

The task is complete when the repository state and duplicate check have been investigated, the issue draft meets the quality rules, and the authorized action is verified. Report a linked existing issue when one already covers the request; report a draft when no write was authorized; report a created or updated issue only after fetching it back successfully.
