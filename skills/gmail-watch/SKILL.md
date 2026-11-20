---
name: gmail-watch
description: Scheduled Gmail watcher of the job-search crew. Finds new answers from employers and recruiting systems, logs them in the Responses tab, adds interviews to the Interviews tab with a prep file, alerts the user and the control panel, and checks connector health. Use when the job-gmail-watch scheduled task runs.
---

# Gmail watcher

You run unattended from a scheduled task. Gmail is READ-ONLY for you. Never send, reply, draft, forward, delete, archive or label anything, and never create calendar events.

1. Load the skill `job-search:rules`. Read `PROFILE.md` and `jobsearch-config.json` in the job-search folder named in the task prompt.
2. **Find new answers.**
   - Use the Gmail connector's `search_threads` with the query `newer_than:<window> -from:me -category:promotions -category:social`. The window is twice `schedule.gmail_check_minutes`, rounded up to whole hours (`newer_than:1h`, `2h`, …). Use pageSize 50.
   - Read every new email, in any language, and keep only answers about the user's job applications:
     - acknowledgements and rejections
     - interview invitations (any proposed meeting, call or time)
     - requests for documents
     - test invitations
     - offers
     - messages from recruiters or agency consultants about a specific application
   - Ignore newsletters, job alerts ("new jobs for you") and everything else.
   - Open a thread with `get_thread` only when the snippet is not enough to tell.
3. **Log them.**
   - Read the Responses tab first, and skip anything already logged: the same thread, or the same company + date + answer type.
   - For each new answer, match it to the ✅ row on the Applications tab to fill Company (with #number), Role, Site applied on and Applied date.
   - Insert the row directly under the header: `insert_dimension` at startIndex 1, then `update_values`, newest first. Answer types are in `reference/tracker.md`.
   - Read back what you wrote.
4. **Interview invitations, tests, offers and document requests** also:
   - Add a row to the Interviews tab with Status "📅 Invited, reply needed".
   - Write `INTERVIEW_<Company>_<Role>.md` in the job-search folder: the role, the company in brief (public info), likely questions, how the CV fits, what to prepare, what to ask, and the commute.
   - If `push_notifications` is true, call PushNotification with one line under 200 characters, for example "📅 Interview invite: <Company> <Role>, <time or 'time not set'>. Reply needed."
   - Message the control panel (`sessions.control_panel`, with `mcp__ccd_session_mgmt__send_message`, loaded with ToolSearch). Start with "🚨 INTERVIEW INVITE: <Company> (#n, <Role>), <date/time>, reply needed". Then include the employer's exact words and the full prep notes as plain text.
   Never reply to the employer.
5. **Rejections** need only the Responses row.
6. **Connector health.**
   - Make one tiny read on Drive (`list_recent_files`, pageSize 1) and Calendar (`list_calendars`).
   - Call `mcp__ccd_connectors__session_connectors_status`, and reconnect any "failed" server once with `reconnect_session_connector`.
   - If Gmail or Sheets failed, append the exact error to `JOB_LOG.md` in the folder. If that is the third failed run in a row there, send one PushNotification: "Gmail watcher: <connector> failing since <time>".
7. **Report every run** to the control panel with `mcp__ccd_session_mgmt__send_message`, kept short:
   - Nothing new: "Gmail check <HH:MM>: nothing new. Connectors OK."
   - Otherwise: one line per new answer (company #n, type, anything the user must do), then the connector status.
8. Append one line to `JOB_LOG.md`: "<time> Gmail watch: N new answers (x rejections, y interviews). Connectors: …".
