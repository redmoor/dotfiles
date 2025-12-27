vim.keymap.set(
  "n",
  "<leader>e",
  "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

vim.api.nvim_create_user_command('Godoc', function(opts)
  local doc_command = 'go doc ' .. opts.args
  local output = vim.fn.systemlist(doc_command)
  vim.cmd('vnew')
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, output)
  vim.bo.filetype = 'go'
  vim.cmd('setlocal buftype=nofile bufhidden=hide nobuflisted')
end, { nargs = '*', complete = 'shellcmd' })

vim.o.tabstop = 8
vim.o.shiftwidth = 8
vim.o.expandtab = false

vim.cmd [[set errorformat^=vet:\ %f:%l:%c:\ %m]] -- go vet (important to prepend, otherwise 'vet' will be a part of the file path)
