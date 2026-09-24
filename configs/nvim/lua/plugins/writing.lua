-- tools for writing text; also loaded by jacin (the IME embeds this config)
vim.pack.add({
  -- auto-close brackets and quotes
  "https://github.com/cohama/lexima.vim",
  -- SKK Japanese input
  "https://github.com/kjuq/skkelua.nvim",
  -- :MakeTable
  "https://github.com/mattn/vim-maketable",
})

vim.keymap.set({ "i", "c" }, "<C-j>", "<Plug>(skkelua-toggle)")

-- skkelua shows its own candidates; pause 'autocomplete' while it is on
local group = vim.api.nvim_create_augroup("skkelua_autocomplete", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "skkelua-enable-post",
  callback = function()
    vim.bo.autocomplete = false
  end,
})
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "skkelua-disable-post",
  command = "setlocal autocomplete<",
})

require("skkelua").config({
  eggLikeNewline = true,
  completion = { enabled = true },
  -- show the mode only while skkelua is on; never in jacin
  indicator = { enabled = not vim.g.jacin, alwaysShown = false },
  globalDictionaries = {
    { "/usr/share/skk/SKK-JISYO.L", "euc-jp" },
    { "/usr/share/skk/SKK-JISYO.emoji", "utf-8" },
  },
})
