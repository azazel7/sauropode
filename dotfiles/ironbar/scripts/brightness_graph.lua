local circle = 4

-- Backlight Device (sysfs path)

local backlight_path = "/sys/class/backlight/intel_backlight"

----------------
-- Brightness reading
----------------

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local contents = f:read("*a")
  f:close()
  return tonumber(contents)
end

local function get_brightness_fraction()
  local current = read_file(backlight_path .. "/brightness")
  local max = read_file(backlight_path .. "/max_brightness")
  if not current or not max or max == 0 then return nil end
  return math.max(0, current / max)
end

----------------
-- RGB Function
----------------

local function get_rgb(fraction_used)
  local r, g, b = 0.0, 0.6, 0.0
  if fraction_used < 0.5 then
    r = fraction_used * 2.0
    b = 1.0
  else
    r = 1.0
    b = 2.0 * (1.0 - fraction_used)
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

  local fraction_used = get_brightness_fraction()
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
