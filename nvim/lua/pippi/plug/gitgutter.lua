local PippiPlug = require'pippi.plug'

return PippiPlug.new({
    plugs = {
        ['airblade/vim-gitgutter'] = {}
    },
    keymap = {
        {'n', '<leader>hh', ':GitGutterLineHighlightsToggle<cr>', { silent = true }},
        {'n', '<leader>hp', ':GitGutterPreviewHunk<cr>',          { silent = true }},
        {'n', '<leader>hs', ':GitGutterStageHunk<cr>',            { silent = true }},
        {'n', '<leader>hu', ':GitGutterUndoHunk<cr>',             { silent = true }},
        {'n', '[h',         ':GitGutterPrevHunk<cr>',             { silent = true }},
        {'n', ']h',         ':GitGutterNextHunk<cr>',             { silent = true }}
    },
    variable = {
        ['g'] = {
            ['gitgutter_map_keys'] = 0,
            ['gitgutter_signs'] = 0,
        }
    }
})
