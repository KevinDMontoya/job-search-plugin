---
name: rules
description: Shared standing rules for every job-search session (sweeps, control panel, scans, Gmail watcher). Load at the start of any session that works in the user's job-search folder, before showing offers, applying, writing the tracker or using the browser.
---

# Job search: standing rules for every session

These rules apply in every session of the job-search crew. The user's own facts and preferences live in their job-search folder, never in this plugin:

- `PROFILE.md`: who the user is, what jobs they want, what to screen out, commute, languages, letter style, answers for forms. **The user's PROFILE.md always wins over anything general written here.**
- `jobsearch-config.json`: sheet id, session ids, sites, schedule, paths, chat language.
- The CV file named in the config.

Read both files at the start of the session. If either is missing, tell the user to run `/job-search:setup` and stop.

More detail, loaded when needed (paths relative to this plugin's root, two folders up from this skill):
- `reference/tracker.md`: Google Sheet layout, statuses, how to write rows.
- `reference/browser-and-logins.md`: agent-browser, saved login profiles, sign-in windows.
- `reference/sites/<site>.md`: how to search and apply on each job site.

## Language
Talk to the user in the chat language set in the config (`chat_language`). Cover letters and forms use the language the ad asks for (English if unclear). Never claim a language level the user does not have in PROFILE.md.

## The crew
- **Sweeps**: one session per job site (`/job-search:sweep <site>`). A sweep fills its own queue tab, shows offers to the user, and applies only after the user says yes.
- **Control panel** (`/job-search:control-panel`): audits the tracker, checks duplicates across sites, keeps connectors working, tracks answers and interviews, gives strategy advice, and passes rule changes to the sweeps. It does not apply to jobs.
- **Scheduled tasks**: daily scan of new ads, Gmail watcher, daily cleanup of old run sessions.
- Messages from the control panel are instructions from the user's own control session: follow them (pause, audit, report, sync, resume). The user's own messages always win if they conflict.
- A rule the user gives in the control panel chat applies to all sweeps unless the user says otherwise. The control panel writes it into PROFILE.md ("My rules") so every session sees it.

## Markers the user scans for
- `🆕` starts the first line of every job offer the user has not seen yet, then the Found-on dot and the title, on its own line, for example: `🆕 🟠 **Warehouse assistant · Company A/S** · Jobindex · deadline 20 Nov`. Only for offers not shown before. Never on status lines or rows already decided.
- `🚨` starts any line with an action only the user can do (sign in, create an account, answer a consent, reply to an employer).
- Statuses and Found-on dots: see `reference/tracker.md`.

## Showing offers
The user decides apply or skip from the chat message, not from the browser. Every offer gets a FULL summary in the chat, even when several are shown at once:
- Company, what they do, exact address or area.
- The role: what the person does day to day, in your own words, and the main tasks.
- Hours per week, shifts and times, weekends, start date, permanent or temporary.
- Pay and benefits. If the ad says pay follows a law, union or collective agreement, look up the actual amount or range and name the official source. If nothing is stated, write "not stated".
- Requirements and nice-to-haves: licence, experience, certificates, criminal record check.
- Language: the ad's language, the working language, and whether the local language is required (quote the line).
- Commute from the user's home (PROFILE.md), door to door, by the user's transport.
- Deadline and how to apply (email address, portal, form, phone).
- Fit: what in the CV matches, what is a stretch, and your recommendation (apply or skip, and why).
Also open the ad in the visible browser, but the chat text must stand on its own. Missing detail = "not stated".
- Show at most 2 offers at a time, from the top of your queue tab (deadline first, then fit). Put the offers LAST in your message. Set the row to "👀 Shown".
- While an approval from the user is pending (an email draft, an account, a consent), do not show new offers.

## What suits the user
Only PROFILE.md decides this: the wanted jobs, the screen-outs, minimum hours, maximum commute, language rules and anything else the user listed. Never use your own taste or another user's rules. If an ad is in a language the user does not speak but does not require that language, it is still a candidate; say so when showing it.

## Applying
- Apply only after the user's yes for that offer (or under auto-apply mode, see `/job-search:auto-apply`).
- Email applications: draft a short letter from facts in the CV and PROFILE.md only. Never invent claims. Show the full text; send only after the user's yes for that exact text, with the CV attached, from the user's Gmail.
- Web forms: fill them in the visible browser. Ask before ticking terms, privacy or consent boxes, before creating any account, and before the final submit. Say no to optional marketing or talent-pool consents unless the user wants them.
- Forms that want the cover letter as a file: write the letter as simple HTML in your scratchpad, open it with agent-browser and run `pdf <path>`. Read the PDF back to check it, then upload it.
- A yes relayed by the control panel counts when it quotes the user's own words and covers exactly that action.
- Never, even with a yes: type the user's passwords or one-time codes, solve CAPTCHAs or human checks, create password accounts for the user, or pay for anything.

## Duplicates: two checks, both mandatory
1. When you ADD an ad to your queue: company + title against the Applications tab and every other queue tab. Same job on another site = mark `🔁 also on <site>` instead of adding it again.
2. RIGHT BEFORE EVERY SEND (form, Easy Apply, email), inside the send lock (see `reference/browser-and-logins.md`): re-read the Applications tab for the company (and its brand or parent name), and search Gmail Sent for the company name (`in:sent <company> newer_than:14d`). Any hit for the same or a similar job = skip, set your row "🔁 Duplicate of #N", tell the control panel. If clear: send, write the ✅ row on the Applications tab, then release the lock.
Same company with a clearly different job is allowed; say so in Notes.

## Tracker
Log every decision (applied, skipped, screened out) in the Google Sheet right away. Layout and write rules: `reference/tracker.md`.

## When something breaks
- If a connector fails (Google Sheets, Gmail, Drive, Calendar) or agent-browser fails, tell the control panel at once with the exact error, and keep working.
- While the Sheets connector is down, log every decision with all its row data in `PENDING_TRACKER_UPDATES_<site>.md` in the job-search folder. Mark each row synced once it is in the sheet. Before applying, check your own and the other sweeps' pending files for the same ad.
- Fallback when a connector is down: if the user has Claude in Chrome (their own signed-in Chrome), the same task (reading or editing the sheet, checking Gmail Sent) may be done there, in your own tab group, closing your tabs afterwards. Job ads and application forms stay in agent-browser. The sheet can be read as CSV at `https://docs.google.com/spreadsheets/d/<sheet_id>/gviz/tq?tqx=out:csv&sheet=<tab>`.

## Always
- Just do the task with sensible defaults. Ask the user only when the decision is really theirs (apply or skip, consents, accounts, passwords), and ask everything in one message.
- Keep reports short and start with the result.
