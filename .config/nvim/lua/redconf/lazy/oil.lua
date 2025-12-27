return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		config = function()
			require("oil").setup({
				view_options = {
					show_hidden = true,
				},
				win_options = {
					signcolumn = "yes:2",
				},
				keymaps = {
					["<C-s>"] = false,
				},
			})
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
		lazy = false,
	},
	{
		"refractalize/oil-git-status.nvim",
		dependencies = {
			"stevearc/oil.nvim",
		},
		config = true,
	}
}
