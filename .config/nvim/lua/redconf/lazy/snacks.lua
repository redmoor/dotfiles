return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      enabled = true,
      ui_select = true,
      layout = {
        preset = "ivy"
      },
      main = {
        current = true,
      },
    },
  },
  keys = {
    { "<leader>ff", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fe", function() Snacks.explorer() end, desc = "File Explorer" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>lt", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
  }
}
