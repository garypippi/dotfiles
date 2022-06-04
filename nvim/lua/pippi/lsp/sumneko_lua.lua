return {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = {'lua/?.lua', 'lua/?/init.lua'}
            },
            diagnostics = {
                globals = {'vim'}
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true)
            },
            telemetry = {
                enable = false
            }
        }
    }
}
