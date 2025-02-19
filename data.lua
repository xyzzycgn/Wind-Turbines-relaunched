require 'prototypes.1_windmill'
require 'prototypes.2_wind_generator'
require 'prototypes.3_wind_turbine'
require 'prototypes.4_titanic_turbine'

if mods['bobelectronics'] then
    bobmods.lib.recipe.replace_ingredient('texugo-wind-turbine', 'electronic-circuit', 'basic-circuit-board')
    bobmods.lib.recipe.replace_ingredient('texugo-wind-turbine2', 'advanced-circuit', 'electronic-circuit-board')
    bobmods.lib.recipe.replace_ingredient('texugo-wind-turbine3', 'processing-unit', 'electronic-logic-board')
    bobmods.lib.recipe.replace_ingredient('texugo-wind-turbine4', 'rocket-control-unit', 'electronic-processing-board')
end