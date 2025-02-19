-- Allow disabling the Titanic wind turbine (by not including it at all) for very low-end computers where the large graphics might cause problems
if settings.startup["texugo-wind-turbine4"].value then
data:extend({
	-- World Entities
    {
        type = 'electric-energy-interface',
        name = 'texugo-wind-turbine4',
        icon = sprite 'titanicicon.png',
        icon_size = 64,
        flags = {"player-creation", "placeable-neutral", "not-rotatable", "not-flammable"},
        minable = {mining_time = 3, result = 'texugo-wind-turbine4'},
        corpse = 'rocket-silo-remnants',
        dying_explosion = 'massive-explosion',
        max_health = 5000,
		resistances = {
			{type = 'fire', percent = 100},
			{type = 'acid', percent = 25, decrease = 5},
			{type = 'physical', percent = 50, decrease = 10},
			{type = 'impact', percent = 60, decrease = 30}
		},
        fast_replaceable_group = 'texugo-wind-turbine4',
        collision_mask = { layers = { item = true, object = true, water_tile = true } },
        collision_box = {{-5.9, -13.9}, {5.9, 3.9}},
        selection_box = {{-6, -14}, {6, 4}},

		energy_source = {
			type = 'electric',
			render_no_power_icon = false,
			usage_priority = 'primary-output',
			buffer_capacity = tostring(settings.startup['texugo-wind-power'].value * 10)..'MJ',
			input_flow_limit = '0W',
			output_flow_limit = tostring(settings.startup['texugo-wind-power'].value * 67500)..'kW',
		},
		energy_production = tostring(settings.startup['texugo-wind-power'].value * 67500)..'kW',
		gui_mode = 'none',
		continuous_animation = false,
        animation = {
			stripes = {
				{
					filename = sprite 'titanic-lr/tlr_0104.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_0508.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_0912.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_1316.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_1720.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_2124.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_2528.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_2932.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_3336.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_3740.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_4144.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_4548.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_4952.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_5356.png',
					width_in_frames = 2, height_in_frames = 2
				},
				{
					filename = sprite 'titanic-lr/tlr_5760.png',
					width_in_frames = 2, height_in_frames = 2
				}
			},
			width = 750,
			height = 562,
			scale = 1.88,
			animation_speed = 1.1*0.000001,
			frame_count = 60,
			shift = {10, -7.1},
			hr_version = {
				stripes = {
					{
						filename = sprite 'titanic-hr/titanic01.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic02.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic03.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic04.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic05.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic06.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic07.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic08.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic09.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic10.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic11.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic12.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic13.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic14.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic15.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic16.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic17.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic18.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic19.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic20.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic21.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic22.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic23.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic24.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic25.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic26.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic27.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic28.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic29.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic30.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic31.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic32.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic33.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic34.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic35.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic36.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic37.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic38.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic39.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic40.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic41.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic42.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic43.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic44.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic45.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic46.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic47.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic48.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic49.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic50.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic51.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic52.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic53.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic54.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic55.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic56.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic57.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic58.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic59.png',
						width_in_frames = 1, height_in_frames = 1
					},
					{
						filename = sprite 'titanic-hr/titanic60.png',
						width_in_frames = 1, height_in_frames = 1
					}
				},
				width = 1500,
				height = 1125,
				frame_count = 60,
				animation_speed = 1.1*0.000001,
				scale = 0.94,
				shift = {10, -7.1}
			}
        },
        min_perceived_performance = 1
    },
    {
		type = 'simple-entity-with-owner',
		name = 'twt-collision-rect4',
		flags = {'not-deconstructable', 'not-on-map', 'placeable-off-grid', 'not-repairable', 'not-blueprintable'},
		selectable_in_game = false,
		collision_box = {{-4, -2.3}, {4, 3.9}},
		picture = {
			filename = "__core__/graphics/empty.png",
			size = 1
		},
        max_health = 5000,
		resistances = {
			{type = 'impact', percent = 60, decrease = 30}
		}
	},
	-- Item, Recipe and Tech
	{
		type = "item",
		name = "texugo-wind-turbine4",
		icon = sprite "titanicicon.png",
		icon_size = 64,
		group = "logistics",
		subgroup = "energy",
		order = "b[steam-power]-c[texugo-wind-turbine]",
		place_result = "texugo-wind-turbine4",
		stack_size = 1
	},
	{
		type = 'recipe',
		name = 'texugo-wind-turbine4',
		icon = sprite "titanicicon.png",
		icon_size = 64,
		enabled = false,
		energy = 240,
		ingredients = {
			{ type = "item", name = 'low-density-structure',   amount = 400},
			{ type = "item", name = 'processing-unit',         amount = 50},
			{ type = "item", name = 'speed-module',            amount = 50},
			{ type = "item", name = 'heat-pipe',        	   amount = 50},
			{ type = "item", name = 'steam-turbine',    	   amount = 10},
			{ type = "item", name = 'steel-plate',      	   amount = 2000},
			{ type = "item", name = 'refined-concrete', 	   amount = 1000}
		},
		results = {{ type = "item", name = 'texugo-wind-turbine4', amount = 1 }},
	},
	{
		type = "technology",
		name = "texugo-wind-turbine4",
		icon = "__Wind_Generator-gfxrestyle__/graphics/titanictech.png",
		icon_size = 128,
		--prerequisites = {"rocket-control-unit",  "nuclear-power", "texugo-wind-turbine3"},
		prerequisites = { "nuclear-power", "texugo-wind-turbine3"},
		effects = {
			{
				type = "unlock-recipe",
				recipe = "texugo-wind-turbine4"
			}
		},
		unit = {
			count = 2000,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"utility-science-pack", 1}
			},
			time = 120
		}
	}
})
end