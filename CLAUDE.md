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
- After bootstrap completion, remind the user to delete bootstrap.md
- Remove bootstrap.md references from CLAUDE.md after setup is complete

<!-- Note for Claude: Always check if the repository is in starting state (no .git folder) or running state. The bootstrap process is a ONE-TIME process that should only be performed in starting state. -->

### New Project Setup

If bootstrap.md is present, and no .git folder exists, help the user through these steps:

1. Gather project information:
   - Project name
   - Primary programming language
   - Preferred development model (Solo/Team)

2. Update all files with project information:
   - Update file headers with project name
   - Set language in appropriate files
   - Configure development model
   - Update creation date (replace all <!-- START_DATE --> placeholders with today's date in YYYY-MM-DD format)

3. Help initialize Git repository:
   - Guide user to run setup_local_git_inception.sh
   - After execution, remind them this script can be deleted

4. Help set up GitHub (if requested):
   - Guide user to run create_github_remote.sh
   - After execution, remind them this script can be deleted

5. Complete setup:
   - Remind user to delete bootstrap.md
   - Remove references to bootstrap.md from this file
   - Transition to PROJECT_GUIDE.md for ongoing work

<!-- Note for Claude: The bootstrap process should be completed in a single session if possible. Always replace <!-- START_DATE --> placeholders with the actual project creation date in YYYY-MM-DD format during setup. After setup, NEVER refer to bootstrap.md again. -->

## Toolkit Usage

There are two main ways to use this repository:

1. **As a Reference**: Help users understand Claude-assisted development practices
2. **As a Starting Point**: Help users set up new projects based on these files

## Development Model

The current development model for this project is: **_development-model: Team_** (see header metadata)

See PROJECT_GUIDE.md for the full description of development models and detailed workflows.

## Quick Reference Commands

Run these commands to check the project status:

```bash
git status                 # Check branch and file status
git branch --show-current  # Show current branch
git log --oneline -n 10    # View recent commit history
```

## Claude Session Management

When working with Claude:
1. Start sessions with context: `claude "load CLAUDE.md, identify branch as [branch-name], and continue project work"`
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