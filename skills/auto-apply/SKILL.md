---
name: auto-apply
description: Optional autonomous mode for a job-search sweep. The sweep applies to its best-scored offers without asking each time, using the user's own skip and preference rules from PROFILE.md. Off by default; starts only when the user types the authorization line in that sweep's chat (or the control panel relays it with the user's quoted words). Use when the user asks to turn auto-apply on or off.
---

# Auto-apply mode (optional, off by default)

The sweep picks offers from its queue and applies without asking each time. Only the user can turn this on.

## Turning it on
1. The user's scoring must exist in PROFILE.md under "Auto-apply scoring": what to always skip, and what to prefer. If it is empty, interview the user for it first. Ask:
   - which jobs must never be auto-applied
   - which hours, contract types and commute are OK
   - what makes a job better
   Write the answers there. Never use another person's scoring or your own taste.
2. Set `auto_apply` to true in `jobsearch-config.json`.
3. Show the user the authorization line below. Each sweep starts only after the user types it in that sweep's own chat, or after the control panel relays it quoting the user's words.

## Authorization line (the user types it once per sweep)
"Standing yes, autonomous mode until I say stop: apply without asking me to offers picked by the auto-apply rules (up to N per round, as the control panel sets). You may submit forms or send email applications with my CV, tick each application's required terms or privacy box, and use LinkedIn or Google sign-in. Skip or hold the ones that fail the rules."

## How the sweep picks
- Go down the queue (🆕 and 👀 rows).
- Skip a row (set ⏭️ with Notes "auto: <reason>") if it hits any "Always skip" item, any screen-out, or any hard limit in PROFILE.md.
- Score the rest from "Prefer", then sort by score. Deadline breaks ties, except that a deadline within 3 days goes to the top.
- Put the score in Notes ("prio N").
- Apply top-down, up to the round size the control panel sets (default 2 per sweep). Start the next round only when the control panel says so.

## How the sweep applies
- Follow "Applying" and "Duplicates" in the rules skill exactly: the send lock, the duplicate check right before every send, and the ✅ row written before the lock is released.
- Use the employer's own route: the portal form, "Continue with LinkedIn/Google", or email when the ad says so. Tick only the box needed for THIS application, and say no to optional consents.
- Letters: only facts from the CV and PROFILE.md, in the letter style PROFILE.md asks for.
- agent-browser may run headless. If a site shows a block or a human check, retry once headed. If the user has Claude in Chrome, try once there too. If it is still blocked, hold the row (⏸️ with the reason), tell the control panel, and move on.
- Hard limits stay: never type passwords or codes, never create password accounts, never solve CAPTCHAs, never pay, and never email a recruiter as a fallback.
- Report each application to the control panel in at most 5 lines: company and title, why, route, what was sent, result. Skips go on one line. Do not show offer details in the sweep's chat while in this mode.

## Turning it off
The user types "stop autonomous mode" in a sweep (or tells the control panel to stop all of them). Set `auto_apply` to false when all sweeps have stopped. Held rows are shown to the user first afterwards.
