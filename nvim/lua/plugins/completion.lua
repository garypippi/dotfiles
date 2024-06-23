return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        'hrsh7th/vim-vsnip',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'uga-rosa/cmp-skkeleton',
        'onsails/lspkind.nvim'
    },
    config = function ()
        local cmp = require'cmp'
        cmp.setup{
            snippet = {
                expand = function (args)
                    vim.fn['vsnip#anonymous'](args.body)
                end
            },
            mapping = cmp.mapping.preset.insert{
                ['<c-k>'] = cmp.mapping.confirm()
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'vsnip' }
            }, {
                { name = 'buffer' },
                { name = 'path' },
                { name = 'skkeleton' },
            }),
            formatting = {
                format = require'lspkind'.cmp_format({
                    mode = 'symbol',
                    menu = ({
                        nvim_lsp = '[LSP]',
                        skkeleton = '[SKK]',
                        buffer = '[BUF]'
                    })
                })
            }
        }
    end
}
