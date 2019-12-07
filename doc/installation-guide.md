# Installation Guide

## On a new MacOS (migrating from another)
 * Log in iCloud and Sync all Keychain passwords
 * Update Mac 
 * Backup `~/.ssh` and `~/.gnupg` from the previous computer to the new one
     - `chmod -R 700 ~/.ssh`
     - `chmod -R 700 ~/.gnupg`
 * Execute the dotfiles installer
 * Login in Google Chrome
 * Open Karabiner-Elements
 * Open Google Backup and Sync
     - Disable "USB Devices & SD Cards"
     - When synced install all the fonts
     - Also download Osaka Mono from Font Book
 * Open Spectacle
     - Gran permissions
     - Start on login
     - Run as a background application
 * Open Contexts
     - Grant permissions
     - Update to beta versions
     - Configure as other pc
       - Apparence
         - Vibrant Dar
         - Text Size: Middle
       - Sidebar
         - No display
       - Panel
         - Disable Moving the cursor
         - Disable Scroll
       - Search
         - Disable search with
 * Go to `Preferences/Keyboard/Shortcuts` and disable everything
 * Go to `Preferences/General` and enable font smoothing (if retina display)
 * Open Alfred
     - Configure for cmd+space
 * Open JetBrains Toolbox and login
     - Login
     - Install IntelliJ
     - Install DataGrip
 * Download iTerm nightly
     - Install
     - Select load preferences from URL and use ~/.dotfiles/mac/iTerm. On the next prompt select "NOT copy"
 * Customize Finder (compare against mac/SetUp)
 * Customize Mac menu bar (compare against mac/SetUp)
 * Restart
