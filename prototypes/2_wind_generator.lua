local sprites = require('sprites')
local surface_conditions = require('surface_conditions')

local extended_collision_area = settings.startup['texugo-extended-collision-area'].value

local function insert_surface_conditions()
    local sc = {
        surface_conditions.pressure(),
    }

    return sc
end

data:extend({
	-- Item, Recipe and Tech
	{
		type = 'item',
		name = 'texugo-wind-turbine2',
		icon = sprites.sprite 'winds_icon.png',
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
		icon = sprites.sprite 'winds_icon.png',
		icon_size = 32,
		enabled = false,
		energy = 15,
		ingredients = {
			{ type = "item", name = 'advanced-circuit',     amount = 5},
			{ type = "item", name = 'engine-unit',          amount = 10},
			{ type = "item", name = 'medium-electric-pole', amount = 5},
			{ type = "item", name = 'stone-wall',           amount = 5}
		},
		results = {{ type = "item", name = 'texugo-wind-turbine2', amount = 1 }},
	},
	{
		type = 'technology',
		name = 'texugo-wind-turbine2',
		icon = sprites.sprite 'winds_tec.png',
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
	},
	-- World Entities
	{
		type = 'electric-energy-interface',
		name = 'texugo-wind-turbine2',
		icon = sprites.sprite 'winds_icon.png',
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
        collision_box = extended_collision_area and {{ -1.9, -4.9 }, { 1.9, 0.9 }} or {{ -1.9, -0.9 }, { 1.9, 0.9 }},
        selection_box = extended_collision_area and {{  -2,    -5 }, {  2,    1 }} or {{  -2,    -1 }, {  2,    1 }},

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
				sprites.stripe('winds1.png', 3, 4),
				sprites.stripe('winds2.png', 3, 4),
				sprites.stripe('winds3.png', 3, 4),
				sprites.stripe('winds4.png', 3, 4),
			},
			width = 650,
			height = 500,
			scale = 0.5,
			animation_speed = 0.0007,
			frame_count = 44,
			shift = {2.5, -1.6},
		},
		min_perceived_performance = 1.0,
		surface_conditions = surface_conditions.check_existence_of_SPA(insert_surface_conditions),
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
    }
})
