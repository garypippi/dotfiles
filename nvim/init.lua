-- where plugins stay
local lazy_root = vim.loop.os_homedir() .. '/.config/nvim/lazy'

-- where lazy.nvim stays
local lazy_path = lazy_root .. '/lazy.nvim'

-- bootstrap lazy.nvim
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim', '--branch=stable', lazy_path })
end


-- set runtime path
vim.opt.rtp:prepend(lazy_path)

-- plugins
local plugins = {
    {
        'lambdalisue/kensaku.vim',
        dependencies = {
            'vim-denops/denops.vim'
        }
    },
    require'plugins.theme'
    --{
    --    'catppuccin/nvim',
    --    name = 'catppuccin',
    --    config = function (_, opts)
    --        require'catppuccin'.setup(opts)
    --        vim.cmd[[colorscheme catppuccin]]
    --    end,
    --    opts = {
    --        flavour = 'macchiato',
    --        transparent_background = true,
    --        no_italic = true,
    --        integrations = {
    --            fern = true,
    --            telescope = true,
    --            gitgutter = true
    --        }
    --    },
    --},
    {
        'github/copilot.vim',
        init = function ()
            vim.api.nvim_create_autocmd({'BufEnter'}, {
                pattern = {'*'},
                callback = function ()
                    vim.b.copilot_enabled = false
                end
            })
        end
    },
    {
        'vim-test/vim-test',
        init = function ()
            vim.keymap.set('n', '<Leader>tf', ':TestFile<CR>')
            vim.keymap.set('n', '<Leader>tn', ':TestNearest<CR>')
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        config = function ()
            require'nvim-treesitter.configs'.setup{
                highlight = { enable = true },
                indent = { enable = true }
            }
        end
    },
    {
        'cohama/lexima.vim'
    },
    {
        'bronson/vim-trailing-whitespace'
    },
    {
        'tpope/vim-fugitive'
    },
    {
        'tpope/vim-sleuth'
    },
    {
        'airblade/vim-gitgutter',
        init = function ()
            vim.keymap.set('n', ']h', ':GitGutterNextHunk<CR>')
            vim.keymap.set('n', '[h', ':GitGutterPrevHunk<CR>')
            vim.keymap.set('n', '<Leader>hp', ':GitGutterPreviewHunk<CR>')
        end
    },
    {
        'APZelos/blamer.nvim'
    },
    {
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
    },
    {
        'lambdalisue/fern.vim',
        branch = 'main',
        dependencies = {
            'lambdalisue/nerdfont.vim',
            'lambdalisue/fern-renderer-nerdfont.vim',
            'lambdalisue/fern-git-status.vim',
            'lambdalisue/glyph-palette.vim'
        },
        init = function ()
            vim.g['fern#renderer'] = 'nerdfont'
            vim.keymap.set('n', '<Leader>r', ':Fern .<CR>', { silent = true })
            vim.keymap.set('n', '-', ':Fern . -reveal=%:p<CR>', { silent = true })
            vim.api.nvim_create_augroup('glyph_palette', {
                clear = true
            })
            vim.api.nvim_create_autocmd('FileType', {
                group = 'glyph_palette',
                pattern = { 'fern' },
                command = 'call glyph_palette#apply()'
            })
        end
    },
    {
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
            --cmp.register_source('kkb', require('cmp_kkb'))
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
                    --{ name = 'kkb' }
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
    },
    {
        'Shougo/ddc.vim',
        enabled = false,
        dependencies = {
            'vim-denops/denops.vim',
            'Shougo/ddc-ui-native',
            'Shougo/ddc-matcher_head',
            'Shougo/ddc-sorter_rank',
            'Shougo/ddc-source-nvim-lsp',
            'Shougo/ddc-source-around'
        },
        config = function ()
            -- ddc settings
            vim.fn['ddc#custom#patch_global']{
                ui = 'native',
                sources = {
                    'nvim-lsp',
                    'skkeleton',
                    'around'
                },
                sourceOptions = {
                    ['nvim-lsp'] = {
                        mark = '[LSP]',
                        forceCompletionPattern = '\\.\\w*|:\\w*|->\\w*'
                    },
                    ['skkeleton'] = {
                        mark = '[SKK]',
                        matchers = { 'skkeleton' },
                        sorters = {},
                        minAutoCompleteLength = 2,
                        maxItems = 1000
                    },
                    _ = {
                        matchers = { 'matcher_head' },
                        sorters = { 'sorter_rank' }
                    }
                },
                sourceParams = {
                    ['nvim-lsp'] = {
                        enableResolveItem = true
                    }
                }
            }
            -- enable
            vim.fn['ddc#enable']()
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function ()
            local config = require'lualine'.get_config()
            table.insert(config.sections.lualine_c, function ()
                return require('orgmode').action('clock.get_statusline')
            end)
            require'lualine'.setup(config)
        end
    },
    {
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
                capabilities = snippet_capability,
                cmd = {
                    vim.fn.stdpath('config') .. '/node_modules/.bin/vscode-css-language-server',
                    '--stdio'
                }
            }
            -- Vim
            lspc.vimls.setup{}
            -- Deno
            --lspc.denols.setup{}
            -- Javascript/TypeScript
            lspc.vtsls.setup{
            --lspc.vsserver.setup{
                -- Disable semantic tokens because it's too slow
                --on_attach = function (client)
                --    client.server_capabilities.semanticTokensProvider = nil
                --end
                cmd = {
                    vim.fn.stdpath('config') .. '/node_modules/.bin/vtsls',
                    '--stdio'
                },
                settings = {
                    vtsls = {
                        experimental = {
                            completion = {
                                enableServerSideFuzzyMatch = true
                            }
                        }
                    }
                }
            }
            -- C/C++
            lspc.ccls.setup{}
            -- Go
            lspc.gopls.setup{}
            --lspc.tsserver.setup{
            --    -- Disable semantic tokens because it's too slow
            --    on_attach = function (client)
            --        client.server_capabilities.semanticTokensProvider = nil
            --    end
            --}
            -- ESLint
            local rulesDir = vim.loop.cwd() .. '/eslint/rules'
            local rulePaths = {}
            if vim.loop.fs_stat(rulesDir) ~= nil then
                table.insert(rulePaths, 'eslint/rules')
            end
            lspc.eslint.setup{
                cmd = {
                    vim.fn.stdpath('config') .. '/node_modules/.bin/vscode-eslint-language-server',
                    '--stdio'
                },
                settings = {
                    options = {
                        rulePaths = rulePaths
                    }
                },
                --on_attach = function (client, bufnr)
                --    vim.api.nvim_create_autocmd('BufWritePre', {
                --        buffer = bufnr,
                --        command = 'EslintFixAll'
                --    })
                --end
            }
            -- JSON
            lspc.jsonls.setup{
                capabilities = snippet_capability,
                cmd = {
                    vim.fn.stdpath('config') .. '/node_modules/.bin/vscode-json-language-server',
                    '--stdio'
                },
                settings = {
                    json = {
                        schemas = {
                            { fileMatch = { 'tsconfig.json' }, url = 'http://json.schemastore.org/tsconfig' },
                            { fileMatch = { '.eslintrc.json' }, url = 'http://json.schemastore.org/eslintrc' },
                            { fileMatch = { '.prettierrc' }, url = 'https://json.schemastore.org/prettierrc.json' }
                        }
                    }
                },
                on_attach = function (client, bufnr)
                    vim.api.nvim_buf_set_option(bufnr, 'tabstop', 2)
                    vim.api.nvim_buf_set_option(bufnr, 'shiftwidth', 2)
                    vim.api.nvim_buf_set_option(bufnr, 'softtabstop', 2)
                end
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
            lspc.lua_ls.setup{
                cmd = {
                    vim.fn.stdpath('config') .. '/.deps/bin/lua-language-server'
                },
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {'vim'}
                        },
                        runtime = {
                            version = 'LuaJIT'
                        },
                        workspace = {
                            library = {
                                vim.env.VIMRUNTIME
                            }
                        }
                    }
                }
            }
  --          lspc.lua_ls.setup{
  --              cmd = { vim.fn.stdpath('config') .. '/.deps/bin/lua-language-server' },
  --              --settings = {
  --              --    Lua = {
  --              --        runtime = {
  --              --            version = 'LuaJIT',
  --              --            path = { 'lua/?.lua', 'lua/?/init.lua' }
  --              --        },
  --              --        diagnostics = {
  --              --            globals = { 'vim' }
  --              --        },
  --              --        workspace = {
  --              --            library = vim.api.nvim_get_runtime_file('', true),
  --              --            checkThirdParty = false
  --              --        },
  --              --        telemetry = {
  --              --            enable = false
  --              --        }
  --              --    }
  --              --},
  --              on_init = function(client)
  --                  local path = client.workspace_folders[1].name
  --                  if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
  --                  client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
  --                      Lua = {
  --                          diagnostics = {
  --                              globals = {'vim'}
  --                          },
  --                          runtime = {
  --                          -- Tell the language server which version of Lua you're using
  --                          -- (most likely LuaJIT in the case of Neovim)
  --                              version = 'LuaJIT'
  --                          },
  --                      -- Make the server aware of Neovim runtime files
  --                      workspace = {
  --                          checkThirdParty = false,
  --                          library = {
  --                              vim.env.VIMRUNTIME
  --                          -- "${3rd}/luv/library"
  --                          -- "${3rd}/busted/library",
  --                      }
  --                      -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
  --                      -- library = vim.api.nvim_get_runtime_file("", true)
  --                          }
  --                      }
  --                  })

  --    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  --  end
  --  return true
  --end
--            }
            -- PHP
            lspc.phpactor.setup{}
            -- Prettier
            local prettierd = {
                formatCommand = vim.fn.stdpath('config') .. '/node_modules/.bin/prettierd "${INPUT}"',
                formatStdin = true,
                env = {
                    'PRETTIERD_LOCAL_PRETTIER_ONLY=1',
                    -- 'PRETTIERD_DEFAULT_CONFIG=' .. vim.loop.cwd() .. '/.prettierrc.json'
                }
            }
            lspc.efm.setup{
                cmd = { vim.fn.stdpath('config') .. '/go/bin/efm-langserver' },
                init_options = { documentFormatting = true },
                filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
                settings = {
                    rootMarkers = {'.git/'},
                    languages = {
                        ['typescript'] = { prettierd },
                        ['typescriptreact'] = { prettierd },
                    }
                },
                on_attach = function (client, bufnr)
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = bufnr,
                        callback = function ()
                            vim.lsp.buf.format { async = false }
                        end
                    })
                end
            }
        end
    }
}

require'lazy'.setup(plugins, {
    root = lazy_root
})

vim.o.hidden = true
vim.o.equalalways = true
vim.o.swapfile = false
vim.o.list = true
vim.o.listchars = 'tab:>-'
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.termguicolors = true
vim.o.completeopt = string.gsub(vim.o.completeopt, ",?preview,?", '')
vim.o.laststatus = 3

-- nnoremap g<tab> /\t\zs.<CR>
--vim.keymap.set('n', '<Leader><Tab>', '/\\t.<CR> :noh<CR>')
vim.keymap.set('n', '<Right>', '/\\(^\\|\\t\\zs.\\)<Cr><Esc>:noh<Cr>')
vim.keymap.set('n', '<Left>', '?\\(^\\|\\t\\zs.\\)<Cr><Esc>:noh<Cr>')

vim.keymap.set('i', '<c-c>', function ()
    require'column_picker'()
end)
