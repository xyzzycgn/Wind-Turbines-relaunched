---
--- Created by xyzzycgn.
--- DateTime: 01.03.25 13:19
---

local surface_conditions = {}

function surface_conditions.surface_condition(property, min, max)
    return { property = property, min = min, max = max }
end

function surface_conditions.pressure()
    return surface_conditions.surface_condition("pressure", 800, 20000)
end

-- checks the existence of space age DLC and only if it's present return the result of the referred function
function surface_conditions.check_existence_of_SPA(func)
    if mods["space-age"] then
        return func()
    end

    return nil
end

local use_surface_wind_speed = settings.startup['texugo-wind-use-surface-wind-speed'].value
local wind_scale_with_pressure = settings.startup['texugo-wind-scale-with-pressure'].value
local use_quality = mods["space-age"]

--- combined scaling factor of max increase by quality and/or pressure
function surface_conditions.scaleWithQualityAndPressure()
    local scale = use_surface_wind_speed and wind_scale_with_pressure and 20 or 1
    return use_quality and (scale * 3.5) or scale
end

return surface_conditions
