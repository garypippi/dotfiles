return {
    'nvim-lualine/lualine.nvim',
    config = function ()
        require'lualine'.setup()
    end
    --config = function ()
    --    local config = require'lualine'.get_config()
    --    table.insert(config.sections.lualine_c, function ()
    --        return require('orgmode').action('clock.get_statusline')
    --    end)
    --    require'lualine'.setup(config)
    --end
}
