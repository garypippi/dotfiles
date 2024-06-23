return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim'
    },
    init = function ()
        vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
        vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
        vim.keymap.set('n', '<leader>gs', '<cmd>Telescope git_status<cr>')
        vim.keymap.set('n', '<leader>gc', '<cmd>Telescope git_commits<cr>')
        vim.keymap.set('n', '<leader>lr', '<cmd>Telescope lsp_references<cr>')
    end
}
