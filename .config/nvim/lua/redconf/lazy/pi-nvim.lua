return {
  "carderne/pi-nvim",
  config = function ()
    require("pi-nvim").setup()
  end,
  keys = {
    { "<leader>pp", ":PiSend<CR>", desc = "Pi Send" },
    { "<leader>pf", ":PiSendFile<CR>", desc = "Pi Send File" },
    { "<leader>ps", ":PiSendSelection<CR>", mode = "v", desc = "Pi Send Selection" },
    { "<leader>pb", ":PiSendBuffer<CR>", desc = "Pi Send Buffer" },
    { "<leader>pi", ":PiPing<CR>", desc = "Pi Ping" },
  },
}
