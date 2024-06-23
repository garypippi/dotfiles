return {
    'lambdalisue/fern.vim',
    branch = 'main',
    dependencies = {
        'lambdalisue/nerdfont.vim',
        'lambdalisue/fern-renderer-nerdfont.vim',
        'lambdalisue/fern-git-status.vim',
        'lambdalisue/glyph-palette.vim'
    },
    init = function ()
        vim.g['fern#renderer'] = 'nerdfont'
        vim.keymap.set('n', '<Leader>r', ':Fern .<CR>', { silent = true })
        vim.keymap.set('n', '-', ':Fern . -reveal=%:p<CR>', { silent = true })
        vim.api.nvim_create_augroup('glyph_palette', {
            clear = true
        })
        vim.api.nvim_create_autocmd('FileType', {
            group = 'glyph_palette',
            pattern = { 'fern' },
            command = 'call glyph_palette#apply()'
        })
    end
}
