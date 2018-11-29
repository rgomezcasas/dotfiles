# Installation Guide

## On a new MacOS (migrating from another)
 * Log in iCloud and Sync all Keychain passwords
 * Update Mac 
 * Backup `~/.ssh` and `~/.gnupg` from the previous computer to the new one
     - `chmod -R 700 ~/.ssh`
     - `chmod -R 700 ~/.gnupg`
 * Go to brew.sh and install
 * Clone this repository `git clone git@github.com:rgomezcasas/dotfiles.git ~/.dotfiles`
 * Execute `sh install.sh`
 * Execute `sh mac/mac-os.sh`
 * Restart
 * Login in Google Chrome
 * Open Spectacle
     - Gran permissions
     - Start on login
     - Run as a background application
 * Open Contexts
     - Grant permissions
     - Configure as other pc
 * Go to `Preferences/Keyboard/Shortcuts` and copy from another mac
 * Open Alfred
 * Open Karabiner
 * Open Day-o
     - Untick `show icon`
     - Set format `EE d MMM HH:mm`
 * Open JetBrains Toolbox and login
     - Login
     - Install IntelliJ
     - Install DataGrip
 * Download iTerm nightly
     - Install
     - Select load preferences from URL and use ~/.dotfiles/mac/iTerm. On the next prompt select "NOT copy"
 * Customize Finder (compare against mac/SetUp)
 * Customize Mac menu bar (compare against mac/SetUp)
