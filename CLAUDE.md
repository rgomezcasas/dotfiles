# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository built on top of the Dotly framework. It manages shell configurations, scripts, and system settings for macOS, Linux, and WSL environments. The repository uses a modular structure with the Dotly framework as a git submodule.

## Key Commands

### Core Command
- `dot` - Main command interface for all dotfiles functionality. Opens interactive menu when run without arguments
- `dot <context>` - Lists available scripts in a specific context (e.g., `dot docker`)
- `dot <context> <script> [args]` - Executes a specific script

### Common Operations
- `dot self update` - Updates the dotfiles framework
- `dot package import` - Imports packages from package managers
- `dot shell zsh test_performance` - Tests shell startup performance

### Script Examples
- `dot docker prune` - Prunes Docker containers and images
- `dot system empty_trash` - Empties system trash
- `dot github open_codely_repo` - Opens Codely repositories
- `dot intellij add_code_templates` - Adds code templates to IntelliJ

## Architecture

### Directory Structure
- `modules/` - Contains git submodules
  - `modules/dotly/` - The Dotly framework (core functionality)
  - `modules/private/` - Private configurations
- `shell/` - Shell configurations and startup scripts
  - `shell/zsh/` - Zsh-specific configurations using ZIM framework
  - `shell/aliases.sh` - Shell aliases
  - `shell/exports.sh` - Environment variables
  - `shell/functions.sh` - Shell functions
  - `shell/init.sh` - Shell initialization
- `scripts/` - Organized collection of utility scripts
  - Each subdirectory represents a context (docker, github, system, etc.)
  - Scripts follow the pattern: `scripts/<context>/<script_name>`
- `editors/` - Editor configurations
  - `editors/claude-code/` - Claude Code settings
  - `editors/cursor/` - Cursor editor settings
  - `editors/intellij/` - IntelliJ configurations
- `git/` - Git configuration files
- `os/` - OS-specific configurations
  - `os/mac/` - macOS-specific scripts and configs
- `bin/` - Binary executables and symlinks
- `langs/` - Programming language-specific configurations

### Script System
The dot command dynamically discovers and executes scripts from both the main dotfiles repository and the Dotly framework. Scripts support documentation headers using the `##?` syntax for help text. The system uses FZF for interactive script selection with live previews.

### Shell Performance
The configuration is optimized for fast shell startup (<0.02s typical). It uses the ZIM framework for Zsh, which is one of the fastest Zsh frameworks available.

### Key Environment Variables
- `$DOTFILES_PATH` - Path to the dotfiles repository (usually `~/.dotfiles`)
- `$DOTLY_PATH` - Path to the Dotly framework (`$DOTFILES_PATH/modules/dotly`)
- `$PATH` - Includes `$DOTLY_PATH/bin` and `$DOTFILES_PATH/bin`
