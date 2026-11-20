# Browser and logins

## agent-browser
- Every sweep uses agent-browser, a command-line browser for AI agents, in a VISIBLE window, so the user can watch every ad and application page.
- Setup installs it with `npm i -g agent-browser`.
- Run agent-browser commands with the sandbox disabled (Bash/PowerShell tool option `dangerouslyDisableSandbox: true`). It cannot start its browser otherwise.
- Set these in every command, or the daemon may relaunch headless after idle:
  - `AGENT_BROWSER_HEADED=1`
  - `AGENT_BROWSER_EXECUTABLE_PATH=<chrome_path from jobsearch-config.json>`
- Use your OWN named session, never the shared default one: `agent-browser --session <your-sweep-name> --headed --profile "<profiles_dir>\<site>-profile" open <url>`
- Useful commands: `open <url>`, `tab new <url>`, `read --max-output N`, `snapshot -i` (gives refs like @e12), `click @e12`, `fill @e12 "text"`, `upload '<css>' <file>`, `eval "<js>"`, `screenshot <path>`, `close`. For more, run `agent-browser skills get core`.
- Always close with `agent-browser --session <name> close`. Never kill Chrome: login cookies are only saved on a clean close.
- Cookie banners: choose the most privacy-preserving option (only necessary cookies / decline).
- Do not pass your own `--args`. `<profiles_dir>\config.json` already starts Chrome with `--no-startup-window,--restore-last-session`, which keeps "session" login cookies such as TheHub's. If you must pass `--args`, include both flags.
- Auto-apply mode may run headless: drop `--headed` and keep `--profile` and `--session`. If a site blocks headless or shows a human check, retry once headed.

## One saved profile per site
- Each site has its own Chrome profile folder: `<profiles_dir>\<site>-profile`, for example `linkedin-profile`, `jobindex-profile`, `adecco-profile`.
- Start agent-browser with that profile so the saved login is reused. Never use a temporary profile for a site that needs a login.
- One profile folder can be open in only ONE Chrome at a time. Never open the same profile in two sessions, or while its sign-in window is still open.

## Signing in (the user does it, never Claude)
- Google and many sites refuse sign-ins inside a remote-controlled browser ("This browser or app may not be secure"). So sign-ins happen in a NORMAL Chrome window on the same profile folder, and agent-browser reuses the saved login afterwards.
- When a page asks for a login, or the login expired:
  1. Close your browser: `agent-browser --session <name> close`.
  2. Open the normal sign-in window: `powershell -ExecutionPolicy Bypass -File "<profiles_dir>\open-login.ps1" -Site <site>`.
  3. 🚨 Ask the user to sign in (or create the account) themselves in that window, then close the window.
  4. Reopen agent-browser with the same `--profile`.
- Never type the user's password or a one-time code. Never create an account for the user. The user creates accounts themselves in the sign-in window.
- "Log in with LinkedIn" or "Continue with Google" on an employer portal: prefer that over a new email-and-password account. Use agent-browser with the LinkedIn profile (check no other sweep has it open). A LinkedIn or Google "Allow" screen, the portal's terms box and the final send still need the user's yes. If it still fails and the user has Claude in Chrome, that one application may be done in the user's own Chrome, with their yes for that step.
- Adding a site to the sign-in script: `open-login.ps1` has a list of sites and sign-in URLs. Add a line in the same pattern if your site is missing.

## Send lock (one send at a time across all sweeps)
- Before any send (form submit, Easy Apply, email application), take the lock file `<profiles_dir>\browser.lock`. Create it with your session name and the time. If it exists and is younger than 10 minutes, wait and retry.
- Do the duplicate check inside the lock (see the rules skill), send, write the ✅ row, then delete the lock file.
- A lock older than 10 minutes is stale: delete it and take it.
