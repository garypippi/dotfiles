#!/bin/sh

case $SSH_ASKPASS_PROMPT in
confirm)
	[ "$(hyprland-dialog --title ssh-agent --text "$1" --buttons 'Deny;Allow')" = Allow ]
	;;
none)
	# ssh sends SIGTERM to this pid when done, so exec to let it reach the dialog
	exec hyprland-dialog --title ssh --text "$1" --buttons Close
	;;
*)
	exit 1
	;;
esac
