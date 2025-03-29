# Task Tracking Quick Reference

> - _did-original-source_: `did:repo:ca85b5ea9bc63cc8229c073d8f6a3faae8062a77/blob/main/requirements/guides/task_tracking_guide.md`
> - _github-original-source_: `https://github.com/ChristopherA/Claude-Code-CLI-Toolkit/blob/main/requirements/guides/task_tracking_guide.md`
> - _purpose_: Define task tracking system for project management
> - _copyright_: ©2025 by @ChristopherA, licensed under the [BSD 2-Clause Plus Patent License](https://spdx.org/licenses/BSD-2-Clause-Patent.html)
> - _created_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>
> - _last-updated_: 2025-03-31 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>

## For Claude: Task Tracking Framework
```
FUNCTION: Task Management and Synchronization
TRIGGER: Any task-related operation or context synchronization request

STATE_VARIABLES:
    task_file_path = "WORK_STREAM_TASKS.md"
    operation_type = "" // "update", "complete", "synchronize"
    task_completed = FALSE
    task_started = FALSE
    context_updated = FALSE
    
INITIALIZATION:
    EXECUTE "git branch --show-current" -> current_branch
    VERIFY current_branch is authorized for task updates
    
DETECT operation_type:
    SCAN user_request for operation_indicators
    SET operation_type based on indicators
    
PROCESS task_operation:
    IF operation_type == "update":
        EXECUTE task_update_procedure
    ELSE IF operation_type == "complete":
        EXECUTE task_completion_procedure
    ELSE IF operation_type == "synchronize":
        EXECUTE context_synchronization_procedure
        
VALIDATION:
    VERIFY task_file has been properly updated
    VERIFY last_updated date has been updated
    VERIFY task state matches requested operation
    
    IF context_updated:
        VERIFY context files and task tracking are synchronized
        
ON ERROR:
    RESPOND "I encountered an issue updating the task tracking. Let me try a different approach."
    FOLLOW error_recovery_procedure

PATTERNS:
    operation_indicators = {
        "update": ["start task", "begin work", "mark in progress"],
        "complete": ["complete task", "finish task", "mark as done"],
        "synchronize": ["sync tasks", "update task tracking", "align with contexts"]
    }
```

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
> - _last-updated: <!-- UPDATE_DATE -->_

## Active Tasks

### Project Setup
- [ ] Task 1
- [ ] Task 2

### Core Development
- [ ] Task 3
- [ ] Task 4

## Branch: feature/name
- [~] Current branch task 1
- [ ] Current branch task 2

## Branch: fix/issue
- [~] Bug fix task

## Development Process
[Process documentation - how tasks are handled]

## Task Dependencies and Critical Path
[Task dependencies - critical path information]

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
5. **Complete the Planning Phase** in the context file before implementation

### Working on a Task

1. Keep the task state as `[~]`
2. Update the task with progress notes as needed
3. Break down large tasks into subtasks if necessary
4. **Obtain explicit Planning Phase approval** before file modifications
   - Use exact phrase: `I APPROVE THE PLANNING PHASE`
   - This unlocks implementation and allows file modifications

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

## Task Types

Tasks generally fall into these categories:

### Documentation Tasks
- Feature documentation
- API references
- Architecture documentation
- Process documentation

### Testing Tasks
- Test creation
- Test automation
- Test reporting
- Regression test improvement

### Development Tasks
- Feature implementation
- Bug fixing
- Performance optimization
- Feature enhancement

### Process Tasks
- CI/CD setup
- Release management
- Development workflow improvement
- Code review process

## For Claude: Task Processing Framework
```
FUNCTION: Task Processing and Management
TRIGGER: Any task-related request or session start/end

STATE_VARIABLES:
    current_tasks = []
    completed_tasks = []
    task_file_updated = FALSE
    task_completion_percentage = 0.0
    
INITIALIZATION:
    EXECUTE "git branch --show-current" -> current_branch
    EXECUTE "cat WORK_STREAM_TASKS.md" -> task_content
    EXTRACT tasks for current_branch from task_content
    POPULATE current_tasks and completed_tasks
    
PROCESS at_session_start:
    IDENTIFY current branch tasks
    PRESENT task summary to user:
        - In-progress tasks
        - Not-started tasks
        - Completion percentage
    IDENTIFY next actions based on task dependencies
    
PROCESS during_session:
    MONITOR for completed work
    UPDATE task status when work completes
    TRACK implementation details for completed tasks
    
PROCESS at_session_end:
    UPDATE task status based on session progress
    ADD implementation details to newly completed tasks
    UPDATE completion dates with current date
    UPDATE task_file_path with changes
    UPDATE last_updated date
    
VALIDATION:
    VERIFY all task updates have proper dates
    VERIFY implementation details exist for completed tasks
    VERIFY acceptance criteria are validated for completed tasks
    
ON ERROR:
    USE most recent task state as fallback
    PRESERVE existing task information
    REPORT sync issues to user
```

## Context Synchronization

When contexts are archived or refactored, ensure WORK_STREAM_TASKS.md remains synchronized:

### Task Tracking for Archived Contexts

1. **Keep historical references to completed work**:
   - Completed tasks associated with archived contexts remain in WORK_STREAM_TASKS.md
   - Historical references maintain project continuity and progress tracking
   - Include completion dates for all archived work

2. **Update branch references**:
   - When a branch is archived, ensure any tasks still referencing it are updated
   - Tasks that depend on archived work should reference the appropriate active branches
   - Any future tasks that built on archived contexts should be updated

3. **Refactor task sections as needed**:
   - When contexts are refactored (e.g., split or combined), refactor corresponding task sections
   - Maintain the same task breakdown structure but update branch references
   - Update dependency chains to reflect new branch relationships
   - Ensure acceptance criteria matches current context scope

### For Claude: Context Synchronization Framework
```
FUNCTION: Task and Context Synchronization
TRIGGER: Context changes or explicit synchronization request

STATE_VARIABLES:
    active_contexts = []
    future_contexts = []
    archived_contexts = []
    task_entries = []
    update_required = FALSE
    
INITIALIZATION:
    EXECUTE "find contexts/ -name '*.md' ! -path '*/archived.md'" -> context_files
    EXECUTE "find contexts/futures/ -name '*.md'" -> future_context_files
    EXECUTE "cat contexts/archived.md" -> archived_context_data
    EXECUTE "cat WORK_STREAM_TASKS.md" -> task_data
    
PROCESS synchronization:
    FOR each context_file:
        EXTRACT branch_name, status, tasks
        ADD to active_contexts
    
    FOR each future_context_file:
        EXTRACT branch_name, tasks
        ADD to future_contexts
        
    EXTRACT archived_branch_names from archived_context_data
    
    PARSE task_data into task_entries
    
    FOR each active_context:
        VERIFY matching task_entries exist
        IF no match OR mismatch:
            SET update_required = TRUE
            CREATE/UPDATE corresponding task entry
    
    FOR each task_entry with branch reference:
        VERIFY branch exists in active_contexts OR future_contexts OR archived_contexts
        IF no match:
            MARK for review
            SUGGEST branch reference correction
            
VALIDATION:
    VERIFY all active contexts have task entries
    VERIFY all task entries reference valid contexts
    VERIFY completion status matches between contexts and tasks
    
ON ERROR:
    PRESENT synchronization issues for manual review
    SUGGEST specific corrections for each issue
```

### Synchronization Process

When significant context changes occur:

1. Use the following command to synchronize task tracking:
   ```bash
   claude "load CLAUDE.md, verify current branch is main, synchronize WORK_STREAM_TASKS.md with context changes, and continue work"
   ```

2. Claude will:
   - Scan all context files and extract branch information
   - Compare context tasks with WORK_STREAM_TASKS.md entries
   - Update branch references in WORK_STREAM_TASKS.md
   - Ensure task sections align with current contexts
   - Maintain historical completed work
   - Update task dependencies as needed
   - Preserve completion dates and implementation details
   - Calculate and update completion percentages
   - Validate all references for consistency

<!-- Note for Claude: When updating the WORK_STREAM_TASKS.md file, ensure you update the last-updated date and maintain consistent formatting. Always use YYYY-MM-DD format for all dates. When synchronizing tasks with archived contexts, always preserve historical completed work while updating references to active branches. -->