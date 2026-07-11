-- wind
-- https://www.geogebra.org/m/GDgua6HK
-- y = sin(3x/2)/3+sin(2x/2+2)/3+sin(3x/2-3)/2-sin(4x/2+1)/3-sin(5x/2+3)/4-sin(6x/2+4)/2+sin(x/3)+2.5

local handle_settings = require("scripts/handle_settings")
local wind_speed = require("scripts/wind_speed")

local powersetting = handle_settings.WindPower()
local use_surface_wind_speed = handle_settings.useSurfaceWindSpeed()
local wind_scale_with_pressure = handle_settings.scaleWithPressure()

local output_modifiers = {
    ['texugo-wind-turbine'] = 1,
    ['texugo-wind-turbine2'] = 10,
    ['texugo-wind-turbine3'] = 100,
    ['texugo-wind-turbine4'] = 1000,
}

local quality_factor = {
    [0] = 1,
    [1] = 1.3,
    [2] = 1.6,
    [3] = 1.9,
    [4] = 2.5
}

local turbine_names = {
    'texugo-wind-turbine',
    'texugo-wind-turbine2',
    'texugo-wind-turbine3',
    'texugo-wind-turbine4',
}

local function resetWindCount(event)
    if storage.wind >= 1800 then
        storage.wind = 0
    end
end
-- ###############################################################

local function businessLogic(event)
    storage.wind = storage.wind + 0.02
    local x = storage.wind
    -- legacy function
    local y = not use_surface_wind_speed and ((math.sin(3*x/2)/3)+(math.sin(2*x/2+2)/3)+(math.sin(3*x/2-3)/2)-(math.sin(4*x/2+1)/3)-
            (math.sin(5*x/2+3)/4)-(math.sin(6*x/2+4)/2)+math.sin(x/3)+2.5)/4.655 or 0

    local knownSurface = {}

    for _, wind_turbine in pairs(storage.wind_turbines) do
        local entity = wind_turbine.entity
        local name = wind_turbine.name

        if entity.valid and entity.type == 'electric-energy-interface' then
            local ql = entity.quality.level
            local qf
            -- if somebody uses a mod with additional quality levels
            if ql > 4 then
                qf = quality_factor[4] + (ql - 4) / ql
            else
                qf = quality_factor[ql]
            end

            local pf = 1
            if use_surface_wind_speed then
                local surface = wind_turbine.surface
                local surface_index = surface.index

                -- surface already used in this round?
                if knownSurface[surface_index] then
                    y = knownSurface[surface_index].y
                    pf = knownSurface[surface_index].pf
                else
                    -- we need ~70% propability (exactly 450/675 = 2/3). windspeed has an average of 50%
                    y = math.sqrt(wind_speed.windspeed(surface_index))

                    if wind_scale_with_pressure then
                        -- scale with the effective pressure of the surface, relative to the
                        -- surface-property default (== pressure on nauvis). get_property works on
                        -- every surface (incl. script-created ones), falling back to the default
                        pf = surface.get_property('pressure') / prototypes.surface_property['pressure'].default_value
                    end

                    knownSurface[surface_index] = {
                        y = y,
                        pf = pf
                    }
                end
            end

            entity.power_production = y * 67500/60 * powersetting * output_modifiers[name] * qf * pf
            entity.electric_buffer_size = 67500/60 * powersetting * output_modifiers[name] * qf * pf
        end
    end
end
-- ###############################################################

local function build_entity(event)
    local twt = event.created_entity or event.entity
    for _, turbine_name in ipairs(turbine_names) do
        if twt.name == turbine_name then
            local registration_number = script.register_on_object_destroyed(twt)
            storage.wind_turbines[registration_number] = {
                entity = twt,
                name = twt.name,
                position = twt.position,
                surface = twt.surface
            }
            break
        end
    end
end
-- ###############################################################

local function destroy_object(event)
    storage.wind_turbines[event.registration_number] = nil
end
-- ###############################################################

--- called from on_init
local function initializer()
    storage.wind = storage.wind or 0
    storage.wind_turbines = storage.wind_turbines or {}
    storage.wind_speed_on_surface = storage.wind_speed_on_surface or {}
end
-- ###############################################################

local control = {}

control.on_init = initializer

control.events = {
    [defines.events.on_built_entity] = build_entity,
    [defines.events.on_robot_built_entity] = build_entity,
    [defines.events.script_raised_revive]= build_entity,
    [defines.events.on_object_destroyed]= destroy_object,
}

control.on_nth_tick = {
    [120] = businessLogic,
    [6000] = resetWindCount,
}

return control
