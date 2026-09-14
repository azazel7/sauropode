-- Thickness of Circle

local circle = 4

local function get_ram()
  local memory_used = ironbar:var_get("sysinfo.memory_percent")
  local fraction_used = math.max(0, memory_used / 100)
  return fraction_used
end

----------------
-- RGB Function
----------------
-- Green (0.0, 0.8, 0.0) -> Orange (1.0, 0.5, 0.0) -> Red (1.0, 0.0, 0.0)
local function get_rgb(fraction_used)
  local r, g, b = 0.0, 0.0, 0.0

  if fraction_used < 0.5 then
    -- Green to Orange
    local t = fraction_used * 2.0
    r = t * 1.0
    g = 0.8 + t * (0.5 - 0.8)
    b = 0.0
  else
    -- Orange to Red
    local t = (fraction_used - 0.5) * 2.0
    r = 1.0
    g = 0.5 + t * (0.0 - 0.5)
    b = 0.0
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

  local fraction_used = get_ram()
  if not fraction_used then return end

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


