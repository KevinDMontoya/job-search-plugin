# Jobindex (https://www.jobindex.dk/)

Denmark's largest job board. Found-on dot: 🟠. Queue tab: "Queue – Jobindex". Profile: `jobindex-profile`.

## Searching
- Search by region and category. The user's region comes from PROFILE.md (Copenhagen area = Region Hovedstaden, path `storkoebenhavn`).
  - Example: `https://www.jobindex.dk/jobsoegning/storkoebenhavn?jobage=2` (jobage = ads from the last N days; use 30 for a first backlog, 1 or 2 for the daily scan).
- Categories are `subid` numbers in the URL, for example `&subid=74&subid=83`. Setup picks the subids that match the user's wanted jobs.
  - To find them, open the search page's category filter and read each category's subid from the filter links.
  - Store the list in `jobsearch-config.json` under `site_settings.jobindex.subids`.
- Full ad text: `https://www.jobindex.dk/c?t=<tid>&ctx=w`, where `<tid>` is the ad id.
- Read the full text of any title that might fit before deciding.
- A Jobagent popup and an "add categories" modal can hide the results. Close them.

## Applying
- Ads link to the employer's site, an email address, or Jobindex's own form.
- Jobindex's form and saved profile need a Jobindex account. The user creates it in the sign-in window (`open-login.ps1 -Site jobindex`).
- Letters: if the ad asks where the job was found, say "which I found on Jobindex".

## Login
Optional. Needed only for Jobindex's own application form and the user's Jobindex profile.
