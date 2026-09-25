-- bru.nvim — a lekker colorscheme
-- https://github.com/kmf/bru
--
-- Vendored from editors/neovim/ in that repo (the theme lives in a subdir, so
-- it can't be installed as a lazy.nvim plugin). To update:
--   git -C ~/.local/share/bru pull
--   cp ~/.local/share/bru/editors/neovim/lua/bru/init.lua ~/.config/nvim/lua/bru/init.lua
--   cp ~/.local/share/bru/editors/neovim/colors/bru-*.lua ~/.config/nvim/colors/

local M = {}

M.palettes = {
  ["bru-espresso"] = {
    bg       = "#1c1814",
    bg_soft  = "#26211c",
    bg_hi    = "#322b23",
    border   = "#3a332b",
    fg       = "#f5e8c7",
    fg_alt   = "#fbf3db",
    fg_muted = "#8a7f6f",
    yellow   = "#dbb32d",
    orange   = "#ed8649",
    red      = "#fa5750",
    magenta  = "#f275be",
    violet   = "#af88eb",
    blue     = "#4695f7",
    teal     = "#41c7b9",
    green    = "#75b938",
    br_red     = "#ff665c",
    br_green   = "#84c747",
    br_yellow  = "#ebc13d",
    br_blue    = "#58a3ff",
    br_magenta = "#ff84cd",
    br_teal    = "#53d6c7",
    br_orange  = "#f19058",
    br_violet  = "#be9af5",
    diff_add_bg = "#1f2a1b",
    diff_del_bg = "#2e1f1d",
    diff_chg_bg = "#2a2518",
  },
  ["bru-latte"] = {
    bg       = "#faf3e0",
    bg_soft  = "#f3ead0",
    bg_hi    = "#ece3cc",
    border   = "#e0d4b0",
    fg       = "#3a2f22",
    fg_alt   = "#2d241a",
    fg_muted = "#8a7f6f",
    yellow   = "#ad8900",
    orange   = "#c25d1e",
    red      = "#d2212d",
    magenta  = "#ca4898",
    violet   = "#8762c6",
    blue     = "#0072d4",
    teal     = "#009c8f",
    green    = "#489100",
    br_red     = "#cc1729",
    br_green   = "#428b00",
    br_yellow  = "#a78300",
    br_blue    = "#006dce",
    br_magenta = "#c44392",
    br_teal    = "#00978a",
    br_orange  = "#bb5617",
    br_violet  = "#815cc0",
    diff_add_bg = "#e8efd4",
    diff_del_bg = "#f3dcd8",
    diff_chg_bg = "#f0e8c4",
  },
}

function M.setup(opts)
  opts = opts or {}
  M.variant = opts.variant or "bru-espresso"
end

function M.load()
  local variant = M.variant or "bru-espresso"
  local p = M.palettes[variant]
  if not p then
    vim.notify("bru: unknown variant '" .. variant .. "'", vim.log.levels.ERROR)
    return
  end

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  vim.o.termguicolors = true
  vim.o.background = variant == "bru-latte" and "light" or "dark"
  vim.g.colors_name = variant

  local function hi(group, opts_hi)
    vim.api.nvim_set_hl(0, group, opts_hi)
  end

  -- ── UI ─────────────────────────────────────────────
  hi("Normal",       { fg = p.fg, bg = p.bg })
  hi("NormalFloat",  { fg = p.fg, bg = p.bg_soft })
  hi("NormalNC",     { fg = p.fg, bg = p.bg })
  hi("FloatBorder",  { fg = p.border, bg = p.bg_soft })
  hi("FloatTitle",   { fg = p.yellow, bg = p.bg_soft, bold = true })

  hi("Cursor",       { fg = p.bg, bg = p.yellow })
  hi("CursorLine",   { bg = p.bg_soft })
  hi("CursorColumn", { bg = p.bg_soft })
  hi("CursorLineNr", { fg = p.yellow, bold = true })
  hi("LineNr",       { fg = p.border })
  hi("SignColumn",   { bg = p.bg })

  hi("Visual",       { bg = p.bg_hi })
  hi("VisualNOS",    { bg = p.bg_hi })

  hi("Search",       { fg = p.bg, bg = p.yellow })
  hi("IncSearch",    { fg = p.bg, bg = p.orange })
  hi("CurSearch",    { fg = p.bg, bg = p.orange, bold = true })
  hi("Substitute",   { fg = p.bg, bg = p.red })

  hi("Pmenu",        { fg = p.fg, bg = p.bg_soft })
  hi("PmenuSel",     { fg = p.bg, bg = p.yellow })
  hi("PmenuSbar",    { bg = p.bg_hi })
  hi("PmenuThumb",   { bg = p.border })

  hi("StatusLine",   { fg = p.fg, bg = p.bg_soft })
  hi("StatusLineNC", { fg = p.fg_muted, bg = p.bg_soft })
  hi("TabLine",      { fg = p.fg_muted, bg = p.bg_soft })
  hi("TabLineFill",  { bg = p.bg })
  hi("TabLineSel",   { fg = p.yellow, bg = p.bg_hi, bold = true })
  hi("WinBar",       { fg = p.fg, bg = p.bg })
  hi("WinBarNC",     { fg = p.fg_muted, bg = p.bg })
  hi("WinSeparator", { fg = p.border })

  hi("Folded",       { fg = p.fg_muted, bg = p.bg_soft })
  hi("FoldColumn",   { fg = p.border })

  hi("MatchParen",   { fg = p.yellow, bg = p.bg_hi, bold = true })

  hi("Directory",    { fg = p.blue })
  hi("Title",        { fg = p.yellow, bold = true })
  hi("Question",     { fg = p.blue })
  hi("MoreMsg",      { fg = p.teal })
  hi("WarningMsg",   { fg = p.orange })
  hi("ErrorMsg",     { fg = p.red, bold = true })

  hi("NonText",      { fg = p.border })
  hi("Whitespace",   { fg = p.border })
  hi("SpecialKey",   { fg = p.border })
  hi("Conceal",      { fg = p.fg_muted })

  -- ── Diff ───────────────────────────────────────────
  hi("DiffAdd",      { bg = p.diff_add_bg })
  hi("DiffChange",   { bg = p.diff_chg_bg })
  hi("DiffDelete",   { fg = p.red, bg = p.diff_del_bg })
  hi("DiffText",     { fg = p.fg_alt, bg = p.diff_chg_bg, bold = true })
  hi("Added",        { fg = p.green })
  hi("Changed",      { fg = p.yellow })
  hi("Removed",      { fg = p.red })

  -- ── Diagnostics ────────────────────────────────────
  hi("DiagnosticError",        { fg = p.red })
  hi("DiagnosticWarn",         { fg = p.orange })
  hi("DiagnosticInfo",         { fg = p.blue })
  hi("DiagnosticHint",         { fg = p.teal })
  hi("DiagnosticOk",           { fg = p.green })
  hi("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
  hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = p.orange })
  hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = p.blue })
  hi("DiagnosticUnderlineHint",  { undercurl = true, sp = p.teal })
  hi("DiagnosticVirtualTextError", { fg = p.red, bg = p.diff_del_bg })
  hi("DiagnosticVirtualTextWarn",  { fg = p.orange, bg = p.diff_chg_bg })
  hi("DiagnosticVirtualTextInfo",  { fg = p.blue, bg = p.bg_soft })
  hi("DiagnosticVirtualTextHint",  { fg = p.teal, bg = p.bg_soft })

  -- ── Syntax (generic Vim) ───────────────────────────
  hi("Comment",        { fg = p.fg_muted, italic = true })
  hi("Constant",       { fg = p.orange })
  hi("String",         { fg = p.green })
  hi("Character",      { fg = p.green })
  hi("Number",         { fg = p.teal })
  hi("Boolean",        { fg = p.orange })
  hi("Float",          { fg = p.teal })
  hi("Identifier",     { fg = p.fg })
  hi("Function",       { fg = p.blue })
  hi("Statement",      { fg = p.red })
  hi("Conditional",    { fg = p.red })
  hi("Repeat",         { fg = p.red })
  hi("Label",          { fg = p.yellow })
  hi("Operator",       { fg = p.fg })
  hi("Keyword",        { fg = p.red })
  hi("Exception",      { fg = p.red })
  hi("PreProc",        { fg = p.magenta })
  hi("Include",        { fg = p.red })
  hi("Define",         { fg = p.magenta })
  hi("Macro",          { fg = p.magenta })
  hi("PreCondit",      { fg = p.magenta })
  hi("Type",           { fg = p.violet })
  hi("StorageClass",   { fg = p.red })
  hi("Structure",      { fg = p.violet })
  hi("Typedef",        { fg = p.violet })
  hi("Special",        { fg = p.orange })
  hi("SpecialChar",    { fg = p.magenta })
  hi("Tag",            { fg = p.yellow })
  hi("Delimiter",      { fg = p.fg })
  hi("SpecialComment", { fg = p.fg_muted, bold = true })
  hi("Debug",          { fg = p.orange })
  hi("Underlined",     { fg = p.blue, underline = true })
  hi("Bold",           { bold = true })
  hi("Italic",         { italic = true })
  hi("Error",          { fg = p.red })
  hi("Todo",           { fg = p.bg, bg = p.yellow, bold = true })

  -- ── Tree-sitter ────────────────────────────────────
  hi("@comment",              { link = "Comment" })
  hi("@string",               { link = "String" })
  hi("@string.escape",        { fg = p.magenta })
  hi("@string.regex",         { fg = p.magenta })
  hi("@string.special",       { fg = p.magenta })
  hi("@character",            { link = "Character" })
  hi("@number",               { link = "Number" })
  hi("@boolean",              { link = "Boolean" })
  hi("@float",                { link = "Float" })
  hi("@function",             { fg = p.blue })
  hi("@function.builtin",     { fg = p.blue, italic = true })
  hi("@function.call",        { fg = p.blue })
  hi("@function.macro",       { fg = p.magenta })
  hi("@method",               { fg = p.blue })
  hi("@method.call",          { fg = p.blue })
  hi("@constructor",          { fg = p.violet })
  hi("@parameter",            { fg = p.orange, italic = true })
  hi("@keyword",              { fg = p.red })
  hi("@keyword.function",     { fg = p.red })
  hi("@keyword.operator",     { fg = p.red })
  hi("@keyword.return",       { fg = p.red })
  hi("@conditional",          { fg = p.red })
  hi("@repeat",               { fg = p.red })
  hi("@label",                { fg = p.yellow })
  hi("@operator",             { fg = p.fg })
  hi("@exception",            { fg = p.red })
  hi("@variable",             { fg = p.fg })
  hi("@variable.builtin",     { fg = p.orange, italic = true })
  hi("@type",                 { fg = p.violet })
  hi("@type.builtin",         { fg = p.violet, italic = true })
  hi("@type.definition",      { fg = p.violet })
  hi("@type.qualifier",       { fg = p.red })
  hi("@namespace",            { fg = p.violet })
  hi("@include",              { fg = p.red })
  hi("@field",                { fg = p.fg })
  hi("@property",             { fg = p.fg })
  hi("@constant",             { fg = p.orange })
  hi("@constant.builtin",     { fg = p.orange, italic = true })
  hi("@constant.macro",       { fg = p.magenta })
  hi("@tag",                  { fg = p.red })
  hi("@tag.attribute",        { fg = p.yellow })
  hi("@tag.delimiter",        { fg = p.fg_muted })
  hi("@punctuation.bracket",  { fg = p.fg })
  hi("@punctuation.delimiter",{ fg = p.fg })
  hi("@punctuation.special",  { fg = p.magenta })
  hi("@text.title",           { fg = p.yellow, bold = true })
  hi("@text.literal",         { fg = p.green })
  hi("@text.uri",             { fg = p.blue, underline = true })
  hi("@text.emphasis",        { italic = true })
  hi("@text.strong",          { bold = true })
  hi("@text.todo",            { fg = p.bg, bg = p.yellow, bold = true })
  hi("@text.note",            { fg = p.blue })
  hi("@text.warning",         { fg = p.orange })
  hi("@text.danger",          { fg = p.red })
  hi("@text.diff.add",        { fg = p.green })
  hi("@text.diff.delete",     { fg = p.red })

  -- ── LSP semantic tokens ────────────────────────────
  hi("@lsp.type.comment",     { link = "Comment" })
  hi("@lsp.type.keyword",     { link = "Keyword" })
  hi("@lsp.type.string",      { link = "String" })
  hi("@lsp.type.number",      { link = "Number" })
  hi("@lsp.type.type",        { link = "Type" })
  hi("@lsp.type.function",    { link = "Function" })
  hi("@lsp.type.method",      { fg = p.blue })
  hi("@lsp.type.property",    { fg = p.fg })
  hi("@lsp.type.variable",    { fg = p.fg })
  hi("@lsp.type.parameter",   { fg = p.orange, italic = true })
  hi("@lsp.type.namespace",   { fg = p.violet })
  hi("@lsp.type.enum",        { fg = p.violet })
  hi("@lsp.type.enumMember",  { fg = p.orange })
  hi("@lsp.type.struct",      { fg = p.violet })
  hi("@lsp.type.interface",   { fg = p.violet })
  hi("@lsp.type.decorator",   { fg = p.magenta })
  hi("@lsp.type.macro",       { fg = p.magenta })

  -- ── Git signs (gitsigns.nvim) ──────────────────────
  hi("GitSignsAdd",          { fg = p.green })
  hi("GitSignsChange",       { fg = p.yellow })
  hi("GitSignsDelete",       { fg = p.red })
  hi("GitSignsCurrentLineBlame", { fg = p.fg_muted, italic = true })

  -- ── Telescope ──────────────────────────────────────
  hi("TelescopeBorder",       { fg = p.border, bg = p.bg })
  hi("TelescopeTitle",        { fg = p.yellow, bold = true })
  hi("TelescopePromptBorder", { fg = p.yellow })
  hi("TelescopePromptTitle",  { fg = p.bg, bg = p.yellow, bold = true })
  hi("TelescopePromptPrefix", { fg = p.yellow })
  hi("TelescopeSelection",    { bg = p.bg_hi })
  hi("TelescopeMatching",     { fg = p.blue, bold = true })
  hi("TelescopeResultsNormal",{ fg = p.fg })

  -- ── nvim-cmp ───────────────────────────────────────
  hi("CmpItemAbbr",           { fg = p.fg })
  hi("CmpItemAbbrMatch",      { fg = p.blue, bold = true })
  hi("CmpItemAbbrMatchFuzzy", { fg = p.blue })
  hi("CmpItemAbbrDeprecated", { fg = p.fg_muted, strikethrough = true })
  hi("CmpItemKindFunction",   { fg = p.blue })
  hi("CmpItemKindMethod",     { fg = p.blue })
  hi("CmpItemKindVariable",   { fg = p.fg })
  hi("CmpItemKindKeyword",    { fg = p.red })
  hi("CmpItemKindText",       { fg = p.fg_muted })
  hi("CmpItemKindSnippet",    { fg = p.yellow })
  hi("CmpItemKindClass",      { fg = p.violet })
  hi("CmpItemKindInterface",  { fg = p.violet })
  hi("CmpItemKindModule",     { fg = p.violet })
  hi("CmpItemKindProperty",   { fg = p.fg })
  hi("CmpItemKindUnit",       { fg = p.teal })
  hi("CmpItemKindValue",      { fg = p.teal })
  hi("CmpItemKindEnum",       { fg = p.violet })
  hi("CmpItemKindConstant",   { fg = p.orange })
  hi("CmpItemKindField",      { fg = p.fg })

  -- ── Indent-blankline ───────────────────────────────
  hi("IblIndent",  { fg = p.border })
  hi("IblScope",   { fg = p.yellow })

  -- ── Which-key ──────────────────────────────────────
  hi("WhichKey",          { fg = p.yellow })
  hi("WhichKeyGroup",     { fg = p.blue })
  hi("WhichKeyDesc",      { fg = p.fg })
  hi("WhichKeySeparator", { fg = p.fg_muted })

  -- ── Notify ─────────────────────────────────────────
  hi("NotifyERRORBorder", { fg = p.red })
  hi("NotifyERRORTitle",  { fg = p.red })
  hi("NotifyERRORIcon",   { fg = p.red })
  hi("NotifyWARNBorder",  { fg = p.orange })
  hi("NotifyWARNTitle",   { fg = p.orange })
  hi("NotifyWARNIcon",    { fg = p.orange })
  hi("NotifyINFOBorder",  { fg = p.blue })
  hi("NotifyINFOTitle",   { fg = p.blue })
  hi("NotifyINFOIcon",    { fg = p.blue })

  -- ── Terminal ANSI ──────────────────────────────────
  vim.g.terminal_color_0  = p.bg
  vim.g.terminal_color_1  = p.red
  vim.g.terminal_color_2  = p.green
  vim.g.terminal_color_3  = p.yellow
  vim.g.terminal_color_4  = p.blue
  vim.g.terminal_color_5  = p.magenta
  vim.g.terminal_color_6  = p.teal
  vim.g.terminal_color_7  = p.fg
  vim.g.terminal_color_8  = p.border
  vim.g.terminal_color_9  = p.br_red
  vim.g.terminal_color_10 = p.br_green
  vim.g.terminal_color_11 = p.br_yellow
  vim.g.terminal_color_12 = p.br_blue
  vim.g.terminal_color_13 = p.br_magenta
  vim.g.terminal_color_14 = p.br_teal
  vim.g.terminal_color_15 = p.fg_alt
end

return M
