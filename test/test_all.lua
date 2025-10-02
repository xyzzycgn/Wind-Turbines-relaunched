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
-- must be after test_control - not nice, but luaunit is not junit and unable to really separate tests
require('test.test_common')

BaseTest.hooked = false
BaseTest:hookTests()
