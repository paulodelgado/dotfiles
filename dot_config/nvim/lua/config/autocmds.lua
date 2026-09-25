-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- YAML is whitespace-significant, so anything that re-indents existing lines
-- can change what the file means.
-- * Never format yaml on save (<leader>cf still works if a formatter is added).
-- * Drop the `<:>`, `0-` and `0#` indentkeys: they re-indent the current line
--   as you type `:`, `-` or `#`, and the treesitter yaml indentexpr gets block
--   scalars (`run: |`) and comments wrong, flattening nested lines.
--   `o`/`O`/<CR> still auto-indent new lines.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_yaml", { clear = true }),
  pattern = { "yaml", "yaml.*" },
  callback = function()
    vim.b.autoformat = false
    vim.opt_local.indentkeys:remove({ "<:>", "0-", "0#" })
  end,
})
