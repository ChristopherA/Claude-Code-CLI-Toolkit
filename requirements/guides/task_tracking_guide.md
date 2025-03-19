# Task Tracking Quick Reference

> - _did-original-source_: `did:repo:ca85b5ea9bc63cc8229c073d8f6a3faae8062a77/blob/main/requirements/guides/task_tracking_guide.md`
> - _github-original-source_: `https://github.com/ChristopherA/Claude-Code-CLI-Toolkit/blob/main/requirements/guides/task_tracking_guide.md`
> - _purpose_: Define task tracking system for project management
> - _copyright_: ©2025 by @ChristopherA, licensed under the [BSD 2-Clause Plus Patent License](https://spdx.org/licenses/BSD-2-Clause-Patent.html)
> - _created_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>
> - _last-updated_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>

## Core Task File

All tasks are tracked in a single file: `WORK_STREAM_TASKS.md`

This file is organized by:
1. Active tasks by category
2. Branch-specific task sections
3. Completed tasks

## Task States

Tasks have three possible states:
- `[ ]` - Not started
- `[~]` - In progress (with start date in YYYY-MM-DD format)
- `[x]` - Completed (with completion date in YYYY-MM-DD format)

Example:
```markdown
- [ ] Create user authentication system
- [~] Implement password reset (started 2025-03-19)
- [x] Add login form (completed 2025-03-19)
```

## Task Organization

Tasks should be organized in this structure:

```markdown
# Project Name - Work Stream Tasks

> - _created: <!-- START_DATE -->_
> - _last-updated: <!-- START_DATE -->_

## Active Tasks

### Project Setup
- [ ] Task 1
- [ ] Task 2

### Feature Development
- [ ] Task 3
- [ ] Task 4

## Branch: feature/name
- [~] Current branch task 1
- [ ] Current branch task 2

## Branch: fix/issue
- [~] Bug fix task

## Completed Tasks
<!-- No entries yet -->
```

<!-- Note for Claude: When helping users set up their project, replace the START_DATE placeholders with the actual project creation date in YYYY-MM-DD format -->

## Task Management Workflow

### Starting a Task

1. Find the task in WORK_STREAM_TASKS.md
2. Move it to the appropriate branch section
3. Change its state to in-progress `[~]`
4. Add a "started" date (YYYY-MM-DD format)

### Working on a Task

1. Keep the task state as `[~]`
2. Update the task with progress notes as needed
3. Break down large tasks into subtasks if necessary

### Completing a Task

1. Change the task state to completed `[x]`
2. Add the completion date in parentheses (YYYY-MM-DD format)
3. Add a brief implementation summary
4. Move the task to the "Completed Tasks" section

## Task Creation Guidelines

### Good Task Descriptions

Tasks should be:
- **Specific**: Clearly defined scope
- **Measurable**: Clear completion criteria
- **Achievable**: Can be completed in a reasonable time
- **Relevant**: Directly related to project goals

### Task Format

```
- [ ] [Action verb] [specific deliverable] - [optional context]
```

Examples:
```
- [ ] Create user login component with form validation
- [ ] Fix navigation bar display on mobile devices
- [ ] Document API endpoints for user management
```

## Claude's Role in Task Tracking

Claude will help with task management by:

1. Identifying current tasks when starting a session
2. Updating task status during work
3. Moving completed tasks to the completed section
4. Adding implementation details to completed tasks
5. Suggesting next tasks based on dependencies

<!-- Note for Claude: When updating the WORK_STREAM_TASKS.md file, ensure you update the last-updated date and maintain consistent formatting. Always use YYYY-MM-DD format for all dates. -->