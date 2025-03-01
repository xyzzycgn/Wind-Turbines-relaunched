---
--- Created by xyzzycgn.
--- DateTime: 01.03.25 13:19
---

local surface_conditions = {}

function surface_conditions.surface_condition(property, min, max)
    return { property = property, min = min, max = max }
end

function surface_conditions.pressure()
    return surface_conditions.surface_condition("pressure", 800, 1.7976931348623156e+308)
end

return surface_conditions
