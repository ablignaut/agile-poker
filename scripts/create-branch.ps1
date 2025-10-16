# Create Branch Script
# This script fetches from origin and creates a new branch based on origin/main
#
# Description:
#   Fetches the latest code from the remote origin repository and creates a new
#   branch based on origin/main. Ensures you're always branching from the latest
#   main branch code without needing to checkout main locally first.
#
# Prerequisites:
#   - Must be run from within a git repository
#   - Remote 'origin' must exist
#   - Remote must have a 'main' or 'master' branch
#
# Usage Examples:
#   # Create a new branch called SAAS-1234 from latest origin/main
#   .\scripts\create-branch.ps1 SAAS-1234
#
#   # Create a feature branch
#   .\scripts\create-branch.ps1 feature/new-login
#
#   # Create a bugfix branch
#   .\scripts\create-branch.ps1 bugfix/fix-header
#
# Parameters:
#   BranchName   The name of the new branch to create (required)

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$BranchName
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

# Validate branch name
if ([string]::IsNullOrWhiteSpace($BranchName)) {
    Write-ColorOutput Red "Error: Branch name cannot be empty"
    exit 1
}

# Check if branch already exists locally
$localBranchExists = git branch --list $BranchName
if ($localBranchExists) {
    Write-ColorOutput Red "Error: Branch '$BranchName' already exists locally"
    Write-ColorOutput Yellow "Use 'git checkout $BranchName' to switch to it"
    exit 1
}

# Check if branch exists on remote
Write-ColorOutput Cyan "Checking if branch exists on remote..."
$remoteBranchExists = git ls-remote --heads origin $BranchName 2>$null
if ($remoteBranchExists) {
    Write-ColorOutput Red "Error: Branch '$BranchName' already exists on remote"
    Write-ColorOutput Yellow "Use 'git checkout -b $BranchName origin/$BranchName' to check it out"
    exit 1
}

# Fetch from origin
Write-ColorOutput Cyan "Fetching latest code from origin..."
git fetch origin
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Red "Error: Failed to fetch from origin"
    exit 1
}
Write-ColorOutput Green "Fetch completed successfully"

# Determine the main branch name (could be 'main' or 'master')
$mainBranch = $null
$mainExists = git rev-parse --verify origin/main 2>$null
if ($LASTEXITCODE -eq 0) {
    $mainBranch = "origin/main"
} else {
    $masterExists = git rev-parse --verify origin/master 2>$null
    if ($LASTEXITCODE -eq 0) {
        $mainBranch = "origin/master"
    }
}

if ($null -eq $mainBranch) {
    Write-ColorOutput Red "Error: Could not find origin/main or origin/master branch"
    exit 1
}

# Create new branch from origin/main or origin/master
Write-ColorOutput Cyan "Creating branch '$BranchName' from $mainBranch..."
git checkout -b $BranchName $mainBranch
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Red "Error: Failed to create branch '$BranchName'"
    exit 1
}

Write-ColorOutput Green "Successfully created and checked out branch '$BranchName' from $mainBranch"
Write-ColorOutput Cyan "Current branch: $(git branch --show-current)"
