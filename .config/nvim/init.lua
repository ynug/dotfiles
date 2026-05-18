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
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        enabled = true,
        sources = {
          files = {
            hidden = true,
            ignored = false,
            exclude = {
              "node_modules",
              ".git",
              "dist",
              "coverage",
            },
          },
          grep = {
            hidden = true,
            ignored = false,
            exclude = {
              "node_modules",
              ".git",
              "dist",
              "coverage",
            },
          },
        },
      },
      explorer = {
        enabled = true,
      },
      notifier = {
        enabled = true,
      },
      input = {
        enabled = true,
      },
      quickfile = {
        enabled = true,
      },
      statuscolumn = {
        enabled = true,
      },
    },
    keys = {
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
  
      { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
  
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols" },
      { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup({})
  
      local parsers = {
        "typescript",
        "javascript",
        "tsx",
        "html",
        "css",
        "scss",
        "json",
        "yaml",
        "lua",
        "bash",
        "markdown",
        "markdown_inline",
      }
  
      require("nvim-treesitter").install(parsers)
  
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    keys = {
      {
        "gf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format",
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      -- format_on_save = {
        -- timeout_ms = 2000,
        -- lsp_format = "fallback",
      -- },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
  
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            silent = true,
            desc = desc,
          })
        end
  
        map("n", "]h", gs.next_hunk, "Next git hunk")
        map("n", "[h", gs.prev_hunk, "Prev git hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage hunk")
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", gs.blame_line, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
      end,
    },
  },

  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gb" },
    opts = {},
  },

  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gb" },
    opts = {},
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
        jsonls = {},
  
        vtsls = {
          settings = {
            typescript = {
              preferences = {
                importModuleSpecifier = "non-relative",
                includePackageJsonAutoImports = "auto",
              },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
            javascript = {
              preferences = {
                importModuleSpecifier = "non-relative",
                includePackageJsonAutoImports = "auto",
              },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },
  
        angularls = {
          root_markers = {
            "angular.json",
            "project.json",
          },
        },
  
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
  
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, {
              desc = desc,
            }))
          end
  
          map("K", vim.lsp.buf.hover, "Hover")
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", vim.lsp.buf.references, "References")
          map("gi", vim.lsp.buf.implementation, "Implementation")
          map("gt", vim.lsp.buf.type_definition, "Type definition")
          map("gn", vim.lsp.buf.rename, "Rename")
          map("ga", vim.lsp.buf.code_action, "Code action")
          map("ge", vim.diagnostic.open_float, "Line diagnostics")
          map("g]", vim.diagnostic.goto_next, "Next diagnostic")
          map("g[", vim.diagnostic.goto_prev, "Previous diagnostic")
  
          map("gf", function()
            require("conform").format({ async = true, lsp_format = "fallback" })
          end, "Format")
        end,
      })
    end,
  },
})
