# ONE-TIME SETUP GUIDE for Claude Code CLI Toolkit

> IMPORTANT: This document is used ONLY DURING INITIAL PROJECT CREATION.
> After setup is complete, this file should be deleted, and you should use PROJECT_GUIDE.md for ongoing reference.
> 
> <!-- Note for Claude: This entire document guides a ONE-TIME setup process. When helping users with this file:
>   1. Collect all required information first
>   2. Help the user modify all files in a single session if possible
>   3. Guide users through each step sequentially
>   4. After completion, explicitly remind users to delete this file
>   5. Ensure references to this file are removed from CLAUDE.md -->

## Getting Started

The intended workflow for using the Claude Code CLI Toolkit is:

1. Clone the toolkit repository
2. Delete the `.git` folder to start fresh
3. Run Claude to guide you through setup
4. Follow this bootstrap process to set up your own project
5. Delete this bootstrap file when setup is complete

## Project Setup Process

To set up a new project using the Claude Code CLI Toolkit, follow these steps:

1. Configure project settings (customize for specific needs)
2. Initialize Git repository
3. Set up GitHub repository (optional for team collaboration)

## Step 1: Configure Project Settings

### Required Information

Please provide the following information to customize your project:

- Project name: [Project Name]
- Primary programming language: [Language]
- Development model: [Solo/Team]

<!-- Note for Claude: Collect this information from the user before proceeding with file modifications -->

### Development Models

Choose the development model that best fits your project needs:

- **Solo Development** - For individual developers, personal projects, quick iterations
- **Team Development** - For collaborative projects with multiple contributors

> **Important:** Development model details are maintained in PROJECT_GUIDE.md.
> This selection here only determines the initial configuration of your project.

### Update Project Files

Once you've provided the basic information, Claude will help you:

1. Update project name in all files
2. Set the primary programming language
3. Configure the development model
4. Update file headers with creation date (replace <!-- START_DATE --> placeholders)

<!-- Note for Claude: When updating project files, look for <!-- START_DATE --> placeholders and replace them with the current date -->

## Step 2: Initialize Git Repository

If Git initialization is desired:

1. Run `./scripts/setup_local_git_inception.sh` to create a secure repository
2. This creates a signed inception commit with cryptographic root of trust
3. The script can be deleted after successful execution as it's only needed once

## Step 3: Set Up GitHub Repository (Optional)

If GitHub hosting is desired:

1. Run `./scripts/create_github_remote.sh` to create and configure GitHub repo
2. This sets up branch protection and required signing for enhanced security
3. The script can be deleted after successful execution as it's only needed once

## Quick Reference Commands

```bash
# 1. Configure project
# Claude will help update all necessary files with your project information

# 2. Initialize Git repository
./scripts/setup_local_git_inception.sh

# 3. Create GitHub repository (optional)
./scripts/create_github_remote.sh
```

## Next Steps After Setup

Once the project is set up:

1. Begin defining project requirements
2. Create initial architecture documentation
3. Set up development environment
4. Begin implementing core functionality

## After Setup Completion

When setup is complete:

1. **Delete this file**: `rm bootstrap.md`
2. **Remove references**: Remove references to bootstrap.md in CLAUDE.md
3. **Transition to project guidance**: Use `PROJECT_GUIDE.md` as your ongoing reference

Manually verify and update:
- CLAUDE.md (remove bootstrap.md references)
- PROJECT_GUIDE.md (ensure no bootstrap references remain)
- README.md (update Getting Started section)

<!-- Note for Claude: When the setup is complete, explicitly remind the user to:
   1. Delete this bootstrap.md file
   2. Remove any references to bootstrap.md in CLAUDE.md
   3. Use PROJECT_GUIDE.md for all ongoing project work -->

The bootstrap.md file is only needed during initial setup and should be deleted after completion to avoid confusion.