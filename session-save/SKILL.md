---
name: session-save
description: Generate a detailed markdown session summary to pass the current session context to the next session.
---

# Session Summary Generator Skill

When a user requests a session summary, a transition plan, or a summary for the next agent/session, you must follow the instructions in this skill to compile and output it as a Markdown file.

## 1. Output Location
Save the summary to the following location (prioritized):
1. In the workspace sessions directory: `<workspace_root>/.gemini/sessions/session_summary_<YYYY-MM-DD>_<short-conversation-id>.md`
   - Replace `<YYYY-MM-DD>` with the current date (e.g., `2026-06-23`).
   - Replace `<short-conversation-id>` with the first 8 characters of the current conversation ID.
   - If the directory `<workspace_root>/.gemini/sessions/` does not exist, create it.
2. As a fallback, save it as an artifact in the conversation artifacts directory: `<appDataDir>/brain/<conversation-id>/session_summary.md`.

## 2. Document Structure
The output summary must be structured as follows:

```markdown
# セッション作業要約 (Session Summary - <Date>)

このドキュメントは、現セッションで完了した作業、および次のセッションへの引継ぎ事項をまとめたものです。

---

## 1. 完了した作業 (Work Accomplished)
- **[カテゴリ名]**: 具体的に何を行ったか (例: 〇〇機能の追加、バグ修正、UI改善など)。
- 技術的な決定事項や実装の背景 (JSDocへの記述内容やエッジ環境最適化等の設計判断)。
- 実施した動作確認、テスト、ビルド検証の結果。

## 2. 現在のステータス (Current Status)
- 現在作業中のブランチ名。
- プルリクエスト (PR) の状況 (オープン中、マージ済み、コンフリクトの有無など)。
- 最新のバージョン・Gitタグの状況。

## 3. 次のセッションへの引継ぎ事項 (Next Steps)
- 次に手をつけるべき具体的なタスク。
- 未解決の課題、ユーザーへ要確認の事項。
```

## 3. Execution Checklist
1. Gather all recent changes using `git status`, `git diff`, or checking log files.
2. Verify if the code builds cleanly and unit tests pass before compiling the final summary.
3. Generate the summary markdown text matching the above format.
4. Save the file to the target location.
5. Provide the user with a clickable link to the generated Markdown file in your final message.
