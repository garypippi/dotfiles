-- where plugins stay
local lazy_root = vim.fn.expand('$HOME/.config/nvim/lazy')

-- where lazy.nvim stays
local lazy_path = lazy_root .. '/lazy.nvim'

-- bootstrap lazy.nvim
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim',
        '--branch=stable',
        lazy_path
    })
end

-- set runtime path
vim.opt.rtp:prepend(lazy_path)

-- plugins
require'lazy'.setup('plugins', {
    root = lazy_root
})

vim.o.hidden = true
vim.o.equalalways = true
vim.o.swapfile = false
vim.o.list = true
vim.o.listchars = 'tab:>-'
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.number = true
vim.o.cmdheight = 0
vim.o.termguicolors = true
