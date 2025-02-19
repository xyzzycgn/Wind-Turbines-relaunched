local sprites = require('sprites')

data:extend({
	-- World Entities
	{
		type = 'electric-energy-interface',
		name = 'texugo-wind-turbine3',
		icon = sprites.sprite 'windh_icon.png',
		icon_size = 32,
		flags = {"player-creation","placeable-neutral", "not-rotatable"},
		minable = {mining_time = 1, result = 'texugo-wind-turbine3'},
		max_health = 1200,
		resistances = {
			{type = 'fire', percent = 70, decrease = 5},
			{type = 'physical', percent = 30, decrease = 3},
			{type = 'impact', percent = 45, decrease = 10}
		},
		corpse = 'big-remnants',
		dying_explosion = 'big-explosion',
		fast_replaceable_group = 'texugo-wind-turbine3',
		collision_mask = { layers = { item = true, object = true, water_tile = true } },
		collision_box = {{-2.9, -7.4}, {2.9, 1.4}},
		selection_box = {{-3, -7.5}, {3, 1.5}},
		energy_source = {
			type = 'electric',
			render_no_power_icon = false,
			usage_priority = 'primary-output',
			buffer_capacity = tostring(settings.startup['texugo-wind-power'].value * 1000)..'kJ',
			input_flow_limit = '0W',
			output_flow_limit = tostring(settings.startup['texugo-wind-power'].value * 6750)..'kW',
		},
		energy_production = tostring(settings.startup['texugo-wind-power'].value * 6750)..'kW',
		gui_mode = 'none',
		continuous_animation = false,
		animation = {
			stripes = {
				sprites.stripe('windh1.png', 2, 3),
				sprites.stripe('windh2.png', 2, 3),
				sprites.stripe('windh3.png', 2, 3),
				sprites.stripe('windh4.png', 2, 3),
				sprites.stripe('windh5.png', 2, 3),
				sprites.stripe('windh6.png', 2, 3),
				sprites.stripe('windh7.png', 2, 3),
				sprites.stripe('windh8.png', 2, 3),
			},
			width = 800,
			height = 550,
			scale = 1.1,
			frame_count = 44,
			shift = {4.8, -4.1},
			animation_speed = 0.000015,
			priority = "low"
		},
		min_perceived_performance = 1.0
	},
	{
		type = 'simple-entity-with-owner',
		name = 'twt-collision-rect3',
		flags = {'not-deconstructable', 'not-on-map', 'placeable-off-grid', 'not-repairable', 'not-blueprintable', 'not-selectable-in-game', 'not-in-kill-statistics'},
		collision_box = {{-1.9, -1.2}, {1.9, 1.4}},
		picture = {
			filename = "__core__/graphics/empty.png",
			size = 1
		},
		max_health = 1200,
		resistances = {
			{type = 'impact', percent = 45, decrease = 10}
		}
	},
	-- Item, Recipe and Tech
	{
		type = 'item',
		name = 'texugo-wind-turbine3',
		icon = sprites.sprite 'windh_icon.png',
		icon_size = 32,
		group = 'logistics',
		subgroup = 'energy',
		order = 'b[steam-power]-c[texugo-wind-turbine]',
		place_result = 'texugo-wind-turbine3',
		stack_size = 4
	},
	{
		type = 'recipe',
		name = 'texugo-wind-turbine3',
		icon = sprites.sprite 'windh_icon.png',
		icon_size = 32,
		enabled = false,
		energy = 60,
		ingredients = {
			{ type = "item", name = 'processing-unit',      amount = 15},
			{ type = "item", name = 'electric-engine-unit', amount = 40},
			{ type = "item", name = 'steel-plate', 			amount = 200},
			{ type = "item", name = 'plastic-bar', 			amount = 300},
			{ type = "item", name = 'concrete',    			amount = 400}
		},
		results = {{ type = "item", name = 'texugo-wind-turbine3', amount = 1 }},
	},
	{
		type = 'technology',
		name = 'texugo-wind-turbine3',
		icon = sprites.sprite 'windh_tec.png',
		icon_size = 128,
		prerequisites = {"electric-engine", "processing-unit", "concrete", "texugo-wind-turbine2"},
		effects = {
			{
				type = 'unlock-recipe',
				recipe = 'texugo-wind-turbine3'
			}
		},
		unit = {
			count = 500,
			ingredients = {
				{'automation-science-pack', 1},
				{'logistic-science-pack', 1},
				{'chemical-science-pack', 1}
			},
			time = 60
		}
	}
})