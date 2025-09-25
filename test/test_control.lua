--- Test for scripts/control.lua
---
require('test.BaseTest')
local lu = require('lib.luaunit')


-- Mocks for Factorio APIs
storage = {}

settings = {
    startup = {
        ["texugo-wind-power"] = { value = 1 },
        ["texugo-wind-extended-collision-area"] = { value = false },
        ["texugo-wind-mode"] = { value = "CLASSICAL" },
    }
}


script = {
    on_event_registered = {},
    on_event = function(type, func)
        script.on_event_registered[type] = func
    end
}

log = function(msg) end

serpent = {
    block = function(data)
        return tostring(data)
    end
}

defines = {
    events = {
        on_built_entity = 100,
        on_robot_built_entity = 101,
        script_raised_revive = 102,
        on_object_destroyed = 103,
        on_entity_damaged = 104,
        on_surface_created = 105,
        on_surface_deleted = 106
    }
}

local control = require('scripts.control')

TestControl = {}

local function mock_turbine(entity, name, position, surface)
    return {
        entity = entity,
        name = name,
        position = position,
        surface = surface
    }
end

function TestControl:setUp()
    prototypes = {
        space_location = {
            nauvis = { type = "planet", surface_properties = { pressure = 1000 } },
            vulcanus = { type = "planet", surface_properties = { pressure = 4000 } },
            fulgora = { type = "planet", surface_properties = { pressure = 800 } }
        }
    }

    storage.wind_turbines = {}
    storage.wind = 0
end
-- ###############################################################

function TestControl:testModuleExports()
    lu.assertNotNil(control)
    lu.assertEquals(type(control), "table")
    lu.assertNotNil(control.on_init)
    lu.assertNotNil(control.on_load)
    lu.assertNotNil(control.on_configuration_changed)
    lu.assertNotNil(control.on_nth_tick)
    lu.assertEquals(table_size(control.on_nth_tick), 2)
    lu.assertEquals(table_size(control.events), 6)
end
-- ###############################################################

local function checkEventRegistered()
    lu.assertEquals(table_size(script.on_event_registered), 1)
    lu.assertEquals(type(script.on_event_registered[defines.events.on_entity_damaged]), "function")
end


function TestControl:testInit()
    control.on_init()

    lu.assertEquals(storage.wind, 0)
    lu.assertEquals(storage.wind_turbines, {})
    lu.assertEquals(storage.wind_speed_on_surface, {})

    lu.assertEquals(storage.pressures, { fulgora = 800, nauvis = 1000, vulcanus = 4000 })

    checkEventRegistered()
end
-- ###############################################################

function TestControl:testLoad()
    control.on_load()

    lu.assertEquals(storage.pressures, { fulgora = 800, nauvis = 1000, vulcanus = 4000 })
    checkEventRegistered()
end
-- ###############################################################

function TestControl:testLoadAdditionalPlanet()
    prototypes.space_location.aquilo = { type = "planet", surface_properties = { pressure = 300 } }
    storage.pressures= { fulgora = 800, nauvis = 1000, vulcanus = 4000 }
    control.on_load()

    lu.assertEquals(storage.pressures, { aquilo = 300, fulgora = 800, nauvis = 1000, vulcanus = 4000 })
    checkEventRegistered()
end
-- ###############################################################

function TestControl:testLoadRemovalOfPlanet()
    prototypes.space_location.fulgora = nil
    storage.pressures = { fulgora = 800, nauvis = 1000, vulcanus = 4000 }
    control.on_load()

    lu.assertEquals(storage.pressures, { nauvis = 1000, vulcanus = 4000 })
    checkEventRegistered()
end
-- ###############################################################

function TestControl:testOnConfigurationChanged()
    -- Test initial setup
    storage.old_extended_collision_area = nil
    control.on_configuration_changed()
    lu.assertEquals(storage.old_extended_collision_area, false) -- should match current setting
end
-- ###############################################################

function TestControl:testResetWindCount()
    storage.wind = 1800
    control.on_nth_tick[6000]()
    lu.assertEquals(storage.wind, 0)
    
    storage.wind = 1799
    control.on_nth_tick[6000]()
    lu.assertEquals(storage.wind, 1799) -- should not reset
