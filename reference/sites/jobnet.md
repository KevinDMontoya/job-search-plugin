# Jobnet (https://jobnet.dk/)

The Danish public employment service's job board. Found-on dot: 🟣. Queue tab: "Queue – Jobnet". Profile: `jobnet-profile`.

## Searching
- The public search needs no login.
- Search the newest ads in the user's area from PROFILE.md. For Copenhagen, use Region Hovedstaden plus nearby Zealand towns within the user's commute, such as Roskilde, Køge and Greve.
- Use the last 30 days for a first backlog, and the scan window (see the daily-scan skill) for the daily scan.
- Read the full ad before deciding.
- Before adding an ad, check the other queue tabs: many Jobnet ads are also on Jobindex. Mark those 🔁.

## Applying and login
- Applying happens by email, through the employer's own site, or through Jobnet's own form.
- Jobnet's own form needs MitID, which needs a Danish CPR number. Check `has_mitid` in `jobsearch-config.json`:
  - **true**: the user may log in with MitID in the sign-in window (`open-login.ps1 -Site jobnet`) and apply through Jobnet's form. MitID approval happens on the user's phone, and only the user does it.
  - **false**: never ask the user to log in to Jobnet. Apply only through the employer's own route. If an ad can ONLY be applied to through Jobnet's form, set ⛔ "Jobnet login needed" and move on.
