---
name: session-save
description: Generate a detailed markdown session summary to pass the current session context to the next session.
---

# Session Summary Generator Skill

When a user requests a session summary, a transition plan, or a summary for the next agent/session, you must follow the instructions in this skill to compile and output it as a Markdown file.

## 1. Output Location
Save the summary to the following location (prioritized):
1. In the workspace sessions directory: `<workspace_root>/.sessions/session_summary_<YYYY-MM-DD>.md`
   - Replace `<YYYY-MM-DD>` with the current date (e.g., `2026-07-14`).
   - **One file per day**: use this exact filename only (do not include conversation ID in the filename).
   - If the directory `<workspace_root>/.sessions/` does not exist, create it.
   - Do **not** write new summaries under `.gemini/sessions/` (legacy path; kept only for load compatibility).
2. As a fallback, save it as an artifact in the conversation artifacts directory: `<appDataDir>/brain/<conversation-id>/session_summary.md`.

## 2. Append vs Create
Before writing, check whether `<workspace_root>/.sessions/session_summary_<YYYY-MM-DD>.md` already exists.

### 2a. File does NOT exist (first save of the day)
Create the file with this structure:

```markdown
# セッション作業要約 (Session Summary - <Date>)

このドキュメントは、<Date> に行ったセッション作業の要約をまとめたものです。同日に複数セッションがあれば、時系列で追記されます。

---

## セッション <N> (<HH:MM> / conversation: <short-conversation-id>)

### 1. 完了した作業 (Work Accomplished)
- **[カテゴリ名]**: 具体的に何を行ったか。
- 技術的な決定事項や実装の背景。
- 実施した動作確認、テスト、ビルド検証の結果。

### 2. 現在のステータス (Current Status)
- 現在作業中のブランチ名。
- プルリクエスト (PR) の状況。
- 最新のバージョン・Gitタグの状況。

### 3. 次のセッションへの引継ぎ事項 (Next Steps)
- 次に手をつけるべき具体的なタスク。
- 未解決の課題、ユーザーへ要確認の事項。
```

- `<N>` is `1` for the first session of the day.
- `<HH:MM>` is the current local time (24-hour format).
- `<short-conversation-id>` is the first 8 characters of the current conversation ID.

### 2b. File already exists (subsequent save on the same day)
**Append** a new session block to the end of the existing file. Do **not** overwrite or replace prior content.

1. Read the existing file.
2. Determine the next session number `<N>` by counting existing `## セッション` headings (or use the highest number + 1).
3. Append the following block after the last line of the file:

```markdown

---

## セッション <N> (<HH:MM> / conversation: <short-conversation-id>)

### 1. 完了した作業 (Work Accomplished)
...

### 2. 現在のステータス (Current Status)
...

### 3. 次のセッションへの引継ぎ事項 (Next Steps)
...
```

4. When appending, write only the **current session's** content. Do not duplicate or rewrite earlier sessions.

## 3. Execution Checklist
1. Gather all recent changes using `git status`, `git diff`, or checking log files.
2. Verify if the code builds cleanly and unit tests pass before compiling the final summary.
3. Check whether today's daily summary file already exists.
4. Generate the summary markdown for the current session only, matching the format above.
5. Create the daily file (first save) or append to it (subsequent saves).
6. Provide the user with a clickable link to the Markdown file in your final message.
