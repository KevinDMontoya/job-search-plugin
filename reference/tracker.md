# Tracker: one Google Sheet

Setup creates one Google Sheet in the user's Drive and writes its id to `jobsearch-config.json` (`sheet_id`). Use the Google Sheets connector for all reads and writes. Write values with input option USER_ENTERED, so dates become real dates and the Dashboard formulas can count them.

## Tabs and columns

**Applications** (every decision; one row per job the user applied to, skipped or screened out)
A Status | B # | C Date | D Company | E Role | F Location / address | G Commute | H Found on | I Applied via / how to apply | J 🔁 Cross-platform | K Notes / reason

- Newest row on top: insert a row directly under the header (`insert_dimension` at startIndex 1), then `update_values` on row 2. Never use `append_values` on this tab: Google may guess the table end wrongly and write in the middle.
- `#` numbers only ✅ Applied rows, in order. Just before writing a ✅ row, read the highest # used and add 1. Read it again right after writing, and fix it if another sweep took the same number at the same moment.
- Re-read the rows you wrote.

**Queue – <Site>** (one tab per active site, e.g. "Queue – Jobindex"; the dash is an en dash `–`)
A Status | B Found | C Ad ID | D Company | E Title | F Location | G Deadline | H Language | I URL | J Notes | K Fit (1-5) | L Full summary

- New ads are appended (`append_values` is fine on queue tabs) with Status "🆕 New".
- Sort order, re-applied after adding ads and after each daily scan: 🆕 rows on top, by Deadline (soonest first, "not stated" last), then Fit (highest first).
- When the user decides, set the queue row's Status and also write the Applications row.

**Scan log** (one row per daily scan)
A Run time | B Run by | C New ads added | D Per queue | E Most urgent | F Problems | G Delivered to sessions

**Responses** (every answer from an employer or recruiting system, newest on top, same insert rule as Applications)
A Date received | B Company | C Role | D Site applied on | E Applied date | F Answer type | G Summary | H Next step | I Deadline | J Link or thread

Answer types: `Acknowledgement`, `❌ Rejection`, `📅 Interview invitation`, `📄 Document request`, `🧪 Test`, `🎉 Offer`, `Other`.

**Interviews**
A Date and time | B Company | C Role | D Format and place | E Who | F Status | G Prep done | H Notes after

**Dashboard** (formulas only; nobody writes values here). See "Dashboard formulas" below.

## Statuses
- `🆕 New`: in a queue, not shown yet
- `👀 Shown`: shown to the user, waiting for apply or skip
- `▶️ Apply next`: user said yes, not sent yet
- `⏳ Waiting on user`: needs the user (account, consent, a question)
- `✅ Applied`
- `⏭️ Skipped`: the user's choice, reason in Notes
- `⛔ Screened out`: fails PROFILE.md rules, reason in Notes
- `⏸️ Held`: could not be sent (blocked, human check), reason in Notes
- `🔁 Duplicate of #N`

## Found-on dots
🟠 Jobindex · 🟣 Jobnet · 🟢 WorkInDenmark · 🔵 LinkedIn · 🟡 TheHub · 🔴 Indeed · 🟤 Agencies · ⚪ Other

## Creating the sheet (setup)
1. Google Drive connector `create_file` with title "Job search tracker" and content mime type `application/vnd.google-apps.spreadsheet` (no content). Keep the returned file id.
2. Google Sheets connector: add the tabs with `update_spreadsheet` (addSheet requests): Dashboard, Applications, one "Queue – <Site>" per active site, Scan log, Responses, Interviews. Rename or delete the default "Sheet1".
3. Write the header rows above with `update_values`. Freeze row 1 and bold it (updateSheetProperties / repeatCell) if the connector allows; skip quietly if not.
4. Write the Dashboard formulas with `update_formulas`.
5. Read back one header row to confirm.
If step 1 fails, ask the user to create an empty Google Sheet named "Job search tracker" themselves (sheets.new) and paste its link; then continue from step 2.

## Dashboard formulas
Write labels in column A and formulas in column B, starting at A1. Replace the queue-tab list with the active sites only.

- `Applied (total)`: `=COUNTIF(Applications!A2:A,"✅*")`
- `Applied (last 7 days)`: `=COUNTIFS(Applications!A2:A,"✅*",Applications!C2:C,">="&(TODAY()-7))`
- `Skipped`: `=COUNTIF(Applications!A2:A,"⏭️*")`
- `Screened out`: `=COUNTIF(Applications!A2:A,"⛔*")`
- `Waiting on me` (⏳ rows are on the queue tabs; one COUNTIF per active queue): `=COUNTIF('Queue – Jobindex'!A2:A,"⏳*")+COUNTIF('Queue – Jobnet'!A2:A,"⏳*")`
- One line per queue, `New in Queue – Jobindex`: `=COUNTIF('Queue – Jobindex'!A2:A,"🆕*")`
- `Answers (total)`: `=COUNTA(Responses!A2:A)`
- `Interview invitations`: `=COUNTIF(Responses!F2:F,"📅*")`
- `Rejections`: `=COUNTIF(Responses!F2:F,"❌*")`

From D1, the 10 nearest deadlines among new and shown ads (header in D1, formula in D2), extended with every active queue tab:
```
=IFERROR(ARRAY_CONSTRAIN(SORT(FILTER({'Queue – Jobindex'!G2:G,'Queue – Jobindex'!D2:E,'Queue – Jobindex'!I2:I;'Queue – Jobnet'!G2:G,'Queue – Jobnet'!D2:E,'Queue – Jobnet'!I2:I},ISNUMBER({'Queue – Jobindex'!G2:G;'Queue – Jobnet'!G2:G}),REGEXMATCH({'Queue – Jobindex'!A2:A;'Queue – Jobnet'!A2:A},"New|Shown")),1,TRUE),10,4),"none")
```
From D14, upcoming interviews: `=IFERROR(ARRAY_CONSTRAIN(SORT(FILTER(Interviews!A2:F,Interviews!A2:A<>""),1,TRUE),10,6),"none")`
From D27, latest answers: `=IFERROR(ARRAY_CONSTRAIN(FILTER(Responses!A2:H,Responses!A2:A<>""),8,8),"none")`
From D38, last scan: `=IFERROR(INDEX('Scan log'!A2:F,COUNTA('Scan log'!A2:A),0),"no scan yet")`

Check the Dashboard once after writing: every cell should show a number, a list, or "none", not `#ERROR!`. Fix the formula if not.
