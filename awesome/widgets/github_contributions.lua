local gears            = require('gears')
local awful            = require('awful')
local wibox            = require('wibox')
local ui = require("ui")
-- local constants = require("constants")
-- 下载图片
M_github_contributions = {
  init = function()
    local imageWidet = wibox.widget {
      resize        = true,
--      forced_width  = ui.dpiSize(435),
--      forced_height = ui.dpiSize(350),
--      shape         = ui.rounded_rect(ui.dpiSize(50)),
--      border_width  = 1,
--      border_color  = '#ffffff',
      widget        = wibox.widget.imagebox
    }
    local github_contributions_widget = wibox.widget {

          wibox.widget {

            wibox.widget {
              imageWidet,
              widget  = wibox.container.margin,
              margins = ui.dpiSize(15),
              valign  = 'center',
              halign  = 'center',
            },
            halign = 'center',
            valign = 'center',
            widget = wibox.container.place
          },

--          bg     = '#00000f',
          bg     = '#ffffff',
          shape  = ui.rounded_rect(ui.dpiSize(50)),
          widget = wibox.container.background,
          opacity = 1.0
        },

        M_github_contributions.upDateImage(imageWidet)
    return github_contributions_widget
  end,
  upDateImage = function(imageWidet)
    local image_file = "/home/goraxe/Downloads/profile-green-animate.svg" -- constants.contributions
    local url = ""
    if not gears.filesystem.file_readable(image_file) then
      awful.spawn.with_shell('curl -L -o "' .. image_file .. '" "' .. url .. '"',
        function() -- 运行 curl 命令下载图片
          imageWidet:set_image(image_file)
        end)
    else
      imageWidet:set_image(image_file)
    end
    imageWidet:set_image(image_file)
  end
}
return M_github_contributions
