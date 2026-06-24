return {
  -- markdownlint (MD### diagnostics) is noisy in prose, so keep it off by
  -- default and expose a toggle. <leader>um turns it on/off per session.
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}

      -- Remember the markdown linters LazyVim configured, then disable them.
      local saved = opts.linters_by_ft.markdown or { "markdownlint-cli2" }
      opts.linters_by_ft.markdown = {}
      vim.g.markdown_lint_enabled = false

      local function clear_md_diagnostics()
        for ns, info in pairs(vim.diagnostic.get_namespaces()) do
          if info.name and info.name:match("markdownlint") then
            vim.diagnostic.reset(ns)
          end
        end
      end

      vim.keymap.set("n", "<leader>um", function()
        local lint = require("lint")
        if vim.g.markdown_lint_enabled then
          vim.g.markdown_lint_enabled = false
          lint.linters_by_ft.markdown = {}
          clear_md_diagnostics()
          vim.notify("Markdown lint disabled", vim.log.levels.INFO, { title = "markdownlint" })
        else
          vim.g.markdown_lint_enabled = true
          lint.linters_by_ft.markdown = saved
          if vim.bo.filetype == "markdown" then
            lint.try_lint()
          end
          vim.notify("Markdown lint enabled", vim.log.levels.INFO, { title = "markdownlint" })
        end
      end, { desc = "Toggle Markdown Lint" })
    end,
  },
}
