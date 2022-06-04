---@class Pippi
local Pippi = {}

---@type PippiPlug[]
Pippi.plugs = {}

---@param self Pippi
---@param plug PippiPlug
Pippi.plug = function (self, plug)
    table.insert(self.plugs, plug)
end

---@param self Pippi
Pippi.init = function (self, home)
    vim.fn['plug#begin'](home)
    for _, plug in pairs(self.plugs) do
        plug:plug()
    end
    vim.fn['plug#end']()
    for _, plug in pairs(self.plugs) do
        plug:init()
    end
end

---@return Pippi
return function ()
    return setmetatable({}, {
        __index = Pippi
    })
end
