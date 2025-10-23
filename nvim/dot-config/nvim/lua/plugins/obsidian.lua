return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = false,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "Work",
        path = "~/Documents/ObsidianVault",
      },
      -- {
      --   name = "Coding Notes",
      --   path = "~/Documents/Coding Notes",
      -- },
    },
  },
}
