local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")

local wifi_widget = {}

local function worker(user_args)
    local args = user_args or {}
    local interface = args.interface or "wlan0"
    local timeout = args.timeout or 5

    local icon_widget = wibox.widget {
        font = args.font or "Hack Nerd Font 14",
        widget = wibox.widget.textbox,
    }

    local text_widget = wibox.widget {
        font = args.font or "Hack NF 10",
        widget = wibox.widget.textbox,
    }

    wifi_widget = wibox.widget {
        icon_widget,
        text_widget,
        layout = wibox.layout.fixed.horizontal,
        spacing = 4,
    }

    local function signal_icon(rssi)
        if rssi == nil then return "󰤭" end -- disconnected
        rssi = tonumber(rssi)
        if rssi >= -50 then return "󰤨" end -- excellent
        if rssi >= -60 then return "󰤥" end -- good
        if rssi >= -70 then return "󰤢" end -- fair
        return "󰤟" -- weak
    end

    local function update_widget()
        awful.spawn.easy_async_with_shell(
            "iwctl station " .. interface .. " show 2>/dev/null",
            function(stdout)
                local state = stdout:match("State%s+(%S+)")
                if state ~= "connected" then
                    icon_widget:set_markup('<span font="Hack Nerd Font 14">󰤭</span>')
                    text_widget:set_text("")
                    return
                end

                local ssid = stdout:match("Connected network%s+(.-)%s*$[^\n]*")
                    or stdout:match("Connected network%s+(%S+)")
                local rssi = stdout:match("RSSI%s+(%-?%d+)")

                icon_widget:set_markup('<span font="Hack Nerd Font 14">' .. signal_icon(rssi) .. '</span>')
                text_widget:set_text(ssid or "")
            end
        )
    end

    local notification
    wifi_widget:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            awful.spawn.easy_async_with_shell(
                "iwctl station " .. interface .. " show 2>/dev/null",
                function(stdout)
                    naughty.destroy(notification)
                    notification = naughty.notify({
                        title = "WiFi Status",
                        text = stdout:gsub("\27%[%d*;?%d*m", ""):gsub("%-+\n", ""):gsub("%s+$", ""),
                        timeout = 10,
                        screen = mouse.screen,
                    })
                end
            )
        elseif button == 3 then
            awful.spawn.easy_async_with_shell(
                "iwctl station " .. interface .. " scan && sleep 1 && iwctl station " .. interface .. " get-networks 2>/dev/null",
                function(stdout)
                    naughty.destroy(notification)
                    notification = naughty.notify({
                        title = "Available Networks",
                        text = stdout:gsub("\27%[%d*;?%d*m", ""):gsub("%-+\n", ""):gsub("%s+$", ""),
                        timeout = 15,
                        screen = mouse.screen,
                    })
                end
            )
        end
    end)

    gears.timer {
        timeout = timeout,
        call_now = true,
        autostart = true,
        callback = update_widget,
    }

    return wifi_widget
end

return setmetatable(wifi_widget, { __call = function(_, ...) return worker(...) end })
