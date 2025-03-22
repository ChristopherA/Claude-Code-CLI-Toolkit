# Context Management Quick Reference

> - _did-original-source_: `did:repo:ca85b5ea9bc63cc8229c073d8f6a3faae8062a77/blob/main/requirements/guides/context_guide.md`
> - _github-original-source_: `https://github.com/ChristopherA/Claude-Code-CLI-Toolkit/blob/main/requirements/guides/context_guide.md`
> - _purpose_: Guide context management across Claude sessions
> - _copyright_: ©2025 by @ChristopherA, licensed under the [BSD 2-Clause Plus Patent License](https://spdx.org/licenses/BSD-2-Clause-Patent.html)
> - _created_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>
> - _last-updated_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>

## Branch-Context Synchronization

The most critical aspect of this workflow is maintaining perfect synchronization between Git branches and their corresponding context files.

### Creating a Branch with Context

When creating a new branch, ALWAYS create its context file at the same time:

1. Create the branch:
   ```bash
   git checkout -b [branch-type]/[branch-name]
   ```

2. Immediately create the context file:
   ```bash
   # Claude will help create this file
   claude "load CLAUDE.md, create context file for branch $(git branch --show-current), and begin work"
   ```

3. Claude MUST:
   - Create `contexts/[branch-type]-[branch-name]-context.md`
   - Use the context file template (see below)
   - Add proper scope boundaries for the branch's purpose
   - Indicate any dependencies on other branches/contexts

### Starting a Session

When starting work with Claude:

```bash
# Load project guidance and verify branch-context synchronization
claude "load CLAUDE.md, verify current branch is correct, load appropriate context, and continue project work"
```

Claude will:
1. Check current branch: `git branch --show-current`
2. Verify existence of corresponding context file: `contexts/[branch-name]-context.md`
3. Load the context file if it exists
4. If no context file exists, offer to create one
5. Verify context file accurately reflects branch purpose
6. Review current progress and tasks

### Verification Steps

Claude MUST perform these verification steps at the start of EVERY session:

1. **Branch-Context Verification**:
   - Confirm context file branch name matches actual branch
   - Verify context file exists and is up-to-date
   - Alert if discrepancies found

2. **State Consistency Check**:
   - Check for uncommitted changes
   - Verify context file reflects current branch state
   - Ensure completed tasks are accurately marked

## Managing Context Size

To prevent context files from becoming too large:

1. **Use Git as the primary history store**
   - Keep detailed implementation notes in commit messages
   - Use PR descriptions for feature summaries
   - Reference specific commit hashes in context files

2. **Keep context files focused**
   - Only track current status and immediate next steps
   - Summarize completed work at a high level
   - Record only significant decisions, not routine choices

3. **Prune regularly**
   - Archive or remove older completed tasks
   - Move detailed implementation notes to documentation
   - Reference external resources instead of including content

## During a Session

When you need to compact context during a long session:

1. Update your branch context file with current progress
2. Use the `/compact` command

```
/compact
```

Claude will:
1. Summarize the conversation so far
2. Maintain awareness of current tasks and progress
3. Continue with reduced context usage

## Ending a Session

Before ending a session completely:

1. Update your branch context file with:
   - Current progress
   - Completed tasks
   - Key decisions
   - Restart instructions
   
2. Use `/exit` to end the session

## Context File Template

Each branch MUST have a context file in `contexts/[branch-type]-[branch-name]-context.md`:

```markdown
# [Branch Name] Context

## Current Status
- Current branch: [branch-type]/[branch-name]
- Started: YYYY-MM-DD
- Progress: [brief description of current state]

## Scope Boundaries
- Primary Purpose: [core objective of this branch]
- In Scope: 
  - [specific task/area 1]
  - [specific task/area 2]
- Out of Scope:
  - [task/area to be handled by other branches]
  - [excluded activities]
- Dependencies:
  - [prerequisite branch or task if any]
  - [related contexts]

## Completed Work
<!-- No entries yet -->

## Current Tasks
- [ ] Task 1 - [description]
  - Subtask 1.1
  - Subtask 1.2
- [ ] Task 2 - [description]
  - Subtask 2.1
  - Subtask 2.2

<!-- Task format: 
- [ ] Not started
- [~] In progress (with start date in YYYY-MM-DD format)
- [x] Completed (with completion date in YYYY-MM-DD format)
-->

## Key Decisions
<!-- No entries yet -->

## Notes
<!-- Optional section for reference information, diagrams, etc. -->
### Reference Information
- [Any relevant technical details]

### Untracked Files References
This branch creates/uses the following untracked files:
- `untracked/[file-path]` - [Purpose of the file]
- `untracked/[another-file-path]` - [Purpose of the file]

## Error Recovery
- If context becomes out of sync with branch: [specific recovery steps]
- If tasks require redirection to another branch: [how to handle]
- If merge conflicts occur: [resolution approach]

## Restart Instructions
To continue this work:
```bash
claude "load CLAUDE.md, verify current branch is [branch-type]/[branch-name], load appropriate context, and continue working on [current task]"
```
```

<!-- Note for Claude: 
1. The Scope Boundaries section is REQUIRED to prevent scope creep and clarify branch responsibilities
2. The Error Recovery section helps maintain workflow integrity when issues occur
3. Always keep branch naming and context file naming synchronized
4. Ensure restart instructions use the "verify current branch" pattern -->

### Development Model-Specific Templates

#### Solo Development Template
For solo development, use this simplified template:

```markdown
# [Branch Name] Context

## Current Status
- Current branch: [branch-type]/[branch-name]
- Started: YYYY-MM-DD
- Progress: [brief description of current state]

## Current Tasks
- [ ] Task 1 - [description]
- [ ] Task 2 - [description]

## Key Decisions
- [YYYY-MM-DD] [Description of decision]

## Untracked Files References
- `untracked/[file-path]` - [Purpose of the file]

## Restart Instructions
To continue this work:
```bash
claude "load CLAUDE.md, verify current branch is [branch-type]/[branch-name], and continue work"
```
```

#### Team Development Template
For team development, use the comprehensive template shown above with all sections.

### Creating Context Files From Existing Branches

If a branch exists without a context file, create one immediately:

1. Verify you're on the correct branch:
   ```bash
   git branch --show-current
   ```

2. Create the context file:
   ```bash
   claude "load CLAUDE.md, create context file for current branch, and continue work"
   ```

3. Claude MUST:
   - Examine branch history to understand its purpose
   - Create context file with accurate scope boundaries
   - Document work completed so far
   - Identify current state and remaining tasks

## Resuming Work After a Break

To resume work where you left off:

```bash
claude "load CLAUDE.md, identify branch as [branch-name], and continue working on [current task]"
```

## Effective Claude Prompt Patterns

Use these core patterns when working with Claude to maintain context and branch awareness:

### Standard Workflow Prompts

#### Continue Work on Current Branch
```bash
claude "load CLAUDE.md, identify branch as $(git branch --show-current), and continue working on [current task]"
```

#### Create and Start Work on New Branch
```bash
claude "load CLAUDE.md, create branch [branch-type]/[branch-name] from main, and start working on [task description]"
```

#### Create PR from Current Feature Branch
```bash
claude "load CLAUDE.md, identify branch as feature/[name], and create a PR to merge into main"
```

#### Review and Merge PR from Main
```bash
claude "load CLAUDE.md, identify branch as main, review PR #[number], and merge if approved"
```

### Context Management Best Practices

1. **Always include branch context** - Every prompt should identify or set the branch
2. **Reference the specific task** - Mention what you're working on
3. **Request context loading** - Ask Claude to load relevant context files for the branch
4. **Maintain work continuity** - Connect your current request to previous work

## Context Management by Branch Type

### Feature Branches

- Create context file when branch is created
- Track implementation decisions and progress
- Document code structure and design choices

### Fix Branches

- Document bug analysis and reproduction steps
- Track testing approaches and verification
- Record root cause when discovered

### Documentation Branches

- Track document organization decisions
- Record key content additions and changes
- Note audience and purpose decisions

### Branch Completion Updates

When a branch is ready for PR:

1. Update the context file with completion status:
   ```markdown
   ## Current Status
   - Current branch: [branch-type]/[branch-name]
   - Started: YYYY-MM-DD
   - Completed: YYYY-MM-DD
   - Progress: Implementation complete, ready for review
   
   ## Implementation Summary
   [Brief overview of what was implemented and key technical decisions]
   
   ## PR Readiness
   - [x] Self-review completed (YYYY-MM-DD)
   - [x] All tests passing
   - [x] Documentation updated
   - [x] Implementation complete
   ```

2. Include a knowledge transfer section for team projects:
   ```markdown
   ## Knowledge Transfer Notes
   - [Important information for other developers]
   - [Special considerations for future maintenance]
   - [Key implementation details worth highlighting]
   ```

## Error Detection and Recovery

### Common Issues and Resolution

#### 1. Branch-Context Mismatch
If the current branch doesn't match the context file being used:

1. **Detection**:
   - Claude notices branch name in context file doesn't match `git branch --show-current`
   - User is working on content inconsistent with branch purpose

2. **Recovery**:
   - Alert user to the mismatch
   - Offer to either:
     a. Switch to the correct branch
     b. Load the correct context file
     c. Create a new context file for the current branch
   - Document the resolution in the context file

#### 2. Missing Context File
If a branch exists without a corresponding context file:

1. **Detection**:
   - Claude can't find `contexts/[branch-type]-[branch-name]-context.md`
   - User mentions tasks not documented in any context

2. **Recovery**:
   - Alert user that no context file exists
   - Offer to create a new context file
   - Examine branch history to infer purpose
   - Document current state and remaining work

#### 3. Context File Drift
If a context file becomes outdated or inaccurate:

1. **Detection**:
   - Completed tasks not marked as complete
   - Task list doesn't reflect actual work in progress
   - Scope boundaries don't match actual work being done

2. **Recovery**:
   - Perform a context refresh:
   ```bash
   claude "load CLAUDE.md, synchronize context file with current branch state, and continue work"
   ```
   - Claude will update the context file to reflect current branch state
   - Document the resynchronization in the context file

#### 4. Main Branch Task Contamination
If feature development tasks appear in main-context.md:

1. **Detection**:
   - Tasks in main-context.md that should be in feature branches
   - Feature work being done directly on main

2. **Recovery**:
   - Identify the appropriate feature branch for the task
   - Move the task to the correct context file
   - If on main branch, create feature branch before continuing work
   - Update main-context.md to focus on branch/PR management