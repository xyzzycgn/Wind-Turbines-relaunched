-- wind
-- https://www.geogebra.org/m/GDgua6HK
-- y = sin(3x/2)/3+sin(2x/2+2)/3+sin(3x/2-3)/2-sin(4x/2+1)/3-sin(5x/2+3)/4-sin(6x/2+4)/2+sin(x/3)+2.5

script.on_nth_tick(6000, function(event)
	if global.wind >= 1800 then
		global.wind = 0
	end
end)

local powersetting = settings.startup['texugo-wind-power'].value
local output_modifiers = {
	['texugo-wind-turbine'] = 1,
	['texugo-wind-turbine2'] = 10,
	['texugo-wind-turbine3'] = 100,
	['texugo-wind-turbine4'] = 1000,
}

script.on_nth_tick(120, function(event)
	global.wind = global.wind + 0.02
	local x = global.wind
	local y = ((math.sin(3*x/2)/3)+(math.sin(2*x/2+2)/3)+(math.sin(3*x/2-3)/2)-(math.sin(4*x/2+1)/3)-
	(math.sin(5*x/2+3)/4)-(math.sin(6*x/2+4)/2)+math.sin(x/3)+2.5)/4.655

	for _, wind_turbine in pairs(global.wind_turbines) do
		if wind_turbine[1].valid and wind_turbine[1].type == 'electric-energy-interface' then
			wind_turbine[1].power_production = y * 67500/60 * powersetting * output_modifiers[wind_turbine[2]]
		end
	end
end)

local function create_vars()
	global.wind = global.wind or 0
	global.wind_turbines = global.wind_turbines or {}
end

script.on_init(create_vars)
script.on_configuration_changed(create_vars)

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

script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_revive}, function(event)
	local entity = event.created_entity or event.entity
    if turbine_map[entity.name] then
		local registration_number = script.register_on_entity_destroyed(entity)
        global.wind_turbines[registration_number] = {entity, entity.name, entity.position, entity.surface}
		local collision_rect = entity.surface.create_entity{name = turbine_map[entity.name], position = entity.position, force = entity.force}
		collision_rect.minable = false
		collision_rect.health = entity.health
    end
end)

script.on_event(defines.events.on_entity_destroyed, function(event)
	local entity = global.wind_turbines[event.registration_number]
	if entity and turbine_map[entity[2]] then
		for _, collision_rect in pairs(entity[4].find_entities_filtered{position = entity[3], name = turbine_map[entity[2]]}) do
			collision_rect.destroy()
		end
	end
--	table.remove(global.wind_turbines, event.registration_number)
	global.wind_turbines[event.registration_number] = nil
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