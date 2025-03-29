# Error Recovery Guide

> - _created: 2025-03-31_
> - _last-updated: 2025-03-31_
> - _purpose: Document common errors and recovery paths for Claude Code CLI Toolkit_

This guide documents common errors that may occur when working with the Claude Code CLI Toolkit and provides structured recovery paths for each scenario.

## For Claude: Error Detection and Recovery Framework
```
FUNCTION: Error Detection and Recovery
TRIGGER: Any error condition in context processing or implementation

STATE_VARIABLES:
    error_type = ""
    error_source = ""
    error_severity = ""
    error_context = {}
    recovery_attempted = FALSE
    recovery_successful = FALSE
    
INITIALIZATION:
    DETECT error_indicators in user_message or system_state
    CLASSIFY error_type based on indicators
    SET error_severity based on operational impact
    GATHER error_context details
    
PROCESS error_response:
    LOOKUP recovery_protocol for error_type
    RESPOND with structured_error_message:
        - Error identification
        - Impact assessment
        - Recovery steps
        - Prevention guidance
        
    EXECUTE recovery_protocol
    VERIFY recovery_successful
    
    IF !recovery_successful:
        ESCALATE to alternative_recovery_approach
        
VALIDATION:
    VERIFY system returned to consistent state
    VERIFY user understands error cause and prevention
    
ON ERROR:
    PROVIDE manual_recovery_instructions
    SUGGEST clear_recovery_steps that user can execute directly
```

## Error Classification Matrix

| Error Type | Severity | Source | Impact | Recovery Complexity |
|------------|----------|--------|--------|---------------------|
| Context Synchronization | Medium | Branch-Context mismatch | Process flow breaks | Simple |
| Permission Control | High | Planning phase bypass | Security violation | Complex |
| State Inconsistency | High | Flag/state mismatch | System confusion | Medium |
| Content Format | Low | Template formatting | Mild dysfunction | Simple |
| Process Violation | Medium | Workflow bypass | Reduced effectiveness | Medium |
| System Execution | Medium | Command failures | Operation blocked | Medium-Complex |

## Common Error Scenarios and Recovery

### Context and Branch Synchronization Errors

#### 1. Branch Without Context File

**Detection Indicators:**
- Cannot find context file for current branch
- References to work not documented in any context

**Error Message:**
```
⚠️ Branch Context Missing: 
I notice the branch [branch-name] doesn't have a corresponding context file.
This means we're missing critical tracking for this branch's purpose and tasks.
```

**Recovery Steps:**
1. Follow Context Creation Facilitation process:
   ```
   claude "load CLAUDE.md, create context file for branch $(git branch --show-current), and begin work"
   ```
2. Document the branch purpose and scope
3. Define tasks and success criteria
4. Set up proper tracking in WORK_STREAM_TASKS.md

**Prevention:**
- Always create context files when creating branches
- Use standard branch creation commands that include context creation

#### 2. Context-Branch Mismatch

**Detection Indicators:**
- Context file branch name differs from `git branch --show-current`
- Work inconsistent with branch purpose

**Error Message:**
```
⚠️ Branch-Context Mismatch:
Current branch is [actual-branch] but context file is for [context-branch].
This creates confusion about work scope and tracking.
```

**Recovery Steps:**
1. Determine if you need to:
   - Switch branches: `git checkout [context-branch]`
   - Use different context: `claude "load correct context for [actual-branch]"`
   - Create new context: `claude "create context for current branch"`
2. Document reason for the mismatch
3. Ensure WORK_STREAM_TASKS.md reflects correct branch assignment

**Prevention:**
- Use standard branch navigation commands 
- Verify branch name before starting work
- Let Claude verify branch-context synchronization

### Planning and Implementation Permission Errors

#### 1. Premature Implementation Attempt

**Detection Indicators:**
- File modification during Planning phase
- Implementation attempt before approval

**Error Message:**
```
⛔ Implementation Blocked:
Planning phase requires approval before implementation can begin.
The planning section must be complete and explicitly approved.
```

**Recovery Steps:**
1. Complete Planning section in context file:
   - Problem statement
   - Approach
   - Success criteria
   - Implementation phases
2. Request approval with: `I APPROVE THE PLANNING PHASE`
3. Proceed with implementation after approval

**Example Interaction:**
```
User: "Let's modify the config file to add logging"
Claude: "⛔ Implementation blocked: Planning phase requires approval.
         I see the Planning section is complete. To approve and begin
         implementation, please respond with:
         'I APPROVE THE PLANNING PHASE'"
User: "I APPROVE THE PLANNING PHASE"
Claude: "✅ Planning phase approved! The implementation gate has been unlocked.
         We can now modify the config file to add logging."
```

**Prevention:**
- Follow the planning → approval → implementation workflow
- Complete planning details before requesting approval
- Use the exact approval phrase to unlock implementation

#### 2. Approval Phrase Variation

**Detection Indicators:**
- Similar but inexact approval phrase
- Planning still blocked after apparent approval

**Error Message:**
```
⚠️ Exact Approval Phrase Required:
I see you've attempted to approve the planning phase, but the 
exact approval phrase is required as a security mechanism.
```

**Recovery Steps:**
1. Type exactly: `I APPROVE THE PLANNING PHASE`
2. Check for:
   - Exact capitalization
   - No extra punctuation
   - No extra spaces
   - Exact wording

**Example Interaction:**
```
User: "I approve the planning phase"
Claude: "⚠️ Exact Approval Phrase Required:
         To unlock implementation, please use the EXACT phrase with proper capitalization:
         'I APPROVE THE PLANNING PHASE'"
User: "I APPROVE THE PLANNING PHASE"
Claude: "✅ Planning phase approved! The implementation gate has been unlocked."
```

**Prevention:**
- Use the exact phrase as shown in the approval request
- Copy-paste the phrase if needed for exactness

#### 3. Planning Phase Bypass Attempt

**Detection Indicators:**
- Context shows Implementation phase but no approval record
- IMPLEMENTATION_ALLOWED flag inconsistent with phase
- Direct editing of phase indicator in context file

**Error Message:**
```
⚠️ Security Alert: Implementation phase detected without planning approval.
Resetting to Planning phase for proper review and approval.
```

**Recovery Steps:**
1. Reset to consistent safe state
2. Verify Planning section is complete
3. Request and provide explicit approval
4. Proceed with implementation after approval

**Example Interaction:**
```
User: "Let's continue implementing feature X" (after manually editing context)
Claude: "⚠️ Security Alert: I've detected an inconsistency in the context file.
         The phase shows 'Implementation' but there's no record of planning approval.
         I've reset the state to 'Planning' for security reasons.
         
         Please review the Planning section and approve with:
         'I APPROVE THE PLANNING PHASE'"
```

**Prevention:**
- Never manually edit phase information in context files
- Follow the standard approval process
- Allow Claude to manage phase transitions

### State Inconsistency Errors

#### 1. Flag-Phase Mismatch

**Detection Indicators:**
- IMPLEMENTATION_ALLOWED flag doesn't match context phase
- Confusion about why implementation is blocked

**Error Message:**
```
⚠️ State Inconsistency Detected:
The implementation permission state doesn't match the documented phase.
This could lead to unpredictable behavior.
```

**Recovery Steps:**
1. Reset to safe state values
2. Verify context phase is accurate
3. Re-establish permission through proper approval if needed
4. Document the resolution in context file

**Prevention:**
- Don't manually edit context process variables
- Let Claude manage state transitions
- Follow standard workflows for approvals

#### 2. Context File Drift

**Detection Indicators:**
- Tasks marked incorrectly (completed not marked, etc.)
- Scope or tasks don't match actual work
- Progress description outdated

**Error Message:**
```
⚠️ Context File Drift Detected:
The context file doesn't accurately reflect the current state of work.
This can lead to confusion and tracking issues.
```

**Recovery Steps:**
1. Perform context synchronization:
   ```
   claude "load CLAUDE.md, synchronize context file with current branch state, and continue work"
   ```
2. Update task statuses to reflect actual progress
3. Update progress description and completion percentages
4. Document the resynchronization in context

**Prevention:**
- Update context file at the end of each session
- Mark tasks complete when finished
- Use standard session closure process

### Process Violation Errors

#### 1. Main Branch Modification Attempt

**Detection Indicators:**
- Attempts to modify files while on main branch
- Implementation tasks discussed on main branch

**Error Message:**
```
⛔ Modification Blocked:
The main branch is protected and cannot be directly modified.
All changes require working branches and pull requests.
```

**Recovery Steps:**
1. Identify appropriate feature branch or create new one:
   ```
   git checkout -b feature/[name]
   ```
2. Create context file for new branch if needed
3. Move implementation work to feature branch
4. Use main branch only for facilitation

**Prevention:**
- Verify current branch before attempting modifications
- Use standard branch creation commands for new work
- Remember main branch is for facilitation only

#### 2. Process Stage Skipping

**Detection Indicators:**
- Attempts to move directly to completion without implementation
- Skipping required planning or validation steps

**Error Message:**
```
⚠️ Process Stage Skip Attempted:
The standard workflow requires completing all stages in sequence.
Skipping stages can lead to quality issues and tracking problems.
```

**Recovery Steps:**
1. Identify the proper current stage
2. Complete all requirements for that stage
3. Progress through stages in proper sequence
4. Document stage completion properly

**Prevention:**
- Follow the standard progression of stages
- Complete all required components of each stage
- Use standard commands for stage transitions

## Recovery Verification Process

After recovering from any error, always verify:

1. **State Consistency**:
   - Context file phase matches actual state
   - Implementation flags consistent with phase
   - Task status reflects actual progress

2. **Process Alignment**:
   - Current work aligns with branch purpose
   - Tasks being worked match branch scope
   - Context file tracking matches actual work

3. **Documentation Accuracy**:
   - Last updated date is current
   - Progress description is accurate
   - Next steps are clearly defined

## Error Prevention Best Practices

### 1. Use Standard Command Patterns

Always use the standard Claude command patterns:

```bash
# Starting work on existing branch
claude "load CLAUDE.md, identify branch as $(git branch --show-current), and continue working on [task]"

# Creating new branch for work
claude "load CLAUDE.md, create branch [type]/[name] from main, and implement [feature]"

# Verifying current branch
claude "load CLAUDE.md, verify current branch is [expected-branch], and continue work"
```

### 2. Follow Phase Progression

Always progress through phases in the proper sequence:
1. Planning (with explicit approval)
2. Implementation (after approval)
3. Completion (after all tasks finished)

### 3. Session Management

- Begin sessions with context loading
- End sessions with context updates
- Use /compact with context updates for long sessions

### 4. Keep Documentation Current

- Update task statuses as work progresses
- Document key decisions when made
- Update progress descriptions regularly
- Maintain accurate next steps

### 5. Respect Scope Boundaries

- Keep work within defined branch scope
- Create new branches for out-of-scope work
- Document scope changes when necessary
- Update task assignments to match scope

## For Claude: Custom Error Recovery Protocols

```
FUNCTION: Handle Planning Approval Errors
TRIGGER: Any planning approval issues

DETECT approval_issue_type:
    SCAN error_context for specific_indicators
    CLASSIFY as:
        - incorrect_phrase_error
        - premature_implementation_error
        - phase_inconsistency_error
        - manual_edit_error
        
PROCESS incorrect_phrase_recovery:
    EXTRACT attempted_phrase from user_message
    RESPOND "To unlock implementation, please use the EXACT phrase with proper capitalization:
             'I APPROVE THE PLANNING PHASE'
             
             Your phrase (${attempted_phrase}) was close but must match exactly as a security measure."
             
PROCESS premature_implementation_recovery:
    VERIFY planning_section_complete
    IF planning_section_complete:
        PRESENT planning_details_for_review
        REQUEST exact_approval
    ELSE:
        IDENTIFY missing_planning_components
        RESPOND "The planning section must be completed before approval.
                Please add the following missing components:
                [missing_components as list]"
                
PROCESS phase_inconsistency_recovery:
    SET context_phase = "Planning"
    SET IMPLEMENTATION_ALLOWED = FALSE
    SET planning_approval = FALSE
    UPDATE context_file with corrected phase
    RESPOND "I've detected an inconsistency between the recorded phase and approval state.
             I've reset to a consistent Planning phase state for security reasons.
             Please complete the standard approval process to proceed."
             
PROCESS manual_edit_recovery:
    DETECT edited_fields in context_file
    REVERT edited_fields to consistent values
    DOCUMENT recovery in context_file
    RESPOND "I've detected manual changes to protected fields in the context file.
             These have been reverted to maintain system integrity.
             Please use standard workflows to manage state transitions."
```