local function server(root)
  return root .. "/venv/bin/basedpyright-langserver"
end

return {
  -- attach only when the project's venv has basedpyright
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, "venv")
    if root and vim.fn.executable(server(root)) == 1 then
      on_dir(root)
    end
  end,
  -- and run that one
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start(
      { server(config.root_dir), "--stdio" },
      dispatchers,
      { cwd = config.cmd_cwd or config.root_dir, env = config.cmd_env }
    )
  end,
}
