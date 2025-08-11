---
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

function TestControl:setUp()
    prototypes = {
        space_location = {
            nauvis = { type = "planet", surface_properties = { pressure = 1000 } },
            vulcanus = { type = "planet", surface_properties = { pressure = 4000 } },
            fulgora = { type = "planet", surface_properties = { pressure = 800 } }
        }
    }
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
    control.on_configuration_changed()
    -- todo assertions
end
-- ###############################################################

BaseTest:hookTests()