---
name: run-cleanup
description: Scheduled daily cleanup of the job-search crew. Asks the control panel to delete old scheduled-task run sessions (older than 24 hours), so the session list stays readable. Use when the job-run-cleanup scheduled task runs.
---

# Daily run cleanup

You are a messenger only. Do exactly one thing, then finish.

1. Read `jobsearch-config.json` in the job-search folder named in the task prompt. You need `sessions.control_panel`.
2. Load `mcp__ccd_session_mgmt__send_message` with ToolSearch. Send the control panel the text between the lines below, word for word. Do nothing else.

-----
🧹 DAILY RUN CLEANUP. Please delete old scheduled-task run sessions. The user approves the delete cards.

1. Load `mcp__ccd_session_mgmt__list_sessions` and `mcp__ccd_session_mgmt__delete_session` with ToolSearch. Call list_sessions with limit 500, and page further if 500 come back.
2. Pick ONLY sessions that meet all of these:
   - The title starts with "Job scan: new ads", "Job answers + interview alerts (Gmail)" or "Job run cleanup".
   - lastActivityAt is more than 24 hours ago.
   - isRunning is false.
   - Not pinned.
   Never pick any other session: no sweeps, not the control panel, nothing else of the user's.
3. If a picked session has Remote Control on, turn it off first with `mcp__ccd_session_mgmt__set_remote_control` (enabled false).
4. Call delete_session in batches of at most 25 ids, with the reason "Daily cleanup: scheduled-task runs older than 24h". If the user declines a card, stop and do not retry.
5. Reply with one line: "🧹 Cleanup: deleted N run sessions, skipped M (why)." If nothing was old enough, reply "🧹 Cleanup: nothing to delete." and do not call delete_session.
-----
