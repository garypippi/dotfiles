return {
    'vim-skk/skkeleton',
    dependencies = {
        'vim-denops/denops.vim'
    },
    init = function ()
        vim.keymap.set('i', '<C-j>', '<Plug>(skkeleton-toggle)')
        vim.keymap.set('c', '<C-j>', '<Plug>(skkeleton-toggle)')
    end,
    config = function ()
        vim.fn['skkeleton#config']({
            eggLikeNewline = true,
            globalDictionaries = {
                { vim.fn.stdpath('config') .. '/SKK-JISYO.L', 'euc-jp' },
                { vim.fn.stdpath('config') .. '/SKK-JISYO.emoji.utf8', 'utf-8' }
            },
        })
    end
}
