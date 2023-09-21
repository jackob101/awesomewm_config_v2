local awful = require("awful")

awful.spawn.with_shell(CONFIG_DIR_PATH .. "config/autostart.sh")
awful.spawn.with_shell("xset r rate 200 20")
