# Main Branch Context

## Current Status
- Current branch: main
- Started: <!-- START_DATE -->
- Progress: Ready for workflow management and branch orchestration

## Branch Protection Notice
**IMPORTANT**: The main branch has protection rules that prevent direct commits. All changes must be made via feature branches and pull requests.

## Main Branch Purpose
The main branch serves as the coordination point for project management and should NOT contain direct development work. Its primary functions are:

1. PR review and merge management
2. Branch orchestration and context switching
3. Work stream task organization and planning

## Active Pull Requests
<!-- List active PRs that need review/merge attention -->
<!-- Example:
- [ ] PR #12: "Add user authentication" - Ready for review
- [~] PR #15: "Fix header styling" - In review (2025-03-15)
-->
<!-- No active PRs at this time -->

## Active Branches
<!-- List active branches with their status -->
<!-- Example:
- [~] feature/user-auth - Implementation in progress (2025-03-15)
- [~] fix/header-style - Testing fixes (2025-03-18)
-->
<!-- No active branches at this time -->

## Available Context Files
<!-- List context files without branches that can be started -->
<!-- Example:
- [ ] feature-payment-processing - Ready to start
-->
<!-- No available context files at this time -->

## Completed Contexts
<!-- List context files for completed work that can be archived -->
<!-- Example:
- [x] docs-initial-setup - Completed (2025-03-10)
-->
<!-- No completed contexts at this time -->

## Work Stream Management
- [ ] Review and prioritize items in WORK_STREAM_TASKS.md
- [ ] Create new context files for upcoming work
- [ ] Archive completed context files
- [ ] Update project documentation

<!-- Task format: 
- [ ] Not started
- [~] In progress (with start date in YYYY-MM-DD format)
- [x] Completed (with completion date in YYYY-MM-DD format)
-->

## Key Decisions
<!-- No entries yet -->

## Notes
<!-- Optional section for reference information, diagrams, etc. -->

## Special Workflows

### PR Review and Merge Process
```bash
claude "load CLAUDE.md, verify current branch is main, review PR #[number], and merge if approved"
```

### Branch Switching
```bash
claude "load CLAUDE.md, verify current branch is main, switch to branch [branch-name], and continue work"
```

### Work Stream Management
```bash
claude "load CLAUDE.md, verify current branch is main, and organize WORK_STREAM_TASKS.md"
```

### Context Archiving
```bash
claude "load CLAUDE.md, verify current branch is main, archive completed context [context-name], and update documentation"
```