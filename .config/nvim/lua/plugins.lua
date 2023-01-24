-- plugins
return {
    {
        -- treesitter
        'nvim-treesitter/nvim-treesitter',
        config = function ()
            require'nvim-treesitter.configs'.setup{
                highlight = { enable = true },
                indent = { enable = true }
            }
        end
    },
    {
        -- theme
        'catppuccin/nvim',
        name = 'catppuccin',
        config = function ()
            vim.cmd[[colorscheme catppuccin]]
        end,
        opts = {
            flavour = 'macchiato',
            transparent_background = true,
            no_italic = true,
            integrations = {
                fern = true,
                telescope = true
            }
        }
    },
    {
        -- autopair
        'cohama/lexima.vim'
    },
    {
        -- skk
        'vim-skk/skkeleton',
        dependencies = {
            'vim-denops/denops.vim'
        },
        config = function ()
            -- keymaps
            vim.keymap.set('i', '<C-j>', '<Plug>(skkeleton-toggle)')
            vim.keymap.set('c', '<C-j>', '<Plug>(skkeleton-toggle)')
            -- dictionaries
            local globalDictionaries = {}
            local fst = vim.loop.fs_scandir('/usr/share/skk')
            local dir = vim.loop.fs_scandir_next(fst)
            while dir ~= nil do
                table.insert(globalDictionaries, '/usr/share/skk/' .. dir)
                dir = vim.loop.fs_scandir_next(fst)
            end
        end
    },
    {
        -- filer
        'lambdalisue/fern.vim',
        branch = 'main',
        dependencies = {
            'lambdalisue/nerdfont.vim',
            'lambdalisue/fern-renderer-nerdfont.vim',
            'lambdalisue/fern-git-status.vim',
            'lambdalisue/glyph-palette.vim'
        },
        init = function ()
            -- set renderer
            vim.g['fern#renderer'] = 'nerdfont'
            -- keymaps
            vim.keymap.set('n', '<Leader>r', ':Fern .<CR>', { silent = true })
            vim.keymap.set('n', '-', ':Fern . -reveal=%:p<CR>', { silent = true })
            -- autocmd
            vim.api.nvim_create_augroup('glyph_palette', { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                group = 'glyph_palette',
                pattern = { 'fern' },
                callback = function ()
                    vim.fn['glyph_palette#apply']()
                end
            })
        end
    },
    {
        -- completion
        'Shougo/ddc.vim',
        dependencies = {
            'vim-denops/denops.vim',
            'Shougo/ddc-ui-native',
            'Shougo/ddc-matcher_head',
            'Shougo/ddc-sorter_rank',
            'Shougo/ddc-source-nvim-lsp'
        },
        config = function ()
            -- ddc settings
            vim.fn['ddc#custom#patch_global']{
                ui = 'native',
                sources = {
                    'nvim-lsp',
                    'skkeleton'
                },
                sourceOptions = {
                    ['nvim-lsp'] = {
                        mark = '[LSP]',
                        forceCompletionPattern = '\\.\\w*|:\\w*|->\\w*'
                    },
                    ['skkeleton'] = {
                        mark = '[SKK]',
                        matchers = { 'skkeleton' }
                    },
                    _ = {
                        matchers = { 'matcher_head' },
                        sorters = { 'sorter_rank' }
                    }
                }
            }
            -- enable
            vim.fn['ddc#enable']()
        end
    },
    {
        -- LSP
        'neovim/nvim-lspconfig',
        init = function ()
            -- keymaps
            vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', {})
            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', {})
            vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', {})
            vim.keymap.set('n', '<leader>u', '<cmd>lua vim.lsp.buf.rename()<cr>', {})
            vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>', {})
            vim.keymap.set('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<cr>', {})
            vim.keymap.set('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<cr>', {})
            vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', {})
            vim.keymap.set('n', 'ff', '<cmd>lua vim.lsp.buf.format()<cr>', {})
            -- hide virtual text and underline
            vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = false,
                underline = false
            })
            -- per-language settings
            local lspc = require'lspconfig'
            -- snippet capability
            local snippet_capability = vim.lsp.protocol.make_client_capabilities()
            snippet_capability.textDocument.completion.completionItem.snippetSupport = true
            -- HTML
            lspc.html.setup{
                capabilities = snippet_capability
            }
            -- CSS
            lspc.cssls.setup{
                capabilities = snippet_capability
            }
            -- Javascript/TypeScript
            lspc.tsserver.setup{
                -- Disable semantic tokens because it's too slow
                on_attach = function (client)
                    client.server_capabilities.semanticTokensProvider = nil
                end
            }
            -- JSON
            lspc.jsonls.setup{
                capabilities = snippet_capability,
                settings = {
                    json = {
                        schemas = {
                            { fileMatch = { 'tsconfig.json' }, url = 'http://json.schemastore.org/tsconfig' },
                            { fileMatch = { '.eslintrc.json' }, url = 'http://json.schemastore.org/eslintrc' }
                        }
                    }
                }
            }
            -- Arduino
            lspc.arduino_language_server.setup{
                cmd = {
                    "arduino-language-server",
                    "-cli", "arduino-cli",
                    "-cli-config", "~/.arduino15/arduino-cli.yaml",
                    "-fqbn", "arduino:avr:uno",
                    "-clangd", "clangd"
                }
            }
            -- Lua
            lspc.sumneko_lua.setup{
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                            path = { 'lua/?.lua', 'lua/?/init.lua' }
                        },
                        diagnostics = {
                            globals = { 'vim' }
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file('', true),
                            checkThirdParty = false
                        },
                        telemetry = {
                            enable = false
                        }
                    }
                }
            }
        end
    }
}
