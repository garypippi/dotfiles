local PippiPlug = require'pippi.plug'

return PippiPlug.new({
    plugs = {
        ['nvim-lualine/lualine.nvim'] = {}
    },
    callback = function ()
        local lualine = require'lualine'
        local setting = lualine.get_config()
        setting.extensions = {'fern'}
        setting.sections.lualine_c = {{
            'filename',
            file_status = true,
            path = 1, -- relative path
            shorting_target = 40,
            symbols = {
                modified = '[+]',      -- Text to show when the file is modified.
                readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                unnamed = '[No Name]', -- Text to show for unnamed buffers.
            }
        }}

        lualine.setup(setting)
    end
})
