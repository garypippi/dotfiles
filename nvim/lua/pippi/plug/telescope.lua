local PippiPlug = require'pippi.plug'

return PippiPlug.new({
    plugs = {
        ['nvim-lua/popup.nvim'] = {},
        ['nvim-lua/plenary.nvim'] = {},
        ['nvim-telescope/telescope.nvim'] = {},
    },
    keymap = {
        {'n', '<leader>ff', '<cmd>Telescope find_files<cr>',   {}},
        {'n', '<leader>fb', '<cmd>Telescope buffers<cr>',      {}},
        {'n', '<leader>fg', '<cmd>Telescope live_grep<cr>',    {}},
        {'n', '<leader>kc', '<cmd>Telescope git_commits<cr>',  {}},
        {'n', '<leader>kv', '<cmd>Telescope git_bcommits<cr>', {}},
        {'n', '<leader>kb', '<cmd>Telescope git_branches<cr>', {}},
        {'n', '<leader>ks', '<cmd>Telescope git_status<cr>',   {}}
    },
    callback = function ()
        local telescope = require'telescope'
        local actions = require'telescope.actions'
        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<c-j>"] = actions.move_selection_next,
                        ["<c-k>"] = actions.move_selection_previous
                    }
                }
            }
        })
    end
})
