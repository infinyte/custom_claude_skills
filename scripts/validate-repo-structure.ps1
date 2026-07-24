$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$failed = $false

function Fail($message) {
  Write-Error $message
  $script:failed = $true
}

$skillsRoot = Join-Path $repoRoot 'Claude Skills'
if (-not (Test-Path $skillsRoot)) {
  Fail "Missing required folder: Claude Skills"
}

# 1) Every skill folder must include SKILL.md and references/
$skillDirs = Get-ChildItem $skillsRoot -Directory
foreach ($dir in $skillDirs) {
  $skillMd = Join-Path $dir.FullName 'SKILL.md'
  $references = Join-Path $dir.FullName 'references'

  if (-not (Test-Path $skillMd)) {
    Fail "Missing SKILL.md in: $($dir.Name)"
  }

  if (-not (Test-Path $references)) {
    Fail "Missing references/ in: $($dir.Name)"
  }
}

# 2) Repo docs should not reference missing platform folders.
$repoDocs = @(
  'docs/README.md',
  'docs/repository-layout.md',
  'docs/skill-index.md'
)

$stalePatterns = @(
  'GitHub Copilot Pro Skills/'
)

foreach ($doc in $repoDocs) {
  $path = Join-Path $repoRoot $doc
  if (-not (Test-Path $path)) {
    Fail "Missing required repo doc: $doc"
    continue
  }

  $content = Get-Content $path -Raw
  foreach ($pattern in $stalePatterns) {
    if ($content -match [Regex]::Escape($pattern)) {
      Fail "Stale reference '$pattern' found in $doc"
    }
  }
}

if ($failed) {
  Write-Host "Validation failed." -ForegroundColor Red
  exit 1
}

Write-Host "Validation passed." -ForegroundColor Green
exit 0
