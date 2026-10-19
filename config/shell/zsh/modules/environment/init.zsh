#
# Generic options and environment settings
#

#
# Changing directories
#

# Perform cd to a directory if the typed command is invalid, but is a directory.
setopt AUTO_CD

# Make cd push the old directory to the directory stack.
setopt AUTO_PUSHD

autoload -Uz is-at-least && if is-at-least 5.8; then
  # Don't print the working directory after a cd.
  setopt CD_SILENT
fi

# Don't push multiple copies of the same directory to the stack.
setopt PUSHD_IGNORE_DUPS

# Don't print the directory stack after pushd or popd.
setopt PUSHD_SILENT

# Have pushd without arguments act like `pushd ${HOME}`.
setopt PUSHD_TO_HOME

#
# Expansion and globbing
#

# Treat `#`, `~`, and `^` as patterns for filename globbing.
setopt EXTENDED_GLOB

#
# History
#

# The file to save the history in.
if (( ! ${+HISTFILE} )) typeset -g HISTFILE=${ZDOTDIR:-${HOME}}/.zhistory

# The maximum number of events stored internally and saved in the history file.
# The former is greater than the latter in case user wants HIST_EXPIRE_DUPS_FIRST.
HISTSIZE=20000
SAVEHIST=10000

# Don't display duplicates when searching the history.
setopt HIST_FIND_NO_DUPS

# Don't enter immediate duplicates into the history.
setopt HIST_IGNORE_DUPS

# Remove commands from the history that begin with a space.
setopt HIST_IGNORE_SPACE

# Don't execute the command directly upon history expansion.
setopt HIST_VERIFY

# Cause all terminals to share the same history 'session'.
setopt SHARE_HISTORY

#
# Input/output
#

# Allow comments starting with `#` in the interactive shell.
setopt INTERACTIVE_COMMENTS

# Disallow `>` to overwrite existing files. Use `>|` or `>!` instead.
setopt NO_CLOBBER

#
# Job control
#

# List jobs in verbose format by default.
setopt LONG_LIST_JOBS

# Prevent background jobs being given a lower priority.
setopt NO_BG_NICE

# Prevent status report of jobs on shell exit.
setopt NO_CHECK_JOBS

# Prevent SIGHUP to jobs on shell exit.
setopt NO_HUP
