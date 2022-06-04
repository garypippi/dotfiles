---@class PippiPlug
local PippiPlug = {}

---@class PippiPlugOption
---@field plugs table<string,table>
---@field keymap table[]
---@field autocmd table<string,table[]>
---@field variable table<string,table<string,string>>
---@field callback function

---@type PippiPlugOption
PippiPlug.option = {
    plugs = {},
    keymap = {},
    autocmd = {},
    variable = {},
    callback = function () end
}

---@param self PippiPlug
PippiPlug.plug = function (self)
    for name, opts in pairs(self.option.plugs) do
        if next(opts) == nil then
            vim.fn['plug#'](name)
        else
            vim.fn['plug#'](name, opts)
        end
    end
end

---@param self PippiPlug
PippiPlug.init = function (self)
    -- set keymaps
    for _, args in pairs(self.option.keymap) do
        vim.keymap.set(unpack(args))
    end
    -- set auto commands
    for name, cmds in pairs(self.option.autocmd) do
        vim.api.nvim_create_augroup(name, { clear = true })
        for _, args in pairs(cmds) do
            vim.api.nvim_create_autocmd(args[1], {
                group = name,
                pattern = args[2],
                callback = args[3]
            })
        end
    end
    -- set variables
    for scope, vars in pairs(self.option.variable) do
        for name, value in pairs(vars) do
            vim[scope][name] = value
        end
    end
    --- call callback function
    self.option.callback()
end

---@param option PippiPlugOption
PippiPlug.new = function (option)
    local _option = {}
    for k, v in pairs(PippiPlug.option) do
        _option[k] = option[k] == nil and v or option[k]
    end
    return setmetatable({ option = _option }, {
        __index = PippiPlug
    })
end

return PippiPlug
