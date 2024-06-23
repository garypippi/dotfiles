return {
    'vim-test/vim-test',
    init = function ()
        vim.keymap.set('n', '<Leader>tf', ':TestFile<CR>')
        vim.keymap.set('n', '<Leader>tn', ':TestNearest<CR>')
    end
}