end
-- ###############################################################

function TestControl:testBusinessLogic()
    -- need to initialize storage objects before test
    control.on_init()

    -- Test wind increment
    control.on_nth_tick[120]()
    lu.assertEquals(storage.wind, 0.02)
    
    -- Test with mock turbine
    local mock_entity = {
        valid = true,
        type = 'electric-energy-interface',
        quality = { level = 0 },
        power_production = 0,
        electric_buffer_size = 0
    }
    
    storage.wind_turbines[1] = mock_turbine(mock_entity, 'texugo-wind-turbine', {x = 0, y = 0}, {index = 1, name = 'nauvis'})
    
    control.on_nth_tick[120]()
    
    lu.assertTrue(mock_entity.power_production > 0)
    lu.assertTrue(mock_entity.electric_buffer_size > 0)
end
-- ###############################################################

function TestControl:testBuildEntity()
    local mock_entity = {
        name = 'texugo-wind-turbine',
        position = {x = 0, y = 0},
        surface = {
            create_entity = function(params)
                return {
                    minable = true,
                    health = 100
                }
            end
        },
        force = "player",
        health = 100
    }
    
    script.register_on_object_destroyed = function(entity)
        return 123 -- mock registration number
    end
    
    local event = { created_entity = mock_entity }
    control.events[defines.events.on_built_entity](event)
    
    lu.assertNotNil(storage.wind_turbines[123])
    lu.assertEquals(storage.wind_turbines[123].name, 'texugo-wind-turbine')
end
-- ###############################################################

function TestControl:testDestroyObject()
    -- Setup mock turbine
    local mock_surface = {
        valid = true,
        find_entities_filtered = function(params)
            return {{destroy = function() end}}
        end
    }
    
    storage.wind_turbines[456] = {
        {name = 'texugo-wind-turbine'}, 
        'texugo-wind-turbine', 
        {x = 0, y = 0}, 
        mock_surface
    }
    
    local event = { registration_number = 456 }
    control.events[defines.events.on_object_destroyed](event)
    
    lu.assertNil(storage.wind_turbines[456])
end
-- ###############################################################

function TestControl:testUpdatePressuresOnSurfaceEvents()
    -- Test surface created event
    local original_pressures = storage.pressures
    prototypes.space_location.new_planet = { type = "planet", surface_properties = { pressure = 1500 } }
    
    control.events[defines.events.on_surface_created]()
    
    lu.assertEquals(storage.pressures.new_planet, 1500)
    
    -- Test surface deleted event  
    prototypes.space_location.new_planet = nil
    
    control.events[defines.events.on_surface_deleted]()
    
    lu.assertNil(storage.pressures.new_planet)
end
-- ###############################################################

function TestControl:testQualityFactors()
    storage.wind = 1
    storage.wind_turbines = {}
    
    -- Test different quality levels
    local qualities = {0, 1, 2, 3, 4, 5} -- including higher than 4
    
    for _, quality_level in ipairs(qualities) do
        local mock_entity = {
            valid = true,
            type = 'electric-energy-interface',
            quality = { level = quality_level },
            power_production = 0,
            electric_buffer_size = 0
        }
        
        storage.wind_turbines[quality_level] = mock_turbine(mock_entity, 'texugo-wind-turbine', {x = 0, y = 0}, {index = 1, name = 'nauvis'})
    end
    
    control.on_nth_tick[120]()
    
    -- Verify that higher quality levels produce more power
    lu.assertTrue(storage.wind_turbines[1].entity.power_production > storage.wind_turbines[0].entity.power_production)
    lu.assertTrue(storage.wind_turbines[4].entity.power_production > storage.wind_turbines[3].entity.power_production)
    lu.assertTrue(storage.wind_turbines[5].entity.power_production > storage.wind_turbines[4].entity.power_production)
end
-- ###############################################################

