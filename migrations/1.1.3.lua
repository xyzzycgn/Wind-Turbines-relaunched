global.wind_turbines = global.wind_turbines or {}

local turbine_map = {
	['texugo-wind-turbine'] = 'twt-collision-rect',
	['texugo-wind-turbine2'] = 'twt-collision-rect2',
	['texugo-wind-turbine3'] = 'twt-collision-rect3',
	['texugo-wind-turbine4'] = 'twt-collision-rect4',
}

for _, surface in pairs(game.surfaces) do
	for _, entity in pairs(surface.find_entities_filtered{
		name = {"twt-electric-pole", "twt-electric-pole2", "twt-electric-pole3", "twt-electric-pole4"}
	}) do
		entity.destroy()
	end
	
	for _, entity in pairs(surface.find_entities_filtered{
		name = {"texugo-wind-turbine", "texugo-wind-turbine2", "texugo-wind-turbine3", "texugo-wind-turbine4"}
	}) do
		local registration_number = script.register_on_entity_destroyed(entity)
		global.wind_turbines[registration_number] = {entity, entity.name, entity.position, entity.surface}
		
		local collision_rect = entity.surface.create_entity{name = turbine_map[entity.name], position = entity.position, force = entity.force}
		collision_rect.minable = false
		collision_rect.destructible = true
	end
end