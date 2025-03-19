#!/usr/bin/env bash
# Script to create a GitHub repository and configure it as a remote
# This script is part of the Claude Code CLI Toolkit
# Source: https://github.com/ChristopherA/Claude-Code-CLI-Toolkit

# Purpose:
# This script:
# 1. Creates a GitHub repository
# 2. Configures it as a remote for your local Git repository
# 3. Pushes your local commits to GitHub
# 4. Sets up branch protection (for public repos)

# Exit immediately if a command fails
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Display banner
echo -e "${BLUE}=================================${NC}"
echo -e "${BLUE}  GitHub Repository Setup  ${NC}"
echo -e "${BLUE}=================================${NC}"

# Check prerequisites
echo -e "\n${BLUE}Checking prerequisites...${NC}"

# Check for git
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed. Please install git and try again.${NC}"
    exit 1
fi

# Check for GitHub CLI
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed. Please install it and try again.${NC}"
    echo -e "${YELLOW}See: https://cli.github.com/manual/installation${NC}"
    exit 1
fi

# Check for jq (needed for GitHub API responses)
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed. Please install jq and try again.${NC}"
    echo -e "${YELLOW}You can install it with: brew install jq (macOS) or apt install jq (Linux)${NC}"
    exit 1
fi

# Check GitHub CLI authentication
if ! gh auth status >/dev/null 2>&1; then
    echo -e "${RED}Error: GitHub CLI is not authenticated. Please run 'gh auth login' and try again.${NC}"
    exit 1
fi

echo -e "${GREEN}All GitHub prerequisites validated successfully.${NC}"

# Function to run GitHub CLI commands with GIT_STATUS_SHOW_UNTRACKED=no
run_github_command() {
    export GIT_STATUS_SHOW_UNTRACKED=no
    "$@"
    local result=$?
    unset GIT_STATUS_SHOW_UNTRACKED
    return $result
}

# Get repository name from command line or use current directory
REPO_NAME=${1:-$(basename "$PWD")}
# Default to public visibility (needed for branch protection)
VISIBILITY=${2:-"public"}

# Check if the visibility parameter is valid
if [[ "$VISIBILITY" != "public" && "$VISIBILITY" != "private" ]]; then
    echo -e "${RED}Error: Visibility must be either 'public' or 'private'.${NC}"
    echo -e "${YELLOW}Usage: $0 <repo-name> [public|private]${NC}"
    exit 1
fi

# Get GitHub username
GITHUB_USERNAME=$(run_github_command gh api user | jq -r '.login')

echo -e "\n${BLUE}Creating GitHub repository: $REPO_NAME...${NC}"

# Check if the repository already exists
echo -e "${BLUE}Checking if repository already exists at github.com/$GITHUB_USERNAME/$REPO_NAME...${NC}"
REPO_EXISTS=false

if run_github_command gh repo view "$GITHUB_USERNAME/$REPO_NAME" &>/dev/null; then
    REPO_EXISTS=true
    echo -e "${YELLOW}Repository already exists at github.com/$GITHUB_USERNAME/$REPO_NAME${NC}"
    
    # Configure the remote if it doesn't exist
    if ! git remote | grep -q "^origin$"; then
        echo -e "${BLUE}Setting up remote for existing repository...${NC}"
        git remote add origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
    else
        echo -e "${BLUE}Remote 'origin' already exists, verifying URL...${NC}"
        CURRENT_URL=$(git remote get-url origin)
        if [[ "$CURRENT_URL" != *"$GITHUB_USERNAME/$REPO_NAME"* ]]; then
            echo -e "${YELLOW}Updating remote URL to match GitHub repository...${NC}"
            git remote set-url origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
        fi
    fi
else
    # Create GitHub repository if it doesn't exist
    echo -e "${BLUE}Creating new GitHub repository: $REPO_NAME...${NC}"
    if ! run_github_command gh repo create "$REPO_NAME" --"$VISIBILITY" --source=. --remote=origin; then
        echo -e "${RED}Error: Failed to create GitHub repository.${NC}"
        exit 1
    fi
fi

# Verify remote configuration
echo -e "${BLUE}Verifying remote configuration...${NC}"
if ! git remote -v | grep -q "^origin"; then
    echo -e "${RED}Error: GitHub remote not configured correctly.${NC}"
    exit 1
