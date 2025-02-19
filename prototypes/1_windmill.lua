data:extend({
	-- Item, Recipe and Tech
	{
		type = 'item',
		name = 'texugo-wind-turbine',
		icon = sprite 'windw_icon.png',
		icon_size = 32,
		group = 'logistics',
		subgroup = 'energy',
		order = 'b[steam-power]-c[texugo-wind-turbine]',
		place_result = 'texugo-wind-turbine',
		stack_size = 50
	},
	-- The Windmill requires no research and is automatically enabled from game start
	{
		type = 'recipe',
		name = 'texugo-wind-turbine',
		icon = sprite 'windw_icon.png',
		icon_size = 32,
		enabled = true,
		energy = 4,
		ingredients = {
			{ type = "item", name = 'iron-gear-wheel',     amount = 5 },
			{ type = "item", name = 'electronic-circuit',  amount = 2 },
			{ type = "item", name = 'small-electric-pole', amount = 8 }
		},
		results = {{ type = "item", name = 'texugo-wind-turbine', amount = 1 }},
	},
})

data:extend({
	-- World Entities
	{
		type = 'electric-energy-interface',
		name = 'texugo-wind-turbine',
		icon = sprite 'windw_icon.png',
		icon_size = 32,
		flags = {"player-creation","placeable-neutral", "not-rotatable"},
		minable = {mining_time = 0.1, result = 'texugo-wind-turbine'},
		max_health = 100,
		corpse = 'medium-small-remnants',
		dying_explosion = 'explosion',
		resistances = {
			{type = 'physical', percent = 10},
			{type = 'impact', percent = 15}
		},
		fast_replaceable_group = 'texugo-wind-turbine',
		collision_mask = { layers = { item = true, object = true, water_tile = true } },
		collision_box = {{-1.4, -2.9}, {1.4, 0.9}},
		selection_box = {{-1.5, -3}, {1.5, 1}},

		energy_source = {
			type = 'electric',
			render_no_power_icon = false,
			usage_priority = 'primary-output',
			buffer_capacity = tostring(settings.startup['texugo-wind-power'].value * 10)..'kJ',
			input_flow_limit = '0W',
			output_flow_limit = tostring(settings.startup['texugo-wind-power'].value * 67.5)..'kW',
		},
		energy_production = tostring(settings.startup['texugo-wind-power'].value * 67.5)..'kW',
		--		gui_mode = 'none',
		continuous_animation = false,
		animation = {
			stripes = {
				{
					filename = sprite 'wind1.png',
					width_in_frames = 4,
					height_in_frames = 5
				},
				{
					filename = sprite 'wind2.png',
					width_in_frames = 4,
					height_in_frames = 5
				},
				{
					filename = sprite 'wind3.png',
					width_in_frames = 4,
					height_in_frames = 5
				}
			},
			width = 500,
			height = 350,
			scale = 0.6,
			frame_count = 44,
			shift = {2, -1.2},
			animation_speed = 0.005
		},
		min_perceived_performance = 1.0
	},
	{
		type = 'simple-entity-with-owner',
		name = 'twt-collision-rect',
		flags = {'not-deconstructable', 'not-on-map', 'placeable-off-grid', 'not-repairable', 'not-blueprintable'},
		selectable_in_game = false,
		collision_box = {{-1, -0.7}, {1, 0.9}},
		picture = {
			filename = "__core__/graphics/empty.png",
			size = 1
		},
		max_health = 100,
		resistances = {
			{type = 'impact', percent = 15}
		}
	},
})