return {
  -- Disable autocomplete documentation popup
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        documentation = {
          auto_show = false,
        },
      },
    },
  },

  -- Formatter for starlark/bazel files
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        starlark = { "buildifier" },
        bzl = { "buildifier" },
      },
    },
  },

  -- Disable golangci-lint LSP
  -- Configure staticcheck in gopls to ignore ST1000/ST1003
  -- Disable inlay hints
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        golangci_lint_ls = { enabled = false },
        gopls = {
          settings = {
            gopls = {
              staticcheck = true,
              analyses = {
                ST1000 = false,
                ST1003 = false,
              },
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
            },
          },
        },
        starpls = {
          filetypes = { "starlark", "bzl" },
        },
      },
    },
  },
}
