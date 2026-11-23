# Indeed (https://dk.indeed.com/)

Found-on dot: 🔴. Queue tab: "Queue – Indeed". Profile: `indeed-profile`.

## Searching
- Search the user's area from PROFILE.md, newest first, for the wanted job types.
- Indeed copies many Jobindex and Jobnet ads. Check duplicates against the other queue tabs: mark copies 🔁, and do not queue them as 🆕.
- Read the full ad before deciding. Write the deadline as YYYY-MM-DD, or "not stated".
- **Daily scan is done by the sweep** on `indeed-profile`, when the daily scan messages it. Indeed shows a bot check to new browser sessions: ask the user once per session to tap it ("When the browser is blocked" in `reference/browser-and-logins.md`), then load pages one at a time, slowly (10 to 20 seconds apart), never in bursts.

## Applying and login
- Indeed Apply needs an Indeed account. The user signs in or creates it in the sign-in window (`open-login.ps1 -Site indeed`).
- Indeed often shows human checks to automated browsers. Never solve them: follow "When the browser is blocked". If it cannot be passed, hold the ad (⏸️) and tell the control panel.
