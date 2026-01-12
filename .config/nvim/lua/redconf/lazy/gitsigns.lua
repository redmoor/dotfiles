return { -- Adds git related signs to the gutter, as well as utilities for managing changes
	"lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup{
      opts = {
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      },
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', '<leader>gn', function()
          if vim.wo.diff then
            vim.cmd.normal({'<leader>gn', bang = true})
          else
            gitsigns.nav_hunk('next')
          end
        end,
          {
            desc = "Next git hunk"
          }
        )

        map('n', '<leader>gp', function()
          if vim.wo.diff then
            vim.cmd.normal({'<leader>gp', bang = true})
          else
            gitsigns.nav_hunk('prev')
          end
        end,
          {
            desc = "Previous git hunk"
          }
        )

        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = "Stage hunk" })
        map('n', '<leader>gr', gitsigns.reset_hunk, { desc = "Reset hunk" })

        map('v', '<leader>gs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = "Stage hunk" })

        map('v', '<leader>gr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = "Reset hunk" })

        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = "Stage buffer" })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = "Reset buffer" })
      end
    }
  end
}
