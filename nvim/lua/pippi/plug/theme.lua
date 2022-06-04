local PippiPlug = require'pippi.plug'

return PippiPlug.new({
    plugs = {
        ['sainnhe/everforest'] = {}
    },
    variable = {
        ['o'] = {
            ['termguicolors'] = true
        }
    },
    callback = function ()
        vim.cmd('colorscheme everforest')
    end
})
