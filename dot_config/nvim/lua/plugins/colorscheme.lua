return {
  -- add gruvbox
  { "maxmx03/dracula.nvim" },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "neanias/everforest-nvim", name = "everforest" },
  { "ficcdaf/ashen.nvim", name = "ashen" },
  -- bru is vendored on the runtimepath at colors/bru-*.lua + lua/bru/,
  -- not installed as a plugin. See lua/bru/init.lua for update steps.
  -- deepsage lives the same way at colors/deepsage*.lua + lua/deepsage/;
  -- it mirrors the "Deep Sage" DankMaterialShell theme (dark + light).

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "deepsage",
    },
  },
}
