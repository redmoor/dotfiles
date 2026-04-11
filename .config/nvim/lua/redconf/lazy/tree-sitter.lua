return {
	"romus204/tree-sitter-manager.nvim",
	lazy = false,
	opts = {
		-- Directory where parsers will be installed
		install_dir = vim.fn.stdpath("data") .. "/site/parser",
		-- Parsers to ensure are installed
		ensure_installed = {
			"bash",
			"c",
			"cpp",
			"css",
			"diff",
			"go",
			"gomod",
			"gowork",
			"gosum",
			"html",
			"javascript",
			"json",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"rust",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
		},
		-- Automatically install parsers when opening files
		auto_install = true,
	},
	config = function(_, opts)
		require("tree-sitter-manager").setup(opts)

		-- Ensure runtimepath includes parser directory for native treesitter to find parsers
		vim.opt.runtimepath:prepend(opts.install_dir)

		-- ============================================================================
		-- Native Tree-sitter Configuration (Neovim 0.12+)
		-- ============================================================================

		-- Treesitter-based folding
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldlevel = 99 -- Start with all folds open
		vim.opt.foldtext = ""

    vim.treesitter.language.register('tsx', 'typescriptreact')
    vim.treesitter.language.register('javascript', 'javascriptreact')

		-- Enable native treesitter highlighting and indentation for any filetype with a parser available
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(args.match)
				if not lang then
					return
				end

				-- Check if parser exists for this language
				local has_parser = pcall(vim.treesitter.language.inspect, lang)
				if not has_parser then
					return
				end

				-- Enable syntax highlighting
				pcall(vim.treesitter.start, args.buf, lang)

				-- Enable treesitter-based indentation (disabled - using smartindent instead)
				-- vim.bo[args.buf].indentexpr = "v:lua.require'vim.treesitter'.indentexpr()"
			end,
		})

		-- Function highlight groups
		vim.api.nvim_set_hl(0, "@function", { link = "Function" })
		vim.api.nvim_set_hl(0, "@function.call", { link = "Function" })
		vim.api.nvim_set_hl(0, "@function.method", { link = "Function" })
		vim.api.nvim_set_hl(0, "@function.method.call", { link = "Function" })
		vim.api.nvim_set_hl(0, "@method", { link = "Function" })
		vim.api.nvim_set_hl(0, "@method.call", { link = "Function" })

		-- Keymap for TSManager
		vim.keymap.set("n", "<leader>t", ":TSManager<CR>", { desc = "Open [T]ree-sitter Manager", silent = true })
	end,
}
