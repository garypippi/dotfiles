vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    lua = { "stylua" },
  },
  -- only format projects that have a config for the formatter
  formatters = {
    prettier = { require_cwd = true },
    stylua = { require_cwd = true },
  },
  -- manual formatting (gq) falls back to LSP
  default_format_opts = { lsp_format = "fallback" },
  -- on save, only the formatters above; never reformat via LSP
  format_on_save = { timeout_ms = 1000, lsp_format = "never" },
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
