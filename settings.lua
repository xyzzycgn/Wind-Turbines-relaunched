data:extend{
	{
		type = 'int-setting',
		name = 'texugo-wind-power',
		setting_type = 'startup',
		default_value = 1,
		maximum_value = 10,
		minimum_value = 1,
		order = 'a',
	},
	{
		type = 'bool-setting',
		name = 'texugo-wind-turbine4',
		setting_type = 'startup',
		default_value = true,
		order = 'b',
	},
	{
		type = "string-setting",
		name = "texugo-wind-mode",
		order = "c",
		setting_type = "startup",
		default_value = "SURFACE+PRESSURE",
		allowed_values = {
			"CLASSICAL",
			"SURFACE",
			"SURFACE+PRESSURE",
		}
	},
	{
		type = 'bool-setting',
		name = 'texugo-wind-extended-collision-area',
		setting_type = 'startup',
		default_value = false,
		order = 'd',
	},
}