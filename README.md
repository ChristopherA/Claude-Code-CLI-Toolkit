# Claude Code CLI Toolkit

> - _did-original-source_: `did:repo:ca85b5ea9bc63cc8229c073d8f6a3faae8062a77/blob/main/README.md`
> - _github-original-source_: `https://github.com/ChristopherA/Claude-Code-CLI-Toolkit/blob/main/README.md`
> - _purpose_: Provide overview of the Claude Code CLI Toolkit
> - _copyright_: ©2025 by @ChristopherA, licensed under the [BSD 2-Clause Plus Patent License](https://spdx.org/licenses/BSD-2-Clause-Patent.html)
> - _created_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>
> - _last-updated_: 2025-03-19 by @ChristopherA <ChristopherA@LifeWithAlacrity.com>

## Project Overview

The Claude Code CLI Toolkit provides a structured environment for developing software projects with Claude AI assistance through the command line interface. This toolkit helps maintain consistent development practices across Claude-assisted projects.

## Purpose

This toolkit serves two main purposes:

1. **As a Starting Point**: Use these files as the foundation for new projects
2. **As a Reference**: Study this toolkit to understand Claude-assisted development

## Getting Started

1. Clone this repository
2. Delete the `.git` folder to start fresh
3. Run Claude to guide you through project setup: `claude "load CLAUDE.md and help me setup this project"`
4. Follow the bootstrap.md instructions to customize for your project
5. Delete bootstrap.md when setup is complete

## Key Features

- **Structured Development Models**: Choose between Solo or Team development models
- **Context Management**: System for maintaining project context across sessions
- **Task Tracking**: Organized approach to tracking work and progress
- **Git Workflow**: Best practices for Git operations and commits
- **Documentation Structure**: Organized approach to project documentation

## Development Approach

See PROJECT_GUIDE.md for detailed information about development models and approaches.

## Additional Resources

- Detailed guides are stored in `requirements/guides/`
- For file organization, see CLAUDE.md
- For task tracking, see WORK_STREAM_TASKS.md
- For context management, see `contexts/` directory

## Updating Toolkit Files

After customizing this toolkit for your project, you can't use Git pull to get updates from the original repository. Instead, follow these steps to manually update specific files:

1. **Check for Updates**: Look at the `_github-original-source_` URL in the file's metadata header
2. **Compare Versions**: Visit the URL to compare with your customized version
3. **Download Updates**: If updates are valuable, download the latest version
4. **Merge Changes**: Manually incorporate changes while preserving your customizations

### Which Files to Update

Best candidates for updates:
- `requirements/guides/*.md` files - workflow guides that may be improved
- `PROJECT_GUIDE.md` - development model documentation

Files to avoid updating:
- `CLAUDE.md` - Contains your project-specific context
- Any files you've heavily customized for your specific project
- Context files in the `contexts/` directory