param(
    [Parameter(Mandatory = $true)]
    [ValidateRange(1, 999)]
    [int]$Day,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Summary,

    [ValidateSet('feat', 'fix', 'docs', 'test', 'refactor', 'chore')]
    [string]$CommitType = 'feat',

    [ValidatePattern('^\d{8}$')]
    [string]$TagDate = (Get-Date -Format 'yyyyMMdd'),

    [string]$Remote = 'origin',
    [string]$Branch = 'main',

    [string]$TagName,
    [string]$CommitMessage,
    [string]$TagMessage,

    [switch]$NoPush,
    [switch]$AllowEmptyCommit
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-Git {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Args,

        [Parameter(Mandatory = $true)]
        [string]$FailMessage
    )

    & git @Args
    if ($LASTEXITCODE -ne 0) {
        throw $FailMessage
    }
}

# Ensure current directory is a git repo.
Invoke-Git -Args @('rev-parse', '--is-inside-work-tree') -FailMessage 'Current directory is not a Git repository.'

$dayPadded = '{0:D2}' -f $Day
if (-not $TagName) {
    $TagName = "day-$dayPadded-$TagDate"
}
if (-not $CommitMessage) {
    $CommitMessage = "$CommitType(day$dayPadded): $Summary"
}
if (-not $TagMessage) {
    $TagMessage = "Day $dayPadded - $Summary"
}

# Block duplicate tags by default.
& git rev-parse -q --verify "refs/tags/$TagName" | Out-Null
if ($LASTEXITCODE -eq 0) {
    throw "Tag already exists locally: $TagName. Use another TagName or TagDate."
}

Invoke-Git -Args @('add', '-A') -FailMessage 'git add failed.'

$statusOutput = (& git status --porcelain)
if (-not $statusOutput -and -not $AllowEmptyCommit) {
    throw 'No changes to commit. Use -AllowEmptyCommit if needed.'
}

$commitArgs = @('commit', '-m', $CommitMessage)
if ($AllowEmptyCommit) {
    $commitArgs = @('commit', '--allow-empty', '-m', $CommitMessage)
}
Invoke-Git -Args $commitArgs -FailMessage 'git commit failed.'

Invoke-Git -Args @('tag', '-a', $TagName, '-m', $TagMessage) -FailMessage 'git tag failed.'

if (-not $NoPush) {
    Invoke-Git -Args @('push', $Remote, $Branch) -FailMessage "git push $Remote $Branch failed."
    Invoke-Git -Args @('push', $Remote, $TagName) -FailMessage "git push $Remote $TagName failed."
}

Write-Host 'Done: commit + tag'
Write-Host "Branch : $Branch"
Write-Host "Tag    : $TagName"
Write-Host "Remote : $Remote"
if ($NoPush) {
    Write-Host 'Status : push skipped (NoPush)'
} else {
    Write-Host 'Status : branch and tag pushed'
}
