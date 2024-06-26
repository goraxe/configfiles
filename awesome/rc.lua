-- vim: foldmethod=marker

require("luarocks.loader")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local conky = require("conky")

conky.properties = {
    floating = true,
    sticky = true,
    ontop = false,
    skip_taskbar = true,
    below = true,
    focusable = true,
    titlebars_enabled = false,
    opacity = 0.5,
    border_width = 0,
}

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

beautiful.init("/home/goraxe/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
browser = "firefox"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

require("screens")

-- -- {{{ Wibar
-- -- Create a textclock widget
-- mytextclock = wibox.widget.textclock()
--
-- -- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()
--
--
-- local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
-- local cw = calendar_widget({
--         theme  = "dark",
--         radius = 8,
--         placement = "top_right"
--     })
-- mytextclock:connect_signal("button::press",
--     function(_, _, _, button)
--         if button == 1 then cw.toggle() end
--     end)
--
-- local apt_widget = require("awesome-wm-widgets.apt-widget.apt-widget")
-- local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
--
-- -- local github_co
-- local github_contributions_widget = require('awesome-wm-widgets.github-contributions-widget.github-contributions-widget')
--
-- -- {{{ taglist and tasklist buttons
-- local taglist_buttons = gears.table.join(
--                     awful.button({ }, 1, function(t) t:view_only() end),
--                     awful.button({ modkey }, 1, function(t)
--                                               if client.focus then
--                                                   client.focus:move_to_tag(t)
--                                               end
--                                           end),
--                     awful.button({ }, 3, awful.tag.viewtoggle),
--                     awful.button({ modkey }, 3, function(t)
--                                               if client.focus then
--                                                   client.focus:toggle_tag(t)
--                                               end
--                                           end)
--                     -- awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
--                     -- awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
--                 )
--
-- local tasklist_buttons = gears.table.join(
--                      awful.button({ }, 1, function (c)
--                                               if c == client.focus then
--                                                   c.minimized = true
--                                               else
--                                                   -- Without this, the following
--                                                   -- :isvisible() makes no sense
--                                                   c.minimized = false
--                                                   if not c:isvisible() and c.first_tag then
--                                                       c.first_tag:view_only()
--                                                   end
--                                                   -- This will also un-minimize
--                                                   -- the client, if needed
--                                                   client.focus = c
--                                                   c:raise()
--                                               end
--                                           end),
--   -- DOC what this does is on right click 
--                     -- awful.button({ }, 3, client_menu_toggle_fn()),
--                      awful.button({ }, 4, function ()
--                                               awful.client.focus.byidx(1)
--                                           end),
--                      awful.button({ }, 5, function ()
--                                               awful.client.focus.byidx(-1)
--                                           end))
--
-- -- }}}
-- -- {{{ Wall paper 
--
-- local function set_wallpaper(s)
--     -- Wallpaper
--     if beautiful.wallpaper then
--         local wallpaper = beautiful.wallpaper
--         -- If wallpaper is a function, call it with the screen
--         if type(wallpaper) == "function" then
--             wallpaper = wallpaper(s)
--         end
--         gears.wallpaper.maximized(wallpaper, s, true)
--     end
-- end
--
-- -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)
--
-- -- }}}
--
-- local tags = {}
--
-- local function make_fa_icon( code )
--     icon_color = "red"
--   return wibox.widget{
--     --    font = theme.icon_font .. theme.icon_size,
--     markup = ' <span color="'.. icon_color ..'">' .. code .. '</span> ',
--     align  = 'center',
--     valign = 'center',
--     widget = wibox.widget.textbox
--   }
-- end
--
-- local facpuicon = make_fa_icon('\u{f2db}')
-- local famemicon = make_fa_icon('\u{f538}')
-- local fatempicon = make_fa_icon('\u{f2c9}')
-- local faweathericon = make_fa_icon('\u{f6c4}')
-- local facalicon = make_fa_icon('\u{f783}' )
-- local fatimeicon = make_fa_icon('\u{f017}' )
-- local terminalicon = make_fa_icon('\u{f489}')
--
-- local function add_primary_screen_tags(s)
--   tags["dev"] = awful.tag.add("dev", {
--     layout = awful.layout.suit.spiral.dwindle,
--     icon = "/home/goraxe/.config/awesome/theme/octicons/icons/terminal-24.svg",
--     -- icon   =  terminalicon,
--     master_width_factor = 10,
--
--     screen = s,
--     selected = true,
--   })
--
--   tags["games"] = awful.tag.add("games", {
--     layout = awful.layout.suit.spiral.dwindle,
--     master_width_factor = 10,
--
--     screen = s,
--   })
--
-- end
--
-- local function add_secendary_screen_tags(s)
--
--   tags["web"] = awful.tag.add("web", {
--     layout = awful.layout.suit.spiral.dwindle,
--     master_width_factor = 10,
--
--     screen = s,
--      selected = true,
--   })
--
--   tags["comms"] = awful.tag.add("comms", {
--     layout = awful.layout.suit.spiral.dwindle,
--     master_width_factor = 10,
--
--     screen = s,
--   })
--
--   tags["monitoring"] = awful.tag.add("monitoring", {
--     layout = awful.layout.suit.spiral.dwindle,
--     screen = s,
--   })
--
--   awful.tag.add("focus", {
--     layout = awful.layout.suit.spiral.dwindle,
--     master_width_factor = 10,
--
--     screen = s,
--   })
-- end
-- awful.screen.connect_for_each_screen(function(s)
--     -- Wallpaper
--     -- TODO FIXME set a wall paper
--     set_wallpaper(s)
--
--     -- print("screen primary :" .. tostring(s), s.primary, s, s.index, screen:count() )
--
--     -- Each screen has its own tag table.
--     -- isMulitscreen
--     if screen:count() > 1 then
--       -- is Primary
--       if s.index == 1 then
--         add_primary_screen_tags(s)
--       else
--         add_secendary_screen_tags(s)
--       end
--     else
--       add_primary_screen_tags(s)
--       add_secendary_screen_tags(s)
--     end
--
--     -- awful.tag({ "dev", "web", "comms", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
--
--     -- Create a promptbox for each screen
--     s.mypromptbox = awful.widget.prompt()
--     -- Create an imagebox widget which will contain an icon indicating which layout we're using.
--     -- We need one layoutbox per screen.
--     s.mylayoutbox = awful.widget.layoutbox(s)
--     s.mylayoutbox:buttons(gears.table.join(
--                            awful.button({ }, 1, function () awful.layout.inc( 1) end),
--                            awful.button({ }, 3, function () awful.layout.inc(-1) end),
--                            awful.button({ }, 4, function () awful.layout.inc( 1) end),
--                            awful.button({ }, 5, function () awful.layout.inc(-1) end)))
--     -- Create a taglist widget
--     s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
--
--     -- Create a tasklist widget
--     s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)
--
--     -- Create the wibox
--     s.mywibox = awful.wibar({
-- --      position = "top",
--       screen = s,
--       border_width = 2,
--       border_color = theme.border_normal,
--       y = 5,
--       height = 50,
--       shape = function(cr,w,h)
--           gears.shape.rounded_rect(cr, w, h, 50)
--       end,
--
--     })
--     print("add wibboxen stuff")
--     -- Add widgets to the wibox
--     s.mywibox:setup {
--         layout = wibox.layout.align.horizontal,
--         { -- Left widgets
--             layout = wibox.layout.fixed.horizontal,
--             mylauncher,
--             s.mytaglist,
--             s.mypromptbox,
--         },
--         s.mytasklist, -- Middle widget
--         { -- Right widgets
--             layout = wibox.layout.fixed.horizontal,
--             github_contributions_widget({username = 'goraxe', margin_top = 15, with_border = true}),
--             conky.widget({
--               label = "conky:",
--               conky = "CPU: ${cpu}% MEM: ${memperc}%",
--               conkybox = { force_width = 30, align = "right" },
--               iconbox = { opacity = 0.8 },
--             }),
--             apt_widget(),
--             cpu_widget(),
--             mykeyboardlayout,
--             wibox.widget.systray(),
--             mytextclock,
--             s.mylayoutbox,
--         },
--     }
-- end)
-- -- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
--    awful.button({ }, 4, awful.tag.viewnext),
--    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "F1",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Applications
    awful.key({ modkey, }, "b", function() awful.spawn(browser) end,
              { description = "open a browser", group = "launcher" }),

    -- Prompt
    awful.key({ modkey, "Shift" },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),

    awful.key({ modkey }, "r", function () awful.spawn("rofi -show combi") end,
              { description = "launch rofi in run application"}),

    awful.key({ modkey }, "Tab", function () awful.spawn("rofi -show window") end,
              { description = "launch rofi in drun"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
  conky.show_key("F12"),                -- conky window on top while held
  conky.toggle_key("F12", { modkey })  -- toggle conky on top
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey, }, "t",      function (c) awful.spawn("picom-trans -c --toggle")            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,  "Shift" }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to dialogs
    { rule_any = {type = { "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    { rule_any = {type = { "normal" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "web" on screen 2.
    { rule = { class = "Firefox" },
      properties = { tag = "web" } },

    { rule = { class = "Firefox" },
      properties = { tag = "web" } },

    -- Set Slack to always map to comms tag
    { rule = { class = "Slack" },
      properties = { tag = "comms" } },
    -- conky rules
    conky.rules(),
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)


-- client.connect_signal("manage", function(c)
--     c.shape = function(cr,w,h)
--       gears.shape.rounded_rect(cr, w, h, 50)
--   end
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
