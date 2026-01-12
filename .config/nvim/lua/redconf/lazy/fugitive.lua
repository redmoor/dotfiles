return {
  "tpope/vim-fugitive",
  config = function()
		-- Create custom :G command that opens fugitive in full window
		vim.api.nvim_create_user_command('G', function(opts)
			vim.cmd('Git ' .. (opts.args or ''))
			vim.schedule(function()
				vim.cmd('only')
			end)
		end, { nargs = '*', complete = 'file' })
	end,
  init = function()
    vim.api.nvim_create_autocmd("User", {
            pattern = "FugitiveIndex",
            callback = function()
                -- remap = true is essential to trigger Fugitive's internal '='
                vim.keymap.set("n", "<Tab>", "=", { remap = true, buffer = true })
            end,
        })
  end
}
