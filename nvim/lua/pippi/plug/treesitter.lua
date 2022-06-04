local PippiPlug = require'pippi.plug'

return PippiPlug.new({
    plugs = {
        ['nvim-treesitter/nvim-treesitter'] = { ['do'] = 'TSUpdate' }
    },
    callback = function ()
        require'nvim-treesitter.configs'.setup({
            highlight = {
                enable = true
            }
        })
    end
})
