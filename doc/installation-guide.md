# Installation Guide

## On a new MacOS (migrating from another)
* Log in iCloud and Sync all Keychain passwords
* Update Mac 
* Backup `~/.ssh` and `~/.gnupg` from the previous computer to the new one
  - `chmod -R 700 ~/.ssh`
  - `chmod -R 700 ~/.gnupg`
* Execute the dotfiles installer
* Open Karabiner-Elements
* Open Authy and login
* Login in Google Chrome
* Open Google Backup and Sync
  - Disable "USB Devices & SD Cards"
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
  - Enable "generate shell scripts in ~/bin"
  - Install IntelliJ
* Open IntelliJ
  - Import from JetBrains account
  - Sync plugins
  - Execute `dot intellij add_code_templates`
* Open Dato (and configure in bar)
  - Preferences/Show Date
* Open Slack
  - Login CodelyTV
  - Login BcnEng
* Open Spotify
  - Set streaming quality to very high
  - Disable automatic startup
* Download iTerm nightly
  - Install
  - Select load preferences from URL and use ~/.dotfiles/mac/iTerm. On the next prompt select "NOT copy"
* Extra:
  - [Prevent a volume from mounting at startup](https://discussions.apple.com/docs/DOC-7942)
* Restart
  - When Google Drive is synced, install all the fonts
    - Also download Osaka Mono from Font Book
* Execute `dot shell zsh reload_completions` and then `compinit`
