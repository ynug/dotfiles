require'plugins'
vim.cmd[[autocmd BufWritePost plugins.lua PackerCompile]]

require'lualine'.setup {
  options = {
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
}


-- Set barbar's options
vim.g.bufferline = {
  icons = false,
  icon_separator_active = '▎',
  icon_separator_inactive = '▎',
  icon_close_tab = '',
  icon_close_tab_modified = '●',
  icon_pinned = '📌',
}


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



vim.api.nvim_set_option('clipboard', 'unnamedplus')
vim.api.nvim_win_set_option(0, 'cursorline', true)
vim.api.nvim_win_set_option(0, 'number', true)
vim.api.nvim_buf_set_option(0, 'expandtab', true)
vim.api.nvim_buf_set_option(0, 'tabstop', 2)
vim.api.nvim_buf_set_option(0, 'shiftwidth', 2)
vim.api.nvim_buf_set_option(0, 'softtabstop', 2)
