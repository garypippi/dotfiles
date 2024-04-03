return {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function (_, opts)
        require'catppuccin'.setup(opts)
        vim.cmd[[colorscheme catppuccin]]
    end,
    opts = {
        flavour = 'macchiato',
        transparent_background = true,
        no_italic = true,
        integrations = {
            fern = true,
            telescope = true,
            gitgutter = true
        }
    },
}
