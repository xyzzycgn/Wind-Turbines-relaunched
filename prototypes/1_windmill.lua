local sprites = require('sprites')
local surface_conditions = require('surface_conditions')

local extended_collision_area = settings.startup['texugo-wind-extended-collision-area'].value

local function insert_surface_conditions()
	local sc = {
		surface_conditions.pressure(),
		surface_conditions.surface_condition("gravity", 10, 30)
	}

	return sc
end

data:extend({
	-- Item, Recipe and Tech
	{
		type = 'item',
		name = 'texugo-wind-turbine',
		icon = sprites.sprite 'windw_icon.png',
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
		icon = sprites.sprite 'windw_icon.png',
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
	-- World Entities
	{
		type = 'electric-energy-interface',
		name = 'texugo-wind-turbine',
		icon = sprites.sprite 'windw_icon.png',
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
		collision_box = extended_collision_area and {{ -1.4, -2.9 }, { 1.4, 0.9 }} or {{ -1.4, -0.9 }, { 1.4, 0.9 }},
		selection_box = extended_collision_area and {{ -1.5, -3 },   { 1.5, 1   }} or {{ -1.5, -1 },   { 1.5, 1 }},

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
				sprites.stripe('wind1.png', 4, 5),
				sprites.stripe('wind2.png', 4, 5),
				sprites.stripe('wind3.png', 4, 5),
			},
			width = 500,
			height = 350,
			scale = 0.6,
			frame_count = 44,
			shift = {2, -1.2},
			animation_speed = 0.005
		},
		min_perceived_performance = 1.0,
		surface_conditions = surface_conditions.check_existence_of_SPA(insert_surface_conditions),
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
	}
})