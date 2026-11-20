---
name: daily-scan
description: Scheduled daily scan of the job-search crew. Reads every active job site's newest ads (last 1-2 days, public pages, no login), adds suitable new ones to the right queue tabs, logs the run, and tells each sweep how many new ads it got. Use when the job-daily-scan scheduled task runs.
---

# Daily scan of new ads

You run unattended from a scheduled task. You only READ job sites and WRITE to the tracker. Never apply, send email, fill forms, create accounts or sign in.

1. Load the skill `job-search:rules`. Read `PROFILE.md` and `jobsearch-config.json` in the job-search folder named in the task prompt.
2. Read the Applications tab (Company, Role) and every queue tab (Ad ID, Company, Title), so you can skip anything already listed.
3. For each site in `sites`, read `reference/sites/<site>.md` in this plugin, two folders up from this skill. Then fetch the ads from the last 1 to 2 days:
   - Use plain web fetches when the site allows it. Otherwise use agent-browser headless in its own session (`--session daily-scan`, sandbox disabled), then close it.
   - Never use the sweeps' sessions, and never use a login profile.
   - Read the full text of any title that might fit.
   - Screen against PROFILE.md only.
4. For each NEW suitable ad, append one row to that site's queue tab:
   - Status `🆕 New`, Found = today, Ad ID, Company, Title, Location
   - Deadline: YYYY-MM-DD, "ASAP" or "not stated"
   - Language: for example "EN", or "DA, English OK"
   - URL, and Notes: hours, how to apply, fit in a few words
   - Fit 1-5
   The same job on several sites goes in once, under the first site, with "🔁 also on <site>" in Notes.
5. If a site cannot be read (blocked, error, empty, login wall), do not loop on it. Note "<site>: could not be read (<short reason>)" and carry on.
6. Append one row to "Scan log":
   - time
   - "local scan"
   - total new
   - "Jobindex n; Jobnet n; …"
   - the 3 most urgent new ads (deadline, company, title)
   - problems, or "none"
   - Delivered (fill in after step 7)
7. For each site with at least one new ad, message its sweep session (`sessions.<site>` in the config) with `mcp__ccd_session_mgmt__send_message`, loading it with ToolSearch. If that tool is missing, use SendMessage. The message:
   "N new ads were added to your queue tab '<Queue – Site>'. Read the 🆕 rows, fill Fit and the full summary, check duplicates once, re-sort, and continue your loop. Most urgent: <deadline, company, title>."
   Skip a session that no longer exists, and note it.
8. Write column G of your Scan log row: "Delivered <time> to <sessions>".
9. Finish with a 3-line summary: ads checked, added per queue, problems.
