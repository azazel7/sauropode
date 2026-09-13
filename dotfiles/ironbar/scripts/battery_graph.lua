--------------------------------
--
-- Paint a Battery Usage Circle
--
--------------------------------

------------
-- Settings
------------

-- Thickness of Circle

local circle = 3

----------------
-- RGB Function
----------------

local function get_rgb(fraction_used)
  local r, g, b = 0.0, 0.0, 0.0
  if fraction_used < 0.5 then
    g = fraction_used * 2.0
    r = 1.0
  else
    g = 1.0
    r = 2.0 * (1.0 - fraction_used)
  end
  return r, g, b
end

-----------
-- Program
-----------

local function render(cr, width, height)
  cr:set_operator(0)
  cr:paint()
  cr:set_operator(2)
  local battery_used = ironbar:var_get("upower.Percentage")
  local fraction_used = math.max(0, battery_used / 100)
  if fraction_used == 0 then return end

    local r, g, b = get_rgb(fraction_used)

    local xc = width / 2
    local yc = height / 2
    local radius = (math.min(width, height) / 2) - 4
    local start_angle = (115) * math.pi / 180
    local end_angle = (65) * math.pi / 180
    local total_span = (2 * math.pi) - (start_angle - end_angle)

    cr:set_line_width(circle)

    cr:set_line_cap(1)
    cr:set_source_rgba(0.19, 0.19, 0.19, 1.0)
    cr:arc(xc, yc, radius, start_angle, end_angle)
    cr:stroke()

    local app_end_angle = start_angle + (fraction_used * total_span)
    if fraction_used > 0 then
      cr:set_source_rgba(r, g, b, 1.0)
      cr:arc(xc, yc, radius, start_angle, app_end_angle)
      cr:stroke()
    end
    collectgarbage("step", 1)
end

return render
