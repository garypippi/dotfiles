local snippet_capability = vim.lsp.protocol.make_client_capabilities()
snippet_capability.textDocument.completion.completionItem.snippetSupport = true

local settings = {
    ['arduino_language_server'] = {
        cmd = {
            "arduino-language-server",
            "-cli", "arduino-cli",
            "-cli-config", "~/.arduino15/arduino-cli.yaml",
            "-fqbn", "arduino:avr:uno",
            "-clangd", "clangd"
        }
    },
    ['ccls'] = {},
    ['eslint'] = {
        on_attach = function()
            vim.cmd([[au BufWritePre <buffer> EslintFixAll]])
        end
    },
    ['gopls'] = {},
    ['intelephense'] = {
        init_options = {
            globalStoragePath = os.getenv('HOME') .. '/.intelephense'
        }
    },
    ['jsonls'] = {
        capabilities = snippet_capability,
        settings = {
            json = {
                schemas = {
                    { fileMatch = { 'tsconfig.json' }, url = 'http://json.schemastore.org/tsconfig' },
                    { fileMatch = { '.eslintrc.json' }, url = 'http://json.schemastore.org/eslintrc' }
                }
            }
        }
    },
    ['html'] = {
      capabilities = snippet_capability,
    },
    ['cssls'] = {
      capabilities = snippet_capability,
    },
    ['pylsp'] = {},
    ['rls'] = {},
    ['sumneko_lua'] = {
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
                    library = vim.api.nvim_get_runtime_file('', true)
                },
                telemetry = {
                    enable = false
                }
            }
        }
    },
    ['tsserver'] = {},
    ['vimls'] = {},
    ['vuels'] = {}
}

return {
    settings = settings
}
