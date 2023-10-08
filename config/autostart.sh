#!/bin/sh

run() {
	if ! pgrep -f "$1"; then
		"$@" &
	fi
}

run "picom" "--config" "$HOME/.config/picom/picom.conf"
run "discord"
run "telegram-desktop"
run "flameshot"
