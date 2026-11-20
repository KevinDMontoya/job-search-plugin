# Job search crew for Claude

A team of Claude sessions that looks for jobs for you, shows you the good ones, applies when you say yes, and keeps track of everything in one Google Sheet. It starts with Denmark: Jobindex, Jobnet, WorkInDenmark, LinkedIn, TheHub, Indeed and staffing agencies.

**What you get**
- **Sweeps:** one Claude chat per job site. It finds suitable ads, shows you up to 2 at a time with a full summary, and applies after your yes.
- **Control panel:** a chat where you ask how things are going and give new rules ("skip all night shifts").
- **Daily scan:** new ads are added every day by themselves.
- **Gmail watcher:** answers from employers are logged, and interview invitations come with a prep sheet.
- **Tracker:** one Google Sheet with a Dashboard tab you can open on your phone.

Nothing is sent, ticked or created without your yes. Claude never types your passwords.

## Setup (about 30 minutes)

You need Claude Pro, a Google account (Gmail), and a Windows computer. The computer must be on with the Claude app open for the daily scan and Gmail checks.

1. Download Claude from **claude.com/download**, install it and sign in.
2. Open the **Code** tab, choose **Local**, pick your **Documents** folder, set the mode (below the message box) to **Auto**, and choose **Opus** in the model menu. Setup then opens the control panel on Opus and the sweeps on Sonnet.
3. Paste this and press Enter:

   ```
   Install the job-search plugin from github.com/KevinDMontoya/job-search-plugin and start setup
   ```

   If that does not work, type `/plugin marketplace add KevinDMontoya/job-search-plugin`, then `/plugin install job-search@job-search`. Open a new Code session in the same folder and type `/job-search:setup`.

4. Answer the questions, drag your CV into the chat, click **Connect** for Google, click **Yes** on Windows prompts, and sign in to each job site when its window opens.

If setup stops or you close the app, open a Code session in `Documents\JobSearch` and type `/job-search:setup`. It continues where it stopped.

## Using it
- Each sweep chat shows you offers. Answer **apply** or **skip**.
- Lines starting with 🚨 are things only you can do (sign in, accept a consent, reply to an employer).
- Ask the control panel anything: "how is it going?", "check Gmail every hour", "add this rule: no jobs north of Hillerød".
- Your profile and rules are in `Documents\JobSearch\PROFILE.md`. They stay on your computer and are never uploaded here.

## Updates
Type in any Code session: `Update the job-search plugin`. Your profile, sheet and sessions stay as they are.

## For Claude: installing from this repo
When a user asks to install this plugin, run the Claude Code CLI that ships with the desktop app. On Windows, find `claude.exe` under `%LOCALAPPDATA%\Claude-Data\*\claude-code\*\*\claude.exe`, or use `claude` if it is on PATH. Then:

```
claude plugin install job-search --marketplace KevinDMontoya/job-search-plugin
```

Plugins load in new sessions. After installing, start a new session in the user's chosen folder (the `start_session` tool, `cwd` = that folder) with the prompt `Run /job-search:setup`. If you cannot start sessions, tell the user: "Open a new Code session in the same folder and type /job-search:setup".

To update: `claude plugin marketplace update job-search`, then `claude plugin update job-search@job-search`. The update applies in new sessions; running sessions keep the old version until they restart.

## Privacy
This repo holds only general instructions. Your profile, CV, tracker, session ids and browser logins stay on your own computer and Google account.

## License
MIT
