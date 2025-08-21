---
--- Created by xyzzycgn.
---
require('test.BaseTest')
local lu = require('lib.luaunit')

--########################################################

BaseTest.hooked = true

require('test.test_surface_conditions')
require('test.test_wind_speed')

BaseTest.hooked = false
BaseTest:hookTests()
