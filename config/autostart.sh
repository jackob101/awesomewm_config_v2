#!/bin/sh

run() {
	if ! pgrep -f "$1"; then
		"$@" &
	fi
}

run "picom" "--config" "$HOME/.config/picom/picom.conf"
run "flameshot"

if ! pgrep -f "discord"; then
	"discord" &
fi

if ! pgrep -f "telegram"; then
	"telegram-desktop" &
fi

"lxqt-policykit-agent" &
"corectrl" "--minimize-systray" &
