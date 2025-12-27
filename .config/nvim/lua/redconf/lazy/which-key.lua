return {
  "folke/which-key.nvim",
  event = "VimEnter", -- Sets the loading event to 'VimEnter'
  config = function()
    require("which-key").setup({
      preset = "classic",
      delay = 0,     -- Document existing key chains
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>l", group = "LSP"},
        { "<leader>s", group = "Search help" },
      },
      icons = {
        mappings = false,
      }
    })
  end,
}
