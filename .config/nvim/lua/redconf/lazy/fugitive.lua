return {
  "tpope/vim-fugitive",
  config = fucntion()
  -- Recreate G command that opens fugitive in full window
    vim.api.nvim_create_user_command("G", function(opts)
      vim.cmd("Git" .. (opts.args or ''))
      vim.schedule(function()
        vim.cmd('only')
      end)
    end, {nargs = '*', complete = 'file'})
  end
}
