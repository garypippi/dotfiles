local PippiPlug = require'pippi.plug'

return PippiPlug.new({
    plugs = {
        ['neovim/nvim-lspconfig'] = {},
        ['hrsh7th/vim-vsnip'] = {},
        ['hrsh7th/cmp-nvim-lsp'] = {},
        ['hrsh7th/cmp-buffer'] = {},
        ['hrsh7th/nvim-cmp'] = {},
        ['onsails/lspkind-nvim'] = {}
    },
    callback = function ()
        local cmp = require'cmp'
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<c-k>'] = cmp.mapping.confirm({ select = true })
            }),
            sources = {
                { name = 'nvim_lsp' },
                { name = 'buffer' }
            },
            formatting = {
                format = require('lspkind').cmp_format({
                    with_text = true,
                    maxwidth = 50
                })
            },
            snippet = {
                expand = function(args) vim.fn["vsnip#anonymous"](args.body) end
            }
        })
    end
})
