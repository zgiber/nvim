return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>si", false }, -- disable Icons picker, using for incoming calls
  },
  opts = {
    picker = {
      sources = {
        explorer = {
          actions = {
            -- Setting the explorer root also changes Neovim's global cwd (:cd).
            explorer_focus = function(picker)
              picker:set_cwd(picker:dir())
              vim.cmd.cd({ args = { picker:cwd() } })
              picker:find()
            end,
            explorer_up = function(picker)
              picker:set_cwd(vim.fs.dirname(picker:cwd()))
              vim.cmd.cd({ args = { picker:cwd() } })
              picker:find()
            end,
          },
        },
      },
    },
  },
}
