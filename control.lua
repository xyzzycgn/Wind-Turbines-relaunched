-- wind
-- https://www.geogebra.org/m/GDgua6HK
-- y = sin(3x/2)/3+sin(2x/2+2)/3+sin(3x/2-3)/2-sin(4x/2+1)/3-sin(5x/2+3)/4-sin(6x/2+4)/2+sin(x/3)+2.5

local handle_settings = require("scripts/handle_settings")

script.on_nth_tick(6000, function(event)
    if storage.wind >= 1800 then
        storage.wind = 0
    end
end)

local powersetting = handle_settings.WindPower()
local use_extended_collision_area = handle_settings.useExtendedCollisionArea()
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

    local knownSurface = {}
    local nauvis = storage.pressures['nauvis']

    for _, wind_turbine in pairs(storage.wind_turbines) do
        local entity = wind_turbine[1]
        local name = wind_turbine[2]

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
                local surface = wind_turbine[4]
                local surface_index = surface.index
                local surface_name = surface.name

                -- init for a never used before surface
                if not storage.wind_speed_on_surface[surface_index] then
                    storage.wind_speed_on_surface[surface_index] = surface.wind_orientation
                end

                -- surface already used in this round?
                if knownSurface[surface_index] then
                    y = knownSurface[surface_index].y
                    pf = knownSurface[surface_index].pf
                else
                    -- wind_speed seems to be constant 0.2 - that's why we use the orientation as replacement ;-)
                    local current = surface.wind_orientation
                    -- The raw value can jump between 0 and 1 (or vice versa), so smooth it
                    y = alpha * current + (1 - alpha) * storage.wind_speed_on_surface[surface_index]
                    storage.wind_speed_on_surface[surface_index] = y

                    if wind_scale_with_pressure then
                        -- scale with pressure on planet
                        pf = storage.pressures[surface_name] / nauvis
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
end)
-- ###############################################################

--- check after switching use_extended_collision_area on
local function check_collisions()
    for _, wind_turbine in pairs(storage.wind_turbines) do
        local entity = wind_turbine[1]
        local name = wind_turbine[2]
        local position= wind_turbine[3]
        local surface = wind_turbine[4]
        local cb = entity.prototype.collision_box
        local cm = entity.prototype.collision_mask.layers
        local area = {{ position.x + cb.left_top.x, position.y + cb.left_top.y },
                      { position.x + cb.right_bottom.x, position.y + cb.right_bottom.y }}

        -- ignore ore, ...
        local inside = surface.find_entities_filtered( { area = area, collision_mask = cm })

        if table_size(inside) > 2 then
            -- if colliding, spill it at the former position
            local quality = entity.quality.name
            local force = entity.force
            -- create alert
            for _, player in pairs(force.players) do
                player.add_custom_alert(entity,
                                        { type = 'entity', name = name, quality = quality, },
                                        { "alerts.texugo-wind-extended-collision-area" },
                                        true)
            end

            entity.destroy()
            surface.spill_item_stack({ position = position,
                                       stack = { name = name, count = 1, quality = quality },
                                       max_radius = 1, })
        end
    end
end

--- check after switching use_extended_collision_area off
local function check_connectivity()
    for _, wind_turbine in pairs(storage.wind_turbines) do
        local entity = wind_turbine[1]
        local name = wind_turbine[2]
        local position= wind_turbine[3]
        local surface = wind_turbine[4]

        if not (entity.is_connected_to_electric_network() or surface.has_global_electric_network) then
            local quality = entity.quality.name
            local force = entity.force
            -- create alert
            for _, player in pairs(force.players) do
                player.add_custom_alert(entity,
                                        { type = 'entity', name = name, quality = quality, },
                                        { "alerts.texugo-wind-not-connected" },
                                        true)
            end
        end
    end
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

local function updatePressures()
    local pressures = {}
    for k, v in pairs(prototypes.space_location) do
        if v.type == "planet" then
            pressures[k] = v.surface_properties and v.surface_properties.pressure or 1000 -- if no pressure set, assume default (from nauvis)
        end
    end

    log(serpent.block(pressures))
    storage.pressures =  pressures
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--- called from on_init and on_configuration_changed
local function create_vars()
    storage.wind = storage.wind or 0
    storage.wind_turbines = storage.wind_turbines or {}
    storage.wind_speed_on_surface = storage.wind_speed_on_surface or {}

    if storage.old_extended_collision_area == nil then
        log("no old_extended_collision_area present")
        --- in prior versions all turbine always had an extended collision_area
        storage.old_extended_collision_area = true
    end

    if use_extended_collision_area ~= storage.old_extended_collision_area then
        log("use_extended_collision_area has changed")
        -- check existing wind turbines
        if use_extended_collision_area then
            check_collisions()
        else
            check_connectivity()
        end

        storage.old_extended_collision_area = use_extended_collision_area
    end

    updatePressures()
end
-- ###############################################################

script.on_init(create_vars)
script.on_configuration_changed(create_vars)
script.on_event({ defines.events.on_surface_created, defines.events.on_surface_deleted }, updatePressures)

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