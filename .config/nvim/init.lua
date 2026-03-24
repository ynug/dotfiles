vim.loader.enable()

-- ============================================================================
-- bootstrap lazy.nvim
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- leaders
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- disable unused providers to reduce health noise
-- ============================================================================
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- ============================================================================
-- basic options
-- ============================================================================
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.mouse = ""
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- ============================================================================
-- keymaps
-- ============================================================================
for _, mode in ipairs({ "n", "i", "v" }) do
  for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
    vim.keymap.set(mode, key, "<Nop>", { noremap = true })
  end
end
vim.keymap.set("n", "<Backspace>", "<Nop>", { noremap = true })

vim.keymap.set("n", "s", "<Nop>", { noremap = true })
vim.keymap.set("n", "sj", "<C-w>j", { noremap = true })
vim.keymap.set("n", "sk", "<C-w>k", { noremap = true })
vim.keymap.set("n", "sl", "<C-w>l", { noremap = true })
vim.keymap.set("n", "sh", "<C-w>h", { noremap = true })
vim.keymap.set("n", "sJ", "<C-w>J", { noremap = true })
vim.keymap.set("n", "sK", "<C-w>K", { noremap = true })
vim.keymap.set("n", "sL", "<C-w>L", { noremap = true })
vim.keymap.set("n", "sH", "<C-w>H", { noremap = true })
vim.keymap.set("n", "ss", "<Cmd>sp<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "sv", "<Cmd>vs<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "H", "<Cmd>bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "L", "<Cmd>bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bd", "<Cmd>bd<CR>", { noremap = true, silent = true })

-- ============================================================================
-- plugins
-- ============================================================================
require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon",
      })
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules" },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<CR>"] = { "accept", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
      signature = {
        enabled = true,
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      local servers = {
        html = {},
        cssls = {},
        ts_ls = {},
        angularls = {},
        jsonls = {},
        eslint = {},
        emmet_language_server = {},
      }

      for name, conf in pairs(servers) do
        vim.lsp.config(name, vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, conf))
        vim.lsp.enable(name)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }

          local map = function(lhs, rhs)
            vim.keymap.set("n", lhs, rhs, opts)
          end

          map("K", vim.lsp.buf.hover)
          map("gd", vim.lsp.buf.definition)
          map("gD", vim.lsp.buf.declaration)
          map("gr", vim.lsp.buf.references)
          map("gi", vim.lsp.buf.implementation)
          map("gt", vim.lsp.buf.type_definition)
          map("gn", vim.lsp.buf.rename)
          map("ga", vim.lsp.buf.code_action)
          map("ge", vim.diagnostic.open_float)
          map("g]", vim.diagnostic.goto_next)
          map("g[", vim.diagnostic.goto_prev)
          map("gf", function()
            vim.lsp.buf.format({ async = true })
          end)
        end,
      })
    end,
  },
})
