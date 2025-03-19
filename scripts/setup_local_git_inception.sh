#!/usr/bin/env bash
# Script to set up a local Git repository with proper SSH signing and create an inception commit
# This script is part of the Claude Code CLI Toolkit
# Source: https://github.com/ChristopherA/Claude-Code-CLI-Toolkit

# Purpose:
# This script initializes a local Git repository with:
# 1. Proper SSH signing configuration using Ed25519 keys
# 2. A secure empty inception commit that establishes a cryptographic root of trust
# 3. This creates a verifiable provenance for the repository

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
echo -e "${BLUE}  Git Repository Inception Setup  ${NC}"
echo -e "${BLUE}=================================${NC}"

# Check prerequisites
echo -e "\n${BLUE}Checking prerequisites...${NC}"

# Check for git
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed. Please install git and try again.${NC}"
    exit 1
fi

# Check git version (needs 2.34.0+ for SSH signing)
GIT_VERSION=$(git --version | awk '{print $3}')
if ! [[ $(awk -v ver="$GIT_VERSION" -v req="2.34.0" 'BEGIN{print (ver>=req)?1:0}') -eq 1 ]]; then
    echo -e "${RED}Error: git version $GIT_VERSION is too old. Version 2.34.0 or newer is required for SSH signing.${NC}"
    exit 1
fi

# Check git user configuration
if [[ -z "$(git config --get user.name)" ]]; then
    echo -e "${RED}Error: git user.name is not configured.${NC}"
    echo -e "${YELLOW}Please set it with: git config --global user.name \"Your Name\"${NC}"
    exit 1
fi

if [[ -z "$(git config --get user.email)" ]]; then
    echo -e "${RED}Error: git user.email is not configured.${NC}"
    echo -e "${YELLOW}Please set it with: git config --global user.email \"your.email@example.com\"${NC}"
    exit 1
fi

# Check for existing SSH signing key
SIGNING_KEY=$(git config --get user.signingkey)

if [[ -n "$SIGNING_KEY" && -f "$SIGNING_KEY" ]]; then
    echo -e "${GREEN}Found existing SSH signing key: $SIGNING_KEY${NC}"
# Fall back to checking for standard Ed25519 key
elif [[ -f ~/.ssh/id_ed25519 ]]; then
    echo -e "${GREEN}Found standard Ed25519 key at ~/.ssh/id_ed25519${NC}"
    SIGNING_KEY=~/.ssh/id_ed25519
else
    echo -e "${RED}Error: No SSH signing key found${NC}"
    echo -e "${YELLOW}Either:${NC}"
    echo -e "${YELLOW}1. Configure git with an existing SSH key: git config --global user.signingkey /path/to/your/key${NC}"
    echo -e "${YELLOW}2. Generate a new Ed25519 key: ssh-keygen -t ed25519 -C \"your_email@example.com\"${NC}"
    echo -e "${YELLOW}For security best practices, we strongly recommend using Ed25519 keys.${NC}"
    exit 1
fi

# Configure Git for SSH signing
echo -e "\n${BLUE}Configuring git for SSH signing...${NC}"

# Configure git for SSH signing
git config --global gpg.format ssh
git config --global user.signingkey "$SIGNING_KEY"
git config --global commit.gpgsign true

# Create allowed signers file if it doesn't exist
ALLOWED_SIGNERS_DIR=~/.config/git
ALLOWED_SIGNERS_FILE="$ALLOWED_SIGNERS_DIR/allowed_signers"

if [[ ! -d "$ALLOWED_SIGNERS_DIR" ]]; then
    mkdir -p "$ALLOWED_SIGNERS_DIR"
    chmod 700 "$ALLOWED_SIGNERS_DIR"
fi

# Get user email from git config
USER_EMAIL=$(git config --global user.email)
USER_NAME=$(git config --global user.name)

# Create or update allowed signers file
echo -e "${BLUE}Setting up allowed signers file at $ALLOWED_SIGNERS_FILE...${NC}"

# Get the corresponding public key path
if [[ "$SIGNING_KEY" == *".pub" ]]; then
    # If somehow the signing key was set to the public key, use it
    PUB_KEY_PATH="$SIGNING_KEY"
elif [[ -f "${SIGNING_KEY}.pub" ]]; then
    # Standard format: private key + .pub
    PUB_KEY_PATH="${SIGNING_KEY}.pub"
else
    # Try to find the corresponding public key
    PUB_KEY_PATH=$(echo "$SIGNING_KEY" | sed 's/\.[^.]*$/.pub/')
    if [[ ! -f "$PUB_KEY_PATH" ]]; then
        # Last resort: search for public keys matching the pattern
        BASE_NAME=$(basename "$SIGNING_KEY")
        DIR_NAME=$(dirname "$SIGNING_KEY")
        PUB_KEY_PATH=$(find "$DIR_NAME" -type f -name "${BASE_NAME}*.pub" | head -1)
    fi
