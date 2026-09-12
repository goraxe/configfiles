local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")

local bluetooth_widget = {}

local function worker(user_args)
    local args = user_args or {}
    local timeout = args.timeout or 10

    local icon_widget = wibox.widget {
        font = args.font or "Hack Nerd Font 14",
        widget = wibox.widget.textbox,
    }

    bluetooth_widget = wibox.widget {
        icon_widget,
        layout = wibox.layout.fixed.horizontal,
    }

    local function update_widget()
        awful.spawn.easy_async_with_shell(
            "bluetoothctl show 2>/dev/null",
            function(stdout)
                local powered = stdout:match("Powered:%s+(%S+)")
                if powered ~= "yes" then
                    icon_widget:set_markup('<span color="gray">󰂲</span>')
                    return
                end

                awful.spawn.easy_async_with_shell(
                    "bluetoothctl devices Connected 2>/dev/null",
                    function(out)
                        local count = 0
                        for _ in out:gmatch("[^\n]+") do
                            count = count + 1
                        end
                        if count > 0 then
                            icon_widget:set_markup('<span color="#3584e4">󰂯</span>')
                        else
                            icon_widget:set_markup('󰂯')
                        end
                    end
                )
            end
        )
    end

    local notification
    bluetooth_widget:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            awful.spawn.easy_async_with_shell(
                "bluetoothctl devices 2>/dev/null",
                function(stdout)
                    awful.spawn.easy_async_with_shell(
                        "bluetoothctl devices Connected 2>/dev/null",
                        function(connected)
                            naughty.destroy(notification)
                            local text = "Paired:\n" .. (stdout ~= "" and stdout or "  (none)") ..
                                "\nConnected:\n" .. (connected ~= "" and connected or "  (none)")
                            notification = naughty.notify({
                                title = "Bluetooth",
                                text = text,
                                timeout = 10,
                                screen = mouse.screen,
                            })
                        end
                    )
                end
            )
        elseif button == 3 then
            -- Toggle power
            awful.spawn.easy_async_with_shell(
                "bluetoothctl show 2>/dev/null | grep 'Powered:'",
                function(stdout)
                    local powered = stdout:match("Powered:%s+(%S+)")
                    if powered == "yes" then
                        awful.spawn("bluetoothctl power off")
                    else
                        awful.spawn("bluetoothctl power on")
                    end
                    gears.timer.start_new(1, function()
                        update_widget()
                        return false
                    end)
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

    return bluetooth_widget
end

return setmetatable(bluetooth_widget, { __call = function(_, ...) return worker(...) end })
