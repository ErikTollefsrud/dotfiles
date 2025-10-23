return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- tag = "v0.9.3",
    opts = {
      ensure_installed = {
        "c",
        "vimdoc",
        "markdown",
        "javascript",
        "typescript",
        "css",
        "gitignore",
        "graphql",
        "http",
        "json",
        "scss",
        "sql",
        "vim",
        "lua",
        "swift",
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
    },
  },
}