fi

if [[ -z "$PUB_KEY_PATH" || ! -f "$PUB_KEY_PATH" ]]; then
    echo -e "${YELLOW}Warning: Could not find public key for $SIGNING_KEY${NC}"
    echo -e "${YELLOW}Will try to use existing allowed_signers file if available${NC}"
    
    if [[ -f "$ALLOWED_SIGNERS_FILE" ]]; then
        echo -e "${GREEN}Using existing allowed_signers file: $ALLOWED_SIGNERS_FILE${NC}"
    else
        echo -e "${RED}Error: No allowed_signers file exists and could not create one${NC}"
        echo -e "${YELLOW}Please manually create $ALLOWED_SIGNERS_FILE with format: \"$USER_EMAIL ssh-ed25519 AAAA...\"${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Using public key for allowed signers: $PUB_KEY_PATH${NC}"
    echo -n "$USER_EMAIL " > "$ALLOWED_SIGNERS_FILE"
    cat "$PUB_KEY_PATH" >> "$ALLOWED_SIGNERS_FILE"
    chmod 600 "$ALLOWED_SIGNERS_FILE"
fi

# Configure git to use the allowed signers file
git config --global gpg.ssh.allowedSignersFile "$ALLOWED_SIGNERS_FILE"

# Get repository name/path from command line or use current directory
REPO_NAME=${1:-$(basename "$PWD")}
REPO_DIR=${1:-"$PWD"}

# Make sure repo_dir is an absolute path
if [[ ! "$REPO_DIR" = /* ]]; then
    REPO_DIR="$PWD/$REPO_DIR"
fi

# Initialize repository
echo -e "\n${BLUE}Creating local repository: $REPO_NAME...${NC}"

# Create directory if it doesn't exist
if [[ ! -d "$REPO_DIR" ]]; then
    mkdir -p "$REPO_DIR"
fi

# Initialize git repository
cd "$REPO_DIR"
if [[ ! -d .git ]]; then
    git init --initial-branch=main
else
    echo -e "${YELLOW}Repository already initialized. Continuing with inception commit...${NC}"
fi

# Create EMPTY inception commit with specialized format (no files)
echo -e "${BLUE}Creating empty inception commit with SHA-1 root of trust...${NC}"

# Get signing key and author information
SIGNING_KEY=$(git config --get user.signingkey)
GIT_AUTHOR_NAME=$(git config --get user.name)
GIT_AUTHOR_EMAIL=$(git config --get user.email)
GIT_AUTHOR_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Get key fingerprint for committer name (simplified compared to original script)
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
GIT_COMMITTER_DATE="$GIT_AUTHOR_DATE"

# Create empty inception commit
GIT_AUTHOR_NAME="$GIT_AUTHOR_NAME" GIT_AUTHOR_EMAIL="$GIT_AUTHOR_EMAIL" \
GIT_COMMITTER_NAME="$GIT_COMMITTER_NAME" GIT_COMMITTER_EMAIL="$GIT_COMMITTER_EMAIL" \
GIT_AUTHOR_DATE="$GIT_AUTHOR_DATE" GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE" \
git -c gpg.format=ssh -c user.signingkey="$SIGNING_KEY" \
    commit --allow-empty --no-edit --gpg-sign \
    -m "Initialize repository and establish a SHA-1 root of trust" \
    -m "This commit serves as the cryptographic inception point for this repository." --signoff

# Verify the inception commit succeeded
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}Empty inception commit created successfully.${NC}"
else
    echo -e "${RED}Error: Failed to create empty inception commit. Check Git configuration.${NC}"
    exit 1
fi

# Display the commit hash
INCEPTION_COMMIT_ID=$(git rev-list --max-parents=0 HEAD)
echo -e "${GREEN}Repository initialized with inception commit: $INCEPTION_COMMIT_ID${NC}"

# Display success message
echo -e "\n${GREEN}Local repository setup complete!${NC}"
echo -e "${BLUE}Repository Directory: $REPO_DIR${NC}"
echo -e "${YELLOW}Next steps:${NC}"

# Check directory structure to give appropriate next step instructions
if [[ -f "$(dirname "$0")/create_github_remote.sh" ]]; then
    echo -e "${YELLOW}1. Create GitHub repository with: $(dirname "$0")/create_github_remote.sh${NC}"
else
    echo -e "${YELLOW}1. Create your GitHub repository if needed${NC}"
fi
echo -e "${YELLOW}2. Continue project setup with Claude: claude "load CLAUDE.md and help me continue setting up this project"${NC}"
echo -e "${YELLOW}3. After setup is complete, this script can be deleted as it's only needed once${NC}"

echo -e "\n${BLUE}Happy coding!${NC}"