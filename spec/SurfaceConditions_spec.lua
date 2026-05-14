---
--- Tests for prototypes/surface_conditions.lua
---
local Require = require("test.require")
require = Require.replace(require)

local sc = require('prototypes.surface_conditions')

-- Mocks for Factorio APIs
_G.mods = {}

describe("surface_conditions", function()
    before_each(function()
        _G.mods = {}
    end)

    it("creates a surface condition", function()
        local ret = sc.surface_condition("prop", 10, 300)

        assert.are.same({ property = "prop", min = 10, max = 300 }, ret)
    end)

    it("creates the default pressure condition", function()
        local ret = sc.pressure()

        assert.are.same({ property = "pressure", min = 800, max = 20000 }, ret)
    end)

    it("loads additional planet support only when Space Age is enabled", function()
        local count = 0

        local function cntIt()
            count = count + 1
            return "ran cntIt"
        end

        assert.is_nil(sc.check_existence_of_SPA(cntIt))
        assert.are.equal(0, count)

        mods["bla-mod"] = true
        assert.is_nil(sc.check_existence_of_SPA(cntIt))
        assert.are.equal(0, count)

        mods["space-age"] = true
        assert.are.equal("ran cntIt", sc.check_existence_of_SPA(cntIt))
        assert.are.equal(1, count)
    end)
end)
