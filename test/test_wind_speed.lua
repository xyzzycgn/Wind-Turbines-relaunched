---
--- Created by xyzzycgn.
---
require('test.BaseTest')
local lu = require('lib.luaunit')

-- SUT
local wind_speed = require("scripts.wind_speed")

-- Provide the global storage used by wind_speed.lua
-- Reset in setUp/tearDown to ensure isolation between tests
storage = storage or {}

TestWindSpeed = {}

function TestWindSpeed:setUp()
    -- Fresh storage for each test
    storage.wind_speed_on_surface = {}
    -- Keep original math.random to restore later
    self._orig_random = math.random
end

function TestWindSpeed:tearDown()
    -- Restore math.random
    math.random = self._orig_random
end

function TestWindSpeed:test_init_returns_values_in_expected_ranges()
    -- Ensure init produces values in expected ranges
    local init_state = wind_speed.init()
    lu.assertIsNumber(init_state.v)
    lu.assertIsNumber(init_state.delta_v)
    lu.assertTrue(init_state.v >= 0 and init_state.v <= 1, "v should be in [0,1]")
    lu.assertTrue(init_state.delta_v >= -0.05 and init_state.delta_v <= 0.05, "delta_v should be in [-0.05,0.05]")
end

function TestWindSpeed:test_windspeed_initializes_storage_when_missing()
    -- When there is no state for a surface, windspeed() should initialize it
    local idx = 1
    lu.assertNil(storage.wind_speed_on_surface[idx])

    local v = wind_speed.windspeed(idx)
    lu.assertIsNumber(v)
    lu.assertTrue(v >= 0 and v <= 1, "returned v should be in [0,1]")

    local ws = storage.wind_speed_on_surface[idx]
    lu.assertNotNil(ws, "state should be stored for surface index")
    lu.assertIsNumber(ws.v)
    lu.assertIsNumber(ws.delta_v)
    lu.assertTrue(ws.v >= 0 and ws.v <= 1, "stored v should be in [0,1]")
    lu.assertTrue(ws.delta_v >= -0.05 and ws.delta_v <= 0.05, "stored delta_v should be in [-0.05,0.05]")
end

function TestWindSpeed:test_windspeed_updates_and_clamps_values_over_multiple_steps()
    -- Calls should update the state and keep values within bounds
    local idx = 2
    for _ = 1, 100 do
        local v = wind_speed.windspeed(idx)
        lu.assertTrue(v >= 0 and v <= 1, "v should stay in [0,1]")
        local ws = storage.wind_speed_on_surface[idx]
        lu.assertTrue(ws.v >= 0 and ws.v <= 1, "stored v should stay in [0,1]")
        lu.assertTrue(ws.delta_v >= -0.05 and ws.delta_v <= 0.05, "delta_v should stay in [-0.05,0.05]")
    end
end

function TestWindSpeed:test_delta_logic_when_negative()
    -- If delta_v is negative, min is adjusted upward:
    -- min = -0.01 - delta_v/5, so with delta_v = -0.05 -> min = 0
    local idx = 3
    storage.wind_speed_on_surface[idx] = { v = 0.5, delta_v = -0.05 }

    -- Force math.random() to return 0 to select the lower edge of the range
    math.random = function() return 0 end

    local v = wind_speed.windspeed(idx)
    lu.assertTrue(v >= 0 and v <= 1, "v should be clamped to [0,1]")

    local ws = storage.wind_speed_on_surface[idx]
    lu.assertAlmostEquals(ws.v, v, 1e-12)
    -- With min=0 and random=0, delta increment is 0; in_range keeps -0.05
    lu.assertAlmostEquals(ws.delta_v, -0.05, 1e-12)
end

function TestWindSpeed:test_delta_logic_when_positive()
    -- If delta_v is positive, max is adjusted downward:
    -- max = 0.01 - delta_v/5, so with delta_v = 0.05 -> max = 0
    local idx = 4
    storage.wind_speed_on_surface[idx] = { v = 0.5, delta_v = 0.05 }

    -- Force math.random() to return 1 to select the upper edge of the range
    math.random = function() return 1 end

    local v = wind_speed.windspeed(idx)
    lu.assertTrue(v >= 0 and v <= 1, "v should be clamped to [0,1]")

    local ws = storage.wind_speed_on_surface[idx]
    lu.assertAlmostEquals(ws.v, v, 1e-12)
    -- With max=0 and random=1, delta increment is 0; in_range keeps 0.05
    lu.assertAlmostEquals(ws.delta_v, 0.05, 1e-12)
end

function TestWindSpeed:test_v_is_clamped_even_with_large_existing_delta()
    -- Even if an existing stored delta_v is out of range, v should be clamped on update
    local idx = 5
    storage.wind_speed_on_surface[idx] = { v = 0.95, delta_v = 1.0 } -- intentionally out of normal range

    -- Force no additional delta change effect for determinism
    math.random = function() return 0.5 end

    local v = wind_speed.windspeed(idx)
    lu.assertTrue(v <= 1 and v >= 0, "v must be clamped to [0,1]")
    lu.assertAlmostEquals(storage.wind_speed_on_surface[idx].v, v, 1e-12)
    -- New delta_v is always clamped within [-0.05, 0.05]
    lu.assertTrue(storage.wind_speed_on_surface[idx].delta_v >= -0.05)
    lu.assertTrue(storage.wind_speed_on_surface[idx].delta_v <= 0.05)
end

-- Do not call LuaUnit.run() here; test/test_all.lua is expected to orchestrate the run.
BaseTest:hookTests()