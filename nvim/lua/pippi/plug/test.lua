local PippiPlug = require'pippi.plug'

return PippiPlug.new({
    plugs = {
        ['janko/vim-test'] = {}
    },
    keymap = {
        {'n', '<leader>tf', ':TestFile<cr>',    { silent = true }},
        {'n', '<leader>tn', ':TestNearest<cr>', { silent = true }},
        {'n', '<leader>tt', ':TestSuite<cr>',   { silent = true }},
        {'n', '<leader>tl', ':TestLast<cr>',    { silent = true }},
        {'n', '<leader>tv', ':TestVisit<cr>',   { silent = true }}
    },
    variable = {
        ['g'] = {
            ['test#php#phpunit#executable'] = './vendor/bin/phpunit'
        }
    }
})
