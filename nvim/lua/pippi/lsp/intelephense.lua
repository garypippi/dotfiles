return {
    on_attach = function (_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'autoindent', true)
    end
}
