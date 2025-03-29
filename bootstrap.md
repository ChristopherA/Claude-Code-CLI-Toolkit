# ONE-TIME SETUP GUIDE for Claude Code CLI Toolkit

> IMPORTANT: This document is used ONLY DURING INITIAL PROJECT CREATION.
> After setup is complete, this file should be deleted, and you should use PROJECT_GUIDE.md for ongoing reference.
> 
> <!-- Note for Claude: This entire document guides a ONE-TIME setup process. When helping users with this file:
>   1. ALWAYS EXECUTE SETUP SCRIPTS FIRST before any file modifications
>   2. Collect required information only after scripts are executed
>   3. After script execution, check for existing context files and prioritize those workflows
>   4. Guide users through each step sequentially
>   5. After completion, explicitly remind users to delete this file
>   6. Ensure references to this file are removed from CLAUDE.md -->

## Getting Started

The intended workflow for using the Claude Code CLI Toolkit is:

1. Clone the toolkit repository
2. Delete the `.git` folder to start fresh
3. Run Claude to guide you through setup
4. Follow this bootstrap process to set up your own project
5. Delete this bootstrap file when setup is complete

## Project Setup Process

To set up a new project using the Claude Code CLI Toolkit, follow these steps:

1. **FIRST: Initialize Git repository** (required before any other steps)
2. Set up GitHub repository (optional for team collaboration)
3. Check for existing context files and create corresponding branches if needed
4. Configure project settings (customize for specific needs)

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

**Important File Update Rules:**
- **NEVER edit files while on the main branch** - always create a feature branch first
- **Check .gitignore before committing files** - don't commit files that should be excluded
- **Respect the /untracked directory** - files in this directory should never be committed
- **Watch for system files** like .DS_Store - these should never be committed

<!-- Note for Claude: When updating project files:
   1. ALWAYS create a feature branch FIRST before making ANY edits
   2. Look for <!-- START_DATE --> placeholders and replace with current date
   3. Check .gitignore contents before staging any files for commit
   4. NEVER suggest committing files in the /untracked directory or system files like .DS_Store -->

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

## Quick Reference Commands - EXECUTE IN THIS ORDER

```bash
# 1. Initialize Git repository - ALWAYS DO THIS FIRST
./scripts/setup_local_git_inception.sh

# 2. Create GitHub repository (optional)
./scripts/create_github_remote.sh

# 3. Check existing context files and create branches if needed
git branch  # Check if there are already branches
ls -la contexts/  # Look for existing context files that need branches created

# 4. Configure project
# Only after scripts are executed, collect project information and update files
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
   3. Use PROJECT_GUIDE.md for all ongoing project work
   4. REMINDER: If docs-import-materials-context.md exists, prioritize creating that branch and following its workflow before other project customizations -->

The bootstrap.md file is only needed during initial setup and should be deleted after completion to avoid confusion.

## Planning Discipline and Development Phases

This toolkit enforces structured planning discipline for all development work:

1. **Planning Phase Required**:
   - Every feature branch begins with a mandatory Planning phase
   - Planning must be explicitly approved before any implementation begins
   - The planning section defines problem statement, approach, and success criteria

2. **Explicit Approval Mechanism**:
   - After reviewing the planning section, you must provide explicit approval
   - To approve, use the exact phrase: `I APPROVE THE PLANNING PHASE`
   - This unlocks the implementation phase and allows file modifications
   - No other response will enable implementation to begin

3. **Implementation Permission Control**:
   - Until planning is approved, file modifications are blocked by Claude
   - This enforces proper planning before coding
   - Ensures deliberate decision-making and clear requirements

4. **Development Phase Progression**:
   - Planning → Implementation → Completion
   - Each phase has specific requirements and controls
   - Progress is tracked in the context file with explicit phase markers

This approach ensures work is well-defined and approved before implementation begins, reducing rework and improving clarity.

## Important Checklist for Claude

When guiding users through the initial setup:

1. ✅ Run setup scripts FIRST - before any other actions
2. ✅ Check for existing context files after scripts execute
3. ✅ Create branches for existing context files (especially docs/import-materials if it exists)
4. ✅ Never edit files while on the main branch
5. ✅ Check .gitignore before suggesting file commits
6. ✅ When creating docs/import-materials branch:
   - First commit all base files
   - Create untracked/source_materials directory
   - Wait for user to add files before processing