return {
  -- add gruvbox
  { "maxmx03/dracula.nvim" },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "neanias/everforest-nvim", name = "everforest" },
  { "ficcdaf/ashen.nvim", name = "ashen" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
