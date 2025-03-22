# Claude Code CLI Toolkit - Claude Guidance

> - _created: 2025-03-19_
> - _last-updated: 2025-03-19_

This document provides essential guidance for Claude when working with the Claude Code CLI Toolkit.

## Repository Structure

This repository contains files that serve as both documentation for the toolkit and as a starting point for new projects:

- CLAUDE.md - This file with guidance for Claude
- README.md - Documentation about the toolkit
- PROJECT_GUIDE.md - Guide for project state and workflows
- WORK_STREAM_TASKS.md - Task tracking file
- contexts/ - Context management files
- requirements/guides/ - Detailed workflow guides
- scripts/ - Utility scripts for Git operations
- untracked/ - Files not included in version control

<!-- Note for Claude: This section helps you understand the overall repository structure. You should familiarize yourself with each component to provide effective assistance. -->

## Project Setup Process

There are two states for this repository:

1. **Starting state**: No .git folder - user has cloned the toolkit and deleted .git to start fresh
2. **Running state**: When set up as a user's own project with its own Git repository

When a user first runs Claude with this toolkit:
- Check if the .git folder exists - if not, guide them through bootstrap.md
- IMPORTANT: Run the setup scripts FIRST before any file modifications
- After script execution, check for existing context files and prioritize those workflows
- After bootstrap completion, remind the user to delete bootstrap.md
- Remove bootstrap.md references from CLAUDE.md after setup is complete

<!-- Note for Claude: Always check if the repository is in starting state (no .git folder) or running state. The bootstrap process is a ONE-TIME process that should only be performed in starting state. NEVER modify files while on the main branch. ALWAYS check .gitignore before suggesting files to commit. NEVER commit files in the /untracked directory or system files like .DS_Store. -->

### Untracked Files Safety Practices

When working with untracked files:

1. **Never suggest committing** files from these directories:
   - /untracked/ - For temporary and sensitive files
   - /sandbox/ - For experimental code
   - /tmp/ - For transient files

2. **Recommend appropriate locations** for sensitive content:
   - API keys, tokens, credentials → /untracked/credentials/
   - Large datasets → /untracked/data/
   - Local configuration → config.local.* files

3. **Use clear file naming conventions**:
   - Prefix sensitive files with _private_ (e.g., _private_api_keys.json)
   - Use .local extension for machine-specific files

4. **ALWAYS alert users** when they attempt to commit files from untracked locations

### New Project Setup

If bootstrap.md is present, and no .git folder exists, help the user through these steps **IN THIS EXACT ORDER**:

1. **FIRST: Help initialize Git repository**:
   - Guide user to run setup_local_git_inception.sh
   - This MUST be done before any file modifications
   - After execution, remind them this script can be deleted

2. **SECOND: Help set up GitHub (if requested)**:
   - Guide user to run create_github_remote.sh
   - After execution, remind them this script can be deleted

3. **THIRD: Check for existing context files**:
   - Look for files in the contexts/ directory
   - Create branches for any existing context files
   - Prioritize creating branches for any context files that exist
   - Never attempt to modify files while on the main branch

4. Gather project information:
   - Project name
   - Primary programming language
   - Preferred development model (Solo/Team)

