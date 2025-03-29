# Context Management Quick Reference

> - _did-original-source_: `did:repo:ca85b5ea9bc63cc8229c073d8f6a3faae8062a77/blob/main/requirements/guides/context_guide.md`
> - _github-original-source_: `https://github.com/ChristopherA/Claude-Code-CLI-Toolkit/blob/main/requirements/guides/context_guide.md`
> - _purpose_: Guide context management across Claude sessions
> - _copyright_: ©2025 by @ChristopherA, licensed under the [BSD 2-Clause Plus Patent License](https://spdx.org/licenses/BSD-2-Clause-Patent.html)
> - _created_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>
> - _last-updated_: 2025-03-31 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>

## For Claude: Context Management Decision Framework
```
FUNCTION: Context Management Process Selection
TRIGGER: Any context-related request

DETECT current_branch using "git branch --show-current"

STEP 1: VERIFY context-branch synchronization
    expected_context_path = "contexts/[branch-type]-[branch-name]-context.md"
    IF !exists(expected_context_path):
        EXECUTE context_creation_facilitation
        RETURN
    
STEP 2: LOAD context file
    context_content = read(expected_context_path)
    context_phase = extract_phase(context_content)
    
STEP 3: CHECK context state and respond
    IF context_phase == "Planning":
        has_approval = check_planning_approval(context_content)
        IF !has_approval:
            REQUEST planning_approval
            RETURN
            
    IF context_phase == "Implementation":
        continue_with_implementation
        
    IF context_phase == "Completion":
        check_PR_readiness
        
STEP 4: END session with proper closure
    UPDATE context with:
        progress_status
        completed_tasks
        key_decisions
        next_steps
    
context_creation_facilitation_pattern = "I notice this branch doesn't have a corresponding context file. Let me help create one to ensure proper tracking of your work."
```

### Self-Contained Process Blocks

#### PROCESS_BLOCK: Context Creation Facilitation
```
FUNCTION: Create context file for branch without one
TRIGGER: Branch exists without corresponding context file

STATE_VARIABLES:
    branch_name = ""
    branch_type = ""
    context_file_path = ""
    purpose = ""
    scope_in = []
    scope_out = []
    dependencies = []
    initial_tasks = []
    success_criteria = []
    current_date = ""

INITIALIZATION:
    EXECUTE "git branch --show-current" -> branch_name
    EXTRACT branch_type from branch_name
    SET context_file_path = "contexts/[branch-type]-[branch-name]-context.md"
    EXECUTE "date +%Y-%m-%d" -> current_date
    
PROCESS structured_interview:
    ASK "What is the primary purpose of this branch?"
    DETECT purpose from user response
    
    ASK "What specific tasks or areas are IN scope for this branch?"
    DETECT scope_in from user response
    
    ASK "What should be considered OUT of scope (to be handled by other branches)?"
    DETECT scope_out from user response
    
    ASK "Are there any dependencies on other branches or contexts?"
    DETECT dependencies from user response
    
    ASK "What are the initial tasks you plan to work on?"
    DETECT initial_tasks from user response
    
    ASK "What would constitute successful completion of this work?"
    DETECT success_criteria from user response
    
PROCESS template_generation:
    CREATE context_content using context_template
    POPULATE context_content with:
        branch_name
        branch_type
        current_date
        purpose
        scope_in
        scope_out
        dependencies
        initial_tasks
        success_criteria
        
    SET "Phase: Planning" in context_content
    
PROCESS file_creation:
    VERIFY context_file_path does not exist
    WRITE context_content to context_file_path
    
    RESPOND "I've created a context file for the [branch_name] branch at [context_file_path].
             The context is in Planning phase. Please review and update the planning section
             before we proceed with implementation."
             
    SUGGEST "Would you like me to help you complete the planning section now?"

VALIDATION:
    VERIFY file_exists = check if context_file_path exists
    IF !file_exists:
        RESPOND "There was an issue creating the context file. Let's try again with a different approach."
        OFFER alternative_file_creation_method

ON ERROR:
    RESPOND "I encountered an issue while creating the context file. Let's try a more direct approach."
    PRESENT simplified_context_template to user
    GUIDE user through manual context file creation

EXPECTED OUTPUTS:
    context_creation_success = "I've created a context file for the [branch_name] branch at [context_file_path].
                              The context is in Planning phase. Let's review and complete the planning section
                              before we proceed with implementation."
                              
    planning_guidance = "To complete the planning section, we need to define:
                         1. What We're Solving - A clear problem statement
                         2. Our Approach - How we'll solve the problem
                         3. Definition of Done - Success criteria with measurable outcomes
                         4. Implementation Phases - Steps to complete the work"
```

#### PROCESS_BLOCK: Planning Phase Verification
```
FUNCTION: Verify and approve planning phase
TRIGGER: Context in Planning phase without approval

STATE_VARIABLES:
    context_file_path = ""
    planning_section = {}
    missing_components = []
    has_problem_statement = FALSE
    has_approach = FALSE
    has_success_criteria = FALSE
    has_implementation_phases = FALSE
    approval_requested = FALSE
    user_approval = FALSE
    current_date = ""
    
INITIALIZATION:
    EXECUTE "git branch --show-current" -> current_branch
    SET context_file_path = "contexts/[branch-type]-[branch-name]-context.md"
    EXECUTE "date +%Y-%m-%d" -> current_date
    
PROCESS planning_completeness_check:
    LOAD context_file_path -> context_content
    EXTRACT "Planning" section -> planning_section
    
    CHECK planning_section for:
        "What We're Solving" with meaningful content -> has_problem_statement
        "Our Approach" with meaningful content -> has_approach
        "Definition of Done" with at least 2 items -> has_success_criteria
        "Implementation Phases" with sequence -> has_implementation_phases
        
    IF !has_problem_statement:
        ADD "Problem Statement" to missing_components
    IF !has_approach:
        ADD "Approach Description" to missing_components
    IF !has_success_criteria:
        ADD "Success Criteria (at least 2 items)" to missing_components
    IF !has_implementation_phases:
        ADD "Implementation Phases" to missing_components
        
PROCESS completion_guidance:
    IF missing_components is not empty:
        RESPOND "The planning section needs to be completed before we can request approval.
                Please add the following missing components:
                [missing_components formatted as list]"
                
        PROVIDE example for each missing component
        RETURN
    
PROCESS approval_request:
    IF missing_components is empty && !approval_requested:
        EXTRACT problem_statement from planning_section
        EXTRACT approach from planning_section
        EXTRACT success_criteria from planning_section
        EXTRACT implementation_phases from planning_section
        
        RESPOND "I've reviewed the planning for [current_branch]:
                
                Problem: [problem_statement]
                Approach: [approach]
                Success Criteria:
                [success_criteria formatted as list]
                Implementation Phases:
                [implementation_phases formatted as list]
                
                To approve this plan and begin implementation, please explicitly respond with:
                'I APPROVE THE PLANNING PHASE'"
                
        SET approval_requested = TRUE
        
PROCESS approval_detection:
    DETECT exact_phrase "I APPROVE THE PLANNING PHASE" in user_response
    IF found:
        SET user_approval = TRUE
        SET IMPLEMENTATION_ALLOWED = TRUE
        
        UPDATE context_file:
            SET "Planning approved - Ready to implement ([current_date])" to checked
            SET "Phase: Implementation" in Current Status section
            
        RESPOND "✅ Planning phase approved! The implementation gate has been unlocked.
                We're now in the Implementation phase and can begin with:
                [first_implementation_phase]"
                
        BEGIN implementation of first phase

VALIDATION:
    IF user_approval == TRUE:
        VERIFY context_updated = check if context file contains updated phase and approval
        IF !context_updated:
            RESPOND "I had trouble updating the context file. Let's try again."
            OFFER manual_update_instructions

ON ERROR:
    RESPOND "I encountered an issue with the planning verification process. Let's try a more direct approach."
    PROVIDE alternative_verification_process
    
EXPECTED OUTPUTS:
    missing_components_alert = "The planning section needs to be completed before we can request approval.
                              Please add the following missing components:
                              - Problem Statement
                              - Approach Description
                              - Success Criteria (at least 2 items)
                              - Implementation Phases"
                              
    approval_request = "I've reviewed the planning for [current_branch]:
                       
                       Problem: [problem_statement]
                       Approach: [approach]
                       Success Criteria:
                       - [criterion 1]
                       - [criterion 2]
                       Implementation Phases:
                       1. [phase 1]
                       2. [phase 2]
                       
                       To approve this plan and begin implementation, please explicitly respond with:
                       'I APPROVE THE PLANNING PHASE'"
                       
    implementation_transition = "✅ Planning phase approved! The implementation gate has been unlocked.
                               We're now in the Implementation phase and can begin with:
                               [first_implementation_phase]"
                               
    implementation_blocked = "⛔ Implementation blocked: Planning phase requires approval.
                            Please review the plan and approve with phrase:
                            'I APPROVE THE PLANNING PHASE'"
```

#### PROCESS_BLOCK: Session Closure
```
FUNCTION: Properly close a development session
TRIGGER: End of session or /exit command

STATE_VARIABLES:
    context_file_path = ""
    current_branch = ""
    current_date = ""
    completed_tasks = []
    started_tasks = []
    key_decisions = []
    next_steps = []
    progress_description = ""
    
INITIALIZATION:
    EXECUTE "git branch --show-current" -> current_branch
    SET context_file_path = "contexts/[branch-type]-[branch-name]-context.md"
    EXECUTE "date +%Y-%m-%d" -> current_date
    
PROCESS progress_detection:
    EXECUTE "git status" -> git_status
    EXTRACT modified_files from git_status
    
    LOAD context_file_path -> context_content
    EXTRACT existing_tasks from context_content
    COMPARE conversation_progress with existing_tasks to identify:
        newly_completed_tasks -> completed_tasks
        newly_started_tasks -> started_tasks
        
    IDENTIFY important_decisions from conversation -> key_decisions
    
PROCESS context_update:
    UPDATE Context Status:
        SET "Last updated: [current_date]"
        UPDATE Progress description with latest state
        
    UPDATE Tasks:
        FOR each task in completed_tasks:
            MARK with [x] and completion date
        FOR each task in started_tasks:
            MARK with [~] and start date
            
    IF key_decisions not empty:
        ADD entries to Key Decisions section with dates
        
    GENERATE next_steps based on:
        remaining tasks
        implementation phases
        current progress
        
    UPDATE Next Steps section with 2-3 specific actions
    
    VERIFY restart_instructions contain correct branch name and specific task
    
PROCESS closure_confirmation:
    GENERATE progress_summary = {
        completed: completed_tasks,
        started: started_tasks,
        decisions: key_decisions,
        next: next_steps
    }
    
    RESPOND "I've updated the context file with today's progress:
             
             Completed: [completed_tasks formatted as list or 'None']
             Started: [started_tasks formatted as list or 'None']
             Decisions: [key_decisions formatted as list or 'None']
             
             Next Steps:
             [next_steps formatted as list]
             
             The context file has been updated for our next session."

VALIDATION:
    VERIFY context_updated = check if context file contains updated date and progress
    IF !context_updated:
        RESPOND "I had trouble updating the context file. Here's what should be updated for next time:"
        PRESENT progress_summary for manual update

ON ERROR:
    RESPOND "I encountered an issue while closing the session. Here's a summary of today's progress that you may want to manually add to the context file:"
    PRESENT progress_summary in user-friendly format
    
EXPECTED OUTPUTS:
    closure_confirmation = "I've updated the context file with today's progress:
                          
                          Completed: 
                          - [task 1] (2025-03-31)
                          - [task 2] (2025-03-31)
                          
                          Started:
                          - [task 3] (2025-03-31)
                          
                          Decisions:
                          - [2025-03-31] [decision description]
                          
                          Next Steps:
                          1. [specific next action]
                          2. [specific next action]
                          3. [specific next action]
                          
                          The context file has been updated for our next session."
```

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

## Planning to Implementation Process

Every branch context must complete a planning phase before implementation begins:

1. **Create Initial Planning**:
   - Complete the Planning section in the context file
   - Define problem statement, approach, and success criteria
   - Outline implementation phases

2. **Request Explicit Approval**:
   Claude should ask for the exact approval phrase: 
   ```
   I've reviewed the planning for [branch-name]:
   
   Problem: [problem statement]
   Approach: [approach]
   [...]
   
   To approve this plan and begin implementation, please explicitly respond with:
   'I APPROVE THE PLANNING PHASE'
   ```

3. **Implementation Gate Unlocking**:
   - Approval ONLY happens when user types the exact phrase: "I APPROVE THE PLANNING PHASE"
   - Any other response will NOT unlock implementation
   - This is a critical security mechanism that prevents accidental approval

4. **Document Approval**:
   - Mark the "Planning approved" checkbox with date when approved
   - Update context Phase from "Planning" to "Implementation"
   - Set IMPLEMENTATION_ALLOWED flag to TRUE
   - Begin implementing per the approved plan

### Example Planning Approval Request

```
The planning phase for feature/enhanced-functionality is now complete:

Problem: We need standardized function documentation to improve maintainability
Approach: Create templates and update all z_* functions with consistent documentation
Success Criteria: 
- All functions have parameter documentation
- Return values are clearly specified
- Examples exist for each function

Implementation will proceed in 3 phases:
1. Create documentation templates
2. Update core functions
3. Update utility functions

Do you approve this plan so we can begin implementation?
```

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

Before ending a session, follow this consistent context closure process:

1. **Mark Progress**
   - Update "Current Status" section with accurate progress description
   - Update "Last updated" date to today
   - Mark completed tasks with [x] and completion date
   - Mark in-progress tasks with [~] and start date

2. **Document Decisions**
   - Add any significant decisions made during the session to "Key Decisions"
   - Include YYYY-MM-DD date format with each decision
   - Capture rationale briefly to aid future understanding

3. **Define Next Actions**
   - Add or update "Next Steps" section at end of context file
   - List 3 specific, actionable items with clear outcomes
   - Ensure they pick up exactly where current session ended

4. **Update Restart Command**
   - Verify restart command includes correct branch name
   - Include specific task focus in the restart command
   - Example: `claude "load CLAUDE.md, verify current branch is feature/example, load appropriate context, and continue implementing file validation"`
   
5. Use `/exit` to end the session

## Context File Template

Each branch MUST have a context file in `contexts/[branch-type]-[branch-name]-context.md` with the following structure:

```markdown
# [Branch Name] Context

## For Claude: Context Processing Framework
```
FUNCTION: Context State Management
TRIGGER: Any context-related operation

STATE_VARIABLES:
    current_branch = ""
    context_path = ""
    context_phase = "Planning"
    IMPLEMENTATION_ALLOWED = FALSE  // CRITICAL GATE FLAG
    planning_approval = FALSE
    completed_tasks_count = 0
    total_tasks_count = 0
    completion_percentage = 0.0
    phase_transition_needed = FALSE

INITIALIZATION:
    EXECUTE "git branch --show-current" -> current_branch
    VERIFY current_branch == "[branch-type]/[branch-name]"
    
    SET context_path = "contexts/[branch-type]-[branch-name]-context.md"
    EXECUTE "cat ${context_path}" -> context_content
    
DETECT context_phase:
    SCAN context_content for "Phase: (Planning|Implementation|Completion)"
    SET context_phase = found_match
    
    // Critical implementation gate check
    IF "I APPROVE THE PLANNING PHASE" found in latest_user_message:
        SET IMPLEMENTATION_ALLOWED = TRUE
        SET planning_approval = TRUE
        UPDATE context_file planning_approval_section
    ELSE:
        SCAN for "Planning approved - Ready to implement" in context_file
        IF found && marked_checked:
            SET planning_approval = TRUE
            SET IMPLEMENTATION_ALLOWED = TRUE
            
PROCESS file_modification_guard:
    // This is the core protection mechanism
    BEFORE ANY Edit/Replace/Bash tool use:
        IF context_phase == "Planning" && IMPLEMENTATION_ALLOWED == FALSE:
            BLOCK TOOL EXECUTION
            RESPOND "⛔ Implementation blocked: Planning phase requires approval.
                     Please review the plan and approve with phrase:
                     'I APPROVE THE PLANNING PHASE'"
            EXIT FUNCTION
            
DETECT task_statistics:
    COUNT tasks marked with "[x]" -> completed_tasks_count
    COUNT total tasks -> total_tasks_count
    CALCULATE completion_percentage = (completed_tasks_count / total_tasks_count) * 100
    
    IF completion_percentage == 100 && context_phase != "Completion":
        SET phase_transition_needed = TRUE
        
PROCESS context_operation:
    IF planning_approval == FALSE && context_phase == "Planning":
        PRESENT planning_details_for_review
        REQUEST planning_approval
        RETURN // Critical: Prevent proceeding until approved
    ELSE IF context_phase == "Implementation":
        EXECUTE implementation_phase_management
    ELSE IF context_phase == "Completion" || phase_transition_needed:
        EXECUTE completion_phase_management
        
VALIDATION:
    VERIFY context_content contains expected elements for current_phase
    VERIFY task statuses are consistent
    
    // Security validation
    IF context_phase == "Implementation" && planning_approval == FALSE:
        // Detect potential bypass attempt
        SET IMPLEMENTATION_ALLOWED = FALSE
        SET context_phase = "Planning"
        RESPOND "⚠️ Security alert: Implementation phase detected without planning approval.
                 Resetting to Planning phase for proper review."
    
ON ERROR:
    SET IMPLEMENTATION_ALLOWED = FALSE  // Default to safe state
    LOG error details
    SUGGEST manual intervention
    OFFER specific recovery actions
```

## Current Status
- Current branch: [branch-type]/[branch-name]
- Started: YYYY-MM-DD
- Last updated: YYYY-MM-DD
- Progress: [brief description of current state]
- Phase: [Planning|Implementation|Completion]

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

## Planning
<!-- Complete this section before implementation -->

### What We're Solving
[1-2 sentence description of the problem or enhancement]

### Our Approach
[Brief explanation of how we'll solve it in 2-3 sentences]

### Definition of Done
- [ ] [Specific, measurable outcome 1]
- [ ] [Specific, measurable outcome 2]
- [ ] [Specific, measurable outcome 3]

### Implementation Phases
1. [Phase 1 focus] → [Expected outcome]
2. [Phase 2 focus] → [Expected outcome]
3. [Phase 3 focus] → [Expected outcome]

### Approval
- [ ] Planning approved - Ready to implement (YYYY-MM-DD)

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

## Restart Instructions
To continue this work:
```bash
claude "load CLAUDE.md, verify current branch is [branch-type]/[branch-name], load appropriate context, and continue working on [current task]"
```

## Next Steps
1. [Next specific action with clear outcome]
2. [Second specific action with clear outcome]
3. [Third specific action with clear outcome]
```

<!-- Note for Claude: 
1. The Scope Boundaries section is REQUIRED to prevent scope creep and clarify branch responsibilities
2. The Planning section is REQUIRED before implementation can begin
3. The Error Recovery section helps maintain workflow integrity when issues occur
4. Always keep branch naming and context file naming synchronized
5. Ensure restart instructions use the "verify current branch" pattern
6. The Next Steps section is REQUIRED for effective session transitions -->

### Development Model-Specific Templates

#### Solo Development Template
For solo development, use this simplified template:

```markdown
# [Branch Name] Context

## For Claude: Context Processing Framework
```
FUNCTION: Context State Management
TRIGGER: Any context-related operation

DETECT current_phase:
    SCAN for "Phase: Planning|Implementation|Completion" in Current Status section
    SET context_phase = detected_value
    
DETECT planning_approval:
    IF context_phase == "Planning":
        SCAN for "Planning approved - (YYYY-MM-DD)" in Planning section
```

## Current Status
- Current branch: [branch-type]/[branch-name]
- Started: YYYY-MM-DD
- Last updated: YYYY-MM-DD
- Progress: [brief description of current state]
- Phase: [Planning|Implementation|Completion] <!-- REQUIRED: Claude uses this for state detection -->

## Planning
<!-- Complete this section before implementation -->

### What We're Solving
[1-2 sentence description of the problem or enhancement]

### Our Approach
[Brief explanation of how we'll solve it]

### Definition of Done
- [ ] [Specific outcome 1]
- [ ] [Specific outcome 2]

### Approval
- [ ] Planning approved - Ready to implement (YYYY-MM-DD)

## Current Tasks
- [ ] Task 1 - [description]
- [ ] Task 2 - [description]

## Key Decisions
- [YYYY-MM-DD] [Description of decision]

## Untracked Files References
- `untracked/[file-path]` - [Purpose of the file]

## For Claude: Session Closure Process
```
FUNCTION: Properly close a development session
TRIGGER: End of session

STEP 1: UPDATE context status
    UPDATE Last-updated date to current date
    UPDATE Progress description
    
STEP 2: GENERATE next steps
    IDENTIFY 2-3 most important next actions
    ENSURE each has clear, specific outcome
```

## Restart Instructions
To continue this work:
```bash
claude "load CLAUDE.md, verify current branch is [branch-type]/[branch-name], and continue work"
```

## Next Steps
1. [Next specific action with clear outcome]
2. [Second specific action with clear outcome]
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

#### Get Help Reviewing PR from Main
```bash
claude "load CLAUDE.md, verify current branch is main, help review PR #[number]"
```


### Context Management Best Practices

1. **Always include branch context** - Every prompt should identify or set the branch
2. **Reference the specific task** - Mention what you're working on
3. **Request context loading** - Ask Claude to load relevant context files for the branch
4. **Maintain work continuity** - Connect your current request to previous work

## Claude-Optimized Context Template

The context template above is specifically optimized for Claude's processing patterns with self-contained management processes.

### Key Design Decisions
1. **Claude Processing Efficiency**: Template prioritizes Claude's processing efficiency over human readability
2. **Direct Command Execution**: Uses git commands directly (git status, etc.) for reliable state detection
3. **Consistent Pattern Format**: Maintains a single, consistent process block format rather than tiered approach
4. **Self-Contained Instructions**: Process blocks are designed to function without cross-referencing

## Content Attribution Guidelines

When creating content with Claude's assistance, always follow these principles:

### Proper Attribution Standards

1. **User Attribution Only**: All content should be attributed to the human user, not to Claude
   - Never include "Generated with Claude Code" in any content
   - Never add "Co-Authored-By: Claude" to commit messages
   - Never reference Claude as a contributor or author

2. **Pre-Submission Review**: Before finalizing any content for commits or PRs:
   - Check for Claude self-references (e.g., "I, Claude...", "Generated by...", etc.)
   - Remove any emoji or signature tokens associated with Claude
   - Ensure the content reflects the user's work, not Claude's

### Content Template Examples

#### Commit Messages

**Correct Format:**
```
Add user authentication feature

Implement JWT-based authentication with password hashing and
session management. Includes unit tests for login/logout flows.
```

**Format to Avoid:**
```
Add user authentication feature

Implement JWT-based authentication with password hashing and
session management. Includes unit tests for login/logout flows.

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

#### Pull Request Descriptions

**Correct Format:**
```
## Summary
This PR adds JWT-based user authentication with secure password handling.

## Changes
- Added User model with password hashing
- Implemented authentication middleware
- Created login/logout/register endpoints
- Added comprehensive test suite

## Test Plan
1. Run unit tests: `npm test`
2. Test login flow with valid/invalid credentials
3. Verify token expiration handling
```

**Format to Avoid:**
```
## Summary
This PR adds JWT-based user authentication with secure password handling.
[...content as above...]

## Test Plan
[...content as above...]

Generated by Claude, implementing the requirements specified by the user
```

#### Documentation

**Correct Format:**
```
# Authentication API

This document describes the authentication endpoints and usage.

## Endpoints
- POST /auth/login
- POST /auth/register
- GET /auth/logout
```

**Format to Avoid:**
```
# Authentication API

This document describes the authentication endpoints and usage.
Written by Claude based on the project requirements.

## Endpoints
[...content as above...]
```

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

### Process Branches

- Document analysis of process improvements
- Track implementation of process changes
- Note impact on existing workflows

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
   - Follow the Context Creation Facilitation process (see below)
   - Examine branch history to infer purpose
   - Document current state and remaining work

#### 3. Planning Approval Issues
If there are problems with the planning approval process:

1. **Common Approval Issues**:
   - **Incorrect Approval Phrase**: User typed a variant of the approval phrase
   - **Premature Implementation Attempt**: User trying to implement before approval
   - **Phase Confusion**: Context file shows different phase than actual state
   - **Flag Inconsistency**: IMPLEMENTATION_ALLOWED flag out of sync with planning_approval status
   - **Accidental Phase Change**: Context file manually updated to skip planning phase

2. **Detection Signs**:
   - Implementation being blocked despite apparent approval
   - Error messages about implementation permission
   - Security alerts about phase inconsistencies
   - Confusion about why file modifications are blocked

3. **Recovery Steps**:
   - **For Incorrect Approval Phrase**:
     - Clearly instruct user to type exactly: `I APPROVE THE PLANNING PHASE`
     - Verify there are no extra spaces, punctuation, or capitalization changes
     - Only this exact phrase will unlock implementation

   - **For Premature Implementation**:
     - Redirect user to complete the Planning section first
     - Review planning components (problem statement, approach, success criteria, phases)
     - Request approval only after planning is complete

   - **For Phase Confusion or Flag Inconsistency**:
     - Reset context state to safe values: `IMPLEMENTATION_ALLOWED = FALSE, planning_approval = FALSE`
     - Verify context file Phase field matches expected state
     - Re-request approval with explicit phrase

   - **For Accidental Phase Change**:
     - Revert context file phase to "Planning" in Current Status section
     - Uncheck the Planning approved checkbox
     - Re-request approval through proper process

4. **Prevention Guidance**:
   - Always follow the exact approval workflow
   - Never manually edit phase information in context files
   - Use the exact approval phrase when prompted
   - Complete all planning components before requesting approval
   
5. **Error Recovery Examples**:

   - **Example: Incorrect Approval Phrase**
     ```
     User: "I approve the plan"
     Claude: "To unlock implementation, please use the exact phrase:
              'I APPROVE THE PLANNING PHASE'
              This exact wording is required as a deliberate security mechanism."
     User: "I APPROVE THE PLANNING PHASE"
     Claude: "✅ Planning phase approved! The implementation gate has been unlocked."
     ```

   - **Example: Phase Confusion Recovery**
     ```
     User: "Let's implement feature X" (when context shows Planning phase)
     Claude: "⛔ Implementation blocked: Planning phase requires approval.
              I notice the context file shows we're in Planning phase, but implementation 
              is being attempted. Let's reset to a consistent state:
              1. I've verified the context file shows Phase: Planning
              2. The Planning section needs to be completed and approved
              3. Please review the planning details and approve with the exact phrase:
                 'I APPROVE THE PLANNING PHASE'"
     ```

   - **Example: Flag Inconsistency Recovery**
     ```
     User: "Why can't I modify files? I already approved the planning."
     Claude: "I've detected an inconsistency between the approval status and implementation
              permission. Let me reset to a consistent state:
              
              1. Context file indicated Phase: Implementation
              2. But implementation permission flag was FALSE
              3. I've verified the planning section is complete
              4. I've reset state variables to a consistent state
              
              Please explicitly approve the planning phase again with:
              'I APPROVE THE PLANNING PHASE'"
     ```

### Context Creation Facilitation

When a branch exists without a corresponding context file, Claude must proactively facilitate its creation through a structured interview process:

1. **Initial Assessment**:
   ```
   I notice that the current branch [branch-type]/[branch-name] does not have a corresponding context file. 
   Let me help you create one to ensure proper tracking and documentation of your work on this branch.
   ```

2. **Structured Interview Questions**:
   Claude must ask the following questions to gather essential information:

   a. **Purpose Definition**:
   ```
   What is the primary purpose of this branch? Please describe the main goal or problem you're addressing.
   ```

   b. **Scope Boundaries**:
   ```
   Let's define the scope boundaries:
   - What specific tasks or areas are IN scope for this branch?
   - What should be considered OUT of scope (to be handled elsewhere)?
   - Are there any dependencies on other branches or tasks?
   ```

   c. **Initial Tasks**:
   ```
   What are the initial tasks you plan to work on in this branch? Please list them in priority order.
   ```

   d. **Success Criteria**:
   ```
   What would constitute successful completion of this branch's work? What are the acceptance criteria?
   ```

   e. **Timeline and Priority**:
   ```
   What is the expected timeline or priority level for this work?
   ```

3. **Context Creation and Validation**:
   - Create the context file based on user responses
   - Present the draft context for user review and approval
   - Make any requested adjustments

4. **Work Stream Task Synchronization**:
   - Identify if tasks in the new context need to be reflected in WORK_STREAM_TASKS.md
   - Suggest updates to WORK_STREAM_TASKS.md as needed
   - Ensure consistency between context tasks and work stream tasks

5. **Work Stream Task Synchronization**:
   - Ensure the new branch and context are properly tracked in WORK_STREAM_TASKS.md
   - Verify task priorities and dependencies are correctly represented

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
If attempting feature development on the main branch:

1. **Detection**:
   - Development tasks being attempted on the protected main branch
   - Feature work being discussed without a proper working branch

2. **Recovery**:
   - Identify the appropriate feature branch for the task
   - Create a new branch if no suitable branch exists
   - Move work to the feature branch context file
   - Use the main branch only for facilitation purposes

## Context Lifecycle Management

### Context States and Transitions

Contexts progress through multiple states during their lifecycle:

1. **Future** (`contexts/futures/` directory)
   - Planned, not yet started
   - Templates for future branches
   - Referenced in main-context.md and WORK_STREAM_TASKS.md

2. **Active** (root of `contexts/` directory)
   - Associated with an active branch
   - Work in progress
   - Tasks being updated

3. **Completed** (moved to `contexts/archived.md`)
   - Branch merged via PR
   - All work completed
   - Preserved for historical reference

### Context Archiving Process

When work on a branch is complete and merged to main:

1. **Mark the context as completed**:
   ```markdown
   ## Current Status
   - Current branch: [branch-type]/[branch-name]
   - Started: YYYY-MM-DD
   - Completed: YYYY-MM-DD
   - Status: COMPLETED - All tasks successfully finished
   ```

2. **Archive the context file**:
   ```bash
   claude "load CLAUDE.md, verify current branch is main, archive completed context [context-name], and update documentation"
   ```

3. **Archiving steps**:
   - Create or update `contexts/archived.md` with entries for each archived context
   - Include completion date, PR number, and branch reference
   - Add a brief summary (3-5 lines) describing the work completed
   - Include a link to the specific Git commit version of the context file
   - Remove the original context file with `git rm`
   - Update WORK_STREAM_TASKS.md to reflect the completed work
   - Ensure references to branch names and context files are current

### Example Archive Entry Format

Each archived context should follow this standard format in `contexts/archived.md`:

```markdown
## branch-name-context.md

**Status:** Completed  
**Branch:** [branch-type]/[branch-name]  
**Completed:** YYYY-MM-DD  
**Archived:** YYYY-MM-DD  
**PR:** [#XX](https://github.com/[org]/[repo]/pull/XX) (Merged YYYY-MM-DD)  
**Categories:** [Category1], [Category2]

Brief description of the work completed in 3-5 lines. Focus on the outcomes,
major accomplishments, and significance of the work.

**Key Accomplishments:**
- Major achievement 1
- Major achievement 2
- Major achievement 3
- Major achievement 4

**Related Contexts:** [related-context-1], [related-context-2]

[View archived context](https://github.com/[org]/[repo]/blob/[commit-hash]/contexts/[context-filename])
```

### Future Contexts Management

Contexts for future branches should be stored in `contexts/futures/` to maintain a clear separation between:

1. **Active work** (in root of `contexts/`)
2. **Future planned work** (in `contexts/futures/`)
3. **Completed work** (in `contexts/archived.md`)

When starting work on a planned branch, move the context from futures/ to the root contexts/ directory:

```bash
git mv contexts/futures/feature-name-context.md contexts/feature-name-context.md
```