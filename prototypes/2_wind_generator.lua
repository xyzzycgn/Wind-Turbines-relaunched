data:extend({
	-- World Entities
	{
		type = 'electric-energy-interface',
		name = 'texugo-wind-turbine2',
		icon = '__Wind_Generator-gfxrestyle__/graphics/winds_icon.png',
		icon_size = 32,
		flags = {"player-creation","placeable-neutral", "not-rotatable"},
		minable = {mining_time = 0.3, result = 'texugo-wind-turbine2'},
		max_health = 300,
		corpse = 'medium-remnants',
		dying_explosion = 'medium-explosion',
		resistances = {
			{type = 'fire', percent = 30},
			{type = 'physical', percent = 20, decrease = 1},
			{type = 'impact', percent = 30, decrease = 4}
		},
		fast_replaceable_group = 'texugo-wind-turbine2',
		collision_mask = { layers = { item = true, object = true, water_tile = true } },
		collision_box = {{-1.9, -4.9}, {1.9, 0.9}},
		selection_box = {{-2, -5}, {2, 1}},

		energy_source = {
			type = 'electric',
			render_no_power_icon = false,
			usage_priority = 'primary-output',
			buffer_capacity = tostring(settings.startup['texugo-wind-power'].value * 100)..'kJ',
			input_flow_limit = '0W',
			output_flow_limit = tostring(settings.startup['texugo-wind-power'].value * 675)..'kW',
		},
		energy_production = tostring(settings.startup['texugo-wind-power'].value * 675)..'kW',
		gui_mode = 'none',
		continuous_animation = false,
		animation = {
			stripes = {
				{
					filename = '__Wind_Generator-gfxrestyle__/graphics/winds1.png',
					width_in_frames = 3,
					height_in_frames = 4
				},
				{
					filename = '__Wind_Generator-gfxrestyle__/graphics/winds2.png',
					width_in_frames = 3,
					height_in_frames = 4
				},
				{
					filename = '__Wind_Generator-gfxrestyle__/graphics/winds3.png',
					width_in_frames = 3,
					height_in_frames = 4
				},
				{
					filename = '__Wind_Generator-gfxrestyle__/graphics/winds4.png',
					width_in_frames = 3,
					height_in_frames = 4
				}
			},
			width = 650,
			height = 500,
			scale = 0.5,
			animation_speed = 0.0007,
			frame_count = 44,
			shift = {2.5, -1.6},
		},
		min_perceived_performance = 1.0
	},
	{
		type = 'simple-entity-with-owner',
		name = 'twt-collision-rect2',
		flags = {'not-deconstructable', 'not-on-map', 'placeable-off-grid', 'not-repairable', 'not-blueprintable'},
		selectable_in_game = false,
		collision_box = {{-1, -1.4}, {1.8, 0.9}},
		picture = {
			filename = "__core__/graphics/empty.png",
			size = 1
		},
		max_health = 300,
		resistances = {
			{type = 'impact', percent = 30, decrease = 4}
		}
	},
	-- Item, Recipe and Tech
	{
		type = 'item',
		name = 'texugo-wind-turbine2',
		icon = sprite 'winds_icon.png',
		icon_size = 32,
		group = 'logistics',
		subgroup = 'energy',
		order = 'b[steam-power]-c[texugo-wind-turbine]',
		place_result = 'texugo-wind-turbine2',
		stack_size = 20
	},
	{
		type = 'recipe',
		name = 'texugo-wind-turbine2',
		icon = sprite 'winds_icon.png',
		icon_size = 32,
		normal = {
			enabled = false,
			energy_required = 15,
			ingredients = {
				{'advanced-circuit', 5},
				{'engine-unit', 10},
				{'medium-electric-pole', 5},
				{'stone-wall', 5}
			},
			result = 'texugo-wind-turbine2'
		},
		expensive = {
			enabled = false,
			energy_required = 25,
			ingredients = {
				{'advanced-circuit', 8},
				{'engine-unit', 20},
				{'medium-electric-pole', 5},
				{'stone-wall', 20}
			},
			result = 'texugo-wind-turbine2'
		}
	},
	{
		type = 'technology',
		name = 'texugo-wind-turbine2',
		icon = '__Wind_Generator-gfxrestyle__/graphics/winds_tec.png',
		icon_size = 128,
		prerequisites = {"electric-energy-distribution-1", "advanced-circuit", "stone-wall"},
		effects = {
			{
				type = 'unlock-recipe',
				recipe = 'texugo-wind-turbine2'
			}
		},
		unit = {
			count = 150,
			ingredients = {
				{'automation-science-pack', 1},
				{'logistic-science-pack', 1}
			},
			time = 30
		}
	}
})
