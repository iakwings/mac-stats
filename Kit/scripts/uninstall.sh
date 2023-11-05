#!/bin/sh

set +e -uf; unset -v _ IFS; #export LC_ALL=C

sudo launchctl unload /Library/LaunchDaemons/eu.exelban.Stats.SMC.Helper.plist
sudo rm /Library/LaunchDaemons/eu.exelban.Stats.SMC.Helper.plist
sudo rm /Library/PrivilegedHelperTools/eu.exelban.Stats.SMC.Helper
