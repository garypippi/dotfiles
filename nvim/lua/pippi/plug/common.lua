local PippiPlug = require'pippi.plug'

return PippiPlug.new({
    plugs = {
        ['tpope/vim-fugitive'] = {},
        ['tyru/caw.vim'] = {},
        ['jiangmiao/auto-pairs'] = {},
        ['mattn/emmet-vim'] = {},
        ['bronson/vim-trailing-whitespace'] = {}
    },
    variable = {
        ['o'] = {
            --
            ['hidden'] = true,
            ['equalalways'] = false,
            ['swapfile'] = false,
            --
            ['expandtab'] = true,
            ['tabstop'] = 4,
            ['shiftwidth'] = 4,
            ['softtabstop'] = 4,
            --
            ['number'] = true,
            --
            ['list'] = true,
            ['listchars'] = 'tab:>-'
        }
    }
})
