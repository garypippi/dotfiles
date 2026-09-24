vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
})

require("catppuccin").setup({
  flavour = "macchiato",
  transparent_background = true,
  no_italic = true,
  integrations = {
    fern = true,
    telescope = true,
    gitsigns = true,
  },
})
vim.cmd.colorscheme("catppuccin-macchiato")

-- experimental redesign of messages and cmdline (no "Press ENTER"); see :h ui2
require("vim._core.ui2").enable()

-- borders for floating windows (hover, diagnostics, ...) and the completion menu
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"
