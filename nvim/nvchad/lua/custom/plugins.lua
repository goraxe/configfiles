local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  {
    "tpope/vim-obsession",
    lazy = false
  },

  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      require("notify").setup()
    end
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    dependencies = {
    "williamboman/mason-lspconfig.nvim",
    },
    opts = overrides.mason
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "github/copilot.vim",
    lazy = false
  },

  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  {
    "Fymyte/rasi.vim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    ft = "rasi",
    build = ':TSInstall rasi'
  },
  {
    "mustache/vim-mustache-handlebars",
    ft = { "mustache", "handlebars"},
    event = {"CmdlineEnter"}
  },
  {
    "stevearc/dressing.nvim"
  },
  {
    'creativenull/efmls-configs-nvim',
    --version = 'v1.x.x', -- version is optional, but recommended
    dependencies = { 'neovim/nvim-lspconfig' },
  },
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      vim.keymap.set({ "v", "n" }, "<leader>fc", require("actions-preview").code_actions)
    end,
    keys = {
      {"<leader>fc",  desc ="Find Code Actions"}
    }
  },

  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function ()
      vim.notify("doing a config of octo")
      require("telescope").load_extension('octo')
      vim.notify("done loading config")
    end,
    cmd = "Telescope octo",
  },

  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim'
    },
    config = function()
      require('telescope').load_extension('media_files')
    end,
    cmd = "Telescope media_files",
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
