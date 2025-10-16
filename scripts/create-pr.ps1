# Create Pull Request Script
# This script creates a PR with the title and description set to the current branch name
#
# Description:
#   Automatically creates a GitHub pull request using the current branch name
#   as both the PR title and description. Useful for workflows where branch
#   names follow a ticket/issue naming convention (e.g., SAAS-1234, JIRA-456).
#
# Prerequisites:
#   - GitHub CLI (gh) must be installed and authenticated
#   - Must be run from within a git repository
#   - Branch must be pushed to remote (or use -Push flag)
#
# Usage Examples:
#   # Basic usage - creates PR with branch name as title and description
#   .\scripts\create-pr.ps1
#
#   # If branch is SAAS-1234, creates PR with:
#   #   Title: SAAS-1234
#   #   Description: SAAS-1234
#
#   # Automatically push branch to remote before creating PR
#   .\scripts\create-pr.ps1 -Push
#
#   # Create PR without opening browser
#   .\scripts\create-pr.ps1 -NoBrowser
#
#   # Combine multiple flags
#   .\scripts\create-pr.ps1 -Push -NoBrowser
#
# Parameters:
#   -Push       Automatically push the branch to remote if not already pushed
#   -NoBrowser  Don't open the PR in browser after creation

param(
    [switch]$Push = $false,
    [switch]$NoBrowser = $false
)

# Function to write colored output
function Write-ColorOutput($ForegroundColor, $Message) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Output $Message
    $host.UI.RawUI.ForegroundColor = $fc
}

# Check if we're in a git repository
$isGitRepo = git rev-parse --is-inside-work-tree 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Red "Error: Not a git repository"
    exit 1
}

# Get the current branch name
$currentBranch = git branch --show-current
if ([string]::IsNullOrWhiteSpace($currentBranch)) {
    Write-ColorOutput Red "Error: Could not determine current branch"
    exit 1
}

# Check if we're on master or main branch
if ($currentBranch -eq "master" -or $currentBranch -eq "main") {
    Write-ColorOutput Red "Error: Cannot create PR from master/main branch"
    exit 1
}

Write-ColorOutput Cyan "Current branch: $currentBranch"

# Check if branch exists on remote
$remoteBranch = git ls-remote --heads origin $currentBranch 2>$null
if ([string]::IsNullOrWhiteSpace($remoteBranch)) {
    if ($Push) {
        Write-ColorOutput Yellow "Branch not found on remote. Pushing..."
        git push -u origin $currentBranch
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput Red "Error: Failed to push branch to remote"
            exit 1
        }
        Write-ColorOutput Green "Branch pushed successfully"
    } else {
        Write-ColorOutput Yellow "Warning: Branch not found on remote"
        Write-ColorOutput Yellow "Run with -Push flag to push the branch first: .\scripts\create-pr.ps1 -Push"
        $response = Read-Host "Do you want to push now? (y/n)"
        if ($response -eq "y" -or $response -eq "Y") {
            git push -u origin $currentBranch
            if ($LASTEXITCODE -ne 0) {
                Write-ColorOutput Red "Error: Failed to push branch to remote"
                exit 1
            }
            Write-ColorOutput Green "Branch pushed successfully"
        } else {
            Write-ColorOutput Red "Aborted: Branch must be pushed to create a PR"
            exit 1
        }
    }
}

# Check if PR already exists
Write-ColorOutput Cyan "Checking for existing PR..."
$existingPR = gh pr list --head $currentBranch --json number,url 2>$null | ConvertFrom-Json
if ($existingPR) {
    Write-ColorOutput Yellow "A PR already exists for this branch:"
    Write-ColorOutput Yellow "  URL: $($existingPR.url)"
    exit 0
}

# Create the PR
Write-ColorOutput Cyan "Creating pull request..."
Write-ColorOutput Cyan "  Title: $currentBranch"
Write-ColorOutput Cyan "  Description: $currentBranch"

$ghArgs = @(
    "pr", "create",
    "--title", $currentBranch,
    "--body", $currentBranch
)

if ($NoBrowser) {
    $ghArgs += "--no-web"
}

& gh @ghArgs

if ($LASTEXITCODE -eq 0) {
    Write-ColorOutput Green "Pull request created successfully!"
} else {
    Write-ColorOutput Red "Error: Failed to create pull request"
    exit 1
}
