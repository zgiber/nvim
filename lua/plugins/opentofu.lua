-- statiq (and every project here) uses OpenTofu (`tofu`), not Terraform.
--
-- LazyVim's `lang.terraform` extra wires the whole HashiCorp toolchain
-- (terraform-ls + the terraform_validate linter + terraform_fmt). All of it
-- resolves bare provider sources like `carlpett/sops` against
-- registry.terraform.io, while a tofu-initialized project pins them to
-- registry.opentofu.org in .terraform.lock.hcl. The mismatch makes `terraform
-- validate` (run by the linter) emit bogus
--   Error: Missing required provider ... registry.terraform.io/carlpett/sops
-- even though `tofu validate` succeeds. This file swaps every piece of the
-- toolchain to its OpenTofu equivalent.

return {
  -- LSP: tofu-ls instead of terraform-ls. lspconfig ships no `tofuls` base
  -- config in this version, so we provide cmd/filetypes/root_markers inline.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = { enabled = false },
        tofuls = {
          cmd = { "tofu-ls", "serve" },
          filetypes = { "terraform", "terraform-vars", "hcl" },
          root_markers = { ".terraform", ".git" },
        },
      },
    },
  },

  -- Install the tofu-ls binary (mason package `tofu-ls`).
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "tofu-ls" } },
  },

  -- Linter: `tofu validate` instead of `terraform validate`. Explicit
  -- assignment (not list_extend) so terraform_validate is fully replaced.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.terraform = { "tofu" }
      opts.linters_by_ft.tf = { "tofu" }
      opts.linters_by_ft.hcl = { "tofu" }
    end,
  },

  -- Formatter: `tofu fmt` instead of `terraform fmt`.
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.terraform = { "tofu_fmt" }
      opts.formatters_by_ft.tf = { "tofu_fmt" }
      opts.formatters_by_ft["terraform-vars"] = { "tofu_fmt" }
      opts.formatters_by_ft.hcl = { "tofu_fmt" }
    end,
  },
}
