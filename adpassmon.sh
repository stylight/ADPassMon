#!/bin/bash

#Check for ADPassMon.app and exit if not found
if [ ! -d /Applications/Utilities/ADPassMon.app ]; then
    echo "ADPassMon not found"
    exit 0
fi

#Check for existing launch agent
if [ -f /Users/$USER/Library/LaunchAgents/AD.ADPassMon.plist ]; then
    echo "LaunchAgent for ADPassMon already exists. Removing..."
    rm /Users/$USER/Library/LaunchAgents/AD.ADPassMon.plist
fi

#Write out a LaunchAgent to launch ADPassMon on login
defaults write /Users/$USER/Library/LaunchAgents/AD.ADPassMon.plist Label AD.ADPassMon
defaults write /Users/$USER/Library/LaunchAgents/AD.ADPassMon.plist ProgramArguments -array
defaults write /Users/$USER/Library/LaunchAgents/AD.ADPassMon.plist RunAtLoad -bool YES
/usr/libexec/PlistBuddy -c "Add ProgramArguments: string /Applications/Utilities/ADPassMon.app/Contents/MacOS/ADPassMon" /Users/$USER/Library/LaunchAgents/AD.ADPassMon.plist
chown -R $USER /Users/$USER/Library/LaunchAgents
chmod 644 /Users/$USER/Library/LaunchAgents/AD.ADPassMon.plist
echo "Created LaunchAgent to launch ADPassMon on login"

#Check for org.pmbuko.ADPassMon.plist and exit if found
if [ -f /Users/$USER/Library/Preferences/org.pmbuko.ADPassMon.plist ]; then
    echo "org.pmbuko.ADPassMon.plist exists"
    exit 0
else
    defaults write /Users/$USER/Library/Preferences/org.pmbuko.ADPassMon enableNotifications -bool true
    defaults write /Users/$USER/Library/Preferences/org.pmbuko.ADPassMon enableKeychainLockCheck -bool true
    defaults write /Users/$USER/Library/Preferences/org.pmbuko.ADPassMon first_run -bool false
    defaults write /Users/$USER/Library/Preferences/org.pmbuko.ADPassMon expireAge -int o
    defaults write /Users/$USER/Library/Preferences/org.pmbuko.ADPassMon selectedMethod -int 0
    defaults write /Users/$USER/Library/Preferences/org.pmbuko.ADPassMon warningDays -int 4
    defaults write /Users/$USER/Library/Preferences/org.pmbuko.ADPassMon pwPolicy "Your password needs to be at least 8 characters long and cannot be a password you've used previously."
    defaults write /Users/$USER/Library/Preferences/org.pmbuko.ADPassMon selectedBehaviour -int 2
    defaults write /Users/$USER/Library/Preferences/org.pmbuko.ADPassMon prefsLocked -bool false
    chown $USER /Users/$USER/Library/Preferences/org.pmbuko.ADPassMon.plist
    echo "Created /Users/$USER/Library/Preferences/org.pmbuko.ADPassMon.plist"
fi