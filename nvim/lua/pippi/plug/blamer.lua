local PippiPlug = require'pippi.plug'

return PippiPlug.new({
    plugs = {
        ['APZelos/blamer.nvim'] = {}
    },
    keymap = {
        {'n', '<leader>b', ':BlamerToggle<cr>', { silent = true }}
    }
})
