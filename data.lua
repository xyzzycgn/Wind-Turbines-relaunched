-- The base game hides the "Toggle visibility of tall entities" shortcut
-- unless something (normally Elevated Rails) unhides it. Our turbines are
-- tall, so unhide it ourselves.
data.raw["shortcut"]["toggle-tall-entity-visibility"].hidden = false

require 'prototypes.1_windmill'
require 'prototypes.2_wind_generator'
require 'prototypes.3_wind_turbine'
require 'prototypes.4_titanic_turbine'

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
