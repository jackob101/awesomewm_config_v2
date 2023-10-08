local awful = require("awful")

local config_commands = {
    "xset r rate 200 20",
}

for app = 1, #config_commands do
    awful.spawn.easy_async_with_shell(config_commands[app], function() end)
end

awful.spawn.easy_async_with_shell(CONFIG_DIR_PATH .. "config/autostart.sh", function() end)
