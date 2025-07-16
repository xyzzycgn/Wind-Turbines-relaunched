-- wind
-- https://www.geogebra.org/m/GDgua6HK
-- y = sin(3x/2)/3+sin(2x/2+2)/3+sin(3x/2-3)/2-sin(4x/2+1)/3-sin(5x/2+3)/4-sin(6x/2+4)/2+sin(x/3)+2.5

script.on_nth_tick(6000, function(event)
    if storage.wind >= 1800 then
        storage.wind = 0
    end
end)

local powersetting = settings.startup['texugo-wind-power'].value
local use_surface_wind_speed = settings.startup['texugo-wind-use-surface-wind-speed'].value

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

-- collision rectangles
local turbine_map = {
    ['texugo-wind-turbine'] = 'twt-collision-rect',
    ['texugo-wind-turbine2'] = 'twt-collision-rect2',
    ['texugo-wind-turbine3'] = 'twt-collision-rect3',
    ['texugo-wind-turbine4'] = 'twt-collision-rect4',
}

local reverse_map = {
    ['twt-collision-rect'] = 'texugo-wind-turbine',
    ['twt-collision-rect2'] = 'texugo-wind-turbine2',
    ['twt-collision-rect3'] = 'texugo-wind-turbine3',
    ['twt-collision-rect4'] = 'texugo-wind-turbine4',
}

local alpha = 0.2  -- smoothing factor

script.on_nth_tick(120, function(event)
    storage.wind = storage.wind + 0.02
    local x = storage.wind
    -- legacy function
    local y = not use_surface_wind_speed and ((math.sin(3*x/2)/3)+(math.sin(2*x/2+2)/3)+(math.sin(3*x/2-3)/2)-(math.sin(4*x/2+1)/3)-
            (math.sin(5*x/2+3)/4)-(math.sin(6*x/2+4)/2)+math.sin(x/3)+2.5)/4.655 or 0

    local ks = {}

    for _, wind_turbine in pairs(storage.wind_turbines) do
        local wt1 = wind_turbine[1]
        local wt2 = wind_turbine[2]

        if wt1.valid and wt1.type == 'electric-energy-interface' then
            local ql = wt1.quality.level
            local qf
            -- if somebody uses a mod with additional quality levels
            if ql > 4 then
                qf = quality_factor[4] + 0.2 + (ql - 4) / ql
            else
                qf = quality_factor[ql]
            end

            if use_surface_wind_speed then
                local surface = wind_turbine[4]
                local surface_index = surface.index

                -- init for a never used before surface
                if not storage.surface_orientations[surface_index] then
                    storage.surface_orientations[surface_index] = surface.wind_orientation
                end

                -- surface already used in this round?
                if ks[surface_index] then
                    y = ks[surface_index]
                else
                    -- The raw value can jump between 0 and 1 (or vice versa), so smooth it
                    local current_orientation = surface.wind_orientation -- wind_speed seems to be constant 0.2
                    y = alpha * current_orientation + (1 - alpha) * storage.surface_orientations[surface_index]
                    ks[surface_index] = y
                    storage.surface_orientations[surface_index] = y
                end
            end

            wt1.power_production = y * 67500/60 * powersetting * output_modifiers[wt2] * qf
        end
    end
end)

--- called from on_init and on_configuration_changed
local function create_vars()
    storage.wind = storage.wind or 0
    storage.wind_turbines = storage.wind_turbines or {}
    storage.surface_orientations = storage.surface_orientations or {}
end

script.on_init(create_vars)
script.on_configuration_changed(create_vars)

script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_revive}, function(event)
    local entity = event.created_entity or event.entity
    if turbine_map[entity.name] then
        local registration_number = script.register_on_object_destroyed(entity)
        storage.wind_turbines[registration_number] = {entity, entity.name, entity.position, entity.surface}
        local collision_rect = entity.surface.create_entity{name = turbine_map[entity.name], position = entity.position, force = entity.force}
        collision_rect.minable = false
        collision_rect.health = entity.health
    end
end)

script.on_event(defines.events.on_object_destroyed, function(event)
    local entity = storage.wind_turbines[event.registration_number]
    if entity and turbine_map[entity[2]] then
        for _, collision_rect in pairs(entity[4].find_entities_filtered{position = entity[3], name = turbine_map[entity[2]]}) do
            collision_rect.destroy()
        end
    end
    --	table.remove(storage.wind_turbines, event.registration_number)
    storage.wind_turbines[event.registration_number] = nil
end)


-- Damage to the base (can only take impact damage) is transmitted to the turbine (for example, when impacting with a car or tank)
script.on_event(defines.events.on_entity_damaged, function(event)
    local entity = event.entity
    if entity and reverse_map[entity.name] then
        for _, turbine in pairs(entity.surface.find_entities_filtered{position = entity.position, name = reverse_map[entity.name]}) do
            if event.cause then
                turbine.damage(event.original_damage_amount, event.force, event.damage_type.name, event.cause)
            else
                turbine.damage(event.original_damage_amount, event.force, event.damage_type.name)
            end
            -- Keep the two entities damage in sync as long as the turbine hasn't been destroyed
            if turbine and turbine.valid then
                entity.health = turbine.health
            end
        end
    end
end,
        {
            {filter="type", type = "simple-entity-with-owner"},
            {filter="name", name = "twt-collision-rect"},
            {filter="name", name = "twt-collision-rect2"},
            {filter="name", name = "twt-collision-rect3"},
            {filter="name", name = "twt-collision-rect4"}
        }
)