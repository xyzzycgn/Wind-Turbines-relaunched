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

-- integration into krastorio2 / Krastorio2 Spaced Out
if mods['Krastorio2'] or mods['Krastorio2-spaced-out'] then
    local twt = data.raw.recipe['texugo-wind-turbine']
    for _, ingredient in pairs(twt.ingredients or {}) do
        if ingredient.name == "electronic-circuit" then
            ingredient.name = "kr-automation-core"
            ingredient.amount = math.ceil(ingredient.amount / 2)
            break
        end
    end
end
