--- @type Theme
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

--- @type Wibox
local wibox = require("wibox")

local awful = require("awful")

--- @type UiUtils
local ui_utils = require("ui_utils")

local gears = require("gears")

local mouse_keybinds = {
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({}, awful.button.names.MIDDLE, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end),
}

-- Credits for this goes to https://github.com/Amitabha37377/Awful-DOTS. Without his/her's dots i would
-- have no idea that nesting tasklists inside taglist is possible

---@param s Screen
function create_nested_tasklist(s, tag)
    local function only_matching_tag(c, _)
        for _, t in pairs(c:tags()) do
            if t == tag then
                return true
            end
        end
        return false
    end

    return awful.widget.tasklist({
        screen = s,
        filter = only_matching_tag,
        layout = {
            spacing = dpi(5),
            layout = wibox.layout.fixed.horizontal,
        },
        widget_template = {
            widget = wibox.container.background,
            awful.widget.clienticon,
            create_callback = function(self, c, _, _)
                self.tooltip = ui_utils.generate_tooltip(self, c.name)
            end,
            update_callback = function(self, c, _, _)
                self.tooltip.text = c.name
            end,
        },
    })
end

---@param s Screen
local function create_taglist(s)
    -- Somehow on second monitor there was a bug where even on empty tag somehow layout.fixed detected empty tasklist and applied spacing between
    -- tag name and task icon. This basicaly fixes it. If there are no client on tag, set spacing to 0 ( fixes additional spacing ) if clients
    -- are present change spacing to normal value
    function update_callback(self, tag)
        layout = self:get_children_by_id("text_and_icon_layout")
        if #tag:clients() == 0 then
            layout[1].spacing = dpi(0)
        else
            layout[1].spacing = dpi(10)
        end
    end

    function create_callback(self, tag)
        local nested_tasklist = create_nested_tasklist(s, tag)
        self:get_children_by_id("task_list")[1]:add(nested_tasklist)

        local widget = self:get_children_by_id("hover_background")[1]

        widget:connect_signal("mouse::enter", function(self_inner)
            self_inner.opacity = 1
        end)

        widget:connect_signal("mouse::leave", function(self_inner)
            self_inner.opacity = 0
        end)
        ui_utils.cursor_hover(widget)
    end

    local widget = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.noempty,
        buttons = mouse_keybinds,
        widget_template = {
            {
                {
                    widget = wibox.container.background,
                    id = "hover_background",
                    opacity = 0,
                    bg = beautiful.bg_focus,
                },
                {
                    widget = wibox.container.margin,
                    left = dpi(10),
                    right = dpi(10),
                    {
                        {
                            widget = wibox.widget.textbox,
                            align = "center",
                            id = "text_role",
                        },
                        {
                            widget = wibox.container.margin,
                            top = dpi(7),
                            bottom = dpi(7),
                            {
                                id = "task_list",
                                layout = wibox.layout.fixed.horizontal,
                            },
                        },
                        id = "text_and_icon_layout",
                        layout = wibox.layout.fixed.horizontal,
                    },
                },
                {
                    layout = wibox.layout.align.vertical,
                    expand = "inside",
                    nil,
                    nil,
                    {
                        widget = wibox.container.background,
                        forced_height = dpi(3),
                        id = "background_role",
                    },
                },
                layout = wibox.layout.stack,
            },
            widget = wibox.container.background,
            update_callback = update_callback,
            create_callback = create_callback,
        },
    })

    return widget
end

return create_taglist
