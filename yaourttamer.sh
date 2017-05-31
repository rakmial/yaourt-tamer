#!/bin/bash

# Get elevated - thanks to Michael Mrozek: https://unix.stackexchange.com/questions/28791/prompt-for-sudo-password-and-programmatically-elevate-privilege-in-bash-script
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

#Initiate yaourt update
yaourt -Syua --noconfirm

#Checks for successful upgrade
if (($?!=0)); then
  echo "Upgrade fails, manual upgrade required"
  sleep 2s
  exit $?
fi

#Initiate paccache clear to a single backup, stores PID & forks to background
paccache -k 1 -r &
pid2=$!

#Checks for successful paccache clear
if (($?!=0)); then
  echo "Paccache clear fails, manual clear required"
  sleep 2s
  exit $?
fi

wait $pid2

echo "Yaourt Tamed!"
sleep 2s
