# LinkedIn (https://www.linkedin.com/jobs/)

Found-on dot: 🔵. Queue tab: "Queue – LinkedIn". Profile: `linkedin-profile`.

## Searching
- Location is the user's area from PROFILE.md, for example "Copenhagen Metropolitan Area". Use "Past month" for a first backlog.
- LinkedIn cannot sort by deadline. Start from the oldest posts, because they close first. Mention a deadline if the ad states one.
- **Daily scan is done by the sweep**, signed in on `linkedin-profile`, when the daily scan messages it. Go through EVERY results page of the scan window, with page loads 10 to 20 seconds apart (never in bursts). The public guest search (for example `https://www.linkedin.com/jobs-guest/jobs/api/seeMoreJobsPostings/search?location=Copenhagen%2C%20Capital%20Region%2C%20Denmark&f_TPR=r172800&start=0`, where `f_TPR=r172800` means the last 48 hours) is only a fallback when the profile is signed out.
- If the user does not speak the local language (PROFILE.md), dismiss posts that require it or are written in it. Dismissing can be undone, so it needs no question. Keep posts where the local language is only "a plus", or where any Scandinavian language is accepted and the user has one.

## Applying and login
- A LinkedIn login is needed for Easy Apply and for saved searches. The user signs in once in the sign-in window (`open-login.ps1 -Site linkedin`).
- Easy Apply, or the employer's own site.
- Many employer portals offer "Log in with LinkedIn". Use the LinkedIn profile for those (see `reference/browser-and-logins.md`).
- Some big employers require their own account first. The user creates it themselves. Note those ads as ⏳ until it exists.
