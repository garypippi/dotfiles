return {
    {
        'tpope/vim-fugitive'
    },
    {
        'APZelos/blamer.nvim'
    },
    {
        'airblade/vim-gitgutter',
        init = function ()
            vim.keymap.set('n', ']h', ':GitGutterNextHunk<CR>')
            vim.keymap.set('n', '[h', ':GitGutterPrevHunk<CR>')
            vim.keymap.set('n', '<Leader>hp', ':GitGutterPreviewHunk<CR>')
        end
    }
}
