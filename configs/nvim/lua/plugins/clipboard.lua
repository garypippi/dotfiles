-- clipboard://: a scratch buffer that never touches disk
-- :w copies it to the system clipboard
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "clipboard://",
  callback = function(ev)
    vim.bo[ev.buf].buftype = "acwrite"
    vim.bo[ev.buf].swapfile = false
  end,
})

vim.api.nvim_create_autocmd("BufWriteCmd", {
  pattern = "clipboard://",
  callback = function(ev)
    local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
    -- charwise, so no trailing newline
    vim.fn.setreg("+", lines, "v")
    vim.bo[ev.buf].modified = false
    vim.notify("Copied.")
  end,
})
