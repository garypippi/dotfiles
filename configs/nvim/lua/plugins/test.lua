vim.pack.add({ "https://github.com/vim-test/vim-test" })

vim.keymap.set("n", "<Leader>tf", ":TestFile<CR>")
vim.keymap.set("n", "<Leader>tn", ":TestNearest<CR>")
