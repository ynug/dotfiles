vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

--  use {
--    'romgrk/barbar.nvim',
--    requires = {'kyazdani42/nvim-web-devicons'}
--  }

--  use {
--    'nvim-telescope/telescope.nvim',
--    requires = { {'nvim-lua/plenary.nvim'} }
--  }
end)

