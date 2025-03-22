# Git Workflow Quick Reference

> - _did-original-source_: `did:repo:ca85b5ea9bc63cc8229c073d8f6a3faae8062a77/blob/main/requirements/guides/git_workflow_guide.md`
> - _github-original-source_: `https://github.com/ChristopherA/Claude-Code-CLI-Toolkit/blob/main/requirements/guides/git_workflow_guide.md`
> - _purpose_: Provide standard Git commands and workflows for the project
> - _copyright_: ©2025 by @ChristopherA, licensed under the [BSD 2-Clause Plus Patent License](https://spdx.org/licenses/BSD-2-Clause-Patent.html)
> - _created_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>
> - _last-updated_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>

## Essential Git Commands

```bash
# Check status
git status                     # Show current branch and changes
git branch --show-current      # Show only current branch name
git diff --staged              # View staged changes before commit

# Branch operations
git checkout main              # Switch to main branch
git pull                       # Get latest changes
git checkout -b feature/name   # Create new branch
git branch -a                  # List all branches

# Commit workflow
git add file.js                # Stage specific file
git add .                      # Stage all changes (use carefully)
git commit -S -s -m "Message"  # Create signed commit
git push -u origin branch-name # Push new branch
git push                       # Push existing branch
```

<!-- Note for Claude: When helping users with Git operations, always guide them through these specific commands rather than suggesting alternatives that might not follow the project's established practices -->

## Branch Types

| Type | Purpose | Naming | Example |
|------|---------|--------|---------|
| feature | New functionality | feature/name | feature/login |
| fix | Bug fixes | fix/description | fix/header-alignment |
| docs | Documentation | docs/area | docs/api-reference |

## Commit Standards

Every commit must:

1. **Be signed** with SSH/GPG keys using `-S` flag
2. **Include DCO sign-off** using `-s` flag
3. **Follow standard message format** (see below)
4. **Be logically atomic** (one conceptual change per commit)

```bash
git commit -S -s -m "Add user authentication feature" -m "- Implement login form
- Add validation logic"
```

## Commit Message Format

Commit messages MUST follow this format:

```
Add feature X                  # First line: Brief summary in present tense (50 chars max)
                               # Second line: Blank
- Implement login component    # Body: Bullet points of key changes (if needed)
- Add form validation          # Keep each bullet concise and focused
- Create authentication service
```

### Commit Message Requirements

1. **First line must be**:
   - Present tense (Add/Fix/Update, not Added/Fixed/Updated)
   - Maximum 50 characters
   - Descriptive but concise
   - No periods at the end

2. **Body (if needed)**:
   - Separated from summary by blank line
   - Bullet points for complex changes
   - Explain what and why, not how
   - No references to AI assistance

### Logical Atomicity

Commits should represent a single logical change:

1. **Single purpose** - Each commit should do exactly one thing
2. **File cohesion** - Typically involves related files for one feature/fix
3. **Separate unrelated changes** - Create multiple commits for unrelated changes
4. **Reviewable** - Small enough to be easily reviewed

## Context-Integrated Workflows

All Git operations MUST be synchronized with context file management. Every branch MUST have a corresponding context file that is kept up-to-date.

### Feature Development

```bash
# Start feature branch with context
git checkout main
git pull
git checkout -b feature/login

# Create context file immediately after branch creation
# Claude will help with this:
claude "load CLAUDE.md, create context file for branch feature/login, and begin work"

# Make changes and update context before committing
# 1. Update context file with progress
# 2. Stage context file along with code changes
git add contexts/feature-login-context.md
git add src/components/Login.js
git commit -S -s -m "Add login component"

# Push and create PR
git push -u origin feature/login
# Update context file with PR readiness before creating PR
claude "load CLAUDE.md, verify current branch is feature/login, update context for PR creation, and create PR"
```

### Bug Fixing

```bash
# Start fix branch with context
git checkout main
git pull
git checkout -b fix/header-alignment

# Create context file immediately after branch creation
claude "load CLAUDE.md, create context file for branch fix/header-alignment, and begin work"

# Make changes and update context before committing
# 1. Update context file with reproduction steps and fix approach
# 2. Stage context file along with code changes
git add contexts/fix-header-alignment-context.md
git add src/components/Header.css
git commit -S -s -m "Fix header alignment on mobile"

# Push and create PR
git push -u origin fix/header-alignment
# Update context file with PR readiness before creating PR
claude "load CLAUDE.md, verify current branch is fix/header-alignment, update context for PR creation, and create PR"
```

### Documentation Updates

```bash
# Start docs branch with context
git checkout main
git pull
git checkout -b docs/api-reference

# Create context file immediately after branch creation
claude "load CLAUDE.md, create context file for branch docs/api-reference, and begin work"

# Make changes and update context before committing
# 1. Update context file with documentation changes
# 2. Stage context file along with documentation changes
git add contexts/docs-api-reference-context.md
git add docs/api.md
git commit -S -s -m "Add API reference documentation"

# Push and create PR
git push -u origin docs/api-reference
# Update context file with PR readiness before creating PR
claude "load CLAUDE.md, verify current branch is docs/api-reference, update context for PR creation, and create PR"
```

## Pull Request Process with Context Integration

1. **Prepare PR and Context**
   - Complete the PR author checklist:
     ```markdown
     ## PR Author Checklist
     - [ ] Implementation fulfills all requirements
     - [ ] Tests cover critical functionality and edge cases
     - [ ] Documentation is updated to reflect changes
     - [ ] Code follows project standards and patterns
     - [ ] Context file is updated with implementation details
     - [ ] Self-review completed (no debugging artifacts, no TODOs)
     - [ ] Branch is up-to-date with main
     ```
   - Update branch context file with:
     - Mark completed tasks as completed
     - Document key decisions made
     - Include implementation details
     - Note any future work identified

2. **Create Context-Aware PR**
   ```bash
   # First update context file and commit
   claude "load CLAUDE.md, verify current branch is feature/login, update context for PR creation"
   git add contexts/feature-login-context.md
   git commit -S -s -m "Update context for PR"
   
   # Create PR with comprehensive description (use HEREDOC for proper formatting)
   gh pr create --title "Feature: Add login functionality" --body "$(cat <<'EOF'
   ## Summary
   This PR implements user login functionality with secure authentication, 
   password validation, and session management to provide a complete login
   experience for users.
   
   ## Key Improvements
   - Added secure password hashing and validation
   - Implemented JWT-based authentication
   - Created responsive login UI component
   - Added comprehensive form validation
   - Integrated with user database
   
   ## Specific Changes
   - **LoginComponent.js**: Created new component for login form and validation
   - **AuthService.js**: Added authentication logic and session management
   - **UserAPI.js**: Added endpoints for user verification
   - **SecurityUtils.js**: Created password hashing utilities
   
   ## Future Work
   - User registration will be implemented in a separate branch
   - Password reset functionality planned for future release
   - OAuth integration will follow in subsequent work
   
   ## Testing
   The changes have been verified by:
   - Unit tests for authentication logic
   - Integration tests for API endpoints
   - Manual testing of login flow with valid/invalid credentials
   
   ## Type of Change
   - [ ] Bug fix
   - [x] New feature
   - [ ] Documentation
   - [ ] Code improvement
   EOF
   )"
   ```

3. **Comprehensive PR Description**
   Claude will help create a PR by extracting detailed information from your context file to build a comprehensive PR description. When Claude helps create a PR, it should:
   
   - Extract the purpose and scope from context boundaries
   - Use completed work items as the basis for key improvements
   - Reference specific file changes and justifications
   - Note future work items identified during implementation
   - Include testing approaches based on the context
   
   The PR should use the HEREDOC approach shown above for proper formatting, and follow this structure:
   ```
   ## Summary
   A concise 2-3 sentence explanation of what this PR accomplishes and why it matters.
   Focus on the value delivered, not just what was changed.
   
   ## Key Improvements
   - Major improvement 1 with impact
   - Major improvement 2 with impact
   - Major improvement 3 with impact
   - Major improvement 4 with impact
   - Major improvement 5 with impact
   
   ## Specific Changes
   - **File/Area 1**: What changed and why
   - **File/Area 2**: What changed and why
   - **File/Area 3**: What changed and why
   - **File/Area 4**: What changed and why
   
   ## Future Work
   - Any follow-up tasks identified during this work
   - Related improvements planned for future branches
   - Dependencies this PR resolves or creates
   
   ## Testing
   The changes have been verified by:
   - Specific test 1
   - Specific test 2
   - Specific test 3
   
   ## Knowledge Transfer
   - Important implementation details reviewers should know
   - Design patterns or approaches used
   - Potential maintenance considerations
   - Areas that might need special attention or review
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation
   - [ ] Code improvement
   
   ## Checklist
   - [ ] Tests pass
   - [ ] Documentation updated (if needed)
   - [ ] Code follows project style
   - [ ] Context file is up-to-date
   ```
   
   Example of an excellent PR description:
   ```
   ## Summary
   This PR improves the project documentation to better focus on Z_Utils as a Zsh utility
   library, establishes clear priorities for future work, and creates a well-organized
   development roadmap.
   
   ## Key Improvements
   - Clarified Z_Utils purpose and value proposition in documentation
   - Enhanced code examples to demonstrate library usage
   - Established high/medium/low priorities for all tasks
   - Identified critical path dependencies between work streams
   - Created comprehensive context files for all planned branches
   - Added detailed Z_Utils-specific development guidelines
   
   ## Documentation Changes
   - **CLAUDE.md**: Added project overview, clarified development model, added key code
   locations and common development tasks
   - **PROJECT_GUIDE.md**: Focused on Z_Utils-specific workflows and development guidelines
   - **README.md**: Enhanced with detailed feature descriptions, code examples, and clearer
   benefits
   - **WORK_STREAM_TASKS.md**: Reorganized with priorities, task dependencies, and critical path
   analysis
   
   ## Future Work Organization
   - Created draft context files for all planned branches
   - Established documentation and testing as highest priorities
   - Defined clear work items for enhanced functionality and CI/CD setup
   - Organized tasks to minimize dependencies between branches
   
   ## Testing
   The changes have been verified by:
   - Reviewing all documentation for consistency
   - Confirming all links and references are valid
   - Ensuring development workflows are clearly described
   ```

   When creating PRs:
   - Ensure your context file is completely up-to-date
   - Check applicable "Type of Change" boxes that reflect your PR's purpose
   - Leave "Checklist" items unchecked - these will be checked during review
   - The PR description will be populated from your context file
   
   ### Review Feedback Organization
   
   When reviewing PRs, organize feedback in these categories:
   
   ```markdown
   ## Review Feedback
   
   ### Critical Issues (Must Fix)
   - [Issue description and suggested fix]
   
   ### Improvements (Should Fix)
   - [Non-blocking improvement suggestion]
   
   ### Future Considerations (Could Fix Later)
   - [Ideas for future improvements]
   
   ### Questions
   - [Questions about implementation choices]
   
   ### Positive Feedback
   - [Well-implemented aspects worth acknowledging]
   ```

## Safety Tips

- Always check which branch you're on before making changes
- Review changes before committing (`git diff --staged`)
- Never force push to main branch
- Keep commits focused on single logical changes
- Write descriptive commit messages
- Test changes before pushing

<!-- Note for Claude: When helping users with Git operations, emphasize these safety practices, especially verifying the current branch and reviewing changes before committing -->

## Context File Lifecycle Management

Context files track the state of each branch and must be managed throughout the branch lifecycle:

### Context Creation

Always create a context file when creating a new branch:

```bash
# After creating branch
git checkout -b feature/new-feature
claude "load CLAUDE.md, create context file for branch feature/new-feature, and begin work"
```

### Context Updates

Update the context file before making Git commits:

```bash
# Before committing changes
claude "load CLAUDE.md, verify current branch is feature/new-feature, update context with recent changes"

# Include context file in commit
git add contexts/feature-new-feature-context.md
git add [other changed files]
git commit -S -s -m "Implement new feature"
```

### Branch Completion

When a branch is complete and ready for PR:

```bash
# Update context file with completion status
claude "load CLAUDE.md, verify current branch is feature/new-feature, mark tasks complete and prepare for PR"

# Include updated context in final commit
git add contexts/feature-new-feature-context.md
git add [other changed files]
git commit -S -s -m "Finalize new feature implementation"
```

### Context Archiving

After a PR is merged, the context can be archived from main branch:

```bash
# Create a temporary branch for archiving
git checkout main
git pull
git checkout -b housekeeping/archive-contexts

# Archives are stored in docs/archived-contexts
mkdir -p docs/archived-contexts
cp contexts/feature-new-feature-context.md docs/archived-contexts/

# Create PR to archive the context
git add docs/archived-contexts/feature-new-feature-context.md
git commit -S -s -m "Archive completed context for feature/new-feature"
git push -u origin housekeeping/archive-contexts
gh pr create
```

## Special Workflows

### Urgent Main Branch Changes

When branch protection prevents direct commits to main:

```bash
# 1. Create a temporary fix branch WITH CONTEXT
git checkout main
git pull
git checkout -b fix/urgent-hotfix
claude "load CLAUDE.md, create context file for branch fix/urgent-hotfix, and begin urgent work"

# 2. Make the necessary changes
git add contexts/fix-urgent-hotfix-context.md
git add path/to/files
git commit -S -s -m "Fix urgent issue X"

# 3. Create a temporary PR
git push -u origin fix/urgent-hotfix
claude "load CLAUDE.md, verify current branch is fix/urgent-hotfix, update context for urgent PR, and create PR"

# 4. Request admin review for expedited merge
# Note: Only repository admins can bypass branch protection rules

# 5. After merge, clean up
git checkout main
git pull
git branch -D fix/urgent-hotfix
# Context file will be archived later
```

Key points for urgent changes:
- Always use a branch, even for small changes
- Clearly mark PRs as urgent in the title
- Use the same signing and review standards
- Request admin override only when truly necessary
- Document the emergency process in the PR

### PR Approval and Admin Merge

For PRs requiring admin override of branch protection:

```bash
# Approve the PR (if not your own)
gh pr review <PR-NUMBER> --approve

# Merge with admin override
gh pr merge <PR-NUMBER> --admin --merge

# Verify merge and clean up
git checkout main
git pull
git branch -D feature/branch-name
```

Important notes:
- Use admin merge ONLY when necessary and authorized
- Cannot approve your own PRs (will receive error)
- Document the reason for admin override in PR comments

### Checking PR Status

```bash
# View PR details
gh pr view <PR-NUMBER>

# List all open PRs
gh pr list
```

<!-- Note for Claude: The special workflows section is particularly important for Team development models, but less critical for Solo development. Adjust your guidance based on the project's development model. -->