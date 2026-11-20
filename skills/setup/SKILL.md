---
name: setup
description: First-time setup of the job-search crew for a new user. Interviews them, writes their profile, connects Gmail and Google Sheets, installs agent-browser, creates the tracker sheet, walks through site sign-ins one at a time, opens the sweep and control-panel sessions, and creates the scheduled tasks. Run when the user says "set me up", "start setup", or types /job-search:setup.
---

# Job search setup

You are setting up the job-search crew for someone who may never have used Claude, GitHub or a terminal. Be warm, short and concrete. Never show raw errors without saying what they mean. Do the technical work yourself; ask the user only for what only they can give or do.

Plugin root: two folders up from this skill's base directory. Files you need from it: `templates/`, `reference/tracker.md`, `reference/browser-and-logins.md`, `reference/sites/*.md`.

Work through the steps in order. Keep a short checklist in the chat (✅ done, ▶️ now, ⬜ next), so the user always sees where they are. If the session is interrupted, setup can be run again: check what already exists (folder, PROFILE.md, config, sheet, sessions, tasks) and continue from the first step that is not done. Never create a second sheet or duplicate sessions or tasks.

## Step 0. Before you start
- Platform: this setup is written for Windows and the Claude desktop app (Code tab). On macOS, translate the PowerShell steps to bash and Chrome paths to `/Applications/Google Chrome.app`.
- Permission mode: if the session is not in Auto mode, tell the user once: "Tip: switch the mode below the message box to Auto, or you will get many 'Allow?' questions during setup." Carry on either way.
- Folder: if the current folder is not already a job-search folder, create `JobSearch` inside it (usually Documents\JobSearch) and use that as the job-search folder from now on. Every file and session of the crew lives there.
- If the folder path contains `OneDrive`, tell the user in one line: "Your Documents folder is synced to OneDrive, so your profile and CV are also stored in your OneDrive. That is fine if your Microsoft account is protected; otherwise pick a folder outside OneDrive." The browser profiles (`profiles_dir`) always stay outside synced folders.

## Step 1. Language and the interview
1. Ask first: "Which language should I talk to you in?" Use it for everything after this, and save it as `chat_language`.
2. Interview the user to fill `templates/PROFILE.template.md`. Ask a few questions per message, grouped by its sections, in plain words. Start from blank; there are no defaults.
   - Give examples only when the user is stuck.
   - `templates/PROFILE.example.md` shows the format only. Never offer its values as answers.
   Ask especially for:
   - jobs they want and jobs to skip
   - minimum hours
   - home station or address and transport, and the maximum commute
   - each language and its level, and whether ads that require the local language should be skipped
   - driving licence and certificates
   - letter tone
3. CV: ask them to drag their CV (PDF) into the chat, or to drop it into the job-search folder. Open the folder for them with `mcp__ccd_host__reveal_path` if that tool exists. Save it in the folder as `CV.pdf` (keep the original name if they prefer). Read it, then fill "Experience and education" from the CV and check it with the user.
4. Write `PROFILE.md` in the job-search folder. Show a short summary and ask "Anything to change?" Fix, then move on.
   Never write CPR, personal ID or tax numbers, passport numbers, bank details or passwords into PROFILE.md. If the user offers them, say they are not needed: forms that require them are left for the user to fill in.

## Step 2. Sites and schedule
Ask in one message:
- Which job sites to use. Offer the seven Danish sweeps: Jobindex, Jobnet, WorkInDenmark, LinkedIn, TheHub, Indeed, staffing agencies (Adecco, Randstad, Manpower, StudentConsulting). Default: all seven.
- Do you have MitID (a Danish CPR number)? This decides how Jobnet works (`reference/sites/jobnet.md`).
- How often to check Gmail for employer answers. Default every 30 minutes; any number of minutes from 15 up.
- What time of day to scan for new ads. Default 12:00.
- Whether they want phone notifications for interview invitations. Default yes.
Explain in one line: the crew runs on this computer, so the computer must be on with the Claude app open for scans and Gmail checks. Missed runs happen when the app opens again.

## Step 3. Connect Google (Gmail, Sheets, Drive, Calendar)
1. Call `mcp__ccd_connectors__session_connectors_status`, loading it with ToolSearch if needed. Find Gmail, Google Sheets, Google Drive and Google Calendar.
2. For any that are missing, need auth, or are disabled, show Connect buttons with `mcp__mcp-registry__suggest_connectors`, keywords `["email", "spreadsheets", "files", "calendar"]`. First get the current directory uuids from `mcp__mcp-registry__search_mcp_registry` with `["gmail", "google sheets", "google drive", "google calendar"]` (field `directoryUuid`). If that search fails, use these known uuids:
   - Gmail `2701e52f-b826-4aaf-8b25-11f2a97c98b0`
   - Google Sheets `2002bd7b-2b05-4653-bb9e-401718270906`
   - Google Drive `b89f7865-a755-4f86-8062-c3bd651740ce`
   - Google Calendar `2a838eaa-f7b4-4bc2-bd47-c326f3c813c5`
   Say: "🚨 Click Connect on each one, choose your Google account, and click Allow. Tell me when done." Use the same Google account as the Gmail in PROFILE.md.
   If the buttons do not show, tell them: Settings → Connectors, then connect each of the four.
3. When they say done, check again. A connector enabled but off for this session can be turned on with `mcp__ccd_connectors__set_session_connector_enabled`, and a failed one retried with `mcp__ccd_connectors__reconnect_session_connector`.
4. Prove each one with a tiny read:
   - Gmail: `list_labels`
   - Drive: `list_recent_files`, pageSize 1
   - Calendar: `list_calendars`
   - Sheets: proved in step 5
   Gmail and Sheets are required. Drive is needed to create the sheet. Calendar is optional.

## Step 4. Install the browser tools
Do this yourself with PowerShell. Each install can show a Windows "allow changes" box. Tell the user "🚨 click Yes if Windows asks" before you start.
1. Node.js: `node --version`. If it is missing, run `winget install -e --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements`, then refresh PATH in the same command (`$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')`).
2. Google Chrome: look in `$env:ProgramFiles\Google\Chrome\Application\chrome.exe`, `${env:ProgramFiles(x86)}\...` and `$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe`. If none has it, run `winget install -e --id Google.Chrome --accept-source-agreements --accept-package-agreements`. Save the path as `chrome_path`.
3. agent-browser, pinned to the version this plugin was tested with: `npm i -g agent-browser@0.42.0`, then `agent-browser --version`. Do not install other versions or extra packages. Never run `agent-browser install`: the crew uses the user's own Chrome.
4. Profiles folder `profiles_dir` = `$env:USERPROFILE\.agent-browser`. Create it. Copy `templates/open-login.ps1` into it. Copy `templates/agent-browser-config.json` as `config.json` with `<chrome_path>` replaced by the real path (JSON-escaped backslashes). If either file already exists there and differs, do not overwrite: keep both by saving yours as `*.job-search` and tell the user.
5. Smoke test, with the sandbox disabled and the two env vars from `reference/browser-and-logins.md`: `agent-browser --session setup-test open https://example.com` (hidden, the default), read the title, then `agent-browser --session setup-test close`. Repeat once with `--headed` to check that a window opens when needed. Check that:
   - the page text comes back between `AGENT_BROWSER_PAGE_CONTENT` markers
   - there is no "Chrome … is behind the current stable release" warning. If there is, 🚨 ask the user to open Chrome → Help → About Google Chrome, let it update, click Relaunch, and then test again.
   If the test fails, read `agent-browser --help` and fix it. Retry with the profile flags removed to narrow the problem down.
6. Claude in Chrome (the user taps human checks there; also the fallback when a connector is down):
   - Load `mcp__claude-in-chrome__list_connected_browsers` with ToolSearch and call it. If a browser is connected, it is done.
   - Otherwise open the extension page in the user's Chrome: `Start-Process "<chrome_path>" "https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn"`. Say: "🚨 In the Chrome window that opened: click Add to Chrome, then Add extension. Click the puzzle icon at the top right and pin Claude. Click the Claude icon and sign in with the same Claude account as this app. Tell me done."
   - Check again. If it is still not connected, tell the user: "In this app open Settings → Connectors (or Customize → Connectors), find Claude in Chrome and turn it on." It is optional: if the user skips it, human checks are tapped in the agent-browser window instead.

## Step 5. Create the tracker sheet
Follow "Creating the sheet" in `reference/tracker.md`, with one queue tab per chosen site. Save `sheet_id` and `sheet_url` (`https://docs.google.com/spreadsheets/d/<id>`). Tell the user: "Your tracker is ready: <link>. Open it in the Google Sheets app on your phone; the Dashboard tab updates by itself."

For Jobindex, find the region path and the category `subid`s that match PROFILE.md (see `reference/sites/jobindex.md`). Show the chosen categories by name in one line, and save both in `site_settings.jobindex` (`region_path`, `subids`).

Keep the sheet private: never change its sharing.

## Step 6. Write the config and the folder rules
- Write `jobsearch-config.json` in the job-search folder, shaped like `templates/jobsearch-config.example.json`, with every value filled from steps 0 to 5. Leave `sessions` empty for now. `auto_apply` is false.
- Copy `templates/FOLDER-CLAUDE.md` to the job-search folder as `CLAUDE.md`. If a `CLAUDE.md` already exists there, append the template's text under a heading instead of replacing it.

## Step 7. Sign in to the sites, one at a time
For each chosen site that needs or benefits from an account (see each `reference/sites/<site>.md`; for agencies, each agency):
1. Say which site, whether an account is required or optional, and what it is used for, in one or two lines.
2. Run `powershell -ExecutionPolicy Bypass -File "<profiles_dir>\open-login.ps1" -Site <site>`.
3. 🚨 "Sign in, or create an account, in the Chrome window that just opened. Then close that window and tell me done (or say skip)." Never type passwords or codes for them.
4. Wait for their answer before opening the next site. Only one sign-in window at a time.
Skip Jobnet unless `has_mitid` is true. Skip optional sites the user does not want an account for.

## Step 8. Open the sessions
Tell the user what you are about to open (the control panel plus one session per chosen site). Then start each one with `mcp__ccd_session__start_session`, loading it with ToolSearch if needed:
- `initiation`: "user_asked" (the user asked for them by running setup)
- `context`: "fresh"
- `cwd`: the job-search folder, and `use_worktree`: false
- `name`: `control-panel`, `sweep-jobindex`, etc.
- `model`: sweeps run on Sonnet (the newest Sonnet model id, e.g. `claude-sonnet-5-5`). Leave `model` out for the control panel so it inherits Opus from this setup session. If this session is not on Opus, open the control panel anyway, then switch it to Opus with `mcp__ccd_session_mgmt__set_session_model` (loaded with ToolSearch). If that is refused, tell the user: "🚨 In the CONTROL PANEL chat, choose Opus in the model menu."

Titles: "CONTROL PANEL", "JOBINDEX", "JOBNET", "WORK IN DENMARK", "LINKEDIN", "THEHUB", "INDEED", "AGENCIES".

Prompts:
- Control panel: `Run /job-search:control-panel. If that command is unknown, load the skill job-search:control-panel and follow it.`
- Each sweep: `Run /job-search:sweep <site>. If that command is unknown, load the skill job-search:sweep with the argument <site> and follow it.`

Background (required): one paragraph saying this is the user's job-search crew, set up just now, with the folder path and that PROFILE.md and jobsearch-config.json hold everything.

Write each returned `local_…` session id into `sessions` in `jobsearch-config.json`, keyed `control_panel`, `jobindex`, `jobnet`, `workindenmark`, `linkedin`, `thehub`, `indeed`, `agencies`.

Then ask once: "Do you want to follow the control panel from your phone (Claude app, Remote Control)? Interview alerts arrive there too." If yes, turn on Remote Control for the control panel session with `mcp__ccd_session_mgmt__set_remote_control` (loaded with ToolSearch). Phone notifications may not arrive while the desktop app is open, so this is the reliable way to see alerts on the phone.

If start_session is not available, tell the user to open a new Code session in the job-search folder per sweep and type the prompt above. Ask them to tell you when done, then read each new session's id with `mcp__ccd_session_mgmt__list_sessions`.

## Step 9. Create the scheduled tasks
Use `mcp__scheduled-tasks__create_scheduled_task` (load it with ToolSearch). Cron times are local. Each prompt is short and points at the plugin, so plugin updates reach the tasks without recreating them:
- `job-daily-scan`, title "Job scan: new ads", cron from `schedule.daily_scan` (e.g. `0 12 * * *`). Prompt: `Load the skill job-search:daily-scan and follow it. Job-search folder: <folder>.`
- `job-gmail-watch`, title "Job answers + interview alerts (Gmail)". Cron every `gmail_check_minutes`, e.g. `*/30 * * * *` for 30 minutes, or `0 */2 * * *` for 120. Prompt: `Load the skill job-search:gmail-watch and follow it. Job-search folder: <folder>.`
- `job-run-cleanup`, title "Job run cleanup", cron from `schedule.cleanup` (e.g. `15 20 * * *`). Prompt: `Load the skill job-search:run-cleanup and follow it. Job-search folder: <folder>.`
If a task id is taken, use the free id the tool suggests and note it in the config under `tasks`.

## Step 10. Finish
Send one short message:
- ✅ what was set up (profile, connectors, sheet link, sites signed in, sessions opened, scheduled tasks with times).
- How it works from now on, in four lines:
  - Each sweep shows you up to 2 offers at a time in its own chat; you answer apply or skip there.
  - The control panel is where you ask how things are going and give new rules.
  - New ads arrive every day at <time>; employer emails are checked every <n> minutes.
  - Your phone: the tracker's Dashboard tab in the Google Sheets app.
- 🚨 anything still to do (a skipped sign-in, an agency profile).
- Keeping it safe, in four short lines (the user does these; never change security settings yourself):
  - Turn on 2-step verification for Google, LinkedIn and Claude. These accounts can now act for you.
  - Lock the computer with a password or PIN when you step away. The saved job-site logins live on it.
  - Let Windows and Chrome update. Restart Chrome when it asks.
  - The crew never asks for passwords, CPR or bank details. Treat any job ad or email that does as a scam.
- Changing things later: tell the control panel, for example "check Gmail every hour", "add this rule: …", or "pause the Indeed sweep".
