return {
  -- load project-local rules from <root>/eslint/rules if present
  on_init = function(client)
    if client.root_dir and vim.uv.fs_stat(client.root_dir .. "/eslint/rules") then
      client.settings.options = vim.tbl_extend("force", client.settings.options or {}, {
        rulePaths = { "eslint/rules" },
      })
    end
  end,
}
