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
    $_.FullName -notmatch '\\node_modules\\'
  }

$linkRegex = [regex]'(?<!!)\[[^\]]+\]\((?<target>[^)\s]+)(?:\s+"[^"]*")?\)'

foreach ($file in $files) {
  $relative = Resolve-Path -Relative $file.FullName
  $content = Get-Content $file.FullName -Raw
  $linkResults = $linkRegex.Matches($content)

  foreach ($linkResult in $linkResults) {
    $target = $linkResult.Groups['target'].Value.Trim()

    if ($target.StartsWith('http://') -or $target.StartsWith('https://') -or $target.StartsWith('mailto:')) {
      continue
    }

    if ($target -eq 'url') {
      continue
    }

    # Skip template placeholders like {github-url}.
    if ($target -match '[{}]') {
      continue
    }

    if ($target.StartsWith('#')) {
      continue
    }

    $pathPart = $target
    $anchorIndex = $target.IndexOf('#')
    if ($anchorIndex -ge 0) {
      $pathPart = $target.Substring(0, $anchorIndex)
    }

    if ([string]::IsNullOrWhiteSpace($pathPart)) {
      continue
    }

    $resolved = Join-Path $file.DirectoryName $pathPart
    if (-not (Test-Path $resolved)) {
      Add-Failure "$relative has broken relative link target: $target"
    }
  }
}

if ($failed) {
  Write-Host 'Markdown link check failed.' -ForegroundColor Red
  exit 1
}

Write-Host 'Markdown link check passed.' -ForegroundColor Green
exit 0
