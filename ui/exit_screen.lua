local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
---@type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local shape_utils = require("utils.shape")
local hover_utils = require("utils.hover")

local theme = {
    overlay_bg_color = beautiful.bg_minimize .. "AA",
    button_hover_fg = beautiful.fg_focus,
    button_icon_bg = beautiful.bg_minimize,
}

local M = {}
local background_dim_widgets = {}

local power_menu_commands = {
    suspend_command = function()
        awful.spawn.with_shell("systemctl suspend")
        M.stop()
    end,
    logout_command = function()
        awesome.quit()
        M.stop()
    end,
    lock_command = function()
        M.stop()
    end,
    poweroff_command = function()
        awful.spawn.with_shell("poweroff")
        M.stop()
    end,
    reboot_command = function()
        awful.spawn.with_shell("reboot")
        M.stop()
    end,
}

local function create_options_popup()
    ---@param name string
    ---@param icon string
    ---@param callback fun()
    ---@return unknown
    local function create_power_button(name, icon, callback)
        local container = wibox.widget({
            widget = wibox.container.background,
            bg = theme.button_icon_bg .. "77",
            shape = shape_utils.rrect(10),
            {
                id = "button_layout",
                layout = wibox.layout.ratio.horizontal,
                spacing = dpi(20),
                {
                    widget = wibox.container.background,
                    shape = shape_utils.prrect(10, true, false, false, true),
                    bg = theme.button_icon_bg,
                    {
                        widget = wibox.container.margin,
                        margins = dpi(10),
                        {
                            layout = wibox.layout.align.horizontal,
                            expand = "outside",
                            nil,
                            {
                                widget = wibox.widget.textbox,
                                markup = icon,
                                font = beautiful.icon_font .. "65",
                                valign = "center",
                                haligh = "center",
                            },
                        },
                    },
                },
                {
                    widget = wibox.widget.textbox,
                    markup = name,
                    font = beautiful.font_name .. "20",
                    valign = "center",
                    haligh = "center",
                },
            },
        })

        container.button_layout:set_ratio(1, 0.45)
        container.button_layout:set_ratio(2, 0.55)
        container:connect_signal("button::release", callback)
        hover_utils.apply_hover_effects(container, {
            hover_utils.fg_hover(theme.button_hover_fg),
        })

        return container
    end

    local is_mouse_on_content_widget = false

    local popup = awful.popup({
        ontop = true,
        bg = theme.overlay_bg_color,
        visible = false,
        widget = {
            id = "widget_container",
            layout = wibox.layout.stack,
            {
                id = "background",
                widget = wibox.container.background,
            },
            {
                id = "option_box_container",
                widget = wibox.container.place,
                valign = "center",
                haligh = "center",
                {
                    id = "option_box",
                    widget = wibox.container.background,
                    shape = shape_utils.rrect(10),
                    bg = beautiful.bg_normal,
                    forced_width = dpi(450),
                    {
                        widget = wibox.container.margin,
                        margins = dpi(50),
                        {
                            layout = wibox.layout.fixed.vertical,
                            spacing = dpi(50),
                            spacing_widget = wibox.widget.separator,
                            {
                                widget = wibox.widget.textbox,
                                markup = "Leaving?",
                                font = beautiful.font_name .. "50",
                                halign = "center",
                            },
                            {
                                layout = wibox.layout.grid,
                                spacing = dpi(10),
                                foced_num_cols = 1,
                                foced_num_rows = 4,
                                homogeneous = true,
                                expand = true,
                                create_power_button("<b>P</b>oweroff ", "", power_menu_commands.poweroff_command),
                                create_power_button("<b>R</b>estart ", "", power_menu_commands.reboot_command),
                                create_power_button("<b>S</b>leep ", "", power_menu_commands.suspend_command),
                                create_power_button("<b>L</b>ogout ", "󰗼", power_menu_commands.logout_command),
                            },
                        },
                    },
                },
            },
        },
    })

    popup.widget.background:connect_signal("button::release", function()
        if not is_mouse_on_content_widget then
            M.stop()
        end
    end)

    popup.widget.option_box_container.option_box:connect_signal("mouse::enter", function()
        is_mouse_on_content_widget = true
    end)

    popup.widget.option_box_container.option_box:connect_signal("mouse::leave", function()
        is_mouse_on_content_widget = false
    end)

    return popup
end

local popup_with_options = create_options_popup()

---@param s Screen
local function create_background_dim_for_screen(s)
    local popup = awful.popup({
        screen = s,
        ontop = true,
        x = s.geometry.x,
        y = s.geometry.y,
        bg = theme.overlay_bg_color,
        visible = false,
        widget = {
            widget = wibox.container.background,
            forced_height = s.geometry.height,
            forced_width = s.geometry.width,
        },
    })
    background_dim_widgets[s.index] = popup

    popup.widget:connect_signal("button::release", function()
        M.stop()
    end)
end

local keygrabber = awful.keygrabber({
    keybindings = {
        awful.key({
            modifiers = {},
            key = "Escape",
            on_press = function()
                M.stop()
            end,
        }),
        awful.key({
            modifiers = {},
            key = "p",
            on_press = power_menu_commands.poweroff_command,
        }),
        awful.key({
            modifiers = {},
            key = "r",
            on_press = power_menu_commands.reboot_command,
        }),
        awful.key({
            modifiers = {},
            key = "s",
            on_press = power_menu_commands.suspend_command,
        }),
        awful.key({
            modifiers = {},
            key = "l",
            on_press = power_menu_commands.logout_command,
        }),
    },
})

awful.screen.connect_for_each_screen(function(s)
    create_background_dim_for_screen(s)
end)

M.start = function()
    local focused_screen = awful.screen.focused()

    -- Dim all monitors except for focused one
    for value in screen do
        if value.index ~= focused_screen.index then
            background_dim_widgets[value.index].visible = true
        end
    end

    -- Set main popup on currently focued screen and show it
    popup_with_options.screen = focused_screen
    popup_with_options.x = focused_screen.geometry.x
    popup_with_options.y = focused_screen.geometry.y
    popup_with_options.minimum_width = focused_screen.geometry.width
    popup_with_options.maximum_width = focused_screen.geometry.width
    popup_with_options.minimum_height = focused_screen.geometry.height
    popup_with_options.maximum_height = focused_screen.geometry.height
    popup_with_options.visible = true

    keygrabber:start()
end

M.stop = function()
    for _, entry in ipairs(background_dim_widgets) do
        entry.visible = false
    end
    popup_with_options.visible = false
    keygrabber:stop()
end

return M
