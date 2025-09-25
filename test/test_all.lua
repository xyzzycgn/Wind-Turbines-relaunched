---
--- Created by xyzzycgn.
---
require('test.BaseTest')
local lu = require('lib.luaunit')

--########################################################

BaseTest.hooked = true

require('test.test_surface_conditions')
require('test.test_wind_speed')
require('test.test_control')

BaseTest.hooked = false
BaseTest:hookTests()
