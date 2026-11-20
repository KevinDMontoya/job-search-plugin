# TheHub (https://thehub.io/jobs)

A Nordic startup job board, mostly with English ads. Found-on dot: 🟡. Queue tab: "Queue – TheHub". Profile: `thehub-profile`.

## Searching
- Cookie banner: click "Only the necessary cookies".
- The country selector defaults to Sweden. Switch it to the user's country (Denmark), then search the user's city.
- Sort by newest, not "Most popular".
- Ad pages are `https://thehub.io/jobs/<id>`. They contain JSON-LD with `datePosted`.
- Many ads are tech roles. Keep only the roles PROFILE.md wants.
- Remote jobs: keep only those that accept candidates living where the user lives.

## Applying and login
- Applying needs a TheHub account, or the ad sends you to the company's own page.
- TheHub's login is a session cookie (`thehub_io.sid`). It survives restarts only because `config.json` starts Chrome with `--restore-last-session`.
- The user creates the account (or links LinkedIn) in the sign-in window (`open-login.ps1 -Site thehub`).
- If the user's TheHub account is linked to LinkedIn, and LinkedIn is already signed in on `thehub-profile`, you may click "Log in" → "Log in with LinkedIn" yourself: it passes through with no password. If LinkedIn asks for a password, a code or an "Allow", stop and 🚨 ask the user.
