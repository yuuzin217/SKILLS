---
name: session-load
description: Import and resume the session context using the session summary markdown file from the previous session.
---

# Session Resume / Import Skill

When the user asks to resume, import, or load the previous session, or when this skill is triggered, follow these instructions to restore context and seamlessly continue development.

## 1. Locate the Session Summary
Find the most recent session summary file. Check the following paths in order:
1. Under the workspace sessions directory: `<workspace_root>/.gemini/sessions/session_summary_*.md`
   - Retrieve all files matching this pattern, and use the one with the latest date in the filename or the latest modification timestamp.
2. At the workspace root: `<workspace_root>/session_summary.md`
3. Under the artifacts directory of recent conversations: `<appDataDir>/brain/<previous-conversation-id>/session_summary.md`

If multiple summaries exist, use the one corresponding to the most recent session or with the latest modification timestamp.

## 2. Process and Restore Context
1. **Read the Summary**: Use `view_file` to read the entire contents of the located `session_summary.md`.
2. **Understand Work Accomplished**: Identify what features were added, updated, or fixed in the previous session.
3. **Verify Git State**:
   - Run `git branch --show-current` to identify the active branch.
   - Run `git status` to check if there are any uncommitted changes or active merges.
   - Check if there are open pull requests using `gh pr list`.
4. **Clean Up**: Once the summary is successfully read and the context is fully restored, delete the temporary `session_summary.md` file *only if* it was located at the workspace root or temporary locations. Do **not** delete files under `<workspace_root>/.gemini/sessions/` to ensure the session history is preserved.
5. **Identify Next Steps**: Review the "Next Steps" or "引き継ぎ事項" section from the summary to determine the immediate actions to take.

## 3. Resume the Work
1. Briefly summarize to the user that you have successfully imported the previous session's context.
2. Confirm the active branch and any pending PRs.
3. Propose the next immediate step to continue the development, and ask the user for confirmation to proceed.
