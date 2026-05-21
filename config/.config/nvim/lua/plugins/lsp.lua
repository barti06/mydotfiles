return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        clangd = {
          mason = false,
        },
        cmd = {
          "clangd",
          "--background-index",
          "--header-insertion=never", -- stop automatic header insertion
          -- "--fallback-style=none", -- no formatting
          "--completion-style=detailed",
        },
        lua_ls = { mason = false },
        pyright = { mason = false },
        ts_ls = { mason = false },
        bashls = { mason = false },
        nixd = { mason = false },
        cmake = { mason = false },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {},
      automatic_installation = false,
    },
  },
}
