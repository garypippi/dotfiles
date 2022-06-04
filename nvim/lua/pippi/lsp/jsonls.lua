local cap = vim.lsp.protocol.make_client_capabilities()
cap.textDocument.completion.completionItem.snippetSupport = true

return {
    capabilities = cap,
    settings = {
        json = {
            schemas = {
                { fileMatch = {'tsconfig.json'}, url = 'http://json.schemastore.org/tsconfig' },
                { fileMatch = {'.eslintrc.json'}, url = 'http://json.schemastore.org/eslintrc' }
            }
        }
    }
}
