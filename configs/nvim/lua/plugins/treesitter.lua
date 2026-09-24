-- "main" is the rewrite for Nvim 0.12+; "master" is the frozen legacy branch
vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } })

-- parsers built by nvim-treesitter
local install = {
  "bash",
  "blade",
  "css",
  "javascript",
  "json",
  "php",
  "rust",
  "tsx",
  "typescript",
  "vue",
  "yaml",
}
-- parsers bundled with Nvim (installing them would shadow the bundled ones)
local bundled = { "c", "vim" }
-- languages that use the nvim-treesitter indentexpr
local indent = { php = true, typescript = true, tsx = true }

require("nvim-treesitter").install(install)

local filetypes = {}
for _, lang in ipairs(vim.list_extend(vim.list_extend({}, install), bundled)) do
  vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = filetypes,
  callback = function(ev)
    if not pcall(vim.treesitter.start, ev.buf) then
      return
    end
    if indent[vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)] then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
