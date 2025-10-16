# Create Pull Request Script
# This script creates a PR with the title from Jira ticket summary
#
# Description:
#   Automatically creates a GitHub pull request by opening the Jira ticket in your
#   browser and prompting you to enter the ticket summary. The branch name should match
#   the Jira ticket number (e.g., SAAS-41565).
#
# Prerequisites:
#   - GitHub CLI (gh) must be installed and authenticated
#   - Must be run from within a git repository
#   - Branch must be pushed to remote (or use -Push flag)
#   - Access to Jira in your browser (uses SSO/existing session)
#
# Usage Examples:
#   # Basic usage - creates PR with Jira ticket summary as title
#   .\scripts\create-pr.ps1
#
#   # If branch is SAAS-41565 and Jira ticket summary is "Make local dev better":
#   #   Title: SAAS-41565: Make local dev better
#   #   Description: https://confluencetechnologies.atlassian.net/browse/SAAS-41565
#
#   # Automatically push branch to remote before creating PR
#   .\scripts\create-pr.ps1 -Push
#
#   # Create PR without opening browser
#   .\scripts\create-pr.ps1 -NoBrowser
#
#   # Skip Jira lookup and use branch name only
#   .\scripts\create-pr.ps1 -NoJira
#
#   # Combine multiple flags
#   .\scripts\create-pr.ps1 -Push -NoBrowser
#
# Parameters:
#   -Push         Automatically push the branch to remote if not already pushed
#   -NoBrowser    Don't open the PR in browser after creation
#   -NoJira       Skip Jira integration and use branch name as title
#   -SkipPRCheck  Skip checking if PR already exists (use if the check hangs)

param(
    [switch]$Push = $false,
    [switch]$NoBrowser = $false,
    [switch]$NoJira = $false,
    [switch]$SkipPRCheck = $false
)

# Jira configuration
$JIRA_BASE_URL = "https://confluencetechnologies.atlassian.net"
$JIRA_API_URL = "$JIRA_BASE_URL/rest/api/3"

# Function to write colored output
function Write-ColorOutput($ForegroundColor, $Message) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Host $Message
    $host.UI.RawUI.ForegroundColor = $fc
}

# Function to fetch Jira ticket summary manually
function Get-JiraTicketSummaryManual {
    param([string]$ticketNumber)

    $jiraUrl = "$script:JIRA_BASE_URL/browse/$ticketNumber"

    Write-ColorOutput Cyan "Opening Jira ticket in browser: $jiraUrl"
    Write-ColorOutput Yellow "Please copy the ticket summary from the browser"

    # Open the Jira URL in default browser
    Start-Process $jiraUrl

    # Wait a moment for browser to open
    Start-Sleep -Seconds 2

    Write-ColorOutput Cyan "Enter the ticket summary (or press Enter to use branch name only):"
    $summary = Read-Host

    if ([string]::IsNullOrWhiteSpace($summary)) {
        return $null
    }

    return $summary.Trim()
}

# Check if we're in a git repository
$isGitRepo = git rev-parse --is-inside-work-tree 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Red "Error: Not a git repository"
    exit 1
}

# Check if gh CLI is authenticated
Write-ColorOutput Cyan "Verifying GitHub CLI authentication..."
$ghAuthStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Red "Error: GitHub CLI is not authenticated"
    Write-ColorOutput Yellow "Please run: gh auth login"
    exit 1
}
Write-ColorOutput Green "GitHub CLI authenticated"

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
if (-not $SkipPRCheck) {
    Write-ColorOutput Cyan "Checking for existing PR..."
    $prCheckResult = & gh pr list --head $currentBranch --json number,url 2>&1

    Write-ColorOutput Green "PR check completed"

    if ($LASTEXITCODE -eq 0 -and $prCheckResult -and $prCheckResult -ne "[]") {
        try {
            $prData = $prCheckResult | ConvertFrom-Json
            if ($prData -and @($prData).Count -gt 0) {
                Write-ColorOutput Yellow "A PR already exists for this branch:"
                Write-ColorOutput Yellow "  URL: $($prData[0].url)"
                exit 0
            }
        } catch {
            Write-ColorOutput Yellow "Note: Could not parse PR check result, continuing..."
        }
    }

    Write-ColorOutput Green "No existing PR found, proceeding..."
} else {
    Write-ColorOutput Yellow "Skipping PR existence check"
}

# Prepare PR title and body
$prTitle = $currentBranch
$prBody = $currentBranch
$jiraUrl = "$JIRA_BASE_URL/browse/$currentBranch"

# Fetch Jira ticket summary if not disabled
if (-not $NoJira) {
    $ticketSummary = Get-JiraTicketSummaryManual $currentBranch

    if ($ticketSummary) {
        $prTitle = "${currentBranch}: $ticketSummary"
        $prBody = $currentBranch
        Write-ColorOutput Green "Using ticket summary: $ticketSummary"
    } else {
        Write-ColorOutput Yellow "No summary provided, using branch name as title"
        $prBody = $currentBranch
    }
} else {
    Write-ColorOutput Yellow "Jira integration disabled, using branch name as title"
}

# Create the PR
Write-ColorOutput Cyan "Creating pull request..."
Write-ColorOutput Cyan "  Title: $prTitle"
Write-ColorOutput Cyan "  Description: $prBody"

$ghArgs = @(
    "pr", "create",
    "--title", $prTitle,
    "--body", $prBody
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
