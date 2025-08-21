---
--- Created by xyzzycgn.
---
--- executes all tests

local Require = require("test.require")
require = Require.replace(require)

local lu = require('lib.luaunit')

--########################################################

storage = {}

--########################################################

BaseTest = {
    hooked = false
}

function BaseTest:hookTests()
    if (not self.hooked) then
        os.exit(lu.LuaUnit.run())
        self.hooked = true
    end
end

-- mock function table_size (normally provided by the game runtime)
function table_size(table)
    if (table) then
        if (type(table) == "table") then
            local count = 0
            for _ in pairs(table) do
                count = count + 1
            end
            return count
        end
    end

    return 0
end
