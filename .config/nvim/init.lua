local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
  {
    'rafamadriz/neon',
    config = function()
      vim.cmd[[colorscheme neon]]
    end
  },
  'editorconfig/editorconfig-vim',
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = {
          theme = 'neon',

          icons_enabled = false,
          theme = 'dracula',
          component_separators = { left = '|', right = '|'},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {},
          always_divide_middle = true,
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = {}
      })
    end
  },
  {
    'romgrk/barbar.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = {"node_modules"},
          hidden = true,
        },
        pickers = {
          find_files = {
            hidden = true
          }
        },
      })
    end
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
          sort_by = "case_sensitive",
          renderer = {
            group_empty = true,
          },
          filters = {
            dotfiles = true,
          },
          view = {
            width = 80,
          }
      })
    end
  },

  'neovim/nvim-lspconfig',
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {  },
      }
			require("mason-lspconfig").setup_handlers {
        function (server_name)
          require("lspconfig")[server_name].setup {
            on_attach = on_attach
          }
        end,
      }
    end
  },

  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'onsails/lspkind-nvim',
  'ray-x/cmp-treesitter'
})


-- Set barbar's options
vim.g.bufferline = {
  animation = true,
  icons = true,
  icon_custom_colors = true,
  icon_separator_active = '▎',
  icon_separator_inactive = '▎',
  icon_close_tab = '',
  icon_close_tab_modified = '●',
  icon_pinned = '📌',
}


-- lspのハンドラーに設定
capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

local cmp = require"cmp"
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  })
})

vim.g.neon_style = "dark"
vim.g.neon_italic_keyword = true
vim.g.neon_italic_function = true
vim.g.neon_transparent = true


local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- 矢印キーを無効化する
-- normal mode
map('n', '<Up>', '<Nop>', { noremap = true })
map('n', '<Down>', '<Nop>', { noremap = true })
map('n', '<Left>', '<Nop>', { noremap = true })
map('n', '<Right>', '<Nop>', { noremap = true })
map('n', '<Backspace>', '<Nop>', { noremap = true })
-- insert  mode
map('i', '<Up>', '<Nop>', { noremap = true })
map('i', '<Down>', '<Nop>', { noremap = true })
map('i', '<Left>', '<Nop>', { noremap = true })
map('i', '<Right>', '<Nop>', { noremap = true })
-- visual mode
map('v', '<Up>', '<Nop>', { noremap = true })
map('v', '<Down>', '<Nop>', { noremap = true })
map('v', '<Left>', '<Nop>', { noremap = true })
map('v', '<Right>', '<Nop>', { noremap = true })

-- vim 画面分割
map('n', 's', '<Nop>', { noremap = true })
map('n', 'sj', '<C-w>j', { noremap = true })
map('n', 'sk', '<C-w>k', { noremap = true })
map('n', 'sl', '<C-w>l', { noremap = true })
map('n', 'sh', '<C-w>h', { noremap = true })
map('n', 'sJ', '<C-w>J', { noremap = true })
map('n', 'sK', '<C-w>K', { noremap = true })
map('n', 'sL', '<C-w>L', { noremap = true })
map('n', 'sH', '<C-w>H', { noremap = true })
map('n', 'ss', ':<C-u>sp<CR>', { noremap = true })
map('n', 'sv', ':<C-u>vs<CR>', { noremap = true })


-- Move to previous/next
map('n', '<A-,>', ':BufferPrevious<CR>', opts)
map('n', '<A-.>', ':BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', ':BufferMovePrevious<CR>', opts)
map('n', '<A->>', ':BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<A-1>', ':BufferGoto 1<CR>', opts)
map('n', '<A-2>', ':BufferGoto 2<CR>', opts)
map('n', '<A-3>', ':BufferGoto 3<CR>', opts)
map('n', '<A-4>', ':BufferGoto 4<CR>', opts)
map('n', '<A-5>', ':BufferGoto 5<CR>', opts)
map('n', '<A-6>', ':BufferGoto 6<CR>', opts)
map('n', '<A-7>', ':BufferGoto 7<CR>', opts)
map('n', '<A-8>', ':BufferGoto 8<CR>', opts)
map('n', '<A-9>', ':BufferGoto 9<CR>', opts)
map('n', '<A-0>', ':BufferLast<CR>', opts)
-- Close buffer
map('n', '<A-c>', ':BufferClose<CR>', opts)


map('n', '<space>j', ':NvimTreeToggle<CR>', { noremap = true} )


map('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>', opts)
map('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', opts)
map('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>', opts)
map('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', opts)


vim.api.nvim_set_option('clipboard', 'unnamedplus')
vim.api.nvim_win_set_option(0, 'cursorline', true)
vim.api.nvim_win_set_option(0, 'number', true)
vim.api.nvim_buf_set_option(0, 'expandtab', true)
vim.api.nvim_buf_set_option(0, 'tabstop', 2)
vim.api.nvim_buf_set_option(0, 'shiftwidth', 2)
vim.api.nvim_buf_set_option(0, 'softtabstop', 2)

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.mouse = ""
