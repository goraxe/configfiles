local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")


local M = {}

M.dpiSize = function (num)
  return dpi(num)
end

M.rounded_rect = function(radius)
  radius = radius or beautiful.border_radius
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

return M
