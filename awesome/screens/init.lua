--
local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local conky = require("conky")

local ui = require("ui")

local github_contributions = require("widgets.github_contributions").init()
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

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()


local modkey = "Mod4"
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local cw = calendar_widget({
        theme  = "dark",
        radius = 8,
        placement = "top_right"
    })
mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
    end)

local apt_widget = require("awesome-wm-widgets.apt-widget.apt-widget")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")

-- local github_co
local github_contributions_widget = require('awesome-wm-widgets.github-contributions-widget.github-contributions-widget')

-- {{{ taglist and tasklist buttons
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end)
                    -- awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    -- awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
  -- DOC what this does is on right click 
                    -- awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

-- }}}
-- {{{ Wall paper 

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- }}}

local tags = {}

local function make_fa_icon( code )
    icon_color = "red"
  return wibox.widget{
    --    font = theme.icon_font .. theme.icon_size,
    markup = ' <span color="'.. icon_color ..'">' .. code .. '</span> ',
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }
end

local facpuicon = make_fa_icon('\u{f2db}')
local famemicon = make_fa_icon('\u{f538}')
local fatempicon = make_fa_icon('\u{f2c9}')
local faweathericon = make_fa_icon('\u{f6c4}')
local facalicon = make_fa_icon('\u{f783}' )
local fatimeicon = make_fa_icon('\u{f017}' )
local terminalicon = make_fa_icon('\u{f489}')


local function add_dock_center (screen)
  local height = screen.geometry.height / 2
  local width = screen.geometry.width / 2

  main = wibox({
    screen = screen,
    x = width / 2,
    y = height /2 ,
    width = width,
    height = height,

    opacity = 0.9,
--    bg = '#ff0000',
--    optop = true,
    visible = true,
    type = 'desktop'
  })

  content = wibox.widget {
    valign = 'center',
    halign = 'center',
    widget = wibox.container.place
  }

  rows_grid = wibox.widget {
    layout = wibox.layout.grid,
    forced_num_cols = 4,
    forced_num_rows = 5,
    orientation = "horizontal",
    spacing = ui.dpiSize(5),
    expand = true,
    homogeneous = true
  }


  rows_grid:add_widget_at(github_contributions, 1, 1, 2, 2)

  content:set_widget(rows_grid)
  main:setup {
    layout = wibox.container.margin, margins = ui.dpiSize(30),
    content
  }
end

local function add_primary_screen_tags(s)
  tags["dev"] = awful.tag.add("dev", {
    layout = awful.layout.suit.tile.left,
    icon = "/home/goraxe/.config/awesome/theme/octicons/icons/terminal-24.svg",
    -- icon   =  terminalicon,
    master_width_factor = 10,

    screen = s,
    selected = true,
  })

  tags["games"] = awful.tag.add("games", {
    layout = awful.layout.suit.tile.left,
    master_width_factor = 10,

    screen = s,
  })

  add_dock_center(s)
end

local function add_secendary_screen_tags(s, selected)

  tags["web"] = awful.tag.add("web", {
    layout = awful.layout.suit.tile,
    master_width_factor = 10,

    screen = s,
     selected = selected,
  })

  tags["comms"] = awful.tag.add("comms", {
    layout = awful.layout.suit.spiral.dwindle,
    master_width_factor = 10,

    screen = s,
  })

  tags["monitoring"] = awful.tag.add("monitoring", {
    layout = awful.layout.suit.spiral.dwindle,
    screen = s,
  })

  awful.tag.add("focus", {
    layout = awful.layout.suit.spiral.dwindle,
    master_width_factor = 10,

    screen = s,
  })
end
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- TODO FIXME set a wall paper
    set_wallpaper(s)

    -- print("screen primary :" .. tostring(s), s.primary, s, s.index, screen:count() )

    -- Each screen has its own tag table.
    -- isMulitscreen
    if screen:count() > 1 then
      -- is Primary
      if s.index == 1 then
        add_primary_screen_tags(s)
      else
        add_secendary_screen_tags(s, true)
      end
    else
      add_primary_screen_tags(s)
      add_secendary_screen_tags(s, false)
    end

    -- awful.tag({ "dev", "web", "comms", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({
--      position = "top",
      screen = s,
      border_width = 2,
      border_color = theme.border_normal,
      y = 5,
      height = 50,
      shape = function(cr,w,h)
          gears.shape.rounded_rect(cr, w, h, 50)
      end,

    })
    print("add wibboxen stuff")
    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            github_contributions_widget({username = 'goraxe', margin_top = 15, with_border = true}),
            conky.widget({
              label = "conky:",
              conky = "CPU: ${cpu}% MEM: ${memperc}%",
              conkybox = { force_width = 30, align = "right" },
              iconbox = { opacity = 0.8 },
            }),
            apt_widget(),
            cpu_widget(),
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}
