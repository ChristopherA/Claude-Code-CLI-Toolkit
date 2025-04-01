#!/usr/bin/env zsh
########################################################################
## Script:        setup_git_inception_repo.sh
## Version:       0.2.00 (2025-03-26)
## did-origin:    did:repo:69c8659959f1a6aa281bdc1b8653b381e741b3f6/blob/main/src/setup_git_inception_repo.sh
## github-origin: https://github.com/OpenIntegrityProject/core/blob/main/src/setup_git_inception_repo.sh
## Description:   Creates a new Git repository with a properly signed empty
##                inception commit following Open Integrity Project standards.
## License:       BSD 2-Clause Patent License (https://spdx.org/licenses/BSD-2-Clause-Patent.html)
## Copyright:     (c) 2025 Blockchain Commons LLC (https://www.BlockchainCommons.com)
## Attribution:   Christopher Allen <ChristopherA@LifeWithAlacrity.com>
## Usage:         create_inception_commit.sh [-r|--repo <directory>] [--no-prompt]
## Examples:      create_inception_commit.sh
##                create_inception_commit.sh --repo my_open_integrity_repo
##                create_inception_commit.sh --repo /full/path/to/new_repo
## Security:      The Inception Commit establishes an immutable cryptographic
##                root of trust using a combination of Git's SHA-1 hashing and
##                SSH signature verification. Always verify the signature
##                to ensure trust integrity.
########################################################################

# Reset the shell environment to a known state
emulate -LR zsh

# Safe shell scripting options
setopt errexit nounset pipefail localoptions warncreateglobal

# Source Z_Utils library
typeset -r Script_Dir="${0:A:h}"
typeset Z_Utils_Path

# Determine Z_Utils library path - search common locations
if [[ -f "${Script_Dir}/_Z_Utils.zsh" ]]; then
    Z_Utils_Path="${Script_Dir}/_Z_Utils.zsh"
elif [[ -f "${Script_Dir}/lib/_Z_Utils.zsh" ]]; then
    Z_Utils_Path="${Script_Dir}/lib/_Z_Utils.zsh"
elif [[ -f "${Script_Dir}/../_Z_Utils.zsh" ]]; then
    Z_Utils_Path="${Script_Dir}/../_Z_Utils.zsh"
elif [[ -f "${Script_Dir}/../lib/_Z_Utils.zsh" ]]; then
    Z_Utils_Path="${Script_Dir}/../lib/_Z_Utils.zsh"
elif [[ -f "${Script_Dir}/../src/_Z_Utils.zsh" ]]; then
    Z_Utils_Path="${Script_Dir}/../src/_Z_Utils.zsh"
else
    print -u2 "Error: Could not find _Z_Utils.zsh library"
    exit 127
fi

# Source the library
source "$Z_Utils_Path"

# Functions used from _Z_Utils.zsh:
# z_Setup_Environment        - Initialize the environment
# z_Check_Dependencies       - Verify external tool dependencies
# z_Output                   - Multi-mode formatted output
# z_Report_Error             - Standardized error reporting
# z_Verify_Git_Config        - Verify Git signing configuration
# z_Create_Inception_Repository - Create repository with signed inception commit

# Initialize Z_Utils environment
z_Setup_Environment || exit $?

# Script constants
# Extract script name using Zsh parameter expansion with :t modifier (tail/basename)
typeset -r Script_Name="${0:t}"
typeset -r Script_Version="0.2.00"  # Updated for function naming standardization

# Script variables with proper type declarations
typeset -r Default_Repo_Name="new_open_integrity_repo"  # Default repository name if not specified
typeset -r Script_Path="${0:A}"                       # Full path to the script
typeset Repo_Path="$Default_Repo_Name"                  # Path where repository will be created
typeset -i Force_Flag=$FALSE                          # Force repository creation if it already exists

