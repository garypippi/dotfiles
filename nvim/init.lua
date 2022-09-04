local plugins = {
    ['lambdalisue/fern.vim'] = { branch = 'main' },
    ['lambdalisue/nerdfont.vim'] = {},
    ['lambdalisue/fern-renderer-nerdfont.vim'] = {},
    ['lambdalisue/fern-git-status.vim'] = {},
    ['lambdalisue/glyph-palette.vim'] = {},
    ['neovim/nvim-lspconfig'] = {},
    ['hrsh7th/vim-vsnip'] = {},
    ['hrsh7th/cmp-nvim-lsp'] = {},
    ['hrsh7th/cmp-buffer'] = {},
    ['hrsh7th/nvim-cmp'] = {},
    ['onsails/lspkind-nvim'] = {},
    ['nvim-lua/popup.nvim'] = {},
    ['nvim-lua/plenary.nvim'] = {},
    ['nvim-telescope/telescope.nvim'] = {},
    ['janko/vim-test'] = {},
    ['nvim-treesitter/nvim-treesitter'] = {},
    ['sainnhe/everforest'] = {},
    ['nvim-lualine/lualine.nvim'] = {},
    ['airblade/vim-gitgutter'] = {},
    ['APZelos/blamer.nvim'] = {},
    ['tpope/vim-fugitive'] = {},
    ['tyru/caw.vim'] = {},
    ['jiangmiao/auto-pairs'] = {},
    ['mattn/emmet-vim'] = {},
    ['bronson/vim-trailing-whitespace'] = {}
}

local keymaps = {
    { 'n', '<leader>r', ':Fern .<cr>', { silent = true } },
    { 'n', '-', ':Fern . -reveal=%:p<cr>', { silent = true } },
    { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', {} },
    { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', {} },
    { 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', {} },
    { 'n', '<leader>u', '<cmd>lua vim.lsp.buf.rename()<cr>', {} },
    { 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>', {} },
    { 'n', ']e', '<cmd>lua vim.diagnostic.goto_next()<cr>', {} },
    { 'n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<cr>', {} },
    { 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', {} },
    { 'n', 'ff', '<cmd>lua vim.lsp.buf.format()<cr>', {} },
    { 'n', '<leader>ff', '<cmd>Telescope find_files<cr>', {} },
    { 'n', '<leader>fb', '<cmd>Telescope buffers<cr>', {} },
    { 'n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {} },
    { 'n', '<leader>kc', '<cmd>Telescope git_commits<cr>', {} },
    { 'n', '<leader>kv', '<cmd>Telescope git_bcommits<cr>', {} },
    { 'n', '<leader>kb', '<cmd>Telescope git_branches<cr>', {} },
    { 'n', '<leader>ks', '<cmd>Telescope git_status<cr>', {} },
    { 'n', '<leader>tf', ':TestFile<cr>', { silent = true } },
    { 'n', '<leader>tn', ':TestNearest<cr>', { silent = true } },
    { 'n', '<leader>tt', ':TestSuite<cr>', { silent = true } },
    { 'n', '<leader>tl', ':TestLast<cr>', { silent = true } },
    { 'n', '<leader>tv', ':TestVisit<cr>', { silent = true } },
    { 'n', '<leader>hh', ':GitGutterLineHighlightsToggle<cr>', { silent = true } },
    { 'n', '<leader>hp', ':GitGutterPreviewHunk<cr>', { silent = true } },
    { 'n', '<leader>hs', ':GitGutterStageHunk<cr>', { silent = true } },
    { 'n', '<leader>hu', ':GitGutterUndoHunk<cr>', { silent = true } },
    { 'n', '[h', ':GitGutterPrevHunk<cr>', { silent = true } },
    { 'n', ']h', ':GitGutterNextHunk<cr>', { silent = true } },
    { 'n', '<leader>b', ':BlamerToggle<cr>', { silent = true } }
}

local autocmds = {
    ['glyph-palette'] = {
        {
            'FileType',
            { 'fern' },
            function()
                vim.fn['glyph_palette#apply']()
            end
        }
    },
    ['indent-json'] = {
        {
            'FileType',
            { 'json' },
            function (e)
                vim.api.nvim_buf_set_option(e.buf, 'shiftwidth', 2)
            end
        }
    }
}

local variables = {
    ['g'] = {
        ['fern#renderer'] = 'nerdfont',
        ['test#php#phpunit#executable'] = './vendor/bin/phpunit',
        ['gitgutter_map_keys'] = 0,
        ['gitgutter_signs'] = 0,
    },
    ['o'] = {
        ['termguicolors'] = true,
        ['hidden'] = true,
        ['equalalways'] = false,
        ['swapfile'] = false,
        ['expandtab'] = true,
        ['tabstop'] = 4,
        ['shiftwidth'] = 4,
        ['softtabstop'] = 4,
        ['number'] = true,
        ['list'] = true,
        ['listchars'] = 'tab:>-'
    }
}

vim.fn['plug#begin']('~/.config/nvim/plugged')

for name, opts in pairs(plugins) do
    if next(opts) ~= nil then
        vim.fn['plug#'](name, opts)
    else
        vim.fn['plug#'](name)
    end
end

vim.fn['plug#end']()

for _, args in pairs(keymaps) do
    vim.keymap.set(unpack(args))
end

for name, cmds in pairs(autocmds) do
    vim.api.nvim_create_augroup(name, {
        clear = true
    })
    for _, args in pairs(cmds) do
        vim.api.nvim_create_autocmd(args[1], {
            group = name,
            pattern = args[2],
            callback = args[3]
        })
    end
end

for scope, value in pairs(variables) do
    for key, val in pairs(value) do
        vim[scope][key] = val
    end
end

local cmp = require 'cmp'

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<c-k>'] = cmp.mapping.confirm({ select = true })
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' }
    },
    formatting = {
        format = require('lspkind').cmp_format({ with_text = true, maxwidth = 50 })
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    }
})

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    underline = false
})

for name, opts in pairs(require 'lsp'.settings) do
    require 'lspconfig'[name].setup(opts)
end

local telescope = require 'telescope'
local actions = require 'telescope.actions'
telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<c-j>"] = actions.move_selection_next,
                ["<c-k>"] = actions.move_selection_previous
            }
        }
    }
})

local lualine = require 'lualine'
local lualine_config = lualine.get_config()
lualine_config.extensions = { 'fern' }
lualine_config.sections.lualine_c = {
    {
        'filename',
        file_status = true,
        path = 1, -- relative path
        shorting_target = 40,
        symbols = {
            modified = '[+]', -- Text to show when the file is modified.
            readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
        }
    }
}

lualine.setup(lualine_config)

require 'nvim-treesitter.configs'.setup({
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    }
})

vim.cmd('colorscheme everforest')
