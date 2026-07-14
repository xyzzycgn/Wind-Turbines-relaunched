---
--- Tests for scripts/TableHelper.lua
---
local Require = require("test.require")
_G.require = Require.replace(_G.require)


local function load_array_helper_with_wt4(enabled)
    package.loaded["scripts.TableHelper"] = nil
    package.loaded["scripts/handle_settings"] = {
        WindTurbine4 = function()
            return enabled
        end
    }

    return require("scripts.TableHelper")
end
-- ###############################################################

describe("TableHelper", function()
    after_each(function()
        -- Force the module and mocked dependency to reload for the next test.
        package.loaded["scripts.TableHelper"] = nil
        package.loaded["scripts/handle_settings"] = nil
    end)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    it("exports the expected module members", function()
        local array_helper = load_array_helper_with_wt4(true)

        assert.is_not_nil(array_helper)
        assert.are.equal("table", type(array_helper))
        assert.are.equal("function", type(array_helper.addOptionalWT4))
    end)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    it("adds the optional entry to an table when wind turbine 4 is enabled", function()
        local array_helper = load_array_helper_with_wt4(true)
        local base = { name1 = "always-present" }
        local wt4_entry = { name4 = "texugo-wind-turbine4" }

        local result = array_helper.addOptionalWT4(base, wt4_entry)

        assert.are.same({
            name1 = "always-present",
            name4 = "texugo-wind-turbine4",
        }, result)
    end)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    it("adds the optional entry when wind turbine 4 is enabled to an empty table", function()
        local array_helper = load_array_helper_with_wt4(true)
        local base = {}
        local wt4_entry = { optional = "captured-setting-entry" }

        local result = array_helper.addOptionalWT4(base, wt4_entry)

        assert.are.same({ optional = "captured-setting-entry" }, result)
    end)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    it("does not add the optional entry when wind turbine 4 is disabled", function()
        local array_helper = load_array_helper_with_wt4(false)
        local base = { always = "always-present" }
        local wt4_entry = { name = "texugo-wind-turbine4" }

        local result = array_helper.addOptionalWT4(base, wt4_entry)

        assert.are.same({ always = "always-present" }, result)
    end)
end)
