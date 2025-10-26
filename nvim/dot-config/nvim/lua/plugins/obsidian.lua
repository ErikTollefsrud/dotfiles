return {
  "obsidian-nvim/obsidian.nvim", -- https://github.com/obsidian-nvim/obsidian.nvim
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = false,
  ft = "markdown",
  -- Replace the above line with this if you want to load obsidian.nvim for markdown files in your vault:
  -- event {
  --  -- If you want to use shortcut '~' here you need to call 'vim.fn.expand'.
  --  -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-fault/*.md"
  --  -- refer to `:h file-pattern` for more examples.
  --  "BufReadPre path/to/my-vault/*.md",
  --  "BufReadFile path/to/my-vault/*md"
  -- },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = "work",
        path = "~/Documents/ObsidianVault",
      },
    },
  },
}
