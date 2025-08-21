---
--- Test for prototypes/surface_conditions.lua
---
require('test.BaseTest')
local lu = require('lib.luaunit')
local sc = require('prototypes.surface_conditions')


-- Mocks for Factorio APIs
mods = {}

TestSurfaceConditions = {}

function TestSurfaceConditions:setUp()
end
-- ###############################################################

function TestSurfaceConditions:testSurfaceCondition()
    local ret = sc.surface_condition("prop", 10, 300)

    lu.assertEquals(ret, { property = "prop", min = 10, max = 300 })
end
-- ###############################################################

function TestSurfaceConditions:testPressure()
    local ret = sc.pressure()

    lu.assertEquals(ret, { property = "pressure", min = 800, max = 20000 })
end
-- ###############################################################

function TestSurfaceConditions:testLoadAdditionalPlanet()
    local count  = 0

    local function cntIt()
        count = count + 1
        return "ran cntIt"
    end

    lu.assertNil(sc.check_existence_of_SPA(cntIt))
    lu.assertEquals(count, 0)

    mods["bla-mod"] = true
    lu.assertNil(sc.check_existence_of_SPA(cntIt))
    lu.assertEquals(count, 0)

    mods["space-age"] = true
    lu.assertEquals(sc.check_existence_of_SPA(cntIt), "ran cntIt")
    lu.assertEquals(count, 1)
end
-- ###############################################################

BaseTest:hookTests()