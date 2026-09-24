-- nvim-lspconfig provides lsp/*.lua configs; local overrides live in after/lsp/
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

vim.lsp.enable({
  "arduino_language_server",
  "awk_ls",
  "basedpyright",
  "clangd",
  "cssls",
  "lua_ls",
  "vtsls",
  "eslint",
  "phpactor",
  "jsonls",
})

-- other LSP mappings are Nvim defaults: K, grr, grn, gri, gra, grt, ]d, [d, <C-w>d
vim.keymap.set("n", "gd", vim.lsp.buf.definition)

-- auto-complete on the server's trigger characters (see :h lsp-attach)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    -- skkelua enables completion for its own client
    if client.name ~= "skkelua" and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
