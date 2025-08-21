---
--- Created by xyzzycgn.
--- DateTime: 21.08.25 08:18
---

local function in_range(x, low, high)
    if (x < low) then
        return low
    elseif x > high then
        return high
    else
        return x
    end
end


local function init()
    return {
        v = math.random(),
        delta_v = (math.random() - 0.5) / 10
    }
end

local function windspeed(surface_index)
    local wsos = storage.wind_speed_on_surface[surface_index] or init()

    local v = in_range(wsos.v + delta_v, 0, 1)
    local delta_v = in_range(wsos.delta_v + (math.random() - 0.5) / 500, -0.05, 0.05)

    wsos.v = v
    wsos.delta_v = delta_v

    storage.wind_speed_on_surface[surface_index] = wsos

    return v
end

return {
    init = init,
    windspeed = windspeed,
}
