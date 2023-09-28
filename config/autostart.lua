local awful = require("awful")

local applications = {
    "picom",
    -- "xinput | grep -i wacom | awk '{print $9}' | awk -F'=' '{print $2}' | xargs -I % sh -c 'xinput map-to-output % DP-1'",
    -- "easyeffects -l Bass Boosted --gapplication-service",
    "xset r rate 200 20",
    "discord",
    "telegram-desktop",
    "flameshot",
}

for app = 1, #applications do
    awful.spawn.easy_async_with_shell(applications[app], function() end)
end
