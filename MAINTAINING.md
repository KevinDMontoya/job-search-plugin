# Maintaining the job-search plugin

This folder is the plugin's source and its GitHub repo. The maintainer adds general improvements here from a Claude Code session opened in this folder, for example: "Add this rule to the plugin: …".

## How to make a change
1. **Make it general.** The plugin is for anyone. Write rules as "the user", read personal values from `PROFILE.md` or `jobsearch-config.json`, and never write names, addresses, phone numbers, emails, sheet ids, session ids, artifact links, employer names from someone's own applications, or local paths with a user name. A rule that only fits one person belongs in that person's PROFILE.md, not here.
2. **Put it where it belongs.**

   | File | What goes there |
   |---|---|
   | `skills/rules/SKILL.md` | Shared rules for every session |
   | `skills/sweep/SKILL.md` | How a sweep works |
   | `skills/control-panel/SKILL.md` | What the control panel does |
   | `skills/daily-scan`, `skills/gmail-watch`, `skills/run-cleanup` | Scheduled tasks |
   | `skills/setup/SKILL.md` | First-time setup |
   | `skills/auto-apply/SKILL.md` | Optional autonomous mode |
   | `reference/tracker.md` | Sheet layout, statuses, Dashboard formulas |
   | `reference/browser-and-logins.md` | agent-browser and sign-in rules |
   | `reference/sites/<site>.md` | One file per job site; add a file for a new site or country |
   | `templates/` | Files setup copies to the user's computer |

3. **Bump the version** in `.claude-plugin/plugin.json` (0.1.0 → 0.1.1 for fixes, 0.2.0 for new features). Users only get an update when the version changes.
4. **Validate:** `claude plugin validate .` must pass.
5. **Privacy scan before EVERY commit.** Search the whole repo for the maintainer's personal data. The search list lives OUTSIDE this repo, in a private file on the maintainer's computer (`%USERPROFILE%\.job-search-private\scan-terms.txt`, one term per line). Never commit that list. Also search for `local_`, `docs.google.com/spreadsheets/d/1`, `claude.ai/artifact/` and `C:\Users\`. Fix every hit before committing.
6. **Security check.** A change must never weaken "Security" in `skills/rules/SKILL.md` or "Safety" in `reference/browser-and-logins.md`. Users run this plugin in Auto mode with Gmail connected, so every rule here acts on their accounts.
7. **Commit and push.** Users update with "Update the job-search plugin". Keep 2-step verification on the GitHub account: whoever controls this repo controls what every user's Claude does after an update.

## Changes that need care
- **Renaming a tab, status or column:** existing users' sheets keep the old names. Say in the commit message what users must change, and have the control panel offer to migrate.
- **Renaming a skill:** setup created scheduled tasks whose prompts name `job-search:daily-scan`, `job-search:gmail-watch` and `job-search:run-cleanup`. Keep those names stable.
- **New sites or countries:** add `reference/sites/<site>.md`, a line in `templates/open-login.ps1`, a Found-on dot in `reference/tracker.md`, and the site to setup's list.
- **agent-browser version:** setup pins `agent-browser@0.42.0`. Test a newer version on your own machine (smoke test, a sign-in, an application form) before raising the pin in `skills/setup/SKILL.md`.
