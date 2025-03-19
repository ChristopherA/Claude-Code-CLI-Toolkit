# Claude Code CLI Toolkit - Project Guide

> - _did-original-source_: `did:repo:ca85b5ea9bc63cc8229c073d8f6a3faae8062a77/blob/main/PROJECT_GUIDE.md`
> - _github-original-source_: `https://github.com/ChristopherA/Claude-Code-CLI-Toolkit/blob/main/PROJECT_GUIDE.md`
> - _purpose_: Define development models and provide project state overview
> - _copyright_: ©2025 by @ChristopherA, licensed under the [BSD 2-Clause Plus Patent License](https://spdx.org/licenses/BSD-2-Clause-Patent.html)
> - _created_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>
> - _last-updated_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>

This guide serves as the central reference for development processes AFTER initial project setup as described in bootstrap.md.

> **Purpose**: This document outlines development models and provides an overview of project state and workflows.
> For detailed Git operations, context management, and task tracking, follow links to specialized guides.

## Development Models

The toolkit supports two development models:

### Solo Development Model
- **Intended for**: Individual developers, personal projects, prototypes
- **Features**: 
  - Simplified workflows with less ceremony
  - Direct commits to main allowed
  - Reduced PR requirements 
  - Streamlined context management
  - Focus on rapid iteration

### Team Development Model
- **Intended for**: Multi-developer teams, collaborative projects
- **Features**:
  - Structured branch protection
  - Required code reviews and PRs
  - Detailed context sharing between team members
  - Formal task assignment and tracking
  - Enhanced security practices

## Initial Setup

```bash
# Initialize Git repository with Open Integrity Project commit signing
./scripts/setup_local_git_inception.sh

# Create GitHub repository with branch protections (optional, but useful in Team Development Model)
./scripts/create_github_remote.sh
```

## Working with Claude

### Starting Work

```bash
# Start Claude with project context
claude "load CLAUDE.md and help me continue project setup"
```

### During Development

Common Claude commands:

```bash
# For continuing work on a branch
claude "load CLAUDE.md, identify branch as feature/name, and continue working on task X"

# For switching to a new task
claude "load CLAUDE.md, check out branch feature/name, and help me implement feature X"

# For troubleshooting issues
claude "load CLAUDE.md and help me debug the error in component X"
```

## Core Process Reference

### Git Workflow

1. Create a branch for your work
   ```bash
   git checkout -b feature/name
   ```

2. Make changes and commit regularly
   ```bash
   git commit -S -s -m "Clear message"
   ```

3. Create a PR when ready
   ```bash
   git push -u origin feature/name
   gh pr create
   ```

### Context Management

1. Create a context file for each branch
   ```
   contexts/[branch-name]-context.md
   ```

2. Update the context file:
   - At the start of each session
   - Before using /compact
   - Before ending a session with /exit

3. Use standard format for context files:
   - Current Status
   - Completed Work
   - Current Tasks
   - Key Decisions
   - Restart Instructions

### Task Tracking

1. Track all tasks in WORK_STREAM_TASKS.md

2. Organize tasks by:
   - Active Tasks (by category)
   - Branch-specific sections
   - Completed Tasks

3. Update task status with:
   - [ ] Not started
   - [~] In progress (with start date in YYYY-MM-DD format)
   - [x] Completed (with completion date in YYYY-MM-DD format)

## Specialized Process Guides

This document provides an overview of workflows. For detailed technical procedures, refer to these specialized guides:

- [Git Workflow Guide](./requirements/guides/git_workflow_guide.md) - Complete Git operations reference
- [Context Management Guide](./requirements/guides/context_guide.md) - Detailed context management procedures
- [Task Tracking Guide](./requirements/guides/task_tracking_guide.md) - Comprehensive task organization

> **Note**: Each specialized guide contains technical details and commands that are not duplicated here. 
> This structure keeps the main workflow reference concise while providing detailed technical procedures when needed.