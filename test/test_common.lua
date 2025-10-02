
--- Test für prototypes/common.lua
---
require('test.BaseTest')
local lu = require('lib.luaunit')

-- mocks for factorio APIs
settings = {
    startup = {
        ["texugo-wind-expensive-recipes"] = { value = false },
    }
}

-- mocks for handle_settings module
local mock_handle_settings = {
    constructionMoreExpensive = function()
        return settings.startup["texugo-wind-expensive-recipes"].value
    end
}

-- replace with mock
local original_require = require
require = function(module_name)
    if module_name == "scripts/handle_settings" then
        return mock_handle_settings
    else
        return original_require(module_name)
    end
end

local common = require('prototypes.common')

TestCommon = {}

function TestCommon:setUp()
    -- reset settings for each test
    settings.startup["texugo-wind-expensive-recipes"].value = false
end
-- ###############################################################

function TestCommon:testModuleExports()
    lu.assertNotNil(common)
    lu.assertEquals(type(common), "table")
    lu.assertNotNil(common.make_recipe)
    lu.assertEquals(type(common.make_recipe), "function")
end
-- ###############################################################

function TestCommon:testMakeRecipeCheap()
    local base_recipe = {
        name = "test-recipe",
        type = "recipe"
    }

    local cheap_config = {
        energy = 5,
        ingredients = {
            { "iron-plate", 2 },
            { "copper-plate", 1 }
        }
    }

    local expensive_config = {
        energy = 10,
        ingredients = {
            { "iron-plate", 5 },
            { "copper-plate", 3 },
            { "steel-plate", 1 }
        }
    }

    settings.startup["texugo-wind-expensive-recipes"].value = false

    local result = common.make_recipe(base_recipe, cheap_config, expensive_config)

    lu.assertEquals(result.energy, 5)
    lu.assertEquals(#result.ingredients, 2)
    lu.assertEquals(result.ingredients[1].name, "iron-plate")
    lu.assertEquals(result.ingredients[1].amount, 2)
    lu.assertEquals(result.ingredients[1].type, "item")
    lu.assertEquals(result.ingredients[2].name, "copper-plate")
    lu.assertEquals(result.ingredients[2].amount, 1)
    lu.assertEquals(result.ingredients[2].type, "item")
end
-- ###############################################################

function TestCommon:testMakeRecipeExpensive()
    local base_recipe = {
        name = "test-recipe",
        type = "recipe"
    }

    local cheap_config = {
        energy = 5,
        ingredients = {
            { "iron-plate", 2 },
            { "copper-plate", 1 },
        }
    }

    local expensive_config = {
        energy = 10,
        ingredients = {
            { "iron-plate", 5 },
            { "copper-plate", 3 },
            { "steel-plate", 1 },
        }
    }

    settings.startup["texugo-wind-expensive-recipes"].value = true

    local result = common.make_recipe(base_recipe, cheap_config, expensive_config)

    lu.assertEquals(result.energy, 10)
    lu.assertEquals(#result.ingredients, 3)

    -- check  ingredients
    local ingredients_by_name = {}
    for _, ingredient in ipairs(result.ingredients) do
        ingredients_by_name[ingredient.name] = ingredient
    end

    lu.assertEquals(ingredients_by_name["iron-plate"].amount, 5)
    lu.assertEquals(ingredients_by_name["iron-plate"].type, "item")
    lu.assertEquals(ingredients_by_name["copper-plate"].amount, 3)
    lu.assertEquals(ingredients_by_name["copper-plate"].type, "item")
    lu.assertEquals(ingredients_by_name["steel-plate"].amount, 1)
    lu.assertEquals(ingredients_by_name["steel-plate"].type, "item")
end
-- ###############################################################

function TestCommon:testMakeRecipeModifiesBaseRecipe()
    local base_recipe = {
        name = "test-recipe",
        type = "recipe",
        existing_field = "should_remain"
    }

    local cheap_config = {
        energy = 15,
        ingredients = {
            { "wood", 10 },
        }
    }

    local expensive_config = {
        energy = 30,
        ingredients = {
            { "wood", 20 },
        }
    }

    settings.startup["texugo-wind-expensive-recipes"].value = false

    local result = common.make_recipe(base_recipe, cheap_config, expensive_config)

    -- check original fields
    lu.assertEquals(result.name, "test-recipe")
    lu.assertEquals(result.type, "recipe")
    lu.assertEquals(result.existing_field, "should_remain")

    -- check new fields
    lu.assertEquals(result.energy, 15)
    lu.assertNotNil(result.ingredients)

    -- check equality of returned object and base_recipe
    lu.assertEquals(result, base_recipe)
end
-- ###############################################################

function TestCommon:testMakeRecipeEmptyIngredients()
    local base_recipe = {
        name = "empty-recipe",
        type = "recipe"
    }

    local config = {
        energy = 1,
        ingredients = {}
    }

    local result = common.make_recipe(base_recipe, config, config)

    lu.assertEquals(result.energy, 1)
    lu.assertEquals(#result.ingredients, 0)
end
-- ###############################################################

function TestCommon:testMakeRecipeSingleIngredient()
    local base_recipe = {
        name = "single-ingredient-recipe",
        type = "recipe"
    }

    local config = {
        energy = 2,
        ingredients = {
            { "electronic-circuit", 3 },
        }
    }

    local result = common.make_recipe(base_recipe, config, config)

    lu.assertEquals(result.energy, 2)
    lu.assertEquals(#result.ingredients, 1)
    lu.assertEquals(result.ingredients[1].name, "electronic-circuit")
    lu.assertEquals(result.ingredients[1].amount, 3)
    lu.assertEquals(result.ingredients[1].type, "item")
end
-- ###############################################################

BaseTest:hookTests()
