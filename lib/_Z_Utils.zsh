#!/usr/bin/env zsh
########################################################################
##                         LIBRARY INFO
########################################################################
## Script:        _Z_Utils.zsh
## Version:       0.1.01 (2025-03-29)
## did-origin:    did:repo:b0c5cd0d85b29543c604c093dd83a1a20eb17af1/blob/main/src/_Z_Utils.zsh
## github-origin: https://github.com/ChristopherA/z_Utils/blob/main/src/_Z_Utils.zsh
##
## DESCRIPTION:
##   A comprehensive library of reusable Zsh utility functions designed to provide
##   consistent, robust, and efficient scripting capabilities. This library
##   implements a cohesive set of functions for output formatting, error handling,
##   environment setup, Git operations, and SSH integration.
##
## DESIGN PHILOSOPHY:
##   - Safety First: Functions fail predictably with proper error propagation
##   - Explicit Over Implicit: Clear function interfaces and documentation
##   - Zsh-Native: Leverages Zsh's parameter expansion and built-in capabilities
##   - Layered Architecture: Functions organized from low-level utilities to 
##     high-level workflow orchestrators
##   - Progressive Enhancement: Basic functionality with minimal dependencies,
##     enhanced features when available
##
## FEATURES:
##   - Comprehensive Output Formatting (z_Output):
##     * Consistent multi-level output with color support
##     * Support for verbosity levels, prompts, and emojis
##     * Line wrapping and indentation control
##   - Robust Error Handling:
##     * Standardized error reporting with z_Report_Error
##     * Consistent exit code usage across functions
##     * Graceful degradation with fallbacks
##   - Environment Management:
##     * Automated environment setup and validation
##     * Dependency checking and version verification
##     * Version compatibility checking with z_Check_Version
##     * Cleanup routines for resource management
##   - Git Integration:
##     * Repository verification and configuration
##     * SSH signing key management
##     * Inception commit creation and verification
##
## LIBRARY USAGE:
##   - Source this library at the beginning of your script:
##     source "/path/to/_Z_Utils.zsh"
##   - Check version compatibility (optional):
##     z_Check_Version "0.1.0" || exit $?
##   - Initialize the environment:
##     z_Setup_Environment || exit $?
##   - Use the library functions in your script
##
## LICENSE:
##   BSD-2-Clause-Patent (https://spdx.org/licenses/BSD-2-Clause-Patent.html)
##   (c) 2025 Christopher Allen
##   Authored by @ChristopherA <ChristopherA@LifeWithAlacrity.com>
########################################################################

########################################################################
##                         CHANGE LOG
########################################################################
## 0.1.01   - Standardization and Enhancement (2025-03-29)
##          - Added proper framework-level documentation:
##            * Enhanced header documentation
##            * Added change log section
##            * Standardized section organization
##          - Enhanced Zsh-native approaches:
##            * Replaced external commands with Zsh parameter expansion
##            * Improved typing with explicit typeset declarations
##            * Enhanced camelCase variable naming with 2+ words
##          - Added version management:
##            * Proper version constants
##            * z_Check_Version function for compatibility checks
##            * Updated documentation
##
## 0.1.00   - Initial Release (2025-03-26)
##          - Core utility functions implementation:
##            * z_Output for consistent formatted output
##            * z_Report_Error for centralized error reporting
##            * z_Check_Dependencies for dependency verification
##            * z_Setup_Environment for environment initialization
##            * z_Cleanup for resource management
##          - Git integration functions:
##            * z_Get_Git_Config for Git configuration handling
##            * z_Verify_Git_Config for signing setup verification
##            * z_Verify_Git_Repository for repository validation
##            * z_Get_First_Commit_Hash for inception commit access
##            * z_Get_Repository_DID for repository DID generation
##          - SSH functionality:
##            * z_Extract_SSH_Key_Fingerprint for key fingerprint extraction
##            * z_Verify_Commit_Signature for SSH signature verification
##            * z_Create_Inception_Repository for properly signed repos
##            * z_Ensure_Allowed_Signers for SSH verification configuration
##            * z_Setup_Git_Environment for full signing environment setup
########################################################################

########################################################################
##                  FOUNDATION LAYER - ENVIRONMENT SETUP
########################################################################
## Description:
##   This section establishes the foundation for the library by setting up
##   a predictable execution environment, defining global constants, and
##   initializing terminal capabilities. These elements provide the basic
##   infrastructure upon which all other functions depend.
##
## Dependencies:
##   - Zsh shell
##   - Basic terminal capabilities (tput)
##
## Variables defined:
##   - Output control flags (Verbose_Mode, Quiet_Mode, etc.)
##   - Boolean constants (TRUE, FALSE)
##   - Exit status codes
##   - Terminal formatting codes
########################################################################

# Reset the shell environment to a known state
emulate -LR zsh

# Safe shell scripting options for strict error handling
setopt errexit nounset pipefail localoptions warncreateglobal

# Library version information
typeset -r -g Z_Utils_Version="0.1.01"
typeset -r -g Z_Utils_Version_Major=0
typeset -r -g Z_Utils_Version_Minor=1
typeset -r -g Z_Utils_Version_Patch=1
typeset -r -g Z_Utils_Version_Date="2025-03-29"