fi

# Find and push the inception commit
echo -e "${BLUE}Pushing inception commit to GitHub repository...${NC}"

# Find the inception commit (first commit)
INCEPTION_COMMIT_ID=$(git rev-list --max-parents=0 HEAD)
if [[ -z "$INCEPTION_COMMIT_ID" ]]; then
    echo -e "${RED}Error: Could not find inception commit.${NC}"
    echo -e "${YELLOW}Please make sure the repository has been properly initialized.${NC}"
    exit 1
fi

echo -e "${BLUE}Found inception commit: $INCEPTION_COMMIT_ID${NC}"

# Push only the inception commit to establish root of trust
if [[ "$REPO_EXISTS" == "true" ]] && 
   run_github_command gh api "repos/$GITHUB_USERNAME/$REPO_NAME/commits/$INCEPTION_COMMIT_ID" --silent 2>/dev/null; then
    echo -e "${GREEN}Inception commit already exists on remote. Skipping push.${NC}"
else
    # Repository is empty or new - use the reliable temp branch method
    echo -e "${BLUE}Creating temporary branch at inception commit...${NC}"
    git branch -f _temp_inception "$INCEPTION_COMMIT_ID"
    
    echo -e "${BLUE}Pushing temporary branch to GitHub main branch...${NC}"
    if ! run_github_command git push -u origin _temp_inception:main; then
        echo -e "${RED}Error: Failed to push inception commit to GitHub repository.${NC}"
        git branch -D _temp_inception
        exit 1
    fi
    
    echo -e "${GREEN}Successfully pushed inception commit to GitHub.${NC}"
    git branch -D _temp_inception
fi

# Configure branch protection (public repos only)
if [[ "$VISIBILITY" == "public" ]]; then
    echo -e "\n${BLUE}Configuring branch protection for $GITHUB_USERNAME/$REPO_NAME...${NC}"
    
    # Create a temporary JSON file with protection rules
    TEMP_JSON_FILE=$(mktemp)
    cat > "$TEMP_JSON_FILE" << EOF
{
  "required_status_checks": null,
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1
  },
  "restrictions": null
}
EOF
    
    echo -e "${BLUE}Setting up branch protection rules...${NC}"
    
    if ! run_github_command gh api --method PUT "/repos/$GITHUB_USERNAME/$REPO_NAME/branches/main/protection" \
       -H "Accept: application/vnd.github+json" \
       --input "$TEMP_JSON_FILE"; then
        echo -e "${YELLOW}Warning: Branch protection could not be applied.${NC}"
        echo -e "${YELLOW}Branch protection will need to be configured manually.${NC}"
    else
        echo -e "${GREEN}Branch protection applied successfully.${NC}"
    fi
    
    # Clean up the temporary file
    rm -f "$TEMP_JSON_FILE"
    
    # Enable required signatures
    echo -e "${BLUE}Enabling required commit signatures...${NC}"
    
    if ! run_github_command gh api --method POST "/repos/$GITHUB_USERNAME/$REPO_NAME/branches/main/protection/required_signatures" \
       -H "Accept: application/vnd.github+json"; then
        echo -e "${YELLOW}Warning: Could not enable required signatures.${NC}"
        echo -e "${YELLOW}This may be due to account limitations or API changes.${NC}"
    else
        echo -e "${GREEN}Required signatures enabled successfully.${NC}"
    fi
else
    echo -e "${YELLOW}Note: Branch protection is only available for public repositories.${NC}"
    echo -e "${YELLOW}Since you chose a private repository, branch protection was not configured.${NC}"
fi

# Push all local commits to GitHub
echo -e "\n${BLUE}Pushing all local commits to GitHub...${NC}"
git push -u origin main

# Display success message
echo -e "\n${GREEN}GitHub repository setup complete!${NC}"
echo -e "${BLUE}GitHub Repository URL: https://github.com/$GITHUB_USERNAME/$REPO_NAME${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "${YELLOW}1. Continue project setup with Claude: claude "load CLAUDE.md and help me continue setting up this project"${NC}"
echo -e "${YELLOW}2. After setup is complete, this script can be deleted as it's only needed once${NC}"

echo -e "\n${BLUE}Happy coding!${NC}"