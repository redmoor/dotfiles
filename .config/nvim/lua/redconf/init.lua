-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("redconf.lazy_init")
require("redconf.set")
require("redconf.remap")
