vim.pack.add({
  -- filer
  "https://github.com/lambdalisue/vim-fern",
  "https://github.com/lambdalisue/vim-nerdfont",
  "https://github.com/lambdalisue/vim-fern-renderer-nerdfont",
  "https://github.com/lambdalisue/vim-fern-git-status",
  "https://github.com/lambdalisue/vim-glyph-palette",
  -- fuzzy finder
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
})

-- fern
vim.g["fern#renderer"] = "nerdfont"
vim.keymap.set("n", "<Leader>r", ":Fern .<CR>", { silent = true })
vim.keymap.set("n", "-", ":Fern . -reveal=%:p<CR>", { silent = true })
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("glyph_palette", { clear = true }),
  pattern = { "fern" },
  command = "call glyph_palette#apply()",
})

-- telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>")
vim.keymap.set("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>")
vim.keymap.set("n", "<leader>gb", function()
  require("telescope.builtin").git_branches({
    attach_mappings = function()
      require("telescope.actions").select_default:replace(function()
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local branch_left = require("telescope.actions.state").get_selected_entry().value

        require("telescope.builtin").git_branches({
          prompt_title = "Branch to compare against " .. branch_left,
          attach_mappings = function()
            require("telescope.actions").select_default:replace(function()
              local utils = require("telescope.utils")
              local branch_right = require("telescope.actions.state").get_selected_entry().value
              local results = {}
              local output =
                utils.get_os_command_output(utils.__git_command({ "diff", branch_left, branch_right, "--name-only" }))
              for _, line in ipairs(output) do
                table.insert(results, line)
              end

              local putils = require("telescope.previewers.utils")

              pickers
                .new({}, {
                  prompt_title = "Comparing " .. branch_left .. " -> " .. branch_right,
                  previewer = require("telescope.previewers").new_buffer_previewer({
                    title = "Git File Diff Preview",
                    get_buffer_by_name = function(_, entry)
                      return entry.value
                    end,

                    define_preview = function(self, entry)
                      local cmd = utils.__git_command({ "--no-pager", "diff", branch_left, branch_right, entry.value })
                      putils.job_maker(cmd, self.state.bufnr, {
                        value = entry.value,
                        bufname = self.state.bufname,
                        callback = function(bufnr)
                          if vim.api.nvim_buf_is_valid(bufnr) then
                            putils.highlighter(bufnr, "diff")
                          end
                        end,
                      })
                    end,
                  }),
                  finder = finders.new_table({
                    results = results,
                  }),
                  sorter = conf.generic_sorter({}),
                })
                :find()
            end)
            return true
          end,
        })
      end)
      return true
    end,
  })
end)
