# Context Management Quick Reference

> - _did-original-source_: `did:repo:ca85b5ea9bc63cc8229c073d8f6a3faae8062a77/blob/main/requirements/guides/context_guide.md`
> - _github-original-source_: `https://github.com/ChristopherA/Claude-Code-CLI-Toolkit/blob/main/requirements/guides/context_guide.md`
> - _purpose_: Guide context management across Claude sessions
> - _copyright_: ©2025 by @ChristopherA, licensed under the [BSD 2-Clause Plus Patent License](https://spdx.org/licenses/BSD-2-Clause-Patent.html)
> - _created_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>
> - _last-updated_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>

## Starting a Session

When starting work with Claude:

```bash
# Load project guidance and check branch context
claude "load CLAUDE.md, identify current branch, and continue project work"
```

Claude will:
1. Check what branch you're on: `git branch --show-current`
2. Load the appropriate context file: `contexts/[branch-name]-context.md`
3. Review current progress and tasks

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

Each branch should have a context file in `contexts/[branch-name]-context.md`:

```markdown
# [Branch Name] Context

## Current Status
- Current branch: [branch-name]
- Started: <!-- START_DATE -->
- Progress: [brief description of current state]

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

## Restart Instructions
To continue this work:
```bash
claude "load CLAUDE.md, identify branch as [branch-name], and continue working on [current task]"
```
```

<!-- Note for Claude: The Notes section is optional but useful for specialized branches that need reference information or diagrams. Include it when creating context files that may benefit from this additional organization. -->

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