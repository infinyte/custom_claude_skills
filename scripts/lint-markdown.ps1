$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$failed = $false

function Add-Failure($message) {
  Write-Error $message
  $script:failed = $true
}

$files = Get-ChildItem -Path . -Recurse -File -Filter '*.md' |
  Where-Object {
    $_.FullName -notmatch '\\.git\\' -and
    $_.FullName -notmatch '\\node_modules\\' -and
    $_.FullName -notmatch '\\archive\\'
  }

foreach ($file in $files) {
  $relative = Resolve-Path -Relative $file.FullName
  $lines = Get-Content $file.FullName

  # Rule 1: File should contain at least one markdown heading.
  $headingCount = ($lines | Where-Object { $_ -match '^#{1,6}\s+\S' }).Count
  if ($headingCount -lt 1) {
    Add-Failure "$relative must contain at least one markdown heading."
  }

  # Rule 2: The first non-empty content line should be a heading or YAML frontmatter.
  $firstContentLine = $lines | Where-Object { $_.Trim().Length -gt 0 } | Select-Object -First 1
  if ($null -ne $firstContentLine -and $firstContentLine -notmatch '^(---|#{1,6}\s+\S)') {
    Add-Failure "$relative should start with a heading or YAML frontmatter."
  }

}

if ($failed) {
  Write-Host 'Markdown lint failed.' -ForegroundColor Red
  exit 1
}

Write-Host 'Markdown lint passed.' -ForegroundColor Green
exit 0
