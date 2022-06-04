local PippiPlug = require'pippi.plug'

local get_handler = function ()
    return vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        underline = false
    })
end

local get_config = function ()
    return {
        ['arduino_language_server'] = require'pippi.lsp.arduino_language_server',
        ['ccls'] = {},
        ['eslint'] = require'pippi.lsp.eslint',
        ['gopls'] = {},
        ['intelephense'] = require'pippi.lsp.intelephense',
        ['jsonls'] = require'pippi.lsp.jsonls',
        ['pylsp'] = {},
        ['rls'] = {},
        ['sumneko_lua'] = require'pippi.lsp.sumneko_lua',
        ['tsserver'] = {},
        ['vimls'] = {},
        ['vuels'] = {}
    }
end

return PippiPlug.new({
    plugs = {
        ['neovim/nvim-lspconfig'] = {}
    },
    keymap = {
        {'n', 'K',         '<cmd>lua vim.lsp.buf.hover()<cr>',          {}},
        {'n', 'gd',        '<cmd>lua vim.lsp.buf.definition()<cr>',     {}},
        {'n', 'gi',        '<cmd>lua vim.lsp.buf.implementation()<cr>', {}},
        {'n', '<leader>u', '<cmd>lua vim.lsp.buf.rename()<cr>',         {}},
        {'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>',  {}},
        {'n', ']e',        '<cmd>lua vim.diagnostic.goto_next()<cr>',   {}},
        {'n', '[e',        '<cmd>lua vim.diagnostic.goto_prev()<cr>',   {}},
        {'n', 'gr',        '<cmd>lua vim.lsp.buf.references()<cr>',     {}}
    },
    callback = function ()
        vim.lsp.handlers['textDocument/publishDiagnostics'] = get_handler()
        for server, options in pairs(get_config()) do
            require'lspconfig'[server].setup(options)
        end
    end
})
