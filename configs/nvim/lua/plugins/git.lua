vim.pack.add({
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/lewis6991/gitsigns.nvim",
})

-- inline blame: :Gitsigns toggle_current_line_blame
local gitsigns = require("gitsigns")
gitsigns.setup()
vim.keymap.set("n", "]h", function()
  gitsigns.nav_hunk("next")
end)
vim.keymap.set("n", "[h", function()
  gitsigns.nav_hunk("prev")
end)
vim.keymap.set("n", "<Leader>hp", gitsigns.preview_hunk)
vim.keymap.set("n", "<Leader>hu", gitsigns.reset_hunk)
vim.keymap.set("n", "<Leader>hs", gitsigns.stage_hunk)