function TestControl:testDifferentTurbineTypes()
    storage.wind = 1
    storage.wind_turbines = {}
    
    local turbine_types = {'texugo-wind-turbine', 'texugo-wind-turbine2', 'texugo-wind-turbine3', 'texugo-wind-turbine4'}
    
    for i, turbine_type in ipairs(turbine_types) do
        local mock_entity = {
            valid = true,
            type = 'electric-energy-interface',
            quality = { level = 0 },
            power_production = 0,
            electric_buffer_size = 0
        }
        
        storage.wind_turbines[i] = mock_turbine(mock_entity, turbine_type, {x = 0, y = 0}, {index = 1, name = 'nauvis'})
    end
    
    control.on_nth_tick[120]()
    
    -- Verify that higher tier turbines produce more power
    lu.assertTrue(storage.wind_turbines[2].entity.power_production > storage.wind_turbines[1].entity.power_production)
    lu.assertTrue(storage.wind_turbines[4].entity.power_production > storage.wind_turbines[3].entity.power_production)
end
-- ###############################################################

function TestControl:testEntityDamageHandling()
    -- Mock setup for entity damage event
    local damaged_entity = {
        name = 'twt-collision-rect',
        surface = {
            find_entities_filtered = function(params)
                return {{
                    damage = function(amount, force, damage_type, cause)
                        -- Mock damage function
                    end,
                    valid = true,
                    health = 50
                }}
            end
        },
        position = {x = 0, y = 0}
    }
    
    local event = {
        entity = damaged_entity,
        original_damage_amount = 25,
        force = "enemy",
        damage_type = { name = "physical" },
        cause = nil
    }
    
    -- This should not throw an error
    script.on_event_registered[defines.events.on_entity_damaged](event)
end
-- ###############################################################

-- Test that different planets with different pressures affect power output
-- Vulcanus has higher pressure (4000) than Nauvis (1000), so should produce more power
-- (This test assumes wind_scale_with_pressure is enabled and use_surface_wind_speed is enabled)
function TestControl:testPressureScaling()
    -- Backup original settings
    local original_settings = settings
    
    -- Mock settings to enable pressure scaling
    settings = {
        startup = {
            ["texugo-wind-power"] = { value = 1 },
            ["texugo-wind-extended-collision-area"] = { value = false },
            ["texugo-wind-mode"] = { value = "SURFACE+PRESSURE" }, -- This enables both surface wind and pressure scaling
        }
    }
    
    -- We need to create a simple mock for the wind_speed module
    local mock_wind_speed = {
        windspeed = function(surface_index) 
            return 0.25 -- Returns 0.25, sqrt(0.25) = 0.5 for consistent testing
        end
    }
    
    -- Temporarily replace require for wind_speed
    local original_require = require
    require = function(module_name)
        if module_name == "scripts/wind_speed" then
            return mock_wind_speed
        else
            return original_require(module_name)
        end
    end
    
    -- Reload control module with new settings
    package.loaded["scripts/control"] = nil
    local control_test = require("scripts/control")
    
    -- Test setup
    storage.wind = 1
    storage.wind_turbines = {}
    storage.pressures = { nauvis = 1000, vulcanus = 4000 }
    
    -- Mock entities on different surfaces
    local nauvis_entity = {
        valid = true,
        type = 'electric-energy-interface',
        quality = { level = 0 },
        power_production = 0,
        electric_buffer_size = 0
    }
    
    local vulcanus_entity = {
        valid = true,
        type = 'electric-energy-interface',
        quality = { level = 0 },
        power_production = 0,
        electric_buffer_size = 0
    }

    storage.wind_turbines[1] = mock_turbine(nauvis_entity, 'texugo-wind-turbine', {x = 0, y = 0}, {index = 1, name = 'nauvis'})
    storage.wind_turbines[2] = mock_turbine(vulcanus_entity, 'texugo-wind-turbine', {x = 0, y = 0}, {index = 2, name = 'vulcanus'})

    control_test.on_nth_tick[120]()
    
    -- Vulcanus has 4x the pressure of Nauvis (4000/1000), so should produce 4x the power
    lu.assertTrue(vulcanus_entity.power_production > nauvis_entity.power_production)
    local ratio = vulcanus_entity.power_production / nauvis_entity.power_production
    lu.assertAlmostEquals(ratio, 4, 0.01)
    
    -- Restore original settings and require function
    settings = original_settings
    require = original_require
    package.loaded["scripts/control"] = nil -- Force reload for subsequent tests
end
-- ###############################################################

BaseTest:hookTests()