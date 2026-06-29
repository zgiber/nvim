-- Workaround: terraform-ls (0.38.7) emits semantic-tokens responses with
-- negative `deltaStartChar` values (seen in lsp.log as ~4294967238 = -58 wrapped
-- to uint32). LuaJIT reads these as ~4.29e9, and neovim's
-- runtime/lua/vim/lsp/semantic_tokens.lua accumulates them into start/end_char,
-- then spins for hundreds of millions of iterations in the
-- `while new_end_char > 0` loop (line ~144) on the main thread -> frozen UI.
--
-- Dropping the semanticTokensProvider capability for terraformls only stops
-- neovim from requesting/processing those tokens, while leaving all other LSP
-- features (and every other server's semantic tokens) intact. Remove this file
-- once terraform-ls stops emitting out-of-range deltas.
return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("terraformls_no_semantic_tokens", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          -- tofu-ls is a fork of terraform-ls and shares the same bug.
          if client and (client.name == "terraformls" or client.name == "tofuls") then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })
    end,
  },
}