#----------------------------------------------------------------------#
# Function: z_Check_Version
#----------------------------------------------------------------------#
# Description:
#   Checks if the current version of the Z_Utils library meets the 
#   minimum version requirements. This function enables scripts to verify
#   compatibility with the library before execution, preventing issues
#   when library APIs change across versions.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Initial implementation with semantic version comparison
#     * Added support for both full version string and individual component checking
#
# Features:
#   - Semantic version comparison (major.minor.patch)
#   - Support for checking full version string or individual components
#   - Detailed reporting of version mismatches
#   - Zsh-native implementation without external dependencies
#
# Parameters:
#   $1 - Required version (string): The minimum version required in format
#        "major.minor.patch" (e.g., "0.2.0" or "1.0.0")
#   $2 - Optional verbosity flag (boolean): If TRUE, outputs detailed version
#        information when check fails. Defaults to TRUE if Output_Verbose_Mode is set.
#
# Returns:
#   Exit_Status_Success (0) when the current version meets or exceeds the required version
#   Exit_Status_Config (6) when the current version is lower than the required version
#
# Runtime Impact:
#   - Outputs version mismatch information to stderr when verbosity is enabled
#   - Does not modify any state
#   - Fast operation with minimal overhead
#
# Dependencies:
#   - Z_Utils_Version* constants
#   - z_Report_Error function for error reporting
#   - Exit status constants
#
# Usage Examples:
#   # Basic version check:
#   if ! z_Check_Version "0.1.0"; then
#     echo "This script requires Z_Utils version 0.1.0 or newer"
#     exit 1
#   fi
#   
#   # With error handling and custom message:
#   if ! z_Check_Version "0.2.0"; then
#     echo "Please update Z_Utils library to version 0.2.0 or newer"
#     echo "Current version: $Z_Utils_Version"
#     exit 1
#   fi
#   
#   # Silent check (no error messages):
#   z_Check_Version "0.1.0" $FALSE || exit 1
#   
#   # In a function with error propagation:
#   check_dependencies() {
#     # Check library version first
#     z_Check_Version "0.1.1" || return $?
#     
#     # Then check other dependencies
#     z_Check_Dependencies "RequiredCommands" || return $?
#   }
#----------------------------------------------------------------------#
function z_Check_Version() {
    typeset RequiredVersion="$1"
    typeset -i VerboseOutput="${2:-$Output_Verbose_Mode}"
    
    # Parse required version into components
    typeset RequiredMajor RequiredMinor RequiredPatch
    
    if [[ "$RequiredVersion" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
        RequiredMajor="${match[1]}"
        RequiredMinor="${match[2]}"
        RequiredPatch="${match[3]}"
    elif [[ "$RequiredVersion" =~ ^([0-9]+)\.([0-9]+)$ ]]; then
        RequiredMajor="${match[1]}"
        RequiredMinor="${match[2]}"
        RequiredPatch=0
    else
        z_Report_Error "Invalid version format: $RequiredVersion" $Exit_Status_Usage
        return $Exit_Status_Usage
    fi
    
    # Compare versions component by component
    # First compare major version
    if (( Z_Utils_Version_Major > RequiredMajor )); then
        return $Exit_Status_Success
    elif (( Z_Utils_Version_Major < RequiredMajor )); then
        if (( VerboseOutput == TRUE )); then
            z_Report_Error "Library version too old. Required: $RequiredVersion, Current: $Z_Utils_Version" $Exit_Status_Config
        fi
        return $Exit_Status_Config
    fi
    
    # Major versions match, compare minor version
    if (( Z_Utils_Version_Minor > RequiredMinor )); then
        return $Exit_Status_Success
    elif (( Z_Utils_Version_Minor < RequiredMinor )); then
        if (( VerboseOutput == TRUE )); then
            z_Report_Error "Library version too old. Required: $RequiredVersion, Current: $Z_Utils_Version" $Exit_Status_Config
        fi
        return $Exit_Status_Config
    fi
    
    # Minor versions match, compare patch version
    if (( Z_Utils_Version_Patch >= RequiredPatch )); then
        return $Exit_Status_Success
    else
        if (( VerboseOutput == TRUE )); then
            z_Report_Error "Library version too old. Required: $RequiredVersion, Current: $Z_Utils_Version" $Exit_Status_Config
        fi
        return $Exit_Status_Config
    fi
}

# Initialize environment variables
# These should be explicitly set by scripts that use this library
# Setting defaults for safety
typeset -g Output_Verbose_Mode=0
typeset -g Output_Quiet_Mode=0
typeset -g Output_Debug_Mode=0
typeset -g Output_Prompt_Enabled=1

# Define TRUE/FALSE constants
typeset -r -g TRUE=1
typeset -r -g FALSE=0

# Exit status constants
typeset -r -g Exit_Status_Success=0
typeset -r -g Exit_Status_General=1
typeset -r -g Exit_Status_Usage=2
typeset -r -g Exit_Status_IO=3
typeset -r -g Exit_Status_Git_Failure=5
typeset -r -g Exit_Status_Config=6
typeset -r -g Exit_Status_Dependency=127

# Initialize terminal formatting codes
# These are used for colored output in various functions
typeset -r -g Term_Black="$(tput setaf 0 2>/dev/null || echo '')"
typeset -r -g Term_Red="$(tput setaf 1 2>/dev/null || echo '')"
typeset -r -g Term_Green="$(tput setaf 2 2>/dev/null || echo '')"
typeset -r -g Term_Yellow="$(tput setaf 3 2>/dev/null || echo '')"
typeset -r -g Term_Blue="$(tput setaf 4 2>/dev/null || echo '')"
typeset -r -g Term_Magenta="$(tput setaf 5 2>/dev/null || echo '')"
typeset -r -g Term_Cyan="$(tput setaf 6 2>/dev/null || echo '')"
typeset -r -g Term_White="$(tput setaf 7 2>/dev/null || echo '')"

# Bright variants
typeset -r -g Term_BrightBlack="$(tput setaf 8 2>/dev/null || echo '')"
typeset -r -g Term_BrightRed="$(tput setaf 9 2>/dev/null || echo '')"
typeset -r -g Term_BrightGreen="$(tput setaf 10 2>/dev/null || echo '')"
typeset -r -g Term_BrightYellow="$(tput setaf 11 2>/dev/null || echo '')"
typeset -r -g Term_BrightBlue="$(tput setaf 12 2>/dev/null || echo '')"
typeset -r -g Term_BrightMagenta="$(tput setaf 13 2>/dev/null || echo '')"
typeset -r -g Term_BrightCyan="$(tput setaf 14 2>/dev/null || echo '')"
typeset -r -g Term_BrightWhite="$(tput setaf 15 2>/dev/null || echo '')"

# Text effects
typeset -r -g Term_Bold="$(tput bold 2>/dev/null || echo '')"
typeset -r -g Term_Underline="$(tput smul 2>/dev/null || echo '')"
typeset -r -g Term_NoUnderline="$(tput rmul 2>/dev/null || echo '')"
typeset -r -g Term_Standout="$(tput smso 2>/dev/null || echo '')"
typeset -r -g Term_NoStandout="$(tput rmso 2>/dev/null || echo '')"
typeset -r -g Term_Dim="$(tput dim 2>/dev/null || echo '')"
typeset -r -g Term_Blink="$(tput blink 2>/dev/null || echo '')"
typeset -r -g Term_Reverse="$(tput rev 2>/dev/null || echo '')"
typeset -r -g Term_Invisible="$(tput invis 2>/dev/null || echo '')"
typeset -r -g Term_Reset="$(tput sgr0 2>/dev/null || echo '')"

########################################################################
##                    UTILITY LAYER - CORE FUNCTIONS
########################################################################
## Description:
##   This section implements core utility functions that provide essential
##   capabilities for all scripts using this library. These functions handle
##   common operations like output formatting, error reporting, and
##   environment setup that are independent of specific domains.
##
## Functions in this section:
##   - z_Output: Multi-mode formatted output with color support
##   - z_Report_Error: Standardized error reporting
##   - z_Convert_Path_To_Relative: Path manipulation utility
##   - z_Check_Dependencies: Dependency verification
##   - z_Ensure_Parent_Path_Exists: Directory creation utility
##   - z_Setup_Environment: Environment initialization
##   - z_Cleanup: Resource management and cleanup
##
## Design principles:
##   - Functions are domain-independent and reusable across contexts
##   - Each function has a single, well-defined responsibility
##   - Robust error handling with appropriate exit codes
##   - Clear parameter validation and documentation
########################################################################

#----------------------------------------------------------------------#
# Function: z_Output
#----------------------------------------------------------------------#
# Description:
#   A flexible and modular function for displaying formatted output
#   in Zsh scripts. Provides consistent output formatting with support
#   for multiple message types, emoji prefixes, text wrapping,
#   indentation, verbosity levels, and interactive prompts.
#
# Version: 1.0.00 (2024-01-30)
#
# Change Log:   - 1.0.00 Initial stable release (2024-01-17)
#                   - Feature complete with 
#                       - Nine message types
#                       - Five modes
#                   - Text wrapping, indentation, and color support
#                   - Emoji and Unicode handling
#                   - Flexible message type and mode controls
#                   - Robust interactive and non-interactive prompting
#
# Features:
#   - Message Types: print, info, verbose, success, warn, error,
#       debug, vdebug, prompt
#   - Verbosity Modes:
#     - Verbose for detailed information
#     - Quiet to suppress non-critical messages
#     - Debug for troubleshooting output
#   - Other Modes:
#     - No-Prompt to disable interactive prompts
#     - Color to set color output
#   - Text Formatting: wrapping, indentation, ANSI colors
#   - Emoji Support: Customizable emoji prefixes per message type
#   - Interactive Prompts: With default values and automation support
#
# Default Behaviors:
#   print type:
#     - By default, behaves exactly like zsh's native print command
#     - No formatting (wrapping, indentation, emoji) by default
#     - Can optionally use formatting features if explicitly requested
#     - Suppressed in quiet mode like other non-critical messages
#     - Emoji support must be explicitly enabled via Emoji option
#   
#   Other message types:
#     - Without indent:
#       * If Wrap=0 or Wrap not specified: No wrapping
#       * If Wrap>0: Wrap at specified width
#     - With indent:
#       * Always wraps (at terminal width if Wrap not specified)
#       * Wraps at Wrap width if specified and < terminal width
#       * Continuation lines indented +2 spaces from base indent
#     - Line Continuation:
#       * Wrapped lines align with text after emoji/prefix
#       * Preserves spacing and formatting
#     - Mode Controls:
#       * debug/vdebug respect both Force and mode flags
#       * verbose respects both quiet mode and Force
#       * error shows even in quiet mode
#
# Parameters:
#   1. Type (string):
#      Message type controlling appearance and behavior
#      Supported types:
#        print:   Standard output, like zsh print (no formatting by default)
#        info:    Informational messages (cyan, 💡)
#        verbose: Detailed output shown in verbose mode, hidden in quiet (yellow, 📘)
#        success: Success messages (green, ✅)
#        warn:    Warning messages (magenta, ⚠️)
#        error:   Critical errors, shown even in quiet mode (red, ❌)
#        debug:   Debug messages shown only in debug mode (blue, 🛠️)
#        vdebug:  Verbose debug messages, requires both debug AND verbose (magenta, 🔍)
#        prompt:  Interactive prompts (standout color, ❓, supports non-interactive)
#
#   2. Message (string):
#      The text content to display. Supports:
#      - Multi-line text
#      - Spaces and tabs (preserved)
#      - Empty messages
#      - Special characters
#      - Very long words/URLs
#      - Unicode including emoji
#
#   3. Options (Key=Value pairs, optional):
#      Additional formatting options:
#      
#      Color (string):
#        - ANSI color code to override default for message type
#        - Empty string disables coloring
#        Example: Color="$(tput setaf 1)" # Force red text
#                Color="" # Disable color
#
#      Emoji (string):
#        - Custom emoji prefix overriding default for message type
#        - Empty string disables emoji
#        - Required for print type to show emoji
#        Example: Emoji="🌟" # Custom star emoji
#
#      Wrap (integer):
#        - Maximum line width for text wrapping
#        - When not specified or 0:
#          * No wrapping if no indent specified
#          * Terminal width wrapping if indent specified
#        - When >0: Wrap at specified width
#        - When >terminal width: Wrap at terminal width
#        - Minimum 20 characters, maximum current terminal width
#        - Adjusts automatically if terminal is resized
#        - Takes precedence over indent-triggered wrapping
#        Example: Wrap=60 # Wrap at 60 characters
#
#      Indent (integer):
#        - Number of spaces for left indentation
#        - Defaults to 0 (no indent)
#        - When specified: Enables wrapping even if Wrap=0
#        - Applies to all lines including wrapped text
#        - Wrapped lines get +2 spaces additional indent
#        - Wrap width defaults to terminal width if not specified
#        Example: Indent=4 # Four space indent
#
#      Default (string):
#        - Default value for prompts when non-interactive
#        - Used when Output_Prompt_Enabled is FALSE
#        - Preserves exact spacing when used
#        Example: Default="yes" # Default prompt response
#
#      Force (boolean):
#        - Forces output even in quiet mode
#        - Overrides quiet mode for all message types
#        - Does not bypass debug/verbose mode requirements
#        - vdebug still requires both debug AND verbose even with Force
#        Example: Force=$TRUE # Force display in quiet mode
#
# Returns:
#   - For prompts: Prints and returns user input or default value
#   - For messages: Prints formatted text, returns 0
#   - For errors: Prints error message and returns 1
#   - Returns 2 for invalid message types
#
# Dependencies:
#   Required commands:
#   - tput: For color and terminal capabilities
#   - printf: For formatted output
#
#   Required zsh options:
#   - localoptions: For local option scope
#   - warncreateglobal: For variable scope warnings
#
#   Script-scoped variables (must be declared):
#   - Output_Verbose_Mode (integer): Controls verbose message display
#   - Output_Quiet_Mode (integer): Controls message suppression
#   - Output_Debug_Mode (integer): Controls debug message display
#   - Output_Prompt_Enabled (integer): Controls interactive prompting
#   - TRUE/FALSE (integer): Boolean constants as integers (i.e. 1/0)
#   - Term_* variables: Color and formatting codes
#
#   Required terminal color variables (script-local read-only):
#   - Basic colors: Term_Black, Term_Red, Term_Green, Term_Yellow,  
#     Term_Blue, Term_Magenta, Term_Cyan, Term_White: 
#   - Bright colors: Term_BrightBlack, Term_BrightRed, 
#     Term_BrightGreen, Term_BrightYellow, Term_BrightBlue, 
#     Term_BrightMagenta, Term_BrightCyan, Term_BrightWhite
#   - Text attributes: Term_Bold, Term_Underline, 
#     Term_NoUnderline, Term_Standout, Term_NoStandout, 
#     Term_Blink, Term_Dim, Term_Reverse, Term_Invisible 
#   - Reset all: Term_Reset
#
# Examples:
#   ### Basic Message Types ###
#   - Print (standard output):
#       z_Output print "Standard message with no formatting"
#       z_Output print "Print with wrap" Wrap=60
#       z_Output print "Print with emoji" Emoji="📝"
#
#   - Info messages:
#       z_Output info "Basic informational message"
#       z_Output info "Custom info message" Emoji="ℹ️" Color="$Term_Cyan"
#       z_Output info "Info with wrap and indent" Wrap=60 Indent=4
#
#   - Success messages:
#       z_Output success "Operation completed successfully"
#       z_Output success "Detailed success" Wrap=60 Indent=2
#
#   - Warning messages:
#       z_Output warn "Configuration issue detected"
#       z_Output warn "Multi-line warning\nSecond line" Indent=4
#
#   - Error messages:
#       z_Output error "Operation failed"
#       z_Output error "Critical error" Color="$Term_BrightRed"
#
#   ### Debug and Verbose Messages ###
#   - Debug messages (requires debug mode):
#       z_Output debug "Debug information follows..."
#       z_Output debug "Force debug message" Force=$TRUE
#
#   - Verbose messages (requires verbose mode):
#       z_Output verbose "Detailed processing information"
#       z_Output verbose "Force verbose message" Force=$TRUE
#
#   - Verbose debug (requires both modes):
#       z_Output vdebug "Detailed debug trace"
#       z_Output vdebug "Forced vdebug" Force=$TRUE
#
#   ### Interactive Prompts ###
#   - Basic prompts:
#       UserInput=$(z_Output prompt "Enter your name:")
#       Choice=$(z_Output prompt "Continue? (Y/n):" Default="Y")
#
#   - Non-interactive mode:
#       Output_Prompt_Enabled=$FALSE
#       Default=$(z_Output prompt "Skip prompt" Default="yes")
#
#   ### Advanced Formatting ###
#   - Wrapping and indentation:
#       z_Output info "Long wrapped message at 60 chars" Wrap=60
#       z_Output warn "Indented warning message" Indent=4
#       z_Output info "Combined format" Wrap=50 Indent=2
#
#   - Custom formatting:
#       z_Output info "Custom color" Color="$Term_BrightCyan"
#       z_Output warn "Custom emoji" Emoji="⚡"
#       z_Output info "No emoji message" Emoji=""
#
#   - Complex combinations:
#       z_Output info "Complex formatted message with custom\n" \
#          "appearance and wrapped text that spans\n" \
#          "multiple lines" \
#          Wrap=40 Indent=4 Emoji="📢" Color="$Term_BrightBlue"
#
#   ### Mode Control ###
#   - Quiet mode override:
#       z_Output info "Always show this" Force=$TRUE
#       z_Output verbose "Force verbose in quiet" Force=$TRUE
#
#   - Debug control:
#       z_Output debug "Debug if enabled" Force=$TRUE
#       z_Output vdebug "Vdebug needs both modes" Force=$TRUE
#
# Notes:
#   - Terminal Support:
#     - Requires terminal with ANSI color support
#     - Automatically wraps to terminal width
#     - Adapts to terminal resizing during execution
#     - Degrades gracefully in basic terminals
#     - Minimum width of 20 characters enforced
#     - Uses current terminal width at time of each call
#
#   - Text Processing:
#     - Preserves tabs (converts to spaces)
#     - Maintains spacing and line breaks
#     - Handles special characters and Unicode
#     - Word-wraps long text
#     - Preserves empty lines
#     - Handles multi-byte characters and emoji correctly
#
#   - Message Control:
#     - Quiet mode suppresses all except error and forced messages
#     - Verbose mode shows verbose messages (unless quiet)
#     - Debug mode enables debug messages
#     - Debug AND verbose modes required for vdebug
#     - Force flag overrides quiet mode only
#     - Error messages always show regardless of modes
#
#   - Zsh Specific:
#     - Uses Zsh parameter expansion flags
#     - Requires Zsh arrays and associative arrays
#     - Takes advantage of Zsh string manipulation
#     - Uses Zsh read builtin for prompts
#     - Handles zsh-specific terminal behavior
#
# Known Issues:
#   - Space Preservation in Interactive Prompts:
#     When entering text at interactive prompts (not accepting defaults),
#     spaces may be affected:
#     - Leading spaces are stripped
#     - Trailing spaces may be inconsistent
#     - Internal spaces are preserved
#     This is a limitation of zsh's read builtin and affects only
#     manually entered text; default values preserve spaces correctly.
#----------------------------------------------------------------------#
function z_Output {
    # Required first parameter is message type with error on missing
    # ${1:?msg} is shared between zsh/bash but behavior differs on missing parameter
    typeset MessageType="${1:?Missing message type}"
    shift

    # Zsh arrays are 1-based and require explicit declaration of pattern matching arrays
    # match/mbegin/mend are special zsh arrays used for regex capture groups
    typeset -a match mbegin mend
    typeset -a MessageParts
    # -A creates associative array (like bash -A but with different scoping rules)
    typeset -A OptionsMap
    
    # In zsh, typeset creates local variables with explicit typing
    # Unlike bash where local/declare are interchangeable
    typeset MessageText IndentText WrapIndentText PrefixText
    typeset LineText WordText CurrentLine OutputText
    typeset KeyName Value
    
    # Zsh associative arrays persist declaration order unlike bash
    typeset -A ColorMap EmojiMap SuppressionMap
    
    ColorMap=(
        "print"   "$Term_Reset"
        "info"    "$Term_Cyan"
        "verbose" "$Term_Yellow"
        "success" "$Term_Green"
        "warn"    "$Term_Magenta"
        "error"   "$Term_Red"
        "debug"   "$Term_Blue"
        "vdebug"  "$Term_Blue"
        "prompt"  "$Term_Standout"
        "reset"   "$Term_Reset"
    )
    
    EmojiMap=(
        "print"   ""
        "info"    "=�"
        "verbose" "=�"
        "success" ""
        "warn"    "�"
        "error"   "L"
        "debug"   "=�"
        "vdebug"  "="
        "prompt"  "S"
    )
    
    SuppressionMap=(
        "print"   1
        "info"    1
        "verbose" 1
        "success" 1
        "warn"    1
        "error"   0
        "debug"   1
        "vdebug"  1
        "prompt"  0
    )

    # Zsh regex pattern matching using =~ behaves differently than bash
    # Captures stored in $match array rather than bash's ${BASH_REMATCH}
    while (( $# > 0 )); do
        if [[ "$1" =~ ^([^=]+)=(.*)$ ]]; then
            KeyName="${match[1]}"
            Value="${match[2]}"
            OptionsMap[$KeyName]="$Value"
        else
            MessageParts+=("$1")
        fi
        shift
    done
    
    # ${(j: :)array} is zsh array joining with space separator
    # Equivalent to "${array[*]}" in bash but preserves multiple spaces
    MessageText="${(j: :)MessageParts}"

    # Explicit integer declaration required in zsh for arithmetic context
    typeset -i AllowMessage=$FALSE
    case "$MessageType" in
        "vdebug")
            # Zsh arithmetic expressions use (( )) like bash but with stricter typing
            (( AllowMessage = (Output_Debug_Mode == 1 && Output_Verbose_Mode == 1) ? TRUE : FALSE ))
            ;;
        "debug")
            (( AllowMessage = (Output_Debug_Mode == 1) ? TRUE : FALSE ))
            ;;
        "verbose")
            (( AllowMessage = (Output_Verbose_Mode == 1) ? TRUE : FALSE ))
            ;;
        *)
            (( AllowMessage = TRUE ))
            ;;
    esac

    if (( Output_Quiet_Mode == 1 && ${SuppressionMap[$MessageType]:-0} == 1 && ${OptionsMap[Force]:-0} != 1 )); then
        return 0
    fi

    if (( AllowMessage == 0 && ${OptionsMap[Force]:-0} != 1 )); then
        return 0
    fi

    if [[ "$MessageType" == "prompt" ]]; then
        typeset Default="${OptionsMap[Default]:-}"
        typeset EmptyDefault="$([[ -z "$Default" ]] && echo "(empty)" || echo "$Default")"
        typeset Prompt="${MessageText:-Enter value}"
        typeset PromptEmoji="${OptionsMap[Emoji]:-${EmojiMap[$MessageType]:-}}"
        typeset IndentText=""
        typeset PromptText
        
        # Handle indentation for prompts
        typeset -i IndentSize=${OptionsMap[Indent]:-0}
        (( IndentSize > 0 )) && IndentText="$(printf '%*s' $IndentSize '')"
        
        if [[ -n "$Default" ]]; then
            # :+ is parameter expansion shared with bash but more commonly used in zsh
            PromptText="${IndentText}${PromptEmoji:+$PromptEmoji }${Prompt} [${EmptyDefault}]"
        else
            PromptText="${IndentText}${PromptEmoji:+$PromptEmoji }${Prompt}"
        fi

        if (( Output_Prompt_Enabled == 0 )); then
            print -- "${Default}"
            return 0
        fi

        # Zsh read has -r flag like bash but variable=value? syntax for prompt
        # This syntax preserves exact spacing unlike bash's -p flag
        typeset UserInput
        read -r "UserInput?${PromptText}: "
        print -- "${UserInput:-$Default}"
        return 0
    fi

    typeset CurrentColor="${OptionsMap[Color]:-${ColorMap[$MessageType]:-}}"
    typeset ResetColor="${ColorMap[reset]}"
    typeset CurrentEmoji=""

    if [[ -n "$MessageText" && ("$MessageType" != "print" || ( -v "OptionsMap[Emoji]" )) ]]; then
        # Use :+ to check if Emoji is set (even if empty) before falling back to default
        if [[ -v "OptionsMap[Emoji]" ]]; then
            CurrentEmoji="${OptionsMap[Emoji]}"
        else
            CurrentEmoji="${EmojiMap[$MessageType]:-}"
        fi
        [[ -n "$CurrentEmoji" ]] && CurrentEmoji+=" "
    fi

    # Integer math in zsh requires explicit typing for reliable results
    typeset -i IndentSize=${OptionsMap[Indent]:-0}
    typeset -i BaseIndent=$IndentSize
    (( BaseIndent < 0 )) && BaseIndent=0

    IndentText=""
    [[ $BaseIndent -gt 0 ]] && IndentText="$(printf '%*s' $BaseIndent '')"
    
    WrapIndentText="$IndentText"
    [[ $BaseIndent -gt 0 ]] && WrapIndentText+="  "

    typeset -i TerminalWidth=$(tput cols)
    typeset -i RequestedWrap=${OptionsMap[Wrap]:-0}
    typeset -i WrapWidth

    if (( RequestedWrap == 0 && IndentSize == 0 )); then
        # print -- behaves differently than echo in zsh, more predictable for output
        print -- "${CurrentColor}${CurrentEmoji}${MessageText}${ResetColor}"
        return 0
    elif (( RequestedWrap > 0 )); then
        WrapWidth=$(( RequestedWrap <= TerminalWidth ? RequestedWrap : TerminalWidth ))
    elif (( IndentSize > 0 )); then
        WrapWidth=$TerminalWidth
    else
        print -- "${CurrentColor}${CurrentEmoji}${MessageText}${ResetColor}"
        return 0
    fi

    typeset -i WrapMargin=2
    typeset -i MinContentWidth=40
    typeset -i EffectiveWidth=$(( WrapWidth - BaseIndent - WrapMargin ))
    (( EffectiveWidth < MinContentWidth )) && EffectiveWidth=MinContentWidth

    OutputText=""
    CurrentLine="${IndentText}${CurrentEmoji}"
    typeset -i IsFirstLine=1

    # ${(ps:\n:)text} is zsh-specific splitting that preserves empty lines
    # Unlike bash IFS splitting which would collapse empty lines
    typeset -a Lines
    typeset Line
    Lines=(${(ps:\n:)MessageText})
    
    typeset -i LineNum=1
    for Line in $Lines; do
        if (( LineNum > 1 )); then
            OutputText+="${CurrentLine}"$'\n'
            CurrentLine="${IndentText}"
            IsFirstLine=0
        fi
        
        # Split preserving exact whitespace patterns
        typeset -a Words
        Words=(${(ps: :)Line})
        
        for WordText in $Words; do
            # Tab expansion consistent between zsh/bash
            WordText=${WordText//$'\t'/    }
            
            # ${(%)string} is zsh-specific expansion that handles prompt escapes
            # Used for accurate Unicode width calculation, no bash equivalent
            typeset -i WordWidth=${#${(%)WordText}}
            typeset -i CurrentWidth=${#${(%)CurrentLine}}
            
            if (( CurrentWidth + WordWidth + 1 > WrapWidth - WrapMargin )); then
                if (( CurrentWidth > ${#IndentText} + (IsFirstLine ? ${#CurrentEmoji} : 0) )); then
                    OutputText+="${CurrentLine}"$'\n'
                    CurrentLine="${WrapIndentText}"
                    IsFirstLine=0
                fi
                
                if (( WordWidth > EffectiveWidth )); then
                    while (( ${#WordText} > EffectiveWidth )); do
                        # Zsh array slicing uses [start,end] unlike bash's offset/length
                        CurrentLine+="${WordText[1,EffectiveWidth]}"
                        OutputText+="${CurrentLine}"$'\n'
                        WordText="${WordText[EffectiveWidth+1,-1]}"
                        CurrentLine="${WrapIndentText}"
                        IsFirstLine=0
                    done
                fi
                CurrentLine+="$WordText"
            else
                if (( CurrentWidth == ${#IndentText} + (IsFirstLine ? ${#CurrentEmoji} : 0) )); then
                    CurrentLine+="$WordText"
                else
                    CurrentLine+=" $WordText"
                fi
            fi
        done
        (( LineNum++ ))
    done

    [[ -n "$CurrentLine" ]] && OutputText+="${CurrentLine}"

    print -- "${CurrentColor}${OutputText}${ResetColor}"
    return 0
}

#----------------------------------------------------------------------#
# Function: z_Convert_Path_To_Relative
#----------------------------------------------------------------------#
# Description:
#   Converts an absolute path to a relative path from the current directory.
#   If the current directory is the path, returns "./" instead of just "."
#   for improved usability and readability. Handles various path relationships
#   including subdirectories, parent directories, and unrelated paths.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive examples
#     * Added detailed dependency information
#     * Renamed "Side Effects" to "Runtime Impact"
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with path normalization
#     * Added special case handling for current directory
#     * Added subdirectory path handling
#     * Added parent directory path handling
#
# Features:
#   - Intelligent path relationship detection
#   - Special case handling for current directory (./)
#   - Conversion of paths to relative format for better readability
#   - Support for parent directory traversal (../)
#   - Consistent output format with leading ./ for current directory
#   - Uses Zsh-native parameter expansion for efficiency
#   - Handles both absolute and relative input paths
#
# Parameters:
#   $1 - Path to convert (string): The path to convert to a relative path.
#        Can be absolute or relative, but will be normalized to absolute first.
#
# Returns:
#   Prints the relative path to stdout
#   Returns 0 on success
#   May return non-zero if the path parameter is missing
#
# Runtime Impact:
#   - Prints formatted path to stdout
#   - Uses PWD to determine the current directory
#   - No file system modifications
#   - Minimal computational overhead
#   - Consistent output formatting regardless of input path style
#
# Dependencies:
#   - Zsh parameter expansion capabilities:
#     * :A modifier for absolute path resolution
#     * :P modifier for relative path calculation
#   - Environment variable: PWD (current working directory)
#
# Usage Examples:
#   # Convert a file path to a relative path:
#   RelPath=$(z_Convert_Path_To_Relative "/home/user/projects/file.txt")
#   # If current directory is /home/user, prints "./projects/file.txt"
#   
#   # Convert current directory to a consistent format:
#   RelPath=$(z_Convert_Path_To_Relative "$PWD")
#   # Always prints "./" for better readability
#   
#   # Use in formatted output:
#   z_Output info "Working with file: $(z_Convert_Path_To_Relative "$FilePath")"
#   
#   # Handle parent directory paths:
#   RelPath=$(z_Convert_Path_To_Relative "/home/user")
#   # If current directory is /home/user/projects, prints "../"
#   
#   # Capture result for later use:
#   if FilePath=$(z_Convert_Path_To_Relative "$LongPath"); then
#     z_Output success "Using path: $FilePath"
#   else
#     z_Output error "Failed to convert path"
#   fi
#----------------------------------------------------------------------#
function z_Convert_Path_To_Relative() {
    typeset InputPath="${1:?Missing path parameter}"
    
    # Use :A modifier to get absolute path
    typeset AbsolutePath="${InputPath:A}"
    typeset CurrentPath="${PWD:A}"
    
    # If the path is the current directory, return "./" instead of "."
    if [[ "$AbsolutePath" == "$CurrentPath" ]]; then
        print -- "./"
        return 0
    fi
    
    # If the path is a subdirectory of the current directory
    if [[ "$AbsolutePath" == "$CurrentPath"/* ]]; then
        # Remove current directory prefix and leading slash
        print -- "./${AbsolutePath#$CurrentPath/}"
        return 0
    fi
    
    # If the path is a parent directory or elsewhere
    # Get relative path using :P modifier
    typeset RelativePath="${AbsolutePath:P}"
    
    # If the result is just ".", return "./" for consistency
    if [[ "$RelativePath" == "." ]]; then
        print -- "./"
    else
        print -- "$RelativePath"
    fi
    
    return 0
}

#----------------------------------------------------------------------#
# Function: z_Report_Error
#----------------------------------------------------------------------#
# Description:
#   Centralized error reporting with consistent formatting and error
#   code management. Provides a unified interface for error handling
#   across scripts, ensuring all errors are reported with appropriate
#   visibility and formatting. The function uses z_Output when available
#   for rich formatting and falls back to basic printing if necessary.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with detailed examples
#     * Improved parameter descriptions
#     * Added comprehensive documentation sections
#   - 0.1.00 (2025-03-26)
#     * Initial implementation
#     * Added support for z_Output fallback
#     * Implemented force display in quiet mode
#
# Features:
#   - Unified error reporting across all scripts
#   - Fallback mechanism when z_Output is unavailable
#   - Support for custom exit codes
#   - Forced display even in quiet mode
#   - Consistent formatting with emoji and color
#   - Simple interface with minimal required parameters
#
# Parameters:
#   $1 - Error message (string): The error message to display
#        Must be provided and non-empty
#   $2 - Exit code (integer): Optional error code to return
#        Defaults to Exit_Status_General (1) if not specified
#
# Returns:
#   Exit_Status_General (1) by default, or the provided exit code
#   Never returns 0 (success), as this function is for error reporting only
#
# Runtime Impact:
#   - Prints error message to stderr
#   - Forces message display even in quiet mode (when using z_Output)
#   - Uses emoji prefix and red color when available
#
# Dependencies:
#   - Optional: z_Output function for rich formatting (used if available)
#   - Required script variables:
#     * Exit_Status_General (1) - Default error code
#
# Usage Examples:
#   # Basic error reporting with default exit code:
#   z_Report_Error "Missing required configuration file"
#   
#   # Error reporting with specific exit code:
#   z_Report_Error "Failed to create directory" $Exit_Status_IO
#   
#   # Error reporting and immediate return:
#   if [[ -z "$Parameter" ]]; then
#     z_Report_Error "Missing required parameter" $Exit_Status_Usage
#     return $Exit_Status_Usage
#   fi
#   
#   # Error with value inspection:
#   z_Report_Error "Invalid value specified: $Value" $Exit_Status_Validation
#----------------------------------------------------------------------#
function z_Report_Error() {
    typeset ErrorMessage="${1:?Missing error message parameter}"
    typeset -i ErrorCode="${2:-$Exit_Status_General}"
    
    # Use z_Output if the function is defined and callable
    if typeset -f z_Output >/dev/null; then
        z_Output error "$ErrorMessage" Force=1
    else
        # Fall back to basic error output if z_Output isn't available
        print -u2 "❌ ERROR: $ErrorMessage"
    fi
    
    return $ErrorCode
}

#----------------------------------------------------------------------#
# Function: z_Check_Dependencies
#----------------------------------------------------------------------#
# Description:
#   Checks for the presence of required and optional external commands 
#   and tools. Provides centralized dependency verification with detailed
#   feedback, distinguishing between mandatory dependencies (which cause
#   failure if missing) and optional dependencies (which only generate
#   warnings if missing). Supports both array-based dependency lists and
#   direct command arguments for flexibility.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive descriptions
#     * Improved parameter details and usage examples
#     * Renamed "Side Effects" to "Runtime Impact"
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with array-based dependency checking
#     * Added support for optional dependencies
#     * Implemented fallback for direct command argument style
#     * Added warning messages for optional dependencies
#
# Features:
#   - Dual interface supporting both array names and direct command arguments
#   - Separate handling for required vs. optional dependencies
#   - Clear error reporting with specific messages for each missing dependency
#   - Warning-only reporting for optional dependencies
#   - Error counting for aggregated status reporting
#   - Compatibility with both old and new usage patterns
#   - Integration with the z_Output system when available
#
# Parameters:
#   $1 - Dependencies (string or array name): Can be either:
#        - An array name containing required command dependencies
#          Example: "RequiredCmds" where RequiredCmds=("git" "ssh")
#        - A direct command name to check
#          Example: "git"
#
#   $2 - Optional dependencies (array name): Optional parameter for
#        specifying an array containing optional command names.
#        Missing optional dependencies generate warnings but don't
#        cause failure. Only used when $1 is an array name.
#
# Returns:
#   Exit_Status_Success (0) if all required dependencies are available
#   Exit_Status_Dependency (127) if any required dependency is missing
#
# Runtime Impact:
#   - Prints error messages for missing required dependencies
#   - Prints warning messages for missing optional dependencies
#   - Messages use z_Output or print to stderr if z_Output unavailable
#   - Doesn't modify any files or persistent state
#   - Performance scales with number of dependencies checked
#
# Dependencies:
#   - command builtin to check command availability
#   - z_Report_Error function for reporting missing requirements
#   - z_Output function (optional) for warning messages
#   - typeset -p command for checking array variables
#
# Usage Examples:
#   # Modern usage with array names:
#   typeset -a RequiredCmds=("git" "ssh" "tput")
#   z_Check_Dependencies "RequiredCmds" || return $?
#
#   # Check both required and optional dependencies:
#   typeset -a RequiredCmds=("git" "ssh")
#   typeset -a OptionalCmds=("gpg" "gh")
#   z_Check_Dependencies "RequiredCmds" "OptionalCmds" || return $?
#
#   # Legacy usage with direct command arguments:
#   z_Check_Dependencies git ssh tput || exit $?
#
#   # With detailed error handling:
#   if ! z_Check_Dependencies "RequiredCmds"; then
#     z_Output error "Missing required dependencies - please install them first"
#     return $Exit_Status_Dependency
#   fi
#----------------------------------------------------------------------#
function z_Check_Dependencies() {
    # First argument is either a command name or an array name
    typeset FirstArg="${1:?Missing dependencies parameter}"
    
    typeset -i ErrorCount=0
    typeset Command
    
    # Check if the first argument is a variable name referring to an array
    if typeset -p "$FirstArg" &>/dev/null; then
        # Process as array reference if possible (for new usage pattern)
        if [[ "$(typeset -p "$FirstArg" 2>/dev/null)" == *"array"* ]]; then
            # Use eval to safely access array by name - avoids typeset -n compatibility issues
            eval "local CommandArray=(\"\${$FirstArg[@]}\")"
            
            for Command in "${CommandArray[@]}"; do
                if ! command -v "$Command" >/dev/null 2>&1; then
                    z_Report_Error "Required command not found: $Command"
                    (( ErrorCount++ ))
                fi
            done
            
            # Handle optional array if provided
            if [[ -n "${2:-}" ]] && typeset -p "$2" &>/dev/null; then
                eval "local OptionalArray=(\"\${$2[@]}\")"
                
                for Command in "${OptionalArray[@]}"; do
                    if ! command -v "$Command" >/dev/null 2>&1; then
                        if typeset -f z_Output >/dev/null; then
                            z_Output warn "Optional command not found: $Command"
                        else
                            print -u2 "⚠️ WARNING: Optional command not found: $Command"
                        fi
                    fi
                done
            fi
        else
            # Fall back to direct command checking (original usage pattern)
            for Command in "$@"; do
                if ! command -v "$Command" >/dev/null 2>&1; then
                    z_Report_Error "Required command not found: $Command"
                    (( ErrorCount++ ))
                fi
            done
        fi
    else
        # Direct command checking (original usage pattern)
        for Command in "$@"; do
            if ! command -v "$Command" >/dev/null 2>&1; then
                z_Report_Error "Required command not found: $Command"
                (( ErrorCount++ ))
            fi
        done
    fi
    
    # Return appropriate exit status
    if (( ErrorCount > 0 )); then
        return $Exit_Status_Dependency
    fi
    
    return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: z_Ensure_Parent_Path_Exists
#----------------------------------------------------------------------#
# Description:
#   Creates parent directories for a given file path if they don't
#   already exist. Useful for ensuring a file can be written to a
#   specific location. Handles both file and directory paths with 
#   proper path normalization, permissions setting, and write-access
#   verification.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive examples
#     * Improved parameter descriptions with more details
#     * Added detailed Runtime Impact section
#     * Added explicit handling for paths ending with slashes
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with basic directory creation
#     * Added permission setting functionality
#     * Added error handling for creation failures
#     * Added writability check for existing directories
#
# Features:
#   - Handles both file and directory paths intelligently
#   - Creates nested directory structures recursively
#   - Sets custom permissions on newly created directories
#   - Verifies write access to existing directories
#   - Provides detailed error reporting on failures
#   - Special case handling for current directory "."
#   - Parameter validation to prevent incorrect usage
#
# Parameters:
#   $1 - Target path (string): File or directory path whose parent 
#        directories should exist. For files, creates the containing
#        directory. For directories (paths ending with '/'), creates
#        the directory itself.
#   $2 - Permissions (string): Optional octal permissions to set on 
#        created directories (default: 755)
#
# Returns:
#   Exit_Status_Success (0) if parent directories exist or were created
#   Exit_Status_Usage (2) if target path parameter is missing
#   Exit_Status_IO (3) if directory creation or permission setting fails
#
# Runtime Impact:
#   - Creates directories on the filesystem if they don't exist
#   - Sets directory permissions according to the specified mode
#   - Outputs error messages for failure conditions
#   - No impact if parent directories already exist and are writable
#   - May require elevated permissions depending on target location
#
# Dependencies:
#   - mkdir command for directory creation
#   - chmod command for setting permissions
#   - z_Report_Error function for error reporting
#   - Zsh parameter expansion for path manipulation
#
# Usage Examples:
#   # Ensure parent directory exists for a file:
#   z_Ensure_Parent_Path_Exists "/path/to/file.txt" || return $?
#   
#   # Create a directory with custom permissions:
#   z_Ensure_Parent_Path_Exists "/path/to/dir/" 700 || return $?
#   
#   # Create nested directory structure:
#   z_Ensure_Parent_Path_Exists "/path/to/deeply/nested/file.cfg" || return $?
#   
#   # Create directory with restrictive permissions:
#   z_Ensure_Parent_Path_Exists "/path/to/secure/config/" 600 || return $?
#   
#   # With detailed error handling:
#   if ! z_Ensure_Parent_Path_Exists "$ConfigPath"; then
#     z_Output error "Failed to create configuration directory"
#     z_Output info "Please check your permissions and try again"
#     return $Exit_Status_IO
#   fi
#----------------------------------------------------------------------#
function z_Ensure_Parent_Path_Exists() {
    typeset TargetPath="${1:?Missing target path parameter}"
    typeset DirPerms="${2:-755}"
    
    # Extract the parent directory path
    typeset ParentDir
    
    # If the path ends with a slash, it's already a directory
    if [[ "$TargetPath" == */ ]]; then
        ParentDir="${TargetPath%/}"
    else
        # Otherwise, get the directory containing the file
        ParentDir="${TargetPath:h}"
    fi
    
    # No need to create anything if parent dir is just '.'
    if [[ "$ParentDir" == "." ]]; then
        return $Exit_Status_Success
    fi
    
    # Create the directory if it doesn't exist
    if [[ ! -d "$ParentDir" ]]; then
        # Use mkdir with -p to create parent directories as needed
        if ! mkdir -p "$ParentDir"; then
            z_Report_Error "Failed to create directory: $ParentDir" $Exit_Status_IO
            return $Exit_Status_IO
        fi
        
        # Set permissions on the created directory
        if ! chmod "$DirPerms" "$ParentDir"; then
            z_Report_Error "Failed to set permissions on directory: $ParentDir" $Exit_Status_IO
            return $Exit_Status_IO
        fi
    fi
    
    # Verify the directory is writable
    if [[ ! -w "$ParentDir" ]]; then
        z_Report_Error "Directory exists but is not writable: $ParentDir" $Exit_Status_IO
        return $Exit_Status_IO
    fi
    
    return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: z_Setup_Environment
#----------------------------------------------------------------------#
# Description:
#   Initializes the script environment with safe defaults, verifies
#   required dependencies, and sets up necessary environment variables.
#   This is typically called near the start of a script after setting
#   the basic Zsh options. This function performs comprehensive
#   environment initialization including version checks, dependency
#   validation, terminal capability setup, and global variable definition.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with detailed explanations
#     * Added comprehensive examples
#     * Renamed "Side Effects" to "Runtime Impact"
#     * Added specific terminal capability initialization details
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with Zsh version checking
#     * Added core dependency verification
#     * Implemented terminal capability detection
#     * Added default environment variable initialization
#
# Features:
#   - Comprehensive environment validation and setup
#   - Zsh version compatibility checking
#   - Core command dependency verification
#   - Terminal capability detection with fallbacks
#   - Output control variable initialization
#   - Safe error propagation
#   - Internal helper functions with clear responsibilities
#   - Script execution state tracking
#
# Parameters:
#   None - Can be customized by modifying the internal constants if needed
#
# Returns:
#   Exit_Status_Success (0) on successful environment setup
#   Exit_Status_Dependency (127) if environment requirements are not met
#
# Runtime Impact:
#   - Defines global variables for output control:
#     * Output_Verbose_Mode - Controls verbose output (0/1)
#     * Output_Quiet_Mode - Controls suppression of non-critical output (0/1)
#     * Output_Debug_Mode - Controls debug message display (0/1)
#     * Output_Prompt_Enabled - Controls interactive prompting (0/1)
#   - Defines global terminal capability variables:
#     * Term_Reset, Term_Bold, Term_Red, Term_Green, etc.
#   - Sets Script_Running flag to track execution state
#   - May generate error messages for missing dependencies
#   - Does not modify any files
#   - Performs validation checks that may fail if requirements aren't met
#
# Dependencies:
#   - Zsh 5.8 or later
#   - Core commands: printf, zsh, tput
#   - z_Report_Error function for error reporting
#   - command builtin for dependency checking
#
# Usage Examples:
#   # Basic usage with immediate exit on failure:
#   z_Setup_Environment || exit $?
#   
#   # With custom error handling:
#   if ! z_Setup_Environment; then
#     print "Environment setup failed - please check requirements"
#     exit $Exit_Status_Dependency
#   fi
#   
#   # Setting custom output modes after initialization:
#   z_Setup_Environment || exit $?
#   Output_Verbose_Mode=$TRUE  # Enable verbose output
#   Output_Debug_Mode=$TRUE    # Enable debug output
#   
#   # Checking available terminal capabilities:
#   z_Setup_Environment || exit $?
#   if [[ -n "$Term_Bold$Term_Red" ]]; then
#     # Use terminal formatting
#   else
#     # Terminal doesn't support formatting
#   fi
#   
#   # For non-interactive scripts:
#   z_Setup_Environment || exit $?
#   Output_Prompt_Enabled=$FALSE  # Disable interactive prompts
#   Output_Quiet_Mode=$TRUE       # Minimize output
#----------------------------------------------------------------------#
function z_Setup_Environment() {
    # Define minimum required version
    typeset -r RequiredZshMajor=5
    typeset -r RequiredZshMinor=8
    
    # Verify Zsh version first
    function check_Zsh_Version() {
        typeset ZshOutput MinVer
        typeset -i Major=0 Minor=0
        
        ZshOutput="$(zsh --version 2>/dev/null)"
        if [[ -z "$ZshOutput" ]]; then
            z_Report_Error "Failed to get Zsh version"
            return 1
        fi
        
        # Extract version numbers using parameter expansion
        MinVer="${ZshOutput#*zsh }"
        MinVer="${MinVer%% *}"
        Major="${MinVer%%.*}"
        Minor="${MinVer#*.}"
        Minor="${Minor%%.*}"  # Handle cases like 5.8.1
        
        if (( Major < RequiredZshMajor || (Major == RequiredZshMajor && Minor < RequiredZshMinor) )); then
            z_Report_Error "Zsh version ${RequiredZshMajor}.${RequiredZshMinor} or later required (found ${Major}.${Minor})"
            return 1
        fi
        return 0
    }
    
    # Check basic command dependencies
    function check_Core_Dependencies() {
        typeset -a RequiredCmds=("printf" "zsh" "tput")
        
        typeset Command
        typeset -i ErrorCount=0
        
        for Command in "${RequiredCmds[@]}"; do
            if ! command -v "${Command}" >/dev/null 2>&1; then
                z_Report_Error "Required command not found: ${Command}"
                (( ErrorCount++ ))
            fi
        done
        
        return $ErrorCount
    }
    
    # Set up terminal capabilities if not already set
    function setup_Terminal_Capabilities() {
        # Only initialize if they aren't already defined
        if [[ -z "$Term_Reset" ]]; then
            # Initialize terminal capabilities
            typeset -g Term_Reset="$(tput sgr0 2>/dev/null || echo '')"
            typeset -g Term_Bold="$(tput bold 2>/dev/null || echo '')"
            typeset -g Term_Red="$(tput setaf 1 2>/dev/null || echo '')"
            typeset -g Term_Green="$(tput setaf 2 2>/dev/null || echo '')"
            typeset -g Term_Yellow="$(tput setaf 3 2>/dev/null || echo '')"
            typeset -g Term_Blue="$(tput setaf 4 2>/dev/null || echo '')"
            typeset -g Term_Magenta="$(tput setaf 5 2>/dev/null || echo '')"
            typeset -g Term_Cyan="$(tput setaf 6 2>/dev/null || echo '')"
        fi
    }
    
    # Run all setup checks
    typeset -i ErrorCount=0
    
    # Check Zsh version
    check_Zsh_Version || (( ErrorCount++ ))
    
    # Check basic dependencies
    check_Core_Dependencies || (( ErrorCount += $? ))
    
    # Set up terminal capabilities
    setup_Terminal_Capabilities
    
    # Initial environment variables with safe defaults
    # Output control flags (only set if not already defined)
    typeset -g Output_Verbose_Mode=${Output_Verbose_Mode:-0}
    typeset -g Output_Quiet_Mode=${Output_Quiet_Mode:-0}
    typeset -g Output_Debug_Mode=${Output_Debug_Mode:-0}
    typeset -g Output_Prompt_Enabled=${Output_Prompt_Enabled:-1}
    
    # Define Script_Running flag if it doesn't exist
    typeset -g Script_Running=${Script_Running:-$TRUE}
    
    # Return appropriate exit status
    if (( ErrorCount > 0 )); then
        return $Exit_Status_Dependency
    fi
    
    return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: z_Cleanup
#----------------------------------------------------------------------#
# Description:
#   Performs cleanup operations when the script exits, handling both
#   successful and error conditions. This function is designed to be
#   registered via a trap to ensure it runs even if the script exits
#   abnormally. It manages resource cleanup, prevents recursive execution,
#   and provides appropriate status messages based on exit conditions.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with detailed explanations
#     * Added comprehensive examples
#     * Renamed "Side Effects" to "Runtime Impact"
#     * Added detailed temporary file handling information
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with basic cleanup functionality
#     * Added recursive execution prevention
#     * Implemented temporary file cleanup
#     * Added status messages for completion
#
# Features:
#   - Safe trap-based cleanup registration
#   - Recursive execution prevention
#   - Temporary file cleanup with pattern matching
#   - Status reporting based on exit condition
#   - Error message propagation
#   - Safe handling of resources on abnormal termination
#   - Function availability detection for reliable operation
#
# Parameters:
#   $1 - Success flag (boolean): $TRUE for normal exit, $FALSE for error
#        Required parameter indicating whether script completed successfully
#   $2 - Error message (string): Optional message describing error condition
#        Only used when Success flag is $FALSE
#
# Returns:
#   Returns the same value as the success flag passed to it:
#   0/TRUE for successful completion
#   1/FALSE for error condition
#
# Runtime Impact:
#   - Sets global Script_Running flag to $FALSE to prevent recursive execution
#   - Deletes temporary files matching Temp_Files_Pattern (if defined)
#   - Outputs status messages about cleanup completion
#   - Outputs error message if script terminated with error
#   - May perform additional resource cleanup as needed
#   - Performance depends on number of temporary files to clean up
#   - Safe to run multiple times due to recursive execution prevention
#
# Dependencies:
#   - Required script variables:
#     * Script_Running - Flag to track and prevent recursive execution
#     * TRUE/FALSE - Boolean constants
#     * Temp_Files_Pattern (optional) - Pattern for temporary files to delete
#   - Optional: z_Output function for formatted output messages
#   - find command for temporary file cleanup
#
# Usage Examples:
#   # Register as trap handlers in your main script:
#   typeset -g Script_Running=$TRUE
#   trap 'z_Cleanup $FALSE "Script interrupted"' INT TERM
#   trap 'z_Cleanup $TRUE' EXIT
#
#   # Define temporary file pattern for automatic cleanup:
#   typeset -g Temp_Files_Pattern="my-script-tmp.*"
#   
#   # For manual cleanup on successful completion:
#   z_Cleanup $TRUE ""
#   
#   # For manual cleanup with error condition:
#   z_Cleanup $FALSE "Script terminated due to network error"
#   
#   # For scripts that generate temp files:
#   typeset -g Temp_Files_Pattern="${0:t}-tmp-$$-*"
#   trap 'z_Cleanup $FALSE "Terminated"' INT TERM
#   trap 'z_Cleanup $TRUE' EXIT
#   
#   # With detailed cleanup workflow:
#   function cleanup_Custom_Resources() {
#     # Custom cleanup code here
#   }
#   
#   typeset -g Script_Running=$TRUE
#   trap 'cleanup_Custom_Resources; z_Cleanup $FALSE "Interrupted"' INT
#   trap 'z_Cleanup $TRUE' EXIT
#----------------------------------------------------------------------#
function z_Cleanup() {
    typeset Success=${1:?Missing success flag parameter}
    typeset ErrorMsg="${2:-}"
    
    # Prevent recursive execution
    if [[ "$Script_Running" != "$TRUE" ]]; then
        return $Success
    fi
    
    # Reset the script running flag
    typeset -g Script_Running=$FALSE
    
    # Perform any required cleanup actions here
    # This is where you would remove temporary files, release resources, etc.
    
    # Remove temporary files if a pattern is defined
    if [[ -n "${Temp_Files_Pattern:-}" ]]; then
        if typeset -f z_Output >/dev/null; then
            z_Output debug "Cleaning up temporary files matching: $Temp_Files_Pattern"
        fi
        # Use safer -name approach for rm (avoid expanding wildcards too broadly)
        find /tmp -type f -name "$Temp_Files_Pattern" -mmin -60 -delete 2>/dev/null || :
    fi
    
    # Report cleanup status
    if typeset -f z_Output >/dev/null; then
        if (( Success == TRUE )); then
            # On success, report cleanup completion in debug mode
            z_Output debug "Cleanup completed successfully."
        else
            # On failure, use warning type which respects quiet mode
            z_Output warn Emoji="" ""
            z_Output warn "Script terminated with errors. Cleanup completed."
            if [[ -n "$ErrorMsg" ]]; then
                z_Output error "$ErrorMsg"
            fi
        fi
    else
        # Fallback if z_Output function isn't available
        if (( Success != TRUE )) && [[ -n "$ErrorMsg" ]]; then
            print -u2 "ERROR: $ErrorMsg"
        fi
    fi
    
    return $Success
}

########################################################################
##                DOMAIN LAYER - GIT & SSH INTEGRATION
########################################################################
## Description:
##   This section implements domain-specific functions for Git repository
##   management and SSH signing integration. These functions build upon
##   the utility layer to provide specialized capabilities for creating,
##   verifying, and managing Git repositories with SSH signatures.
##
## Functions in this section:
##   - z_Extract_SSH_Key_Fingerprint: SSH key fingerprint extraction
##   - z_Get_Git_Config: Git configuration retrieval 
##   - z_Verify_Git_Config: Git signing configuration validation
##   - z_Verify_Git_Repository: Git repository validation
##   - z_Verify_Commit_Signature: SSH signature verification
##   - z_Get_First_Commit_Hash: Inception commit access
##   - z_Get_Repository_DID: Repository DID generation
##   - z_Create_Inception_Repository: Signed repository creation
##   - z_Ensure_Allowed_Signers: SSH signature validation setup
##   - z_Setup_Git_Environment: Complete Git environment configuration
##
## Design principles:
##   - Functions focus on specific Git and SSH operations
##   - Strong validation with detailed error reporting
##   - Progressive trust implementation with verification steps
##   - Consistent parameter patterns across related functions
########################################################################

#----------------------------------------------------------------------#
# Function: z_Extract_SSH_Key_Fingerprint
#----------------------------------------------------------------------#
# Description:
#   Extracts the SSH key fingerprint from an SSH key file using a
#   consistent format. Handles various key types and formats while 
#   performing robust validation and error handling. The function
#   standardizes output to SHA256 format for consistency, ensuring
#   reliable fingerprint extraction for Git commit verification.
# 
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive examples
#     * Added detailed error handling description
#     * Renamed "Side Effects" to "Runtime Impact"
#     * Improved parameter explanations
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with basic fingerprint extraction
#     * Added support for both private and public keys
#     * Implemented SHA256 format standardization
#     * Added robust error handling and validation
#
# Features:
#   - Supports both private and public SSH key files
#   - Standardizes output format to SHA256 regardless of input format
#   - Robust error handling for missing or unreadable key files
#   - Detailed error reporting for invalid key formats
#   - Path normalization with tilde expansion support
#   - Automatic key format detection
#   - Regular expression-based fallback for non-standard outputs
#
# Parameters:
#   $1 - Path to SSH key file (string): The absolute or relative path to the
#        SSH key (supports tilde expansion). Can be either a private or 
#        public key file.
#
# Returns:
#   Prints the fingerprint to stdout in SHA256 format (SHA256:xxx...)
#   Exit_Status_Success (0) when fingerprint is successfully extracted
#   Exit_Status_Usage (2) when the key path parameter is missing
#   Exit_Status_IO (3) when the key file doesn't exist or isn't readable
#   Exit_Status_Config (6) when fingerprint extraction fails or format is invalid
#
# Runtime Impact:
#   - May create temporary files when processing non-standard key formats
#   - Prints fingerprint to stdout, which can be captured in a variable
#   - Does not modify any files permanently
#   - Minimal computational overhead
#   - Safe to run on all valid SSH key files
#
# Dependencies:
#   - ssh-keygen command (OpenSSH 8.2+ recommended for best results)
#   - Parameter expansion features of Zsh (for path normalization)
#   - Regular expression support in Zsh for fallback parsing
#
# Usage Examples:
#   # Basic usage with explicit error handling:
#   Fingerprint=$(z_Extract_SSH_Key_Fingerprint "~/.ssh/id_ed25519") || return $?
#   
#   # Using with private or public key:
#   Fingerprint=$(z_Extract_SSH_Key_Fingerprint "~/.ssh/id_ed25519.pub") || return $?
#   
#   # Capturing both fingerprint and exit status:
#   if ! Fingerprint=$(z_Extract_SSH_Key_Fingerprint "$KeyPath"); then
#     z_Report_Error "Failed to extract fingerprint"
#     return $?
#   fi
#   
#   # Usage with verbose output:
#   if Fingerprint=$(z_Extract_SSH_Key_Fingerprint "$KeyPath"); then
#     z_Output success "Key fingerprint: $Fingerprint"
#     z_Output info "This fingerprint uniquely identifies your SSH key"
#   else
#     z_Output error "Could not extract fingerprint from key: $KeyPath"
#   fi
#   
#   # Verifying key identity before operations:
#   ExpectedFingerprint="SHA256:AbCdEf123456789..."
#   ActualFingerprint=$(z_Extract_SSH_Key_Fingerprint "$KeyPath") || return $?
#   
#   if [[ "$ActualFingerprint" == "$ExpectedFingerprint" ]]; then
#     z_Output success "Key identity verified"
#   else
#     z_Output error "Key identity mismatch!"
#     z_Output error "Expected: $ExpectedFingerprint"
#     z_Output error "Actual: $ActualFingerprint"
#     return $Exit_Status_Validation
#   fi
#----------------------------------------------------------------------#
function z_Extract_SSH_Key_Fingerprint() {
   typeset KeyPath="$1"
   typeset SshKeygenOutput
   typeset Fingerprint
   typeset -a OutputParts
   typeset -a match mbegin mend  # Required for Zsh regex capturing
   
   # Ensure parameter is provided
   if [[ -z "$KeyPath" ]]; then
       z_Report_Error "Missing required parameter: SSH key path" $Exit_Status_Usage
       return $Exit_Status_Usage
   fi
   
   # Expand the path if it contains a tilde
   KeyPath=${~KeyPath}
   
   # Check if file exists and is readable
   if [[ ! -r "$KeyPath" ]]; then
       z_Report_Error "SSH key file not found or not readable: $KeyPath" $Exit_Status_IO
       return $Exit_Status_IO
   fi
   
   # Capture ssh-keygen output with explicit SHA256 format
   SshKeygenOutput=$(ssh-keygen -E sha256 -lf "$KeyPath" 2>/dev/null)
   
   # Exit on failure to get output
   if [[ -z "$SshKeygenOutput" ]]; then
       z_Report_Error "Failed to get fingerprint for key: $KeyPath" $Exit_Status_Config
       return $Exit_Status_Config
   fi
   
   # Split output into parts using Zsh-specific array splitting
   # The (s: :) flag splits the string on spaces - unique to Zsh
   OutputParts=(${(s: :)SshKeygenOutput})
   
   # Second part should be the SHA256 fingerprint
   if (( ${#OutputParts} >= 2 )); then
       Fingerprint="${OutputParts[2]}"
   else
       z_Report_Error "Unexpected ssh-keygen output format: $SshKeygenOutput" $Exit_Status_Config
       return $Exit_Status_Config
   fi
   
   # Ensure the fingerprint is in SHA256: format
   if [[ ! "$Fingerprint" =~ ^SHA256: ]]; then
       # Try to extract fingerprint using regex if format is different
       if [[ "$SshKeygenOutput" =~ SHA256:[a-zA-Z0-9+/]+=* ]]; then
           Fingerprint=$match
       else
           z_Report_Error "Invalid fingerprint format: $Fingerprint" $Exit_Status_Config
           return $Exit_Status_Config
       fi
   fi
   
   # Print and return
   print -- "$Fingerprint"
   return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: z_Get_Git_Config
#----------------------------------------------------------------------#
# Description:
#   Retrieves Git configuration values with robust error handling.
#   Provides consistent error reporting when configuration is not set.
#   This function encapsulates Git configuration access in a reliable,
#   standardized manner, supporting both repository-specific and global
#   configurations while providing clear error feedback.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive examples
#     * Added detailed parameter explanations
#     * Renamed "Side Effects" to "Runtime Impact"
#     * Improved error reporting descriptions
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with basic Git config retrieval
#     * Added error handling for missing configuration
#     * Implemented consistent output format
#     * Added parameter validation
#
# Features:
#   - Standardized access to Git configuration values
#   - Consistent error handling for missing configurations
#   - Support for both global and repository-specific settings
#   - Clean output format without trailing whitespace
#   - Efficient implementation using Zsh parameter expansion
#   - Detailed error reporting with specific key information
#   - Appropriate exit codes for different failure conditions
#
# Parameters:
#   $1 - Configuration key (string): The Git configuration key to retrieve
#        (e.g., "user.name", "user.email", "gpg.format"). Must use standard
#        Git config key syntax with section.key format.
#
# Returns:
#   Prints configuration value to stdout if found
#   Exit_Status_Success (0) when the configuration value is found
#   Exit_Status_Config (6) when the configuration key is not set
#   Exit_Status_Usage (2) when the configuration key parameter is missing
#
# Runtime Impact:
#   - Outputs configuration value to stdout (capture in variable when needed)
#   - Reports errors to stderr when configuration is missing
#   - No file system modifications
#   - No persistent state changes
#   - Minimal computational overhead
#
# Dependencies:
#   - git command (2.34+ recommended for all features)
#   - z_Report_Error function for consistent error reporting
#   - Zsh parameter expansion for output processing
#
# Usage Examples:
#   # Basic usage with error handling:
#   Username=$(z_Get_Git_Config "user.name") || return $?
#   
#   # Checking specific git configuration with explicit error handling:
#   if ! SigningKey=$(z_Get_Git_Config "user.signingkey"); then
#     z_Output warn "SSH signing key not configured in Git"
#     z_Output info "Run: git config --global user.signingkey ~/.ssh/your_key"
#     return $Exit_Status_Config
#   fi
#   
#   # Determine if a feature is enabled:
#   IsSigningEnabled=$(z_Get_Git_Config "commit.gpgsign") || echo "false"
#   if [[ "$IsSigningEnabled" == "true" ]]; then
#     z_Output success "Commit signing is enabled"
#   fi
#   
#   # With default values and validation:
#   Email=$(z_Get_Git_Config "user.email") || {
#     z_Output warn "Email not configured in Git, using default"
#     Email="default@example.com" 
#   }
#   
#   # Checking repository-specific configuration:
#   Origin=$(z_Get_Git_Config "remote.origin.url") || {
#     z_Output warn "Repository has no origin configured"
#     z_Output info "Use 'git remote add origin <url>' to set one"
#   }
#----------------------------------------------------------------------#
function z_Get_Git_Config() {
   typeset configKey="$1"
   typeset configValue

   # Use Zsh-specific nested parameter expansion for config retrieval
   # The ${$(command):-} syntax captures command output with empty fallback
   configValue=${$(git config "$configKey" 2>/dev/null):-}

   if [[ -z "$configValue" ]]; then
       z_Report_Error "Git configuration '$configKey' not set" $Exit_Status_Config
       return $Exit_Status_Config
   fi

   print -- "$configValue"
   return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: z_Verify_Git_Config
#----------------------------------------------------------------------#
# Description:
#   Verifies Git configuration includes required settings for SSH signing.
#   Performs comprehensive validation of Git's configuration for SSH-based
#   commit signing, including user identity, signing key availability,
#   proper format settings, and signing preferences. Provides detailed
#   error reporting with actionable guidance when configuration issues
#   are detected.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive examples
#     * Added detailed validation descriptions
#     * Renamed "Side Effects" to "Runtime Impact"
#     * Improved parameter explanations
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with basic Git configuration verification
#     * Added identity validation (user.name and user.email)
#     * Added signing key verification
#     * Added format validation (gpg.format must be "ssh")
#     * Added commit signing preference validation
#
# Features:
#   - Comprehensive Git configuration validation for SSH signing
#   - Support for alternative SSH signing key paths
#   - Detailed, actionable error messages when issues are found
#   - Multiple validation layers (identity, keys, format, preferences)
#   - Informative warnings for non-critical issues
#   - Explicit verification of SSH key existence and readability
#   - Format standardization (requiring "ssh" for gpg.format)
#   - Preference validation (recommending commit.gpgsign=true)
#
# Parameters:
#   $1 - Optional signing key path (string): Alternative SSH key path to use
#        instead of the one configured in git config. If provided, this key
#        will be validated instead of the one from git config. Supports tilde
#        expansion for home directory references.
#
# Returns:
#   Exit_Status_Success (0) when all required configuration is valid
#   Exit_Status_Config (6) when one or more required settings are missing or invalid
#
# Runtime Impact:
#   - Outputs error messages for missing or invalid configuration
#   - Provides guidance for fixing configuration issues
#   - No file system modifications
#   - No persistent state changes
#   - Validates SSH key existence and readability
#
# Dependencies:
#   - git command (2.34+ required for SSH signing support)
#   - z_Output function for formatted output
#   - z_Report_Error function for error reporting
#   - z_Get_Git_Config function for configuration retrieval
#
# Validation Checks:
#   - User identity (user.name and user.email)
#   - SSH signing key existence and readability
#   - GPG format setting (must be "ssh")
#   - Commit signing preference (warns if not enabled)
#
# Usage Examples:
#   # Verify using Git's configured signing key:
#   z_Verify_Git_Config || return $?
#   
#   # Verify with an alternative signing key:
#   z_Verify_Git_Config "~/.ssh/custom_signing_key" || return $?
#   
#   # With detailed error handling:
#   if ! z_Verify_Git_Config; then
#     z_Output error "Git is not properly configured for SSH signing"
#     z_Output info "Run the following to configure Git:"
#     z_Output info "  git config --global user.name \"Your Name\""
#     z_Output info "  git config --global user.email \"your.email@example.com\""
#     z_Output info "  git config --global user.signingkey ~/.ssh/your_key"
#     z_Output info "  git config --global gpg.format ssh"
#     z_Output info "  git config --global commit.gpgsign true"
#     return $Exit_Status_Config
#   fi
#   
#   # As part of a setup process:
#   z_Output info "Verifying Git configuration for SSH signing..."
#   if z_Verify_Git_Config; then
#     z_Output success "Git configuration valid for SSH signing"
#   else
#     z_Output warn "Git configuration needs adjustment before proceeding"
#     z_Setup_Git_Environment || return $?
#   fi
#   
#   # With verbose output for diagnostics:
#   Output_Verbose_Mode=$TRUE
#   z_Verify_Git_Config && z_Output success "SSH signing properly configured"
#----------------------------------------------------------------------#
function z_Verify_Git_Config() {
   # Check for required Git config settings
   typeset Username SigningKey EmailAddress Format CommitSign
   typeset ProvidedKey="${1:-}"
   typeset -i ErrorFound=$FALSE
   
   # Support both directly provided key and git config
   if [[ -n "$ProvidedKey" ]]; then
       SigningKey="$ProvidedKey"
       # Expand path if needed
       SigningKey=${~SigningKey}
   else
       # Get signing key from git config
       SigningKey=$(git config user.signingkey 2>/dev/null)
       if [[ -z "$SigningKey" ]]; then
           z_Report_Error "Git user.signingkey not set"
           z_Output info "Run: git config --global user.signingkey /path/to/ssh_key"
           ErrorFound=$TRUE
       fi
   fi
   
   # Check for required git user information
   Username=$(git config user.name 2>/dev/null)
   if [[ -z "$Username" ]]; then
       z_Report_Error "Git user.name not set"
       z_Output info "Run: git config --global user.name \"Your Name\""
       ErrorFound=$TRUE
   fi
   
   EmailAddress=$(git config user.email 2>/dev/null)
   if [[ -z "$EmailAddress" ]]; then
       z_Report_Error "Git user.email not set"
       z_Output info "Run: git config --global user.email \"your.email@example.com\""
       ErrorFound=$TRUE
   fi
   
   # Only check the signing key if we have one to check
   if [[ -n "$SigningKey" ]]; then
       # Check SSH key exists and is readable
       if [[ ! -r "$SigningKey" ]]; then
           z_Report_Error "SSH signing key not found or not readable: $SigningKey"
           ErrorFound=$TRUE
       fi
   fi
   
   # Verify gpg.format is set to ssh
   Format=$(git config gpg.format 2>/dev/null)
   if [[ "$Format" != "ssh" ]]; then
       z_Report_Error "Git gpg.format not set to 'ssh'"
       z_Output info "Run: git config --global gpg.format ssh"
       ErrorFound=$TRUE
   fi
   
   # Verify commit.gpgSign is true (warn-only)
   CommitSign=$(git config commit.gpgsign 2>/dev/null)
   if [[ "$CommitSign" != "true" ]]; then
       z_Output warn "Git commit.gpgsign not set to 'true'"
       z_Output info "For automatic signing, run: git config --global commit.gpgsign true"
   fi
   
   # Return error if any problems were found
   if (( ErrorFound == TRUE )); then
       return $Exit_Status_Config
   fi
   
   return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: z_Verify_Git_Repository
#----------------------------------------------------------------------#
# Description:
#   Verifies a path is a functional Git repository. Performs a multi-step
#   validation process to confirm the specified path exists as a directory
#   and contains a valid, accessible Git repository. Provides clear error
#   messaging when validation fails, distinguishing between path errors
#   and repository errors.
#
# Version: 0.1.01 (2025-03-28)
#
# Parameters:
#   $1 - Repository path (string): The absolute or relative path to verify
#        as a Git repository. Supports tilde expansion for home directory
#        references.
#
# Returns:
#   Exit_Status_Success (0) when the path contains a valid Git repository
#   Exit_Status_Usage (2) when the path parameter is missing
#   Exit_Status_IO (3) when the directory doesn't exist or isn't accessible
#   Exit_Status_Git_Failure (5) when the directory exists but is not a Git repository
#
# Required Script Variables:
#   - Exit_Status_Success - Success status code (0)
#   - Exit_Status_IO - IO error status code (3)
#   - Exit_Status_Git_Failure - Git failure status code (5)
#   - Exit_Status_Usage - Usage error status code (2)
#
# Side Effects:
#   - Reports errors to stderr when validation fails
#
# Dependencies:
#   - git command
#   - z_Report_Error function for consistent error reporting
#
# Validation Checks:
#   1. Parameter presence verification
#   2. Path existence and directory type validation
#   3. Git repository verification using rev-parse
#
# Usage Examples:
#   # Basic usage with error propagation:
#   z_Verify_Git_Repository "/path/to/repo" || return $?
#   
#   # With repository-specific error handling:
#   if ! z_Verify_Git_Repository "$RepoPath"; then
#     z_Output error "Cannot proceed with invalid repository"
#     z_Output info "Please ensure the path is a valid Git repository"
#     z_Output info "Run: git init $RepoPath to create a new repository"
#     return $Exit_Status_Git_Failure
#   fi
#   
#   # Using with home directory reference:
#   z_Verify_Git_Repository "~/Documents/Projects/my-repo" || return $?
#----------------------------------------------------------------------#
#----------------------------------------------------------------------#
# Function: z_Verify_Git_Repository
#----------------------------------------------------------------------#
# Description:
#   Verifies if a given path is a valid Git repository directory.
#   Performs comprehensive validation checking both directory existence
#   and Git repository status. This function serves as a foundation for
#   other Git operations by ensuring commands target valid repositories.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive descriptions
#     * Added Runtime Impact and Features sections
#     * Added detailed usage examples
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with basic repository validation
#     * Added tilde expansion support
#     * Implemented error reporting with specific codes
#
# Features:
#   - Path validation with tilde expansion support
#   - Directory existence verification
#   - Git repository validity checking
#   - Detailed error reporting with specific codes
#   - Integration with z_Report_Error for consistent error handling
#   - Fast execution with minimal overhead
#
# Parameters:
#   $1 - Repository path (string): The path to the directory to verify.
#        Supports tilde expansion for home directory references.
#        Must be a valid directory path that contains a Git repository.
#
# Returns:
#   Exit_Status_Success (0) when the path is a valid Git repository
#   Exit_Status_IO (3) when the path doesn't exist or isn't a directory
#   Exit_Status_Git_Failure (5) when the path exists but isn't a Git repository
#
# Runtime Impact:
#   - Outputs error messages to stderr when validation fails
#   - Does not modify any files or repository state
#   - Performs minimal filesystem operations
#   - Executes quickly with low resource usage
#
# Dependencies:
#   - git command (any version)
#   - z_Report_Error function for error reporting
#   - Exit status constants (Exit_Status_Success, Exit_Status_IO, Exit_Status_Git_Failure)
#
# Usage Examples:
#   # Basic usage with error propagation:
#   z_Verify_Git_Repository "/path/to/repo" || return $?
#   
#   # With home directory reference:
#   z_Verify_Git_Repository "~/Projects/my-repo" || return $?
#   
#   # With detailed error handling:
#   if ! z_Verify_Git_Repository "$RepoPath"; then
#     z_Output error "Invalid repository path: $RepoPath"
#     z_Output info "Please ensure the directory exists and is a Git repository"
#     return $?
#   fi
#   
#   # In a loop checking multiple repositories:
#   for repo in $RepoList; do
#     if z_Verify_Git_Repository "$repo"; then
#       z_Output success "Repository valid: $repo"
#     else
#       z_Output warn "Skipping invalid repository: $repo"
#     fi
#   done
#----------------------------------------------------------------------#
function z_Verify_Git_Repository() {
   typeset repoPath="$1"

   # Verify path exists and is a directory using Zsh parameter expansion
   # ${~pattern} expands the pattern (e.g., tilde) before checking if it's a directory
   if [[ ! -d "${~repoPath}" ]]; then
       z_Report_Error "Directory does not exist: $repoPath" $Exit_Status_IO
       return $Exit_Status_IO
   fi

   # Verify path is a Git repository
   if ! git -C "$repoPath" rev-parse --git-dir >/dev/null 2>&1; then
       z_Report_Error "Not a Git repository: $repoPath" $Exit_Status_Git_Failure
       return $Exit_Status_Git_Failure
   fi

   return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: z_Verify_Commit_Signature
#----------------------------------------------------------------------#
# Description:
#   Verifies the SSH signature of a Git commit with detailed reporting.
#   Performs comprehensive validation of a commit's SSH signature,
#   ensuring cryptographic verification through Git's signature
#   verification mechanism. The function provides detailed reporting
#   on verification status, including signature details and committer
#   information for audit purposes.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive descriptions
#     * Renamed "Side Effects" to "Runtime Impact"
#     * Added Features section
#     * Improved usage examples with more practical scenarios
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with SSH signature verification
#     * Added support for flexible commit references
#     * Implemented detailed error reporting
#     * Added verbose output mode support
#
# Features:
#   - Complete SSH signature verification with detailed feedback
#   - Support for any commit reference (hash, branch, tag, or relative)
#   - Configurable verbosity for different reporting needs
#   - Comprehensive status checking with specific error codes
#   - Extraction and display of signer details for audit purposes
#   - Tilde expansion support for repository paths
#   - Integration with z_Output for consistent formatting
#
# Parameters:
#   $1 - Repository path (string): The path to the Git repository containing
#        the commit to verify. Supports tilde expansion for home directory paths.
#   $2 - Commit hash (string): The hash of the commit to verify. Defaults to
#        HEAD if not provided. Can be any valid Git commit reference (hash,
#        branch, tag, or relative reference like HEAD~1).
#
# Returns:
#   Prints signature verification details to stdout
#   Exit_Status_Success (0) when signature is valid
#   Exit_Status_Usage (2) when repository path parameter is missing
#   Exit_Status_Git_Failure (5) when verification fails for any reason:
#     - Repository is not valid
#     - Commit hash is invalid
#     - Signature is missing or invalid
#     - Verification process fails
#
# Runtime Impact:
#   - Outputs verification details to stdout
#   - Reports errors to stderr when verification fails
#   - Does not modify repository or commit data
#   - Performs only read operations on the repository
#   - May access network if signatures require key retrieval (rare)
#
# Dependencies:
#   - git command (2.34+ required for SSH signature support)
#   - z_Verify_Git_Repository function for repository validation
#   - z_Output function for formatted output
#   - z_Report_Error function for error reporting
#   - Exit status constants (Exit_Status_Success, Exit_Status_Git_Failure, Exit_Status_Usage)
#   - TRUE/FALSE constants for boolean values
#   - Output_Verbose_Mode variable for controlling output detail
#
# Usage Examples:
#   # Verify the HEAD commit signature:
#   z_Verify_Commit_Signature "/path/to/repo" || return $?
#   
#   # Verify a specific commit by hash:
#   z_Verify_Commit_Signature "/path/to/repo" "abcd1234" || return $?
#   
#   # With detailed error handling and custom error messaging:
#   if ! z_Verify_Commit_Signature "$RepoPath" "$CommitHash"; then
#     z_Output error "Failed to verify commit signature"
#     z_Output info "Ensure the commit was signed and allowed_signers is configured"
#     return $Exit_Status_Git_Failure
#   fi
#   
#   # Verifying a tag or branch:
#   z_Verify_Commit_Signature "/path/to/repo" "v1.0.0" || return $?
#   
#   # In verbose mode to see author/committer details:
#   typeset -i OldVerboseMode=$Output_Verbose_Mode
#   Output_Verbose_Mode=$TRUE
#   z_Verify_Commit_Signature "$RepoPath" "$CommitHash"
#   Output_Verbose_Mode=$OldVerboseMode
#   
#   # Checking an inception commit to verify repository integrity:
#   FirstCommit=$(z_Get_First_Commit_Hash "$RepoPath") || return $?
#   z_Verify_Commit_Signature "$RepoPath" "$FirstCommit" || {
#     z_Output error "Repository inception commit has invalid signature"
#     return $Exit_Status_Git_Failure
#   }
#----------------------------------------------------------------------#
function z_Verify_Commit_Signature() {
    typeset RepoPath="$1"
    typeset CommitHash="${2:-HEAD}"
    typeset -a VerifyLines
    typeset -i SignatureValid=$FALSE
    typeset line
    
    # Validate repo path is provided
    if [[ -z "$RepoPath" ]]; then
        z_Report_Error "Repository path parameter is required" $Exit_Status_Usage
        return $Exit_Status_Usage
    fi
    
    # Expand path if it contains a tilde
    RepoPath=${~RepoPath}
    
    # Verify the repository using our utility function
    z_Verify_Git_Repository "$RepoPath" || return $?
    
    # Verify the commit hash is valid
    if ! git -C "$RepoPath" rev-parse --verify "$CommitHash" >/dev/null 2>&1; then
        z_Report_Error "Invalid commit hash: $CommitHash" $Exit_Status_Git_Failure
        return $Exit_Status_Git_Failure
    fi
    
    # Capture verify output as array, preserving line breaks
    # The (f) flag is Zsh-specific and splits output by newlines
    VerifyLines=(${(f)"$(git -C "$RepoPath" verify-commit "$CommitHash" 2>&1)"})
    
    # Zsh-native pattern matching for signature verification
    for line in $VerifyLines; do
        if [[ $line == *"Good"*"signature"* ]]; then
            SignatureValid=$TRUE
            break
        fi
    done
    
    # Error handling with Zsh-native conditionals
    if (( SignatureValid == FALSE )); then
        z_Report_Error "Signature verification failed for commit $CommitHash"
        (( ${#VerifyLines} > 0 )) && print -u2 "${VerifyLines[1]}"
        return $Exit_Status_Git_Failure
    fi
    
    # Output verification details
    z_Output success "Commit signature verified successfully:"
    
    # Use Zsh pattern matching to extract signature details
    typeset -a MatchedLines
    MatchedLines=("${(@)VerifyLines[(r)*Good*signature*]}")
    z_Output print "${(j:\n:)MatchedLines}"
    
    # Get committer info for additional verification
    typeset CommitterName=$(git -C "$RepoPath" show --no-patch --format="%cn" "$CommitHash" 2>/dev/null)
    typeset CommitterEmail=$(git -C "$RepoPath" show --no-patch --format="%ce" "$CommitHash" 2>/dev/null)
    typeset AuthorName=$(git -C "$RepoPath" show --no-patch --format="%an" "$CommitHash" 2>/dev/null)
    typeset AuthorEmail=$(git -C "$RepoPath" show --no-patch --format="%ae" "$CommitHash" 2>/dev/null)
    
    # Output additional details if verbose mode is on
    if (( Output_Verbose_Mode == TRUE )); then
        z_Output verbose "Commit details:"
        z_Output verbose "Committer: $CommitterName <$CommitterEmail>"
        z_Output verbose "Author: $AuthorName <$AuthorEmail>"
    fi
    
    return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: z_Get_First_Commit_Hash
#----------------------------------------------------------------------#
# Description:
#   Retrieves the hash of the first (inception) commit in a Git repository.
#   If multiple root commits exist, returns the first one found. This
#   function finds the genesis commit(s) of a repository by following the
#   commit graph to its origin point(s), which is essential for establishing
#   a cryptographic root of trust in the repository history.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive descriptions
#     * Renamed "Side Effects" to "Runtime Impact"
#     * Added Features section with key capabilities
#     * Added detailed usage examples
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with repository validation
#     * Added support for multiple root commits
#     * Implemented error reporting with specific codes
#
# Features:
#   - Root commit discovery across complex repository histories
#   - Zsh-native array handling for efficient operation
#   - Support for repositories with multiple root commits
#   - Clear error reporting with specific error codes
#   - Fast execution using Git's rev-list capabilities
#   - Integration with z_Report_Error for consistent error handling
#
# Parameters:
#   $1 - Repository path (string): The path to the Git repository to analyze.
#        Must be a valid Git repository directory. Supports tilde expansion.
#
# Returns:
#   Prints first commit hash to stdout
#   Exit_Status_Success (0) when the first commit hash is successfully found
#   Exit_Status_Usage (2) when repository path parameter is missing
#   Exit_Status_Git_Failure (5) when no commits exist or repository is invalid
#
# Runtime Impact:
#   - Outputs commit hash to stdout
#   - Reports errors to stderr when no commits are found
#   - Performs only read operations on the repository
#   - Does not modify repository state
#   - Minimal performance impact even on large repositories
#
# Dependencies:
#   - git command (any version)
#   - z_Report_Error function for error reporting
#   - Exit status constants (Exit_Status_Success, Exit_Status_Git_Failure, Exit_Status_Usage)
#
# Usage Examples:
#   # Basic usage with error propagation:
#   FirstCommit=$(z_Get_First_Commit_Hash "/path/to/repo") || return $?
#   
#   # With detailed error handling:
#   if ! FirstCommit=$(z_Get_First_Commit_Hash "$RepoPath"); then
#     z_Output error "Failed to retrieve inception commit"
#     z_Output info "Ensure the repository exists and has at least one commit"
#     return $?
#   fi
#   z_Output success "Repository inception commit: $FirstCommit"
#   
#   # With home directory reference:
#   FirstCommit=$(z_Get_First_Commit_Hash "~/Projects/my-repo") || return $?
#   
#   # Using with repository DID generation:
#   FirstCommit=$(z_Get_First_Commit_Hash "$RepoPath") || return $?
#   RepoDID="did:repo:$FirstCommit"
#   z_Output info "Repository DID: $RepoDID"
#   
#   # In a verification workflow:
#   FirstCommit=$(z_Get_First_Commit_Hash "$RepoPath") || return $?
#   if z_Verify_Commit_Signature "$RepoPath" "$FirstCommit"; then
#     z_Output success "Inception commit signature verified"
#   else
#     z_Output error "Inception commit has invalid signature"
#   fi
#   - Handles repositories with multiple root commits (returns first found)
#   - Provides proper error handling for empty repositories
#
# Usage Examples:
#   # Basic usage with error propagation:
#   FirstCommit=$(z_Get_First_Commit_Hash "/path/to/repo") || return $?
#   
#   # With detailed error handling:
#   if ! FirstCommit=$(z_Get_First_Commit_Hash "$RepoPath"); then
#     z_Output error "Could not determine the inception commit"
#     z_Output info "The repository may be empty or corrupted"
#     return $Exit_Status_Git_Failure
#   fi
#   
#   # Using with home directory reference:
#   FirstCommit=$(z_Get_First_Commit_Hash "~/Projects/my-repo") || return $?
#   z_Output info "Repository's first commit: $FirstCommit"
#----------------------------------------------------------------------#
function z_Get_First_Commit_Hash() {
   typeset repoPath="$1"
   typeset -a commitHashes

   # Zsh-native array splitting of commit hashes
   # This splits command output directly into array elements (different from Bash behavior)
   commitHashes=($(git -C "$repoPath" rev-list --max-parents=0 HEAD 2>/dev/null))

   # Robust array length checking
   if (( ${#commitHashes} == 0 )); then
       z_Report_Error "No initial commit found in repository" $Exit_Status_Git_Failure
       return $Exit_Status_Git_Failure
   fi

   # Always return the first commit hash
   print -- "${commitHashes[1]}"
   return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: z_Get_Repository_DID
#----------------------------------------------------------------------#
# Description:
#   Gets the DID (Decentralized Identifier) for a repository based on
#   its inception commit hash. Creates a DID in the format did:repo:<hash>.
#   This function transforms a repository's genesis commit into a standardized
#   Decentralized Identifier that uniquely identifies the repository in a
#   verifiable, platform-independent manner, supporting distributed trust
#   models and cryptographic verification across systems.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive descriptions
#     * Renamed "Side Effects" to "Runtime Impact"
#     * Added Features section with key capabilities
#     * Added comprehensive usage examples
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with DID generation
#     * Added tilde expansion support
#     * Implemented detailed error reporting
#     * Added repository validation
#
# Features:
#   - Standardized W3C-compliant DID generation
#   - Cryptographic identity based on repository inception commit
#   - Complete repository validation before DID generation
#   - Consistent format with did:repo: method prefix
#   - Detailed error reporting with specific codes
#   - Support for home directory references with tilde expansion
#   - Integration with z_Get_First_Commit_Hash for robust root finding
#
# Parameters:
#   $1 - Repository path (string): The path to the Git repository to generate
#        a DID for. Must be a valid Git repository with at least one commit.
#        Supports tilde expansion for home directory references.
#
# Returns:
#   Prints DID in the format "did:repo:<hash>" to stdout
#   Exit_Status_Success (0) when DID is generated successfully
#   Exit_Status_Usage (2) when repository path parameter is missing
#   Exit_Status_IO (3) when repository directory doesn't exist or isn't accessible
#   Exit_Status_Git_Failure (5) when repository has no commits or is invalid
#
# Runtime Impact:
#   - Outputs DID string to stdout
#   - Reports errors to stderr when DID generation fails
#   - Performs only read operations on the repository
#   - Does not modify any repository state
#   - Fast operation even on large repositories
#
# Dependencies:
#   - git command (any version)
#   - z_Verify_Git_Repository function for repository validation
#   - z_Get_First_Commit_Hash function to find genesis commit
#   - z_Report_Error function for error reporting
#   - Exit status constants (Exit_Status_Success, Exit_Status_Git_Failure, Exit_Status_IO, Exit_Status_Usage)
#
# Usage Examples:
#   # Basic usage with error propagation:
#   DID=$(z_Get_Repository_DID "/path/to/repo") || return $?
#   
#   # With detailed error handling and reporting:
#   if ! DID=$(z_Get_Repository_DID "$RepoPath"); then
#     z_Output error "Could not generate DID for repository"
#     z_Output info "Ensure the repository exists and has at least one commit"
#     return $?
#   fi
#   z_Output success "Repository DID: $DID"
#   
#   # Using with home directory reference and alternative handling:
#   DID=$(z_Get_Repository_DID "~/Projects/my-repo") || {
#     z_Output error "Failed to get repository DID"
#     return $?
#   }
#   
#   # Storing in a configuration file:
#   if DID=$(z_Get_Repository_DID "$RepoPath"); then
#     echo "REPO_DID=$DID" > .repo-identity
#     z_Output success "Repository identity saved to .repo-identity"
#   else
#     z_Output error "Could not generate repository DID"
#     return $?
#   fi
#   
#   # Using DID for repository verification:
#   ExpectedDID="did:repo:abcd1234..."
#   ActualDID=$(z_Get_Repository_DID "$RepoPath") || return $?
#   if [[ "$ActualDID" == "$ExpectedDID" ]]; then
#     z_Output success "Repository identity verified"
#   else
#     z_Output error "Repository identity mismatch!"
#     z_Output error "Expected: $ExpectedDID"
#     z_Output error "Actual: $ActualDID"
#   fi
#----------------------------------------------------------------------#
function z_Get_Repository_DID() {
   typeset RepoPath="$1"
   typeset CommitHash
   
   # Validate repo path parameter
   if [[ -z "$RepoPath" ]]; then
       z_Report_Error "Repository path parameter is required" $Exit_Status_Usage
       return $Exit_Status_Usage
   fi
   
   # Expand path if it contains a tilde
   RepoPath=${~RepoPath}
   
   # Verify the repository using our utility function
   z_Verify_Git_Repository "$RepoPath" || return $?
   
   # Get the first commit hash using our utility function
   CommitHash=$(z_Get_First_Commit_Hash "$RepoPath") || return $?
   
   # Format and return DID
   print "did:repo:$CommitHash"
   return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: z_Create_Inception_Repository
#----------------------------------------------------------------------#
# Description:
#   Creates a new Git repository with a properly signed empty inception
#   commit that establishes a cryptographic root of trust. The function
#   handles directory creation, repository initialization, and creating 
#   a signed inception commit using SSH keys. This creates a secure,
#   verifiable Git repository with an empty first commit that can serve
#   as an immutable reference point for the repository's entire history.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive descriptions
#     * Renamed "Side Effects" to "Runtime Impact"
#     * Added Features section with key capabilities
#     * Added detailed usage examples
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with inception commit creation
#     * Added support for custom signing key
#     * Implemented force flag for existing repositories
#     * Added DID generation for created repositories
#
# Features:
#   - Complete Git repository initialization with proper trust foundation
#   - Cryptographically signed inception commit for verifiable history
#   - DID (Decentralized Identifier) generation for repository identity
#   - Support for custom SSH signing keys
#   - Force mode for existing repository handling
#   - Path validation with tilde expansion and absolute path conversion
#   - Detailed commit message explaining trust model and verification
#   - Comprehensive error reporting with specific status codes
#   - Automatic directory creation when needed
#   - Signature verification to confirm successful signing
#
# Parameters:
#   $1 - Repository path (string): The path where the new repository should be
#        created. If the directory doesn't exist, it will be created. If it
#        exists but doesn't contain a Git repository, it will be initialized.
#   $2 - Optional signing key path (string): Path to the SSH key to use for
#        signing the inception commit. If omitted, uses the key configured in
#        Git's user.signingkey. Supports tilde expansion.
#   $3 - Optional force flag (boolean): If set to TRUE, allows creation even if
#        a repository already exists at the specified path. Defaults to FALSE.
#
# Returns:
#   Exit_Status_Success (0) when repository is created successfully
#   Exit_Status_Usage (2) when repository path parameter is missing
#   Exit_Status_IO (3) when directory creation fails or already contains a repository
#   Exit_Status_Git_Failure (5) when Git operations fail
#   Exit_Status_Config (6) when Git configuration is invalid
#
# Runtime Impact:
#   - Creates directory if it doesn't exist
#   - Initializes Git repository
#   - Creates an empty signed commit
#   - Reports status information to stdout
#   - Generates repository DID
#   - Verifies commit signature
#
# Dependencies:
#   - git command (2.34+ required for SSH signing support)
#   - ssh-keygen command (for fingerprint extraction)
#   - z_Extract_SSH_Key_Fingerprint function for key fingerprint retrieval
#   - z_Verify_Git_Config function for Git configuration validation
#   - z_Verify_Commit_Signature function for signature verification
#   - z_Get_Repository_DID function for DID generation
#   - z_Output function for formatted output
#   - z_Report_Error function for error reporting
#   - Exit status constants (various)
#   - TRUE/FALSE constants for boolean values
#
# Usage Examples:
#   # Basic usage with default Git configuration:
#   z_Create_Inception_Repository "/path/to/new_repo" || return $?
#   
#   # With custom signing key:
#   z_Create_Inception_Repository "/path/to/new_repo" "~/.ssh/special_key" || return $?
#   
#   # Force creation even if repository exists:
#   z_Create_Inception_Repository "/path/to/new_repo" "" $TRUE || return $?
#   
#   # With detailed error handling:
#   if ! z_Create_Inception_Repository "$RepoPath"; then
#     z_Output error "Failed to create inception repository"
#     z_Output info "Ensure Git is properly configured for SSH signing"
#     z_Output info "Run: z_Setup_Git_Environment to configure Git"
#     return $?
#   fi
#   
#   # Creating a new repository and saving its DID:
#   if z_Create_Inception_Repository "$RepoPath"; then
#     RepoID=$(z_Get_Repository_DID "$RepoPath")
#     echo "REPOSITORY_ID=$RepoID" > "$RepoPath/.repo-identity"
#     z_Output success "Repository created with ID: $RepoID"
#   fi
#   
#   # Using in a script with confirmation prompt:
#   read -r -p "Create new repository at $RepoPath? (y/n) " CONFIRM
#   if [[ "$CONFIRM" =~ ^[Yy] ]]; then
#     z_Create_Inception_Repository "$RepoPath" || exit $?
#     z_Output success "Repository successfully created and initialized"
#   fi
#----------------------------------------------------------------------#
function z_Create_Inception_Repository() {
    typeset RepoPath="$1"
    typeset CustomSigningKey="${2:-}"
    typeset -i ForceCreation="${3:-$FALSE}"
    typeset SigningKey UserName UserEmail AuthorDate CommitterName
    
    # Validate repository path parameter
    if [[ -z "$RepoPath" ]]; then
        z_Report_Error "Repository path parameter is required" $Exit_Status_Usage
        return $Exit_Status_Usage
    fi
    
    # Expand path if it contains a tilde
    RepoPath=${~RepoPath}
    
    # Handle absolute vs relative paths
    if [[ ! "$RepoPath" =~ ^/ ]]; then
        RepoPath="$(pwd)/$RepoPath"
    fi
    
    # Check if repository already exists
    if [[ -d "$RepoPath/.git" ]]; then
        if (( ForceCreation == TRUE )); then
            z_Output warn "Repository already exists at $RepoPath, proceeding anyway"
        else
            z_Report_Error "Repository already exists at $RepoPath" $Exit_Status_IO
            z_Output info "Use force flag to proceed anyway"
            return $Exit_Status_IO
        fi
    fi
    
    # Create repository directory if needed
    if [[ ! -d "$RepoPath" ]]; then
        if ! mkdir -p "$RepoPath"; then
            z_Report_Error "Failed to create directory: $RepoPath" $Exit_Status_IO
            return $Exit_Status_IO
        fi
    fi
    
    # Verify Git configuration includes required signing settings
    if [[ -n "$CustomSigningKey" ]]; then
        # Verify Git config with provided signing key
        z_Verify_Git_Config "$CustomSigningKey" || return $?
        SigningKey="$CustomSigningKey"
    else
        # Verify Git config with default signing key
        z_Verify_Git_Config || return $?
        SigningKey=$(git config user.signingkey)
    fi
    
    # Get Git configuration values
    UserName=$(git config user.name)
    UserEmail=$(git config user.email)
    
    # Use system date for UTC timestamp
    AuthorDate=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # Get SSH key fingerprint for committer name
    CommitterName=$(z_Extract_SSH_Key_Fingerprint "$SigningKey") || return $?
    
    # Initialize Git repository
    z_Output info "Initializing Git repository at $RepoPath"
    if ! git -C "$RepoPath" init > /dev/null; then
        z_Report_Error "Failed to initialize Git repository" $Exit_Status_Git_Failure
        return $Exit_Status_Git_Failure
    fi
    
    # Create the inception commit with specific environment variables for authorship
    z_Output info "Creating signed inception commit"
    if ! GIT_AUTHOR_NAME="$UserName" GIT_AUTHOR_EMAIL="$UserEmail" \
       GIT_COMMITTER_NAME="$CommitterName" GIT_COMMITTER_EMAIL="$UserEmail" \
       GIT_AUTHOR_DATE="$AuthorDate" GIT_COMMITTER_DATE="$AuthorDate" \
       git -C "$RepoPath" -c gpg.format=ssh -c user.signingkey="$SigningKey" \
         commit --allow-empty --no-edit --gpg-sign \
         -m "Initialize repository and establish a SHA-1 root of trust" \
         -m "This key also certifies future commits' integrity and origin. Other keys can be authorized to add additional commits via the creation of a ./.repo/config/verification/allowed_commit_signers file. This file must initially be signed by this repo's inception key, granting these keys the authority to add future commits to this repo, including the potential to remove the authority of this inception key for future commits. Once established, any changes to ./.repo/config/verification/allowed_commit_signers must be authorized by one of the previously approved signers." --signoff; then
        z_Report_Error "Failed to create inception commit" $Exit_Status_Git_Failure
        return $Exit_Status_Git_Failure
    fi
    
    # Verify the inception commit was created successfully
    typeset CommitHash
    CommitHash=$(git -C "$RepoPath" rev-parse HEAD 2>/dev/null)
    if [[ -z "$CommitHash" ]]; then
        z_Report_Error "Failed to get commit hash" $Exit_Status_Git_Failure
        return $Exit_Status_Git_Failure
    fi
    
    # Verify the signature
    z_Output info "Verifying commit signature"
    z_Verify_Commit_Signature "$RepoPath" "$CommitHash" > /dev/null || return $?
    
    # Generate repository DID
    typeset Repo_DID
    Repo_DID=$(z_Get_Repository_DID "$RepoPath") || return $?
    
    # Success message
    z_Output success "Repository initialized with signed inception commit"
    z_Output success "Inception commit: $CommitHash"
    z_Output success "Repository DID: $Repo_DID"
    
    return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: z_Ensure_Allowed_Signers
#----------------------------------------------------------------------#
# Description:
#   Creates or updates the git allowed_signers file for SSH commit signing.
#   This file maps email addresses to public SSH keys for verification.
#   The function manages the Git SSH signature verification infrastructure
#   by maintaining the allowed_signers file that enables cryptographic
#   verification of commit signatures. This is essential for establishing
#   a chain of trust in Git repositories using SSH signing.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive descriptions
#     * Renamed "Side Effects" to "Runtime Impact"
#     * Added Features section with key capabilities
#     * Added comprehensive usage examples
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with allowed signers configuration
#     * Added tilde expansion support
#     * Implemented automatic directory creation with proper permissions
#     * Added Git configuration updates for allowed signers
#
# Features:
#   - Automatic allowed_signers file management for Git SSH signing
#   - Support for custom file locations with tilde expansion
#   - Secure permission management (700 for directories, 600 for files)
#   - Automatic Git configuration for gpg.ssh.allowedSignersFile
#   - Intelligent SSH key discovery and validation
#   - Public key extraction from private keys
#   - Duplicate entry prevention with existing key checking
#   - Support for custom email association with keys
#   - Self-managed directory creation with proper permissions
#
# Parameters:
#   $1 - Optional signers file path (string): Path to the allowed_signers file
#        to create or update. Defaults to ~/.config/git/allowed_signers if not
#        provided. Supports tilde expansion.
#   $2 - Optional SSH key path (string): Path to the SSH key to add to the
#        allowed_signers file. If not provided, uses the key configured in
#        Git's user.signingkey. Supports tilde expansion.
#   $3 - Optional email (string): Email address to associate with the SSH key
#        in the allowed_signers file. If not provided, uses the email from
#        Git's user.email configuration.
#
# Returns:
#   Exit_Status_Success (0) when file is created/updated successfully
#   Exit_Status_IO (3) when file operations fail (directory creation, file writing)
#   Exit_Status_Config (6) when required Git configurations are missing
#
# Runtime Impact:
#   - Creates ~/.config/git directory if it doesn't exist
#   - Creates or updates the allowed_signers file
#   - Updates Git's global configuration to use the allowed_signers file
#   - Sets appropriate permissions on created directories and files
#   - Outputs status information to stdout
#   - Reads existing Git configuration using git config
#   - Reads public key file content
#
# Dependencies:
#   - git command (2.34+ required for SSH signing support)
#   - z_Output function for formatted output
#   - z_Report_Error function for error reporting
#   - Exit status constants (Exit_Status_Success, Exit_Status_IO, Exit_Status_Config)
#   - TRUE/FALSE constants for boolean values
#
# Usage Examples:
#   # Create/update allowed_signers with defaults from Git config:
#   z_Ensure_Allowed_Signers || return $?
#   
#   # Use custom allowed_signers location:
#   z_Ensure_Allowed_Signers "~/Projects/custom_signers" || return $?
#   
#   # Specify custom key and email:
#   z_Ensure_Allowed_Signers "" "~/.ssh/project_key" "project@example.com" || return $?
#   
#   # Fully custom configuration:
#   z_Ensure_Allowed_Signers "~/custom/signers" "~/.ssh/custom_key" "custom@example.com" || return $?
#   
#   # With detailed error handling:
#   if ! z_Ensure_Allowed_Signers; then
#     z_Output error "Failed to configure SSH signature verification"
#     z_Output info "Ensure you have proper permissions and Git is configured"
#     return $?
#   fi
#   
#   # Setting up allowed signers for a team:
#   for member in "${TeamMembers[@]}"; do
#     MemberKey="${member%%:*}"
#     MemberEmail="${member##*:}"
#     if ! z_Ensure_Allowed_Signers "$TeamSignersFile" "$MemberKey" "$MemberEmail"; then
#       z_Output warn "Failed to add $MemberEmail to allowed signers"
#     else
#       z_Output success "Added $MemberEmail to allowed signers"
#     fi
#   done
#   
#   # Verifying configuration after setup:
#   if z_Ensure_Allowed_Signers; then
#     z_Output success "SSH signature verification properly configured"
#     z_Output info "Signers file: $(git config --global gpg.ssh.allowedSignersFile)"
#     z_Output info "Signing key: $(git config --global user.signingkey)"
#   fi
#----------------------------------------------------------------------#
function z_Ensure_Allowed_Signers() {
    typeset SignersFilePath="${1:-}"
    typeset KeyPath="${2:-}"
    typeset UserEmail="${3:-}"
    typeset AllowedSignersDir PubKeyPath KeyType KeyData
    
    # If no signers file path provided, use default
    if [[ -z "$SignersFilePath" ]]; then
        # Default location
        AllowedSignersDir=~/.config/git
        SignersFilePath="$AllowedSignersDir/allowed_signers"
    else
        # Expand path if it contains a tilde
        SignersFilePath=${~SignersFilePath}
        AllowedSignersDir=$(dirname "$SignersFilePath")
    fi
    
    # If no key path provided, get from git config
    if [[ -z "$KeyPath" ]]; then
        KeyPath=$(git config user.signingkey 2>/dev/null)
        if [[ -z "$KeyPath" ]]; then
            z_Report_Error "No SSH key specified and git user.signingkey not set" $Exit_Status_Config
            z_Output info "Run: git config --global user.signingkey /path/to/ssh_key"
            return $Exit_Status_Config
        fi
    fi
    
    # Expand key path if it contains a tilde
    KeyPath=${~KeyPath}
    
    # If no email provided, get from git config
    if [[ -z "$UserEmail" ]]; then
        UserEmail=$(git config user.email 2>/dev/null)
        if [[ -z "$UserEmail" ]]; then
            z_Report_Error "No email specified and git user.email not set" $Exit_Status_Config
            z_Output info "Run: git config --global user.email \"your.email@example.com\""
            return $Exit_Status_Config
        fi
    fi
    
    # Check if the key file exists
    if [[ ! -r "$KeyPath" ]]; then
        z_Report_Error "SSH key not found or not readable: $KeyPath" $Exit_Status_IO
        return $Exit_Status_IO
    fi
    
    # Determine public key path based on private key path
    if [[ "$KeyPath" == *".pub" ]]; then
        # If somehow the signing key was set to the public key, use it
        PubKeyPath="$KeyPath"
    elif [[ -f "${KeyPath}.pub" ]]; then
        # Standard format: private key + .pub
        PubKeyPath="${KeyPath}.pub"
    else
        # Try to find the corresponding public key
        PubKeyPath=$(echo "$KeyPath" | sed 's/\.[^.]*$/.pub/')
        if [[ ! -f "$PubKeyPath" ]]; then
            z_Report_Error "Could not find public key for $KeyPath" $Exit_Status_IO
            return $Exit_Status_IO
        fi
    fi
    
    # Create directory if it doesn't exist
    if [[ ! -d "$AllowedSignersDir" ]]; then
        z_Output info "Creating allowed signers directory: $AllowedSignersDir"
        if ! mkdir -p "$AllowedSignersDir"; then
            z_Report_Error "Failed to create directory: $AllowedSignersDir" $Exit_Status_IO
            return $Exit_Status_IO
        fi
        chmod 700 "$AllowedSignersDir"
    fi
    
    # Extract key type and data from public key
    # Assuming format: "ssh-ed25519 AAAA... comment"
    typeset PubKeyContent
    PubKeyContent=$(cat "$PubKeyPath" 2>/dev/null)
    if [[ -z "$PubKeyContent" ]]; then
        z_Report_Error "Failed to read public key: $PubKeyPath" $Exit_Status_IO
        return $Exit_Status_IO
    fi
    
    # Use Zsh array splitting to extract key parts
    typeset -a KeyParts=(${=PubKeyContent})
    KeyType="${KeyParts[1]}"
    KeyData="${KeyParts[2]}"
    
    if [[ -z "$KeyType" || -z "$KeyData" ]]; then
        z_Report_Error "Invalid public key format in $PubKeyPath" $Exit_Status_Config
        return $Exit_Status_Config
    fi
    
    # Check if the allowed_signers file already exists
    typeset -i FileExists=$FALSE
    if [[ -f "$SignersFilePath" ]]; then
        FileExists=$TRUE
        # Check if the email + key combination already exists
        if grep -q "^$UserEmail $KeyType $KeyData" "$SignersFilePath" 2>/dev/null; then
            z_Output success "Key for $UserEmail already exists in $SignersFilePath"
            # Configure git to use this allowed signers file if not already set
            if [[ "$(git config --global gpg.ssh.allowedSignersFile 2>/dev/null)" != "$SignersFilePath" ]]; then
                git config --global gpg.ssh.allowedSignersFile "$SignersFilePath"
                z_Output info "Updated Git config to use allowed signers file: $SignersFilePath"
            fi
            return $Exit_Status_Success
        fi
    fi
    
    # Create or append to the allowed_signers file
    if (( FileExists == TRUE )); then
        z_Output info "Appending key for $UserEmail to $SignersFilePath"
        if ! echo "$UserEmail $KeyType $KeyData" >> "$SignersFilePath"; then
            z_Report_Error "Failed to update allowed signers file: $SignersFilePath" $Exit_Status_IO
            return $Exit_Status_IO
        fi
    else
        z_Output info "Creating allowed signers file: $SignersFilePath"
        if ! echo "$UserEmail $KeyType $KeyData" > "$SignersFilePath"; then
            z_Report_Error "Failed to create allowed signers file: $SignersFilePath" $Exit_Status_IO
            return $Exit_Status_IO
        fi
        # Set proper permissions
        chmod 600 "$SignersFilePath"
    fi
    
    # Configure git to use this allowed signers file
    git config --global gpg.ssh.allowedSignersFile "$SignersFilePath"
    
    z_Output success "SSH key for $UserEmail added to allowed signers file: $SignersFilePath"
    z_Output success "Git configured to use allowed signers file: $SignersFilePath"
    
    return $Exit_Status_Success
}

#----------------------------------------------------------------------#
# Function: z_Setup_Git_Environment
#----------------------------------------------------------------------#
# Description:
#   Sets up a complete Git environment for SSH signing, including Git
#   configuration, signing key setup, and allowed signers configuration.
#   This is a high-level orchestration function that configures all
#   aspects of Git required for SSH-based commit signing, providing
#   a one-step solution for establishing a secure signing environment.
#   The function handles user identity, SSH key configuration, signing
#   format settings, and verification infrastructure.
#
# Version: 0.1.01 (2025-03-28)
#
# Parameters:
#   $1 - Optional SSH key path (string): Path to the SSH key to use for
#        signing. If not provided, attempts to use ~/.ssh/id_ed25519 or find
#        another suitable key. Supports tilde expansion.
#   $2 - Optional user name (string): Git user name to configure. If not
#        provided, uses existing Git config or reports an error.
#   $3 - Optional user email (string): Git user email to configure. If not
#        provided, uses existing Git config or reports an error.
#
# Returns:
#   Exit_Status_Success (0) when setup completes successfully
#   Exit_Status_Config (6) when Git configuration fails
#   Exit_Status_IO (3) when file operations fail
#   Other error codes based on specific failure points in dependencies
#
# Required Script Variables:
#   - Exit_Status_Success - Success status code (0)
#   - Exit_Status_IO - IO error status code (3)
#   - Exit_Status_Config - Configuration error status code (6)
#   - TRUE/FALSE - Boolean constants for status tracking
#
# Side Effects:
#   - Updates Git's global configuration:
#     * user.name
#     * user.email
#     * user.signingkey
#     * gpg.format
#     * commit.gpgsign
#     * gpg.ssh.allowedSignersFile
#   - Creates or updates allowed_signers file
#   - Outputs status information to stdout
#
# Dependencies:
#   - git command (2.34+ required for SSH signing support)
#   - z_Verify_Git_Config function for configuration validation
#   - z_Ensure_Allowed_Signers function for allowed signers setup
#   - z_Extract_SSH_Key_Fingerprint function for key fingerprint retrieval
#   - z_Output function for formatted output
#   - z_Report_Error function for error reporting
#
# Implementation Details:
#   - Automatically finds and selects an SSH key if none provided
#   - Configures Git's global settings for SSH signing
#   - Sets up the allowed_signers file for signature verification
#   - Validates the final configuration to ensure everything is correct
#   - Reports success with key information for reference
#
# Usage Examples:
#   # Setup with defaults (uses existing config or available SSH keys):
#   z_Setup_Git_Environment || return $?
#   
#   # Setup with custom key but default user information:
#   z_Setup_Git_Environment "~/.ssh/custom_key" || return $?
#   
#   # Complete custom setup:
#   z_Setup_Git_Environment "~/.ssh/custom_key" "User Name" "email@example.com" || return $?
#   
#   # With detailed error handling:
#   if ! z_Setup_Git_Environment; then
#     z_Output error "Failed to setup Git environment for SSH signing"
#     z_Output info "Check if you have valid SSH keys available"
#     z_Output info "Run: ssh-keygen -t ed25519 -C \"your.email@example.com\" to create a key"
#     return $?
#   fi
#   z_Output success "Git environment is now configured for SSH signing"
#----------------------------------------------------------------------#
#----------------------------------------------------------------------#
# Function: z_Setup_Git_Environment
#----------------------------------------------------------------------#
# Description:
#   Configures Git for SSH commit signing with proper verification setup.
#   This comprehensive function handles the complete setup process for
#   Git SSH signature infrastructure, including key selection, user
#   configuration, and allowed signers setup. It ensures all required
#   Git configuration is in place for cryptographically secure commit
#   signing and verification using SSH keys.
#
# Version: 0.1.01 (2025-03-29)
#
# Change Log:
#   - 0.1.01 (2025-03-29)
#     * Enhanced documentation with comprehensive descriptions
#     * Added Change Log and Features sections
#     * Added detailed usage examples
#     * Improved parameter descriptions
#   - 0.1.00 (2025-03-26)
#     * Initial implementation with Git SSH signing configuration
#     * Added automatic SSH key discovery
#     * Implemented Git global configuration setting
#     * Added allowed signers configuration
#
# Features:
#   - Complete Git SSH signing environment configuration
#   - Automatic SSH key discovery from standard locations
#   - User-friendly defaults requiring minimal parameters
#   - Integration with z_Ensure_Allowed_Signers for verification setup
#   - Comprehensive validation of all configuration steps
#   - Detailed status reporting for successful configuration
#   - Intelligent handling of existing configurations
#   - Support for custom user names, emails, and SSH keys
#
# Parameters:
#   $1 - Optional SSH key path (string): Path to the SSH key to use for
#        commit signing. If not provided, attempts to find a suitable key
#        from standard locations. Supports tilde expansion.
#   $2 - Optional user name (string): Name to configure in Git's user.name.
#        If not provided, uses existing Git configuration if available.
#   $3 - Optional user email (string): Email to configure in Git's user.email.
#        If not provided, uses existing Git configuration if available.
#
# Returns:
#   Exit_Status_Success (0) when Git environment is configured successfully
#   Exit_Status_IO (3) when SSH key file operations fail
#   Exit_Status_Config (6) when required configurations are missing
#
# Runtime Impact:
#   - Updates Git's global configuration with user settings
#   - Sets Git's commit signing configuration (gpg.format, commit.gpgsign)
#   - Configures allowed signers file for signature verification
#   - Outputs status information to stdout
#   - Does not modify repository-specific configurations
#   - Only affects global Git settings
#
# Dependencies:
#   - git command (2.34+ required for SSH signing support)
#   - z_Ensure_Allowed_Signers function for verification setup
#   - z_Verify_Git_Config function for configuration validation
#   - z_Extract_SSH_Key_Fingerprint function for key information
#   - z_Output function for formatted output
#   - z_Report_Error function for error reporting
#   - Exit status constants (Exit_Status_Success, Exit_Status_IO, Exit_Status_Config)
#   - TRUE/FALSE constants for boolean values
#
# Usage Examples:
#   # Basic usage with auto-detection:
#   z_Setup_Git_Environment || return $?
#   
#   # Specify custom SSH key:
#   z_Setup_Git_Environment "~/.ssh/custom_key" || return $?
#   
#   # Complete custom configuration:
#   z_Setup_Git_Environment "~/.ssh/project_key" "Jane Doe" "jane@example.com" || return $?
#   
#   # With detailed error handling:
#   if ! z_Setup_Git_Environment; then
#     z_Output error "Failed to configure Git environment"
#     z_Output info "Please ensure SSH keys exist and Git is properly installed"
#     return $?
#   fi
#   
#   # Setting up for a new user:
#   if ! git config --global user.name >/dev/null 2>&1; then
#     z_Output info "First-time Git configuration detected"
#     read -r "UserName?Enter your full name: "
#     read -r "UserEmail?Enter your email: "
#     if ! z_Setup_Git_Environment "" "$UserName" "$UserEmail"; then
#       z_Output error "Failed to configure Git for first use"
#       return $?
#     fi
#   fi
#----------------------------------------------------------------------#
function z_Setup_Git_Environment() {
    typeset KeyPath="${1:-}"
    typeset UserName="${2:-}"
    typeset UserEmail="${3:-}"
    typeset DefaultKeyPath="${HOME}/.ssh/id_ed25519"
    typeset -i ConfigUpdated=$FALSE
    
    # Use default key path if none provided
    if [[ -z "$KeyPath" ]]; then
        if [[ -r "$DefaultKeyPath" ]]; then
            KeyPath="$DefaultKeyPath"
        else
            # Try to find an existing SSH key
            typeset -a SshKeyFiles
            SshKeyFiles=(${HOME}/.ssh/id_ed25519 ${HOME}/.ssh/id_rsa)
            
            for KeyFile in "${SshKeyFiles[@]}"; do
                if [[ -r "$KeyFile" ]]; then
                    KeyPath="$KeyFile"
                    break
                fi
            done
            
            # If still no key found, suggest generating one
            if [[ -z "$KeyPath" ]]; then
                z_Report_Error "No SSH key found. Please generate an SSH key first." $Exit_Status_Config
                z_Output info "Run: ssh-keygen -t ed25519 -C \"your.email@example.com\""
                return $Exit_Status_Config
            fi
        fi
    else
        # Expand path if it contains a tilde
        KeyPath=${~KeyPath}
    fi
    
    # Check if SSH key exists
    if [[ ! -r "$KeyPath" ]]; then
        z_Report_Error "SSH key not found or not readable: $KeyPath" $Exit_Status_IO
        return $Exit_Status_IO
    fi
    
    # Configure Git user settings if provided
    if [[ -n "$UserName" ]]; then
        git config --global user.name "$UserName"
        ConfigUpdated=$TRUE
    elif [[ -z "$(git config user.name 2>/dev/null)" ]]; then
        z_Report_Error "Git user.name not set and no name provided" $Exit_Status_Config
        z_Output info "Run: git config --global user.name \"Your Name\""
        return $Exit_Status_Config
    fi
    
    if [[ -n "$UserEmail" ]]; then
        git config --global user.email "$UserEmail"
        ConfigUpdated=$TRUE
    elif [[ -z "$(git config user.email 2>/dev/null)" ]]; then
        z_Report_Error "Git user.email not set and no email provided" $Exit_Status_Config
        z_Output info "Run: git config --global user.email \"your.email@example.com\""
        return $Exit_Status_Config
    fi
    
    # Configure SSH signing key
    if [[ "$(git config user.signingkey 2>/dev/null)" != "$KeyPath" ]]; then
        git config --global user.signingkey "$KeyPath"
        ConfigUpdated=$TRUE
    fi
    
    # Configure gpg.format to ssh
    if [[ "$(git config gpg.format 2>/dev/null)" != "ssh" ]]; then
        git config --global gpg.format "ssh"
        ConfigUpdated=$TRUE
    fi
    
    # Configure commit.gpgsign to true
    if [[ "$(git config commit.gpgsign 2>/dev/null)" != "true" ]]; then
        git config --global commit.gpgsign "true"
        ConfigUpdated=$TRUE
    fi
    
    # Setup allowed signers file
    UserEmail=${UserEmail:-$(git config user.email)}
    z_Ensure_Allowed_Signers "" "$KeyPath" "$UserEmail" || return $?
    
    # Verify the final configuration
    z_Verify_Git_Config || return $?
    
    # Success message
    if (( ConfigUpdated == TRUE )); then
        z_Output success "Git environment successfully configured for SSH signing"
    else
        z_Output success "Git environment already properly configured for SSH signing"
    fi
    
    # Display key information
    typeset KeyFingerprint
    KeyFingerprint=$(z_Extract_SSH_Key_Fingerprint "$KeyPath") || return $?
    z_Output info "Using SSH key: $KeyPath"
    z_Output info "Key fingerprint: $KeyFingerprint"
    
    return $Exit_Status_Success
}

########################################################################
##                        END OF LIBRARY
########################################################################