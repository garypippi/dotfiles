-- external tools installed by `make deps`
local deps_path = vim.fn.stdpath("data") .. "/deps"
vim.env.PATH = deps_path .. "/bin:" .. deps_path .. "/node_modules/.bin:" .. vim.env.PATH

vim.o.swapfile = false
vim.o.list = true
vim.o.listchars = "tab:>-,trail:-,nbsp:+"
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.laststatus = 3

-- completion: words via 'autocomplete'; LSP completion is set up in plugins/lsp.lua
vim.o.autocomplete = true
vim.o.complete = ".^5,w^5,b^5"
vim.o.completeopt = "menuone,noselect,popup"
-- LSP items can carry long signatures and module paths
vim.o.pummaxwidth = 60

-- plugin build hooks; registered before the first vim.pack call so that they
-- also run for plugins installed from the lockfile (see :h vim.pack-events)
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

-- plugins (managed by vim.pack; revisions pinned in nvim-pack-lock.json)
require("plugins.ui")
require("plugins.writing")

-- jacin (IME) embeds this config; it only needs the writing tools
if vim.g.jacin then
  return
end

require("plugins.editing")
require("plugins.navigation")
require("plugins.git")
require("plugins.lsp")
require("plugins.format")
require("plugins.treesitter")
require("plugins.test")
require("plugins.org")
require("plugins.clipboard")
