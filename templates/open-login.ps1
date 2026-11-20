# Opens a NORMAL Chrome window (no automation, no debug port) on a job site's
# saved agent-browser profile, so the user can sign in or create an account
# themselves. Google and other sites accept sign-ins there. The login is saved
# in the profile folder, and agent-browser reuses it later with:
#   --profile "$env:USERPROFILE\.agent-browser\<site>-profile"
#
# Usage:  powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agent-browser\open-login.ps1" -Site linkedin
# Close the matching agent-browser session first (agent-browser --session <name> close):
# Chrome can open one profile folder in only one window process at a time.
param([Parameter(Mandatory=$true)][string]$Site)

# Same Chrome as agent-browser uses (chrome_path in jobsearch-config.json), so the saved login carries over.
$chrome = $null
foreach ($p in @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe")) {
  if ($p -and (Test-Path $p)) { $chrome = $p; break }
}
if (-not $chrome) { Write-Output "Chrome not found. Install Google Chrome, then run this again."; exit 1 }

# Add a site: one line, name = sign-in or start URL.
$urls = [ordered]@{
  linkedin          = 'https://www.linkedin.com/login'
  jobindex          = 'https://www.jobindex.dk/bruger/log-ind'
  jobnet            = 'https://jobnet.dk/'
  workindenmark     = 'https://www.workindenmark.dk/'
  thehub            = 'https://thehub.io/jobs'
  indeed            = 'https://dk.indeed.com/'
  adecco            = 'https://www.adecco.dk/'
  randstad          = 'https://www.randstad.dk/'
  manpower          = 'https://www.manpower.dk/'
  studentconsulting = 'https://www.studentconsulting.com/'
  google            = 'https://accounts.google.com/'
}

if (-not $urls.Contains($Site)) {
  Write-Output "Unknown site: $Site. Known: $($urls.Keys -join ', ')"
  exit 1
}
$dir = Join-Path $env:USERPROFILE ".agent-browser\$Site-profile"
New-Item -ItemType Directory -Force -Path $dir | Out-Null
# --restore-last-session keeps "session" login cookies (TheHub uses one) across Chrome restarts.
# agent-browser gets the same flag from config.json in the same folder.
$chromeArgs = @("--user-data-dir=`"$dir`"", '--no-first-run', '--no-default-browser-check', '--restore-last-session', $urls[$Site])
Start-Process -FilePath $chrome -ArgumentList $chromeArgs
Write-Output "Opened $Site  profile=$dir  url=$($urls[$Site])"
