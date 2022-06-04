local PippiPlug = require'pippi.plug'

local glyph_palette_apply = function ()
    vim.fn['glyph_palette#apply']()
end

return PippiPlug.new({
    plugs = {
        ['lambdalisue/fern.vim'] = {},
        ['lambdalisue/nerdfont.vim'] = {},
        ['lambdalisue/fern-renderer-nerdfont.vim'] = {},
        ['lambdalisue/fern-git-status.vim'] = {},
        ['lambdalisue/glyph-palette.vim'] = {},
    },
    keymap = {
        {'n', '<leader>r', ':Fern .<cr>',             { silent = true }},
        {'n', '-',         ':Fern . -reveal=%:p<cr>', { silent = true }}
    },
    autocmd = {
        ['glyph-palette'] = {
            {'FileType', {'fern'}, glyph_palette_apply}
        }
    },
    variable = {
        ['g'] = {
            ['fern#renderer'] = 'nerdfont'
        }
    }
})