#----------------------------------------------------------------------#
# Function: display_Script_Usage
#----------------------------------------------------------------------#
# Description:
#   Displays usage information for the script
# Parameters:
#   $1 - Optional error flag (if not provided, exits with success)
# Returns:
#   Exit_Status_Success when called with no error flag
#   Exit_Status_Usage when called with error flag
#----------------------------------------------------------------------#
function display_Script_Usage() {
   z_Output print "$Script_Name v$Script_Version - Create an Open Integrity signed inception commit"
   z_Output print ""
   z_Output print "Usage: $Script_Name [-r|--repo <directory>] [-f|--force]"
   z_Output print "Creates a new Git repository with a properly signed inception commit."
   z_Output print ""
   z_Output print "Options:"
   z_Output print "  -r, --repo <directory>  Specify repository directory path"
   z_Output print "                          (default: $Default_Repo_Name)"
   z_Output print "  -f, --force             Force creation even if repository already exists"
   z_Output print "  -h, --help              Show this help message"
   z_Output print ""
   z_Output print "Examples:"
   z_Output print "  $Script_Name                      Create with default name"
   z_Output print "  $Script_Name --repo my_repo       Create with custom name"
   z_Output print "  $Script_Name --repo /path/to/repo Create with full path"
   z_Output print "  $Script_Name --force --repo existing_repo    Force creation in existing directory"
   
   # Exit with success for help, error for invalid usage
   if [[ "${1:-}" == "error" ]]; then
       exit $Exit_Status_Usage
   else
       exit $Exit_Status_Success
   fi
}

#----------------------------------------------------------------------#
# Function: parse_CLI_Options
#----------------------------------------------------------------------#
# Description:
#   Processes command line parameters
# Parameters:
#   $@ - Command line arguments
# Sets:
#   Repo_Path - The directory path where the repository will be created
#   Output_Prompt_Enabled - Boolean controlling prompt display (TRUE=interactive, FALSE=non-interactive)
# Returns:
#   Exit_Status_Success if parameters are valid
#   Calls display_Script_Usage() for invalid parameters
#----------------------------------------------------------------------#
function parse_CLI_Options() {
   typeset currentArg
   
   while (( $# > 0 )); do
      currentArg="$1"  # Store current argument for clarity
       case "$currentArg" in
           -r|--repo)
               if (( $# < 2 )); then
                   z_Report_Error "Option $currentArg requires an argument" $Exit_Status_Usage
                   display_Script_Usage "error"
               fi
               Repo_Path="$2"
               shift 2
               ;;
           -f|--force)
               Force_Flag=$TRUE
               shift
               ;;
           -h|--help)
               display_Script_Usage
               ;;
           -*)
               z_Report_Error "Unknown option: $currentArg" $Exit_Status_Usage
               display_Script_Usage "error"
               ;;
           *)
               z_Report_Error "Unexpected argument: $currentArg" $Exit_Status_Usage
               display_Script_Usage "error"
               ;;
       esac
   done

   return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: execute_Core_Workflow
#----------------------------------------------------------------------#
# Description:
#   Orchestrates the main script workflow for creating an inception repository
# Parameters:
#   None (uses script-scoped variables)
# Uses:
#   Repo_Path - The directory path where the repository will be created
#   Force_Flag - Controls whether to force creation of repositories that already exist
# Returns:
#   Exit_Status_Success on success
#   Various error codes on failure from z_Create_Inception_Repository
#----------------------------------------------------------------------#
function execute_Core_Workflow() {
   
   # Validate that repository path is provided
   if [[ -z "$Repo_Path" ]]; then
      z_Report_Error "Repository path not specified" $Exit_Status_Usage
      return $Exit_Status_Usage
   fi
   
   # Create repository with inception commit using Z_Utils library
   z_Create_Inception_Repository "$Repo_Path" "" $Force_Flag || return $?

   return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: main
#----------------------------------------------------------------------#
# Description:
#   Main entry point for the script
# Parameters:
#   $@ - Command line arguments
# Returns:
#   Exit_Status_Success on success
#   Various error codes on failure
#----------------------------------------------------------------------#
function main() {
   # Check for core dependencies
   z_Check_Dependencies "git" "ssh-keygen" || exit $?

   # Parse command line parameters
   parse_CLI_Options "$@" || exit $?

   # Verify Git configuration
   z_Verify_Git_Config || exit $?

   # Execute core workflow
   execute_Core_Workflow || exit $?

   return $Exit_Status_Success
}

# Script Entry Point
# Zsh-specific syntax: ${(%):-%N} expands to the script name when run directly,
# but to the function name when sourced.
if [[ "${(%):-%N}" == "$0" ]]; then
   # Call main function with all arguments
   main "$@"
   # Propagate exit status from main function
   exit $?
fi

########################################################################
## END of Script `create_inception_commit.sh`
########################################################################
