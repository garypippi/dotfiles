return {
    on_attach = function ()
        vim.cmd([[au BufWritePre <buffer> EslintFixAll]])
    end
}
