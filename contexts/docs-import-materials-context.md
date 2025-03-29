# docs/import-materials Context

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
    VERIFY current_branch == "docs/import-materials"
    
    SET context_path = "contexts/docs-import-materials-context.md"
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
- Current branch: docs/import-materials
- Started: <!-- START_DATE -->
- Last updated: <!-- START_DATE -->
- Progress: Not started - ready for document import and organization
- Phase: Planning

## Scope Boundaries
- Primary Purpose: Import, organize, and inventory documentation from untracked sources
- In Scope:
  - Collecting documents from untracked sources
  - Creating an inventory of available documentation
  - Moving documents to appropriate locations in the repository
  - Basic organization and linking of documentation
  - Identifying future documentation work needed
- Out of Scope:
  - Creating new standards (only document existing ones)
  - Rewriting or significantly modifying code files
  - Implementing features or fixes
  - Changing project structure beyond documentation organization
  - Making architectural decisions about the project
- Dependencies:
  - Should be one of the first branches created after repository initialization
  - Does not depend on other feature branches

## Planning
<!-- Complete this section before implementation -->

### What We're Solving
The project needs a structured approach to importing and organizing existing documentation from untracked sources into the repository.

### Our Approach
We'll collect documents from untracked sources, create an inventory, and organize them into a coherent structure while preserving original content.

### Definition of Done
- [ ] All source materials collected in untracked/source_materials
- [ ] Complete inventory of available documentation created
- [ ] Documentation organized in appropriate repository locations
- [ ] Missing documentation areas identified for future work

### Implementation Phases
1. Document Collection → All materials gathered in source_materials directory
2. Document Inventory → Complete inventory with metadata created
3. Documentation Organization → Files moved to appropriate locations
4. Gap Analysis → Missing documentation areas identified

### Approval
- [ ] Planning approved - Ready to implement (YYYY-MM-DD)

## Completed Work
<!-- None yet -->

## Current Tasks
- [ ] **Document Collection**
  - Create `untracked/source_materials` directory for source documents
  - Use `open untracked/source_materials` command to help user open the folder
  - Wait for user confirmation that files have been added
  - Import documents from existing sources
  - Document origins and sources
  - Organize by preliminary categories

- [ ] **Document Inventory**
  - Create document inventory in markdown table
  - Record metadata for each document (status, purpose, completeness)
  - Identify documentation gaps
  - Prioritize documents for processing

- [ ] **Basic Documentation Organization**
  - Evaluate appropriate structure for this specific project
  - Create documentation directory structure
  - Move documents to appropriate locations
  - Update references between documents

- [ ] **Future Work Identification**
  - Create list of documentation tasks needed in future branches
  - Document remaining work in WORK_STREAM_TASKS.md
  - Suggest future branch contexts for specific documentation improvements
  - Prepare branch for PR

<!-- Task format: 
- [ ] Not started
- [~] In progress (with start date in YYYY-MM-DD format)
- [x] Completed (with completion date in YYYY-MM-DD format)
-->

## Key Decisions
<!-- None yet -->

## Notes
### Documentation Structure Options
#### Simple Structure
```
docs/
└── *.md           # All documentation files in single directory
```

#### Comprehensive Structure
```
docs/
├── api/           # API documentation
├── development/   # Development guides
├── usage/         # Usage tutorials
├── reference/     # Reference documentation
└── media/         # Images and other media
```

### Important Guidelines
- This branch focuses ONLY on organizing existing documentation
- Do NOT rewrite scripts or create standards before project definition
- Focus on minimal effective organization without over-engineering
- Mark document status (draft, WIP, complete) but don't extensively rewrite
- If major content changes are needed, note them for future branches

## Error Recovery
- If scope expands beyond documentation: Create new branch for that work
- If documentation requires significant rewriting: Note as future work
- If uncertain about document categorization: Use simple structure initially

## Restart Instructions
To continue this work:
```bash
claude "load CLAUDE.md, verify current branch is docs/import-materials, load appropriate context, and continue working on documentation import and organization"
```

<!-- When ready to create PR for this branch:
```bash
claude "load CLAUDE.md, verify current branch is docs/import-materials, and create a PR to merge into main"
```
-->