# Claude Code CLI Toolkit - Claude Guidance

> - _did-original-source_: `did:repo:ca85b5ea9bc63cc8229c073d8f6a3faae8062a77/blob/main/CLAUDE.md`
> - _github-original-source_: `https://github.com/ChristopherA/Claude-Code-CLI-Toolkit/blob/main/CLAUDE.md`
> - _purpose_: Provide guidance for Claude when working with the Claude Code CLI Toolkit
> - _copyright_: ©2025 by @ChristopherA, licensed under the [BSD 2-Clause Plus Patent License](https://spdx.org/licenses/BSD-2-Clause-Patent.html)
> - _created_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>
> - _last-updated_: 2025-03-30 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>
> - _version_: v0.1.03

## DEVELOPER GUIDE

This document provides essential guidance for working with the Claude Code CLI Toolkit, explaining how Claude helps maintain context and facilitate development workflows.

### Purpose and Architecture

The Claude Code CLI Toolkit implements process frameworks that help Claude:

1. **Maintain Context Awareness**: Track current branch, context file state, and approval status
2. **Ensure Process Compliance**: Enforce planning before implementation
3. **Facilitate Workflows**: Streamline branch management, PR reviews, and context lifecycle
4. **Recover from Errors**: Detect and remediate workflow issues

The process framework architecture uses a standardized structure:
- **Global Framework**: Branch context management and phase detection
- **Self-Contained Process Blocks**: Specialized workflows for common operations
- **Natural Language Detection**: Pattern recognition for more intuitive interaction

### Role Distinctions

This toolkit distinguishes between three roles with different objectives:

**User**: Someone using a project created with this toolkit
- Primary concern: Using the application/project functionality
- Typically doesn't interact with Claude or context system
- May use features implemented with Claude's assistance

**Developer**: Someone building or maintaining a project with this toolkit
- Primary concern: Implementing features, fixing bugs, enhancing functionality
- Regular interaction with Claude using natural language or ceremonial patterns
- Works with context files and follows branch workflows

**Maintainer**: Someone responsible for toolkit infrastructure
- Primary concern: Managing project structure, workflows, and processes
- May extend or customize process frameworks
- Manages context lifecycle and ensures project organization

### Repository Structure

The toolkit organizes project files into a structured hierarchy:

- **CLAUDE.md**: Process framework definitions and developer guidance (this file)
- **DEVELOPER_GUIDE.md**: Development model definitions and workflow reference
- **README.md**: Project overview and getting started information
- **WORK_STREAM_TASKS.md**: Task tracking and management
- **contexts/**: Branch-specific context files that track work state
  - **active/**: Currently active work contexts
  - **futures/**: Planned future work
  - **archived.md**: Record of completed work
- **requirements/guides/**: Detailed process documentation
- **scripts/**: Utility scripts for Git operations and setup

### Interacting with Claude

You can interact with Claude using either ceremonial or conversational patterns:

#### Ceremonial Pattern Examples:
```bash
# Starting a new feature
claude "load CLAUDE.md, create branch feature/auth from main, and implement user authentication"

# Continuing work on a branch
claude "load CLAUDE.md, verify current branch is feature/auth, and continue implementation"

# Approving planning phase
claude "load CLAUDE.md, verify current branch is feature/auth, and approve planning phase"
```

#### Conversational Pattern Examples:
```bash
# Starting a new feature
claude "our project needs user authentication, let's create a branch and implement it"

# Continuing work on a branch
claude "let's continue working on the authentication feature we started"

# Approving planning phase
claude "I've reviewed the auth feature plan and I APPROVE THE PLANNING PHASE"
```

Both styles work equally well - choose the approach that feels most natural for your workflow.

## For Claude: Process Detection and Execution Framework

### Global Framework
```
FUNCTION: Branch Context Management
TRIGGER: Any request requiring branch context awareness OR
         Messages containing phrases like "our project" OR
         Messages mentioning branch operations OR
         Messages indicating implementation intent OR
         Messages containing approval phrases

STATE_VARIABLES:
    current_branch = ""
    context_phase = ""
    planning_approval = FALSE
    requested_action = ""
    protection_violation = FALSE
    has_git_folder = TRUE
    bootstrap_needed = FALSE
    user_intent = ""
    branch_mentioned = ""
    feature_mentioned = ""
    implementation_phrases = []

INITIALIZATION:
    EXECUTE "[ -d .git ] && echo 'true' || echo 'false'" -> has_git_folder_str
    SET has_git_folder = (has_git_folder_str == "true")
    
    IF has_git_folder:
        EXECUTE "git branch --show-current" -> current_branch
    ELSE:
        SET bootstrap_needed = TRUE
        SET current_branch = "bootstrap"
    
BRANCH DETECTION:
    IF bootstrap_needed:
        EXECUTE bootstrap_process
    ELSE IF current_branch == "main":
        EXECUTE main_branch_protection_process
    ELSE:
        EXECUTE working_branch_context_process

PROCESS bootstrap_process:
    DETECT bootstrap_md_exists = check if "bootstrap.md" exists
    IF bootstrap_md_exists:
        RESPOND "I notice this repository doesn't have a .git folder yet. 
                Let me guide you through the initial setup process."
        EXECUTE bootstrap_md_guidance
    ELSE:
        RESPOND "I notice this repository doesn't have a .git folder, 
                but I can't find bootstrap.md. Please ensure you have 
                the complete toolkit files."

PROCESS main_branch_protection_process:
    // Enhanced action detection with natural language patterns
    DETECT requested_action from user_request with improved pattern matching:
        "file_modification" = (
            message contains edit/create/update/modify/implement/fix/add AND
            message does not contain "context file" AND
            message does not contain "in PR" AND
            message does not contain "on branch" other than main
        )
        "pr_review" = (
            message contains "review PR" OR "check PR" OR "look at PR" OR
            message contains "PR #" OR "pull request" OR
            message mentions reviewing changes OR
            message asks for opinions on code/changes
        )
        "context_lifecycle" = (
            message contains "context" AND (
                "activate" OR "archive" OR "synchronize" OR "manage" OR "lifecycle"
            ) OR
            message contains "future context" OR "completed context" OR
            message suggests context management operations
        )
        "branch_creation" = (
            message suggests creating or starting new work OR
            message discusses new features without mentioning branch OR
            message mentions implementing completely new functionality
        )
    
    // Process detected action
    IF requested_action == "file_modification":
        SET protection_violation = TRUE
        RESPOND with branch_protection_warning
        OFFER branch_selection_options
    ELSE IF requested_action == "pr_review":
        EXECUTE pr_review_facilitation
    ELSE IF requested_action == "context_lifecycle":
        EXECUTE context_lifecycle_facilitation
    ELSE IF requested_action == "branch_creation":
        OFFER branch_creation_options
    ELSE:
        EXECUTE general_facilitation

PROCESS working_branch_context_process:
    // Detect feature/task intent from natural language
    EXTRACT feature_mentioned = CHECK if message contains specific feature/task names
    EXTRACT implementation_intent = CHECK if message suggests implementation/coding activity
    
    // Map branch name to likely context file with flexible matching
    DETECT context_file_exists = check if "contexts/[branch-type]-[branch-name]-context.md" exists
    
    // If no context file but we can detect intent, offer context creation
    IF !context_file_exists:
        IF feature_mentioned != "":
            SUGGEST "I notice you're working on [feature_mentioned] but I don't see a context file for it."
        EXECUTE context_creation_facilitation
        RETURN
        
    LOAD context_file for current_branch
    DETECT context_phase from context_file
    
    // Initialize the critical implementation gate flag
    SET IMPLEMENTATION_ALLOWED = FALSE
    
    // Enhanced approval detection with multiple patterns
    IF context_phase == "Planning":
        DETECT planning_approval from context_file
        IF planning_approval == FALSE:
            // Check for explicit approval command with flexible patterns
            IF "I APPROVE THE PLANNING PHASE" found in latest_user_message OR
               message contains "approve" AND "plan" AND current_branch OR
               message indicates clear approval of planning with reference to current work:
                
                SET planning_approval = TRUE
                SET IMPLEMENTATION_ALLOWED = TRUE
                UPDATE context_file planning_approval_section
                RESPOND "✅ Planning phase approved! The implementation gate has been unlocked."
            ELSE:
                // Check if user intent suggests implementation without approval
                IF implementation_intent == TRUE:
                    RESPOND with planning_approval_request
                    INCLUDE brief_plan_summary from context_file
                    // Block implementation until approved
                    RETURN
                ELSE:
                    // User might be reviewing the plan, provide helpful context
                    PROVIDE plan_summary_from_context
        ELSE:
            SET IMPLEMENTATION_ALLOWED = TRUE
            CONTINUE with requested_work
    ELSE:
        SET IMPLEMENTATION_ALLOWED = TRUE
        CONTINUE with requested_work
        
    // File modification guard - critical security mechanism
    BEFORE ANY Edit/Replace/Bash tool use:
        IF context_phase == "Planning" && IMPLEMENTATION_ALLOWED == FALSE:
            BLOCK TOOL EXECUTION
            RESPOND "⛔ Implementation blocked: Planning phase requires approval.
                     Please review the plan and approve with phrase:
                     'I APPROVE THE PLANNING PHASE'"
            EXIT FUNCTION
            
    // Enhanced continuation logic based on natural language
    IF implementation_intent == TRUE:
        CHECK current_tasks from context_file
        IDENTIFY next_logical_task based on completion status and dependencies
        SUGGEST "Based on the context file, the next logical task would be: [next_logical_task]"

VALIDATION:
    IF has_git_folder:
        VERIFY correct_branch_detection = (current_branch matches git status)
        VERIFY correct_context_loading = (context_file exists for branch)
        VERIFY correct_phase_detection = (context_phase matches context file)
        
        IF any verification fails:
            EXECUTE recovery_process

ON ERROR:
    IF bootstrap_needed:
        RESPOND "I encountered an issue with the bootstrap process. Let's take a step back and try a more direct approach."
        PROVIDE simplified_bootstrap_instructions
    ELSE IF current_branch == "main":
        RESPOND "I encountered an issue while processing your request on the main branch.
                Since this is a protected branch, I'll help you select a working branch
                where we can proceed with your task safely."
        EXECUTE branch_selection_facilitation
    ELSE:
        RESPOND "I encountered an issue while processing your request.
                Let me try to recover the context state."
        EXECUTE context_recovery_process

PATTERNS:
    branch_protection_warning = "I notice we're attempting to modify files while on the protected main branch. 
    The main branch cannot be directly modified - all changes require pull requests.
    Instead, I can help you:
    1. Select an existing branch to work on
    2. Create a new branch for this work
    3. Prepare a PR from another branch"

    planning_approval_request = "The planning phase for this work needs approval before we can proceed with implementation.
    Please review the planning details above and if you approve, respond with the exact phrase:
    'I APPROVE THE PLANNING PHASE'"
```

### Self-Contained Process Blocks

#### PROCESS_BLOCK: Bootstrap Guidance
```
FUNCTION: Guide user through initial repository setup
TRIGGER: Repository without .git folder and bootstrap.md exists

STATE_VARIABLES:
    bootstrap_step = "initialize"
    project_name = ""
    primary_language = ""
    development_model = "Team"
    setup_scripts_run = FALSE
    github_setup_needed = FALSE
    all_files_updated = FALSE
    
INITIALIZATION:
    DETECT bootstrap_md_exists = check if "bootstrap.md" exists
    IF !bootstrap_md_exists:
        EXIT FUNCTION
        
    LOAD "bootstrap.md" -> bootstrap_content
    
PROCESS bootstrap_initialization:
    RESPOND "I notice this is a fresh repository without a .git folder. 
            Let me help you set up this project using the Claude Code CLI Toolkit.
            
            First, I need to gather some basic information about your project:"
            
    ASK "What name would you like to use for this project?"
    DETECT project_name from user response
    
    ASK "What is the primary programming language for this project?"
    DETECT primary_language from user response
    
    ASK "Which development model would you prefer: 'Solo' (simpler) or 'Team' (more comprehensive)?"
    DETECT development_model from user response
    
    VERIFY development_model in ["Solo", "Team"]
    IF !verified:
        SET development_model = "Team"
        
    RESPOND "Great! Now I'll guide you through the setup process in the correct order."

PROCESS script_execution_guidance:
    VERIFY script_exists = check if "scripts/setup_local_git_inception.sh" exists
    
    IF script_exists:
        RESPOND "FIRST: We need to initialize the Git repository.
                Please run this script:
                
                ```bash
                chmod +x scripts/setup_local_git_inception.sh
                ./scripts/setup_local_git_inception.sh
                ```
                
                This must be done before any file modifications."
                
        WAIT for user confirmation
        SET setup_scripts_run = TRUE
    ELSE:
        RESPOND "I can't find the setup script. Please verify the toolkit files are complete."
        EXIT FUNCTION
        
    ASK "Would you like to set up a GitHub remote repository as well? (yes/no)"
    DETECT github_setup_needed from user response
    
    IF github_setup_needed:
        VERIFY github_script_exists = check if "scripts/create_github_remote.sh" exists
        
        IF github_script_exists:
            RESPOND "SECOND: Let's set up your GitHub remote repository.
                    Please run:
                    
                    ```bash
                    chmod +x scripts/create_github_remote.sh
                    ./scripts/create_github_remote.sh
                    ```"
                    
            WAIT for user confirmation
        ELSE:
            RESPOND "I can't find the GitHub setup script. We'll skip this step."

PROCESS file_updates:
    AFTER script execution:
        RESPOND "Now that we have the Git repository initialized, let's update the project files with your information."
        
        UPDATE_STEPS = [
            "Create a feature branch for setup: git checkout -b feature/project-setup",
            "Update README.md with project info",
            "Update CLAUDE.md with project name",
            "Update PROJECT_GUIDE.md with development model",
            "Update all placeholder dates with today's date",
            "Update WORK_STREAM_TASKS.md with project name"
        ]
        
        PRESENT UPDATE_STEPS to user
        
        GUIDE user through each step with specific instructions
        SET all_files_updated = TRUE

PROCESS bootstrap_completion:
    AFTER file updates:
        RESPOND "Congratulations! Your project is now set up with:
                
                - Project name: [project_name]
                - Primary language: [primary_language]
                - Development model: [development_model]
                - Git repository initialized
                - Project files customized
                
                IMPORTANT: As a final step, you should delete bootstrap.md as it's no longer needed:
                
                ```bash
                git rm bootstrap.md
                git commit -m 'Remove bootstrap.md after setup completion'
                ```
                
                You're now ready to start development using the project context system!"

VALIDATION:
    AFTER bootstrap_completion:
        VERIFY git_initialized = check if ".git" folder exists
        VERIFY bootstrap_removed = check if "bootstrap.md" removed
        
        IF !git_initialized:
            ALERT "Warning: Git repository doesn't appear to be properly initialized"
        IF !bootstrap_removed:
            REMIND "Don't forget to remove bootstrap.md when you're done with setup"

ON ERROR:
    RESPOND "I encountered an issue during the bootstrap process. Let's try a more direct approach:"
    GUIDE user through manual setup steps:
        "1. Initialize git repository: git init"
        "2. Create initial commit: git add . && git commit -m 'Initial commit'"
        "3. Create feature branch: git checkout -b feature/project-setup"
        "4. Update project files manually"

EXPECTED OUTPUTS:
    successful_bootstrap = "Congratulations! Your project is now set up with:
                          
                          - Project name: [project_name]
                          - Primary language: [primary_language]
                          - Development model: [development_model]
                          - Git repository initialized
                          - Project files customized"
                          
    cleanup_reminder = "IMPORTANT: Don't forget to delete bootstrap.md as it's no longer needed:
                       
                       ```bash
                       git rm bootstrap.md
                       git commit -m 'Remove bootstrap.md after setup completion'
                       ```"
```

#### PROCESS_BLOCK: Branch Selection Facilitation
```
FUNCTION: Facilitate branch selection when on main branch
TRIGGER: User requests work on a feature/task while on main

STATE_VARIABLES:
    existing_branches = []
    future_contexts = []
    selected_option = ""
    selected_branch = ""
    branch_type = ""
    branch_name = ""
    
INITIALIZATION:
    EXECUTE "git branch" -> existing_branches
    EXECUTE "ls contexts/futures/" -> future_contexts_files
    PARSE future_contexts_files -> future_contexts

PROCESS option_presentation:
    RESPOND "Since we're on the main branch which is protected, we need to select a working branch. Here are your options:
    
    1. Continue work on an existing branch
    2. Create a new branch from main for this work
    3. Start work on a planned feature from a future context
    
    Which option would you prefer?"
    
    DETECT user_selection from response
    SET selected_option = user_selection

PROCESS option_handling:
    IF selected_option == "1" || selected_option contains "existing":
        EXECUTE existing_branch_selection
    ELSE IF selected_option == "2" || selected_option contains "new":
        EXECUTE new_branch_creation
    ELSE IF selected_option == "3" || selected_option contains "future":
        EXECUTE future_context_activation
    ELSE:
        RESPOND "I didn't understand your selection. Let's try again."
        RESTART option_presentation

PROCESS existing_branch_selection:
    PRESENT existing_branches to user
    DETECT selected_branch from user response
    
    VERIFY branch_exists = (selected_branch in existing_branches)
    IF !branch_exists:
        RESPOND "That branch doesn't appear to exist. Let's try again."
        RESTART existing_branch_selection
    
    GUIDE user: "To switch to this branch, use: git checkout [selected_branch]"
    AFTER user confirms switch:
        EXECUTE "git branch --show-current" -> current_branch
        VERIFY current_branch == selected_branch
        LOAD corresponding context file

PROCESS new_branch_creation:
    ASK "What type of branch is this? (feature, fix, docs, etc.)"
    DETECT branch_type from user response
    
    ASK "What name would you like for this branch?"
    DETECT branch_name from user response
    
    GUIDE user: "To create this branch, use: git checkout -b [branch_type]/[branch_name]"
    AFTER user confirms creation:
        EXECUTE "git branch --show-current" -> current_branch
        VERIFY current_branch == "[branch_type]/[branch_name]"
        CREATE new context file
        BEGIN planning phase

PROCESS future_context_activation:
    PRESENT future_contexts to user
    DETECT selected_context from user response
    
    VERIFY context_exists = (selected_context in future_contexts)
    IF !context_exists:
        RESPOND "That context doesn't appear to exist. Let's try again."
        RESTART future_context_activation
    
    EXTRACT branch_name from selected_context
    GUIDE user: "To create this branch, use: git checkout -b [branch_name]"
    AFTER user confirms creation:
        EXECUTE "git branch --show-current" -> current_branch
        VERIFY current_branch == branch_name
        GUIDE user: "Now move the context file with: git mv contexts/futures/[selected_context] contexts/"
        LOAD moved context file
        BEGIN planning phase verification

VALIDATION:
    VERIFY branch_transition_successful = (current_branch != "main")
    IF !branch_transition_successful:
        RESPOND "It appears we're still on the main branch. Let's try another approach."
        RESTART option_presentation

ON ERROR:
    RESPOND "I encountered an issue while helping you select a branch. Let's try a simpler approach."
    PRESENT basic_branch_options to user
    GUIDE user through manual branch selection/creation

EXPECTED OUTPUTS:
    successful_transition = "Great! You're now on the [branch_name] branch and ready to work.
                           I've loaded the corresponding context file and we can continue with [specific_task]."
    
    creation_success = "Your new branch [branch_type]/[branch_name] has been created.
                      I've created a new context file with the planning phase ready for you to complete."
                      
    future_activation = "You've successfully activated the future context [selected_context].
                        Let's review the planning details and proceed with implementation."
```

#### PROCESS_BLOCK: Planning Phase Management
```
FUNCTION: Manage planning phase approval and transition
TRIGGER: Context in Planning phase requires approval

STATE_VARIABLES:
    context_file_path = ""
    planning_section_complete = FALSE
    planning_section = {}
    missing_elements = []
    has_problem_statement = FALSE
    has_approach = FALSE
    has_success_criteria = FALSE
    has_implementation_phases = FALSE
    user_approval = FALSE
    current_date = ""
    
INITIALIZATION:
    EXECUTE "git branch --show-current" -> current_branch
    SET context_file_path = "contexts/[branch-type]-[branch-name]-context.md"
    EXECUTE "date +%Y-%m-%d" -> current_date
    
PROCESS planning_verification:
    LOAD context_file_path -> context_content
    EXTRACT "Planning" section -> planning_section
    
    VERIFY has_problem_statement = planning_section contains "What We're Solving" with content
    VERIFY has_approach = planning_section contains "Our Approach" with content
    VERIFY has_success_criteria = planning_section contains "Definition of Done" with at least 2 items
    VERIFY has_implementation_phases = planning_section contains "Implementation Phases" with sequence
    
    IF !has_problem_statement:
        ADD "Problem Statement" to missing_elements
    IF !has_approach:
        ADD "Approach Description" to missing_elements
    IF !has_success_criteria:
        ADD "Success Criteria (at least 2 items)" to missing_elements
    IF !has_implementation_phases:
        ADD "Implementation Phases" to missing_elements
        
    IF missing_elements is empty:
        SET planning_section_complete = TRUE

PROCESS completion_request:
    IF !planning_section_complete:
        RESPOND "The planning section needs to be completed before implementation can begin.
                 Please add the following missing elements:
                 [missing_elements formatted as list]"
                 
        PROVIDE example_planning_section
        RETURN
    
PROCESS approval_request:
    IF planning_section_complete:
        EXTRACT problem_statement from planning_section
        EXTRACT approach from planning_section
        EXTRACT success_criteria from planning_section
        EXTRACT implementation_phases from planning_section
        
        RESPOND "I've reviewed the planning for [current_branch]:
                
                 Problem: [problem_statement]
                 Approach: [approach]
                 Success Criteria: [success_criteria formatted as list]
                 Implementation Phases: [implementation_phases formatted as list]
                
                 Do you approve this plan so we can begin implementation?"
                 
        DETECT user_approval from response
        
PROCESS plan_approval:
    IF user_approval == TRUE:
        UPDATE context_file:
            SET "Planning approved - Ready to implement ([current_date])" to checked
            SET "Phase: Implementation" in Current Status section
            
        RESPOND "Great! The plan has been approved and we're now in the Implementation phase.
                 Let's begin with the first implementation phase: [first_implementation_phase]"
                 
        BEGIN implementation of first phase

VALIDATION:
    VERIFY context_file_updated = (context_file contains approval date)
    VERIFY phase_updated = (context_file contains "Phase: Implementation")
    
    IF !context_file_updated || !phase_updated:
        RESPOND "I had trouble updating the context file. Let's try again."
        EXECUTE context_file_update_recovery

ON ERROR:
    RESPOND "I encountered an issue while processing the planning phase.
             Let me try an alternative approach to verify and update the planning status."
    EXECUTE simplified_planning_process

EXPECTED OUTPUTS:
    missing_elements_response = "The planning section needs to be completed before implementation can begin.
                                Please add the following missing elements:
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
                       
                       Do you approve this plan so we can begin implementation?"
                       
    approval_confirmation = "Great! The plan has been approved and we're now in the Implementation phase.
                            Let's begin with the first implementation phase: [first_implementation_phase]"
```

#### PROCESS_BLOCK: PR Review Facilitation
```
FUNCTION: Help review a pull request while on main branch
TRIGGER: "help review PR #X" command while on main branch

STATE_VARIABLES:
    pr_number = 0
    pr_details = {}
    pr_files = []
    pr_checks = {}
    review_decision = ""
    selected_option = ""
    selected_files = []
    feedback_points = []
    potential_issues = []
    
INITIALIZATION:
    EXTRACT pr_number from trigger command
    VERIFY pr_number is valid integer
    
PROCESS pr_examination:
    EXECUTE "gh pr view [pr_number]" -> pr_details
    EXECUTE "gh pr diff [pr_number]" -> pr_diff
    EXECUTE "gh pr checks [pr_number]" -> pr_checks
    EXECUTE "gh pr files [pr_number]" -> pr_files
    
    VERIFY pr_exists = (pr_details contains PR title and description)
    IF !pr_exists:
        RESPOND "I couldn't find PR #[pr_number]. Please verify the PR number and try again."
        EXIT FUNCTION

PROCESS structured_overview:
    EXTRACT pr_title from pr_details
    EXTRACT pr_description from pr_details
    EXTRACT pr_author from pr_details
    EXTRACT pr_branch from pr_details
    EXTRACT files_changed from pr_files
    
    SCAN pr_description and pr_diff for:
        implementation_choices
        major_changes
        potential_issues
    
    GENERATE pr_summary = {
        title: pr_title,
        author: pr_author,
        branch: pr_branch,
        files_changed: files_changed,
        key_changes: major_changes,
        implementation_choices: implementation_choices
    }
    
    RESPOND "PR #[pr_number]: [pr_title] by [pr_author]
            
             Branch: [pr_branch]
             Files Changed: [files_changed formatted as list]
             
             Key Changes:
             [major_changes formatted as list]
             
             Implementation Choices:
             [implementation_choices formatted as list]
             
             Would you like me to:
             1. Examine specific files in detail
             2. Check for potential issues
             3. Help you approve the PR
             4. Help you request changes to the PR"
             
    DETECT selected_option from user response

PROCESS review_guidance:
    IF selected_option == "1" || selected_option contains "files" || selected_option contains "examine":
        PRESENT files_changed to user
        DETECT selected_files from user response
        
        FOR each file in selected_files:
            EXECUTE "gh pr diff [pr_number] -- [file]" -> file_diff
            ANALYZE file_diff for:
                code_patterns
                potential_issues
                logic_changes
            PRESENT analysis to user
        
        RETURN to option presentation
        
    ELSE IF selected_option == "2" || selected_option contains "issues" || selected_option contains "check":
        CHECK pr_diff and pr_files for:
            code_style_issues
            test_coverage
            documentation_updates
            attribution_standards
        
        RESPOND with findings
        RETURN to option presentation
        
    ELSE IF selected_option == "3" || selected_option contains "approve":
        SET review_decision = "approve"
        EXECUTE decision_process
        
    ELSE IF selected_option == "4" || selected_option contains "changes" || selected_option contains "request":
        SET review_decision = "request_changes"
        EXECUTE decision_process
        
    ELSE:
        RESPOND "I didn't understand your selection. Let's try again."
        RESTART option presentation

PROCESS decision_process:
    IF review_decision == "approve":
        ASK "Would you like to add any comments to your approval?"
        DETECT approval_comment from user response
        
        GUIDE user "To approve this PR, use: gh pr review [pr_number] --approve -c \"[approval_comment]\""
        
    ELSE IF review_decision == "request_changes":
        ASK "What changes would you like to request for this PR?"
        DETECT feedback_points from user response
        
        GUIDE user "To request changes, use: gh pr review [pr_number] --request-changes -c \"[feedback_points formatted as list]\""

VALIDATION:
    VERIFY command_execution = (gh commands executed successfully)
    IF !command_execution:
        RESPOND "There was an issue executing the gh commands. Please ensure the GitHub CLI is correctly installed and configured."
        PROVIDE alternative_instructions

ON ERROR:
    RESPOND "I encountered an issue while helping you review the PR. Let's try a more direct approach."
    PRESENT simplified_pr_review_options
    GUIDE user through manual review process

EXPECTED OUTPUTS:
    pr_overview = "PR #12: Add user authentication by johndoe
                  
                  Branch: feature/user-auth
                  Files Changed:
                  - src/auth/user.js
                  - src/auth/tests/user.test.js
                  - src/config/auth.js
                  
                  Key Changes:
                  - Added JWT-based authentication
                  - Implemented password hashing
                  - Added user session management
                  
                  Implementation Choices:
                  - Used bcrypt for password handling
                  - Implemented stateless JWT approach
                  - Added test cases for auth failures
                  
                  Would you like me to:
                  1. Examine specific files in detail
                  2. Check for potential issues
                  3. Help you approve the PR
                  4. Help you request changes to the PR"
```

#### PROCESS_BLOCK: Context Lifecycle Management
```
FUNCTION: Facilitate context lifecycle transitions
TRIGGER: Context lifecycle management request while on main branch

STATE_VARIABLES:
    current_branch = ""
    future_contexts = []
    active_contexts = []
    completed_contexts = []
    operation_type = ""
    selected_context = ""
    branch_name = ""
    
INITIALIZATION:
    EXECUTE "git branch --show-current" -> current_branch
    
    VERIFY current_branch == "main"
    IF current_branch != "main":
        RESPOND "Context lifecycle management should be performed from the main branch. You are currently on [current_branch]."
        EXIT FUNCTION
        
    EXECUTE "ls contexts/futures/" -> future_contexts_files
    EXECUTE "ls contexts/ | grep -v 'archived\|futures'" -> active_contexts_files
    
    PARSE future_contexts_files -> future_contexts
    PARSE active_contexts_files -> active_contexts
    
PROCESS operation_selection:
    RESPOND "What type of context lifecycle operation would you like to perform?
    
             1. Activate a future context
             2. Archive a completed context
             3. Synchronize task tracking with contexts"
            
    DETECT operation_type from user response
    
PROCESS lifecycle_operation:
    IF operation_type == "1" || operation_type contains "activate" || operation_type contains "future":
        EXECUTE future_context_activation
        
    ELSE IF operation_type == "2" || operation_type contains "archive" || operation_type contains "completed":
        EXECUTE context_archiving
        
    ELSE IF operation_type == "3" || operation_type contains "synchronize" || operation_type contains "tracking":
        EXECUTE task_synchronization
        
    ELSE:
        RESPOND "I didn't understand your selection. Let's try again."
        RESTART operation_selection

PROCESS future_context_activation:
    IF future_contexts is empty:
        RESPOND "There are no future contexts available for activation."
        EXIT FUNCTION
    
    PRESENT future_contexts to user
    DETECT selected_context from user response
    
    VERIFY context_exists = (selected_context in future_contexts)
    IF !context_exists:
        RESPOND "That context doesn't appear to exist. Let's try again."
        RESTART future_context_activation
    
    EXTRACT branch_name from selected_context
    
    GUIDE user: "To activate this context:
                 1. First create the branch: git checkout -b [branch_name]
                 2. Then move the context file: git mv contexts/futures/[selected_context] contexts/
                 3. Finally commit the change: git commit -m 'Activate [selected_context]'"
                 
    PROVIDE work_stream_update_suggestion based on selected_context

PROCESS context_archiving:
    FOR each context in active_contexts:
        EXTRACT completion_status = CHECK if context contains "Phase: Completion" and all tasks marked complete
        IF completion_status == TRUE:
            ADD context to completed_contexts
    
    IF completed_contexts is empty:
        RESPOND "There are no completed contexts ready for archiving. A context must be in Completion phase with all tasks completed."
        EXIT FUNCTION
    
    PRESENT completed_contexts to user
    DETECT selected_context from user response
    
    VERIFY context_exists = (selected_context in completed_contexts)
    IF !context_exists:
        RESPOND "That context doesn't appear to be a completed context. Let's try again."
        RESTART context_archiving
    
    EXTRACT context_details from selected_context including:
        branch_name
        completion_date
        pr_number if available
        key_accomplishments
        categories
        
    GENERATE archive_entry based on context_details
    
    GUIDE user: "To archive this context:
                 1. First update contexts/archived.md with this entry:
                    [archive_entry formatted per template]
                 2. Then remove the original file: git rm contexts/[selected_context]
                 3. Update WORK_STREAM_TASKS.md to mark the task as completed
                 4. Finally commit these changes: git commit -m 'Archive [selected_context]'"

PROCESS task_synchronization:
    EXECUTE "cat WORK_STREAM_TASKS.md" -> work_stream_tasks
    
    DETECT active_branches from active_contexts
    DETECT tracked_tasks from work_stream_tasks
    
    IDENTIFY untracked_contexts = active_contexts not in tracked_tasks
    IDENTIFY completed_tasks = tasks marked complete in work_stream_tasks but context still active
    
    GENERATE synchronization_plan = {
        add_to_work_stream: untracked_contexts,
        mark_as_completed: completed_tasks,
        update_references: tasks with incorrect branch references
    }
    
    PRESENT synchronization_plan to user
    GUIDE user through implementing synchronization_plan

VALIDATION:
    VERIFY user_understanding = ASK "Does this guidance make sense for managing the context lifecycle?"
    IF !user_understanding:
        PROVIDE simplified_instructions
        
    REMIND user "Remember that these operations should be committed to maintain proper history tracking."

ON ERROR:
    RESPOND "I encountered an issue while facilitating context lifecycle management. Let's try a more basic approach."
    PRESENT simplified_lifecycle_options
    GUIDE user through manual lifecycle management

EXPECTED OUTPUTS:
    future_activation_guidance = "To activate this context:
                                 1. First create the branch: git checkout -b feature/user-auth
                                 2. Then move the context file: git mv contexts/futures/feature-user-auth-context.md contexts/
                                 3. Finally commit the change: git commit -m 'Activate feature-user-auth-context.md'"
                                 
    archive_entry_template = "## feature-user-auth-context.md
                             
                             **Status:** Completed  
                             **Branch:** feature/user-auth  
                             **Completed:** 2025-03-15  
                             **Archived:** 2025-03-31  
                             **PR:** #42 (Merged 2025-03-16)  
                             **Categories:** Authentication, Security
                             
                             Added JWT-based user authentication with secure password handling
                             and comprehensive test coverage for all authentication flows.
                             
                             **Key Accomplishments:**
                             - Implemented secure password hashing with bcrypt
                             - Added JWT token generation and validation
                             - Created comprehensive test suite for auth flows
                             - Added user session management
                             
                             **Related Contexts:** feature-user-profile, feature-permissions
                             
                             [View archived context](https://github.com/org/repo/blob/commit-hash/contexts/feature-user-auth-context.md)"
```

This document provides essential guidance for Claude when working with the Claude Code CLI Toolkit.

## Repository Structure

This repository contains files that serve as both documentation for the toolkit and as a starting point for new projects:

- CLAUDE.md - This file with guidance for Claude
- README.md - Documentation about the toolkit
- PROJECT_GUIDE.md - Guide for project state and workflows
- WORK_STREAM_TASKS.md - Task tracking file
- contexts/ - Context management files
- requirements/guides/ - Detailed workflow guides
- scripts/ - Utility scripts for Git operations
- untracked/ - Files not included in version control

<!-- Note for Claude: This section helps you understand the overall repository structure. You should familiarize yourself with each component to provide effective assistance. -->

## Project Setup Process

There are two states for this repository:

1. **Starting state**: No .git folder - user has cloned the toolkit and deleted .git to start fresh
2. **Running state**: When set up as a user's own project with its own Git repository

When a user first runs Claude with this toolkit:
- Check if the .git folder exists - if not, guide them through bootstrap.md
- IMPORTANT: Run the setup scripts FIRST before any file modifications
- After script execution, check for existing context files and prioritize those workflows
- After bootstrap completion, remind the user to delete bootstrap.md
- Remove bootstrap.md references from CLAUDE.md after setup is complete

<!-- Note for Claude: Always check if the repository is in starting state (no .git folder) or running state. The bootstrap process is a ONE-TIME process that should only be performed in starting state. NEVER modify files while on the main branch. ALWAYS check .gitignore before suggesting files to commit. NEVER commit files in the /untracked directory or system files like .DS_Store. -->

### Untracked Files Safety Practices

When working with untracked files:

1. **Never suggest committing** files from these directories:
   - /untracked/ - For temporary and sensitive files
   - /sandbox/ - For experimental code
   - /tmp/ - For transient files

2. **Recommend appropriate locations** for sensitive content:
   - API keys, tokens, credentials → /untracked/credentials/
   - Large datasets → /untracked/data/
   - Local configuration → config.local.* files

3. **Use clear file naming conventions**:
   - Prefix sensitive files with _private_ (e.g., _private_api_keys.json)
   - Use .local extension for machine-specific files

4. **ALWAYS alert users** when they attempt to commit files from untracked locations

### New Project Setup

If bootstrap.md is present, and no .git folder exists, help the user through these steps **IN THIS EXACT ORDER**:

1. **FIRST: Help initialize Git repository**:
   - Guide user to run setup_local_git_inception.sh
   - This MUST be done before any file modifications
   - After execution, remind them this script can be deleted

2. **SECOND: Help set up GitHub (if requested)**:
   - Guide user to run create_github_remote.sh
   - After execution, remind them this script can be deleted

3. **THIRD: Check for existing context files**:
   - Look for files in the contexts/ directory
   - Create branches for any existing context files
   - Prioritize creating branches for any context files that exist
   - Never attempt to modify files while on the main branch

4. Gather project information:
   - Project name
   - Primary programming language
   - Preferred development model (Solo/Team)

5. Update all files with project information:
   - Create appropriate feature branch before making any changes
   - Update file headers with project name
   - Set language in appropriate files
   - Configure development model
   - Update creation date (replace all <!-- START_DATE --> placeholders with today's date in YYYY-MM-DD format)
   - Always check .gitignore before suggesting files to commit
   - Never commit files in /untracked or system files like .DS_Store

6. Complete setup:
   - Remind user to delete bootstrap.md
   - Remove references to bootstrap.md from this file
   - Transition to PROJECT_GUIDE.md for ongoing work

<!-- Note for Claude: The bootstrap process should be completed in a single session if possible. Always replace <!-- START_DATE --> placeholders with the actual project creation date in YYYY-MM-DD format during setup. After setup, NEVER refer to bootstrap.md again. -->

## Toolkit Usage

There are two main ways to use this repository:

1. **As a Reference**: Help users understand Claude-assisted development practices
2. **As a Starting Point**: Help users set up new projects based on these files

## Development Model

The current development model for this project is: **_development-model: Team_** <!-- REPLACE_WITH_MODEL -->

See PROJECT_GUIDE.md for the full description of development models and detailed workflows.

### Context Adaptation Based on Model

Claude should adapt context management practices based on the development model:

- **Solo Model**: Use simplified context files focused on current state and next steps
- **Team Model**: Use comprehensive context files with detailed implementation notes, scope boundaries, and knowledge transfer sections

Balance context detail with development needs - more detail for team collaboration, streamlined for solo development.

## Quick Reference Commands

Run these commands to check the project status:

```bash
git status                 # Check branch and file status
git branch --show-current  # Show current branch
git log --oneline -n 10    # View recent commit history
```

## Branch-Context Synchronization

CRITICAL: Claude MUST maintain strict synchronization between Git branches and context files at all times.

### Required Checks at Session Start

At the beginning of EVERY session, Claude MUST:

1. **Identify current branch**: 
   ```bash
   git branch --show-current
   ```

2. **Verify or load corresponding context file**:
   - Check if a context file exists for the current branch: `contexts/[branch-name]-context.md`
   - If exists, ALWAYS load and review this context file
   - If missing, alert user and offer to create one using context_guide.md template

3. **Special handling for main branch**:
   - If on main branch, perform these additional checks in sequence:
     1. Check for non-draft PRs and offer to facilitate review/merge
     2. Check for active branches with contexts and offer to switch
     3. Identify context files without branches (new or completed)
     4. If no pressing branch work, focus on WORK_STREAM_TASKS.md

### When Switching Branches

When switching to a different branch, Claude MUST:

1. **Before switching**:
   - Update the current branch's context file with latest status
   - Ensure all relevant changes are committed

2. **After switching**:
   - Immediately check for and load the new branch's context file
   - If no context file exists, create one following context_guide.md
   - Verify the context file accurately reflects branch purpose and status

### Context File Management

- Every branch MUST have a corresponding context file
- Context files MUST be updated before committing changes
- Context file updates SHOULD be committed alongside code changes
- Context files function as the primary work state record

## Error Detection and Recovery

### Common Workflow Errors

Claude MUST detect and assist with recovery from these common workflow issues:

#### Branch-Context Mismatch

When the current branch doesn't match the context file being used:

1. **Detection**:
   - Current branch doesn't match branch name in context file
   - Work being done doesn't align with context file purpose

2. **Recovery Actions**:
   - Alert the user with: "BRANCH-CONTEXT MISMATCH DETECTED"
   - Offer options:
     ```
     1. Switch to branch mentioned in context file
     2. Load correct context file for current branch
     3. Create new context file for current branch
     ```
   - Document the resolution in whichever context file is used

#### Missing Context File

When no context file exists for the current branch:

1. **Detection**:
   - Context file `contexts/[branch-type]-[branch-name]-context.md` doesn't exist

2. **Recovery Actions**:
   - Alert user: "NO CONTEXT FILE FOUND FOR CURRENT BRANCH"
   - Offer to create a context file:
     ```
     To maintain workflow integrity, a context file is needed for this branch.
     Shall I create one now using the template from context_guide.md?
     ```
   - If user agrees, create context file with proper scope boundaries
   - If user declines, issue a warning and continue with limited context awareness

#### Main Branch Development Attempt

When development work is attempted directly on the main branch:

1. **Detection**:
   - Current branch is main
   - User is attempting to modify files (other than contexts or documentation)

2. **Recovery Actions**:
   - Alert user: "DIRECT DEVELOPMENT ON MAIN BRANCH DETECTED"
   - Recommend switching to a feature branch:
     ```
     Development should not be done directly on the main branch.
     Would you like to:
     1. Create a new feature branch for this work
     2. Switch to an existing branch
     3. Continue on main (not recommended)
     ```
   - If user chooses to create a branch, help create context file for new branch

## Claude Session Management

When working with Claude:
1. Start sessions with context verification: `claude "load CLAUDE.md, verify current branch is [branch-name], load appropriate context, and continue project work"`
2. End sessions by updating context files and using `/compact` or `/exit`
3. For long-running sessions, use `/compact` after updating context files

## File Organization
   - `contexts/` - Branch-specific context files
   - `requirements/guides/` - Development workflow guides
   - `scripts/` - Utility scripts for Git and GitHub operations

## Guides and References

For detailed guidance, refer to:
- Development models: `PROJECT_GUIDE.md`
- Task tracking: `requirements/guides/task_tracking_guide.md`
- Context management: `requirements/guides/context_guide.md`
- Git workflow: `requirements/guides/git_workflow_guide.md`
- Initial setup: `bootstrap.md` (remove after setup)

## Important Guidelines

### Attribution Standards

When creating content with Claude's assistance, NEVER include Claude self-references:

1. **Commit Messages**
   - NEVER include "Generated with Claude Code"
   - NEVER include "Co-Authored-By: Claude"
   - ALWAYS use only the user's attribution

2. **Pull Request Descriptions**
   - NEVER include Claude references or attribution
   - NEVER add Claude logos or markers

3. **Documentation**
   - NEVER refer to Claude as the author or contributor
   - ALWAYS present content as the user's work

Check all generated content carefully before finalizing to remove any self-references or attribution to Claude.

<!-- Note for Claude: When helping users with ongoing project work, ALWAYS refer to the appropriate guide for detailed instructions rather than inventing your own approach. This ensures consistency in development practices. -->

## Natural Language Pattern Detection

This toolkit implements a multi-layered approach to detecting user intent from natural language:

### Detection Layers

1. **Goal Detection** - Extracts the primary goal from phrases like "our project is..."
2. **Intent Matching** - Identifies specific intents like "create branch", "review PR", "implement feature"
3. **Context Awareness** - Combines the current branch, conversation context, and project goal
4. **Pattern Recognition** - Matches known patterns for common operations
5. **Action Resolution** - Determines the appropriate process to execute

### Common Pattern Categories

- **Project Context Patterns**: "our project", "we're working on", "this project needs"
- **Branch Operation Patterns**: "create branch", "new branch", "switch to branch"
- **Implementation Patterns**: "implement", "add feature", "fix bug", "enhance"
- **Planning Patterns**: "plan for", "design", "approach for", "strategy for"
- **Approval Patterns**: "approve the plan", "looks good", "ready to implement"
- **Lifecycle Patterns**: "complete", "archive", "finish up", "ready for PR"

### Natural Language Variants

The detection system recognizes many ways to express the same intent:

| Intent | Ceremonial Pattern | Natural Language Variants |
|--------|-------------------|----------------------------|
| Create branch | "create branch feature/auth" | "our project needs authentication", "let's add auth features", "implement user login" |
| Continue work | "verify branch feature/auth" | "let's continue with auth", "back to the authentication work", "resume auth feature" |
| Approve plan | "approve planning phase" | "the authentication plan looks good", "the auth approach makes sense", "approve the auth plan" |
| Review PR | "review PR #42" | "check out the changes in PR 42", "what do you think about pull request 42" |

This flexibility allows for more natural conversation while maintaining process integrity.