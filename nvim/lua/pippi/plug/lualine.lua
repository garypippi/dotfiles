local PippiPlug = require'pippi.plug'

return PippiPlug.new({
    plugs = {
        ['nvim-lualine/lualine.nvim'] = {}
    },
    callback = function ()
        require'lualine'.setup({
            extensions = {
                'fern'
            }
        })
    end
})
