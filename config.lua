--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "carbonfox"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<leader>D"] = "\"_d"

-- lvim.keys.normal_mode["dI"] = "di%"
local keymap = vim.keymap.set;
--duplicate line
keymap("n", "<M-S-j>", ":t.<CR>")
keymap("i", "<M-S-j>", "<ESC>:t.<CR>a")
keymap("v", "<M-S-j>", "yk<ESC>p")

--ci and di commands
keymap("n", "c(", "ci(")
keymap("n", "c{", "ci{")
keymap("n", "c[", "ci[")
keymap("n", "c\"", "ci\"")
keymap("n", "d\"", "di\"")
keymap("n", "d(", "di(")
keymap("n", "d{", "di{")
keymap("n", "d[", "di[")

--delete without getting it into clipboard
keymap("v", "<leader>D", "\"_d")
--goto preview bindings
vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")


-- example mappings you can place in some other place
-- An awesome method to jump to windows
local picker = require('window-picker')

vim.keymap.set("n", ",w", function()
  local picked_window_id = picker.pick_window({
    include_current_win = true
  }) or vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(picked_window_id)
end, { desc = "pick a window" })

-- swap two windows using the awesome window picker
local function swap_windows()
  local window = picker.pick_window({
    include_current_win = false
  })
  local target_buffer = vim.fn.winbufnr(window)
  vim.api.nvim_win_set_buf(window, 0)
  vim.api.nvim_win_set_buf(0, target_buffer)
end

vim.keymap.set('n', ',W', swap_windows, { desc = 'swap windows' })
--hop word
vim.keymap.set('n', '<leader>H', ":HopWord<CR>")
-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["<leader>"] = { "<cmd> Telescope oldfiles<CR>", "Recent opend files" }
table.insert(lvim.builtin.which_key.mappings["l"], 1, {
  o = { "<cmd>SymbolsOutline<CR>", "Outline" }
})

table.insert(lvim.builtin.which_key.mappings["l"], 1, {
  R = { "<cmd>Telescope lsp_references<CR>", "References" }
})
table.insert(lvim.builtin.which_key.mappings["b"], 1, {
  a = { "<cmd> Telescope buffers <CR>", "Opend Buffers" }
})
lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true
vim.opt.clipboard = "unnamedplus"
lvim.builtin.lualine.style = "lvim"
lvim.plugins = {
  -- { "prettier/vim-prettier" },
  { "pantharshit00/vim-prisma" },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      vim.schedule(function()
        require("copilot").setup()
      end)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup(
        {
          method = "getCompletionsCycling",
        }
      )
    end
  },
  { "rmagatti/goto-preview",
    config = function()
      require('goto-preview').setup {
        width = 120; -- Width of the floating window
        height = 25; -- Height of the floating window
        default_mappings = true; -- Bind default mappings
        debug = false; -- Print debug information
        opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
      }
    end
  },
  { "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end
  }
  , {
    "simrat39/symbols-outline.nvim",
    config = function()
      require('symbols-outline').setup()
    end
  },
  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit",
        },
        lastplace_open_folds = true,
      })
    end,
  },
  {
    "felipec/vim-sanegx",
    event = "BufRead",
  },
  {
    "ahmedkhalf/lsp-rooter.nvim",
    event = "BufRead",
    config = function()
      require("lsp-rooter").setup()
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  {
    'marko-cerovac/material.nvim'
  },
  {
    "echasnovski/mini.map",
    branch = "stable",
    config = function()
      require('mini.map').setup()
      local map = require('mini.map')
      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic({
            error = 'DiagnosticFloatingError',
            warn  = 'DiagnosticFloatingWarn',
            info  = 'DiagnosticFloatingInfo',
            hint  = 'DiagnosticFloatingHint',
          }),
        },
        symbols = {
          encode = map.gen_encode_symbols.dot('4x2'),
        },
        window = {
          side = 'right',
          width = 20, -- set to 1 for a pure scrollbar :)
          winblend = 15,
          show_integration_count = false,
          -- opacity = 1.0
        },
      })
    end
  },
  {
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    tag = "1.*",
    config = function()
      require("window-picker").setup({
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },

            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal" },
          },
        },
        other_win_hl_color = "#e35e4f",
      })
    end,
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 0
    end,
  },
  {
    "p00f/nvim-ts-rainbow",
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    module = "persistence",
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  {
    "tpope/vim-surround",
    setup = function()
      vim.o.timeoutlen = 500
    end
  },
  {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },
  {
    "EdenEast/nightfox.nvim"
  }
}
-- lvim.autocommands = {
--   {
--     { "BufEnter", "Filetype" },
--     {
--       desc = "Open mini.map and exclude some filetypes",
--       pattern = { "*" },
--       callback = function()
--         local exclude_ft = {
--           "qf",
--           "NvimTree",
--           "toggleterm",
--           "TelescopePrompt",
--           "alpha",
--           "netrw",
--         }

--         local map = require('mini.map')
--         if vim.tbl_contains(exclude_ft, vim.o.filetype) then
--           vim.b.minimap_disable = true
--           map.close()
--         elseif vim.o.buftype == "" then
--           map.open()
--         end
--       end,
--     },
--   },
-- }

require("lvim.lsp.manager").setup("angularls")
require("lvim.lsp.manager").setup("emmet_ls")
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    exe = "prettier",
    filetypes = { "typescript", "typescriptreact", "html", "javascript", "javascriptreact", "css" },
  },
}
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    exe = "eslint",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", },
  }
}
lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })
vim.g.tokyonight_style = "night"
vim.opt.rnu = true
lvim.builtin.treesitter.rainbow.enable = true