5. Update all files with project information:
   - Create appropriate feature branch before making any changes
   - Update file headers with project name
   - Set language in appropriate files
   - Configure development model
   - Update creation date (replace all <!-- START_DATE --> placeholders with today's date in YYYY-MM-DD format)
   - Always check .gitignore before suggesting files to commit
   - Never commit files in /untracked or system files like .DS_Store

6. Complete setup:
   - Remind user to delete bootstrap.md
   - Remove references to bootstrap.md from this file
   - Transition to PROJECT_GUIDE.md for ongoing work

<!-- Note for Claude: The bootstrap process should be completed in a single session if possible. Always replace <!-- START_DATE --> placeholders with the actual project creation date in YYYY-MM-DD format during setup. After setup, NEVER refer to bootstrap.md again. -->

## Toolkit Usage

There are two main ways to use this repository:

1. **As a Reference**: Help users understand Claude-assisted development practices
2. **As a Starting Point**: Help users set up new projects based on these files

## Development Model

The current development model for this project is: **_development-model: Team_** <!-- REPLACE_WITH_MODEL -->

See PROJECT_GUIDE.md for the full description of development models and detailed workflows.

### Context Adaptation Based on Model

Claude should adapt context management practices based on the development model:

- **Solo Model**: Use simplified context files focused on current state and next steps
- **Team Model**: Use comprehensive context files with detailed implementation notes, scope boundaries, and knowledge transfer sections

Balance context detail with development needs - more detail for team collaboration, streamlined for solo development.

## Quick Reference Commands

Run these commands to check the project status:

```bash
git status                 # Check branch and file status
git branch --show-current  # Show current branch
git log --oneline -n 10    # View recent commit history
```

## Branch-Context Synchronization

CRITICAL: Claude MUST maintain strict synchronization between Git branches and context files at all times.

### Required Checks at Session Start

At the beginning of EVERY session, Claude MUST:

1. **Identify current branch**: 
   ```bash
   git branch --show-current
   ```

2. **Verify or load corresponding context file**:
   - Check if a context file exists for the current branch: `contexts/[branch-name]-context.md`
   - If exists, ALWAYS load and review this context file
   - If missing, alert user and offer to create one using context_guide.md template

3. **Special handling for main branch**:
   - If on main branch, perform these additional checks in sequence:
     1. Check for non-draft PRs and offer to facilitate review/merge
     2. Check for active branches with contexts and offer to switch
     3. Identify context files without branches (new or completed)
     4. If no pressing branch work, focus on WORK_STREAM_TASKS.md

### When Switching Branches

When switching to a different branch, Claude MUST:

1. **Before switching**:
   - Update the current branch's context file with latest status
   - Ensure all relevant changes are committed

2. **After switching**:
   - Immediately check for and load the new branch's context file
   - If no context file exists, create one following context_guide.md
   - Verify the context file accurately reflects branch purpose and status

### Context File Management

- Every branch MUST have a corresponding context file
- Context files MUST be updated before committing changes
- Context file updates SHOULD be committed alongside code changes
- Context files function as the primary work state record

## Error Detection and Recovery

### Common Workflow Errors

Claude MUST detect and assist with recovery from these common workflow issues:

#### Branch-Context Mismatch

When the current branch doesn't match the context file being used:

1. **Detection**:
   - Current branch doesn't match branch name in context file
   - Work being done doesn't align with context file purpose

2. **Recovery Actions**:
   - Alert the user with: "BRANCH-CONTEXT MISMATCH DETECTED"
   - Offer options:
     ```
     1. Switch to branch mentioned in context file
     2. Load correct context file for current branch
     3. Create new context file for current branch
     ```
   - Document the resolution in whichever context file is used

#### Missing Context File

When no context file exists for the current branch:

1. **Detection**:
   - Context file `contexts/[branch-type]-[branch-name]-context.md` doesn't exist

2. **Recovery Actions**:
   - Alert user: "NO CONTEXT FILE FOUND FOR CURRENT BRANCH"
   - Offer to create a context file:
     ```
     To maintain workflow integrity, a context file is needed for this branch.
     Shall I create one now using the template from context_guide.md?
     ```
   - If user agrees, create context file with proper scope boundaries
   - If user declines, issue a warning and continue with limited context awareness

#### Main Branch Development Attempt

When development work is attempted directly on the main branch:

1. **Detection**:
   - Current branch is main
   - User is attempting to modify files (other than contexts or documentation)

2. **Recovery Actions**:
   - Alert user: "DIRECT DEVELOPMENT ON MAIN BRANCH DETECTED"
   - Recommend switching to a feature branch:
     ```
     Development should not be done directly on the main branch.
     Would you like to:
     1. Create a new feature branch for this work
     2. Switch to an existing branch
     3. Continue on main (not recommended)
     ```
   - If user chooses to create a branch, help create context file for new branch

## Claude Session Management

When working with Claude:
1. Start sessions with context verification: `claude "load CLAUDE.md, verify current branch is [branch-name], load appropriate context, and continue project work"`
2. End sessions by updating context files and using `/compact` or `/exit`
3. For long-running sessions, use `/compact` after updating context files

## File Organization
   - `contexts/` - Branch-specific context files
   - `requirements/guides/` - Development workflow guides
   - `scripts/` - Utility scripts for Git and GitHub operations

## Guides and References

For detailed guidance, refer to:
- Development models: `PROJECT_GUIDE.md`
- Task tracking: `requirements/guides/task_tracking_guide.md`
- Context management: `requirements/guides/context_guide.md`
- Git workflow: `requirements/guides/git_workflow_guide.md`
- Initial setup: `bootstrap.md` (remove after setup)

<!-- Note for Claude: When helping users with ongoing project work, ALWAYS refer to the appropriate guide for detailed instructions rather than inventing your own approach. This ensures consistency in development practices. -->