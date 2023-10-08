#!/bin/sh

run() {
	if ! pgrep -f "$1"; then
		"$@" &
	fi
}

run "picom" "--config" "$HOME/.config/picom/picom.conf"
run "flameshot"

if ! pgrep -f "discord"; then
	"com.discordapp.Discord" &
fi

if ! pgrep -f "telegram"; then
	"org.telegram.desktop" &
fi
