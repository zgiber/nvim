return {
  -- Coverage visualization
  {
    "andythigpen/nvim-coverage",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "Coverage",
      "CoverageLoad",
      "CoverageLoadLcov",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
      "CoverageSummary",
    },
    keys = {
      { "<leader>tc", "<cmd>Coverage<cr>", desc = "Toggle Test Coverage" },
      { "<leader>tC", "<cmd>CoverageSummary<cr>", desc = "Coverage Summary" },
      { "<leader>tL", "<cmd>CoverageLoad<cr>", desc = "Load Coverage" },
    },
    opts = {
      auto_reload = true,
      auto_reload_timeout_ms = 500,
      -- Coverage file paths
      lcov_file = nil, -- Will be auto-detected
      -- Signs to display in the gutter
      signs = {
        covered = { hl = "CoverageCovered", text = "▎" },
        uncovered = { hl = "CoverageUncovered", text = "▎" },
        partial = { hl = "CoveragePartial", text = "▎" },
      },
      -- Highlight groups for covered/uncovered lines
      highlights = {
        covered = { fg = "#98c379" }, -- green
        uncovered = { fg = "#e06c75" }, -- red
        partial = { fg = "#e5c07b" }, -- yellow
      },
      summary = {
        min_coverage = 80.0,
      },
      lang = {
        go = {
          coverage_file = vim.fn.getcwd() .. "/coverage.out",
        },
      },
    },
    config = function(_, opts)
      require("coverage").setup(opts)
      
      -- Set up highlight groups
      vim.api.nvim_set_hl(0, "CoverageCovered", { fg = "#98c379", bold = true })
      vim.api.nvim_set_hl(0, "CoverageUncovered", { fg = "#e06c75", bold = true })
      vim.api.nvim_set_hl(0, "CoveragePartial", { fg = "#e5c07b", bold = true })
    end,
  },
  
  -- Configure neotest-go adapter for LazyVim's test extras
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = {
      adapters = {
        ["neotest-go"] = {
          experimental = {
            test_table = true,
          },
          args = { "-v", "-race", "-count=1", "-coverprofile=coverage.out" },
        },
      },
    },
  },
}
