return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  commit = vim.fn.has("nvim-0.12") == 0 and "7caec274fd19c12b55902a5b795100d21531391f" or nil,
  version = false, -- last release is way too old and doesn't work on Windows
  build = function()
    local TS = require("nvim-treesitter")
    if TS.get_installed then
      TS.update(nil, { summary = true })
    end
  end,
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
  opts_extend = { "ensure_installed" },
  ---@alias lazyvim.TSFeat { enable?: boolean, disable?: string[] }
  ---@class lazyvim.TSConfig: TSConfig
  opts = {
    -- LazyVim config for treesitter
    indent = { enable = true }, ---@type lazyvim.TSFeat
    highlight = { enable = true }, ---@type lazyvim.TSFeat
    folds = { enable = false }, ---@type lazyvim.TSFeat
    ensure_installed = {
      "bash",
      "c",
      "go",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  },
  ---@param opts lazyvim.TSConfig
  config = function(_, opts)
    local TS = require("nvim-treesitter")

    -- compilers check removed (LazyVim specific)

    -- some quick sanity checks
    if not TS.get_installed then
      vim.notify("Please use `:Lazy` and update `nvim-treesitter`", vim.log.levels.ERROR)
      return
    elseif type(opts.ensure_installed) ~= "table" then
      vim.notify("`nvim-treesitter` opts.ensure_installed must be a table", vim.log.levels.ERROR)
      return
    end

    -- setup treesitter
    TS.setup(opts)

    -- install missing parsers
    local function have_parser(lang)
      local ok, _ = pcall(vim.treesitter.language.inspect, lang)
      return ok
    end
    
    local install = vim.tbl_filter(function(lang)
      return not have_parser(lang)
    end, opts.ensure_installed or {})
    if #install > 0 then
      TS.install(install, { summary = true })
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_ft", { clear = true }),
      callback = function(ev)
        local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
        
        local function have_parser(check_lang)
          local ok, _ = pcall(vim.treesitter.language.inspect, check_lang)
          return ok
        end
        
        if not have_parser(ft) then
          return
        end

        ---@param feat string
        local function enabled(feat)
          local f = opts[feat] or {}
          return f.enable ~= false
            and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
        end

        -- highlighting
        if enabled("highlight") then
          pcall(vim.treesitter.start, ev.buf)
        end

        -- indents
        if enabled("indent") and vim.bo[ev.buf].indentexpr == "" then
          vim.bo[ev.buf].indentexpr = "v:lua.vim.treesitter.indent()"
        end

        -- folds
        if enabled("folds") and vim.wo.foldmethod == "manual" then
          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
      end,
    })
  end,
}
