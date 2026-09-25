-- deepsage.nvim — a Neovim port of the "Deep Sage" DankMaterialShell theme
-- (dot_config/DankMaterialShell/themes/deepsage/theme.json, by viewerofall).
--
-- Surfaces, outlines, error/warning/info and the sage accents come straight
-- from that theme.json (dark = flavor "sage" + accent "deep"/"bright",
-- light = flavor "sage-light" + accent "bright"). The remaining syntax hues
-- are new: muted, low-chroma companions picked to sit at the same saturation
-- as the sage so nothing screams out of the palette.
--
-- Vendored like bru: colors/deepsage*.lua + lua/deepsage/, not a plugin.

local M = {}

M.palettes = {
  -- flavor "sage" (dark) with the "deep" accent for chrome and the "bright"
  -- accent for text, which needs the contrast.
  ["deepsage"] = {
    bg       = "#0d120f", -- background
    bg_soft  = "#121915", -- surface
    bg_hi    = "#1b251f", -- surfaceVariant
    bg_high  = "#1e2922", -- surfaceContainerHigh
    bg_sel   = "#27342c", -- surfaceContainerHighest
    border   = "#2c3a30", -- outline
    fg       = "#d7e2d9", -- surfaceText
    fg_alt   = "#dce6df", -- backgroundText
    fg_dim   = "#9fb3a3", -- surfaceVariantText
    fg_muted = "#6f8478",

    sage       = "#8bbf8a", -- accent "bright" primary
    sage_soft  = "#a9cda7", -- accent "bright" secondary
    sage_deep  = "#5c7a5e", -- accent "deep" primary
    sage_dark  = "#3a4f3c", -- accent "deep" primaryContainer
    on_accent  = "#0d150f", -- accent "bright" primaryText
    accent_bg  = "#a9cda7",
    gold_bg    = "#d9a256",

    clay     = "#dd8f85",
    red      = "#e07a7a", -- error
    gold     = "#d9a256", -- warning
    olive    = "#a6bd7e",
    teal     = "#8fbdb6",
    info     = "#7fa8a3", -- info
    mauve    = "#c095b8",
    lavender = "#a99ac9",
    slate    = "#8aa9c9",

    br_red     = "#ec9191",
    br_green   = "#a9d6a3",
    br_yellow  = "#e5b473",
    br_blue    = "#a2bedb",
    br_magenta = "#d4abc4",
    br_teal    = "#a6d0c9",

    diff_add_bg = "#16241a",
    diff_del_bg = "#2a1b1b",
    diff_chg_bg = "#26231a",
  },

  -- flavor "sage-light" with the "bright" accent (the theme's light default).
  ["deepsage-light"] = {
    bg       = "#f4f7f4", -- background
    bg_soft  = "#eef3ee", -- surface
    bg_hi    = "#e1e9e2", -- surfaceVariant
    bg_high  = "#e3e9e3", -- surfaceContainerHigh
    bg_sel   = "#d8e0d8", -- surfaceContainerHighest
    border   = "#c7d2c8", -- outline
    fg       = "#1d2820", -- surfaceText
    fg_alt   = "#19231c", -- backgroundText
    fg_dim   = "#46524a", -- surfaceVariantText
    fg_muted = "#6c7a6e",

    sage       = "#4d7a4f", -- accent "bright" primary (light), darkened for text
    sage_soft  = "#6f9c70", -- accent "bright" secondary (light)
    sage_deep  = "#3f5940", -- accent "deep" primary (light)
    sage_dark  = "#c3d3c2", -- accent "deep" primaryContainer (light)
    on_accent  = "#19231c",
    accent_bg  = "#d3e6d2", -- accent "bright" primaryContainer (light)
    gold_bg    = "#edc98f",

    clay     = "#b1544a",
    red      = "#c4453f", -- error
    gold     = "#8a6420", -- warning #a8732e, darkened so it holds up as text
    olive    = "#5f7a33",
    teal     = "#3f7a71",
    info     = "#3f6f68", -- info
    mauve    = "#8f5078",
    lavender = "#63578f",
    slate    = "#3c6a8a",

    br_red     = "#a93a34",
    br_green   = "#4b7a4d",
    br_yellow  = "#8f6222",
    br_blue    = "#325b77",
    br_magenta = "#7c4267",
    br_teal    = "#356059",

    diff_add_bg = "#dfeedd",
    diff_del_bg = "#f6dedc",
    diff_chg_bg = "#f1e9d2",
  },
}

function M.setup(opts)
  opts = opts or {}
  M.variant = opts.variant or "deepsage"
end

function M.load()
  local variant = M.variant or "deepsage"
  local p = M.palettes[variant]
  if not p then
    vim.notify("deepsage: unknown variant '" .. variant .. "'", vim.log.levels.ERROR)
    return
  end

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  vim.o.termguicolors = true
  vim.o.background = variant == "deepsage-light" and "light" or "dark"
  vim.g.colors_name = variant

  local function hi(group, opts_hi)
    vim.api.nvim_set_hl(0, group, opts_hi)
  end

  -- ── UI ─────────────────────────────────────────────
  hi("Normal",       { fg = p.fg, bg = p.bg })
  hi("NormalFloat",  { fg = p.fg, bg = p.bg_soft })
  hi("NormalNC",     { fg = p.fg, bg = p.bg })
  hi("FloatBorder",  { fg = p.border, bg = p.bg_soft })
  hi("FloatTitle",   { fg = p.sage, bg = p.bg_soft, bold = true })

  hi("Cursor",       { fg = p.on_accent, bg = p.sage })
  hi("CursorLine",   { bg = p.bg_soft })
  hi("CursorColumn", { bg = p.bg_soft })
  hi("CursorLineNr", { fg = p.sage, bold = true })
  hi("LineNr",       { fg = p.border })
  hi("SignColumn",   { bg = p.bg })
  hi("ColorColumn",  { bg = p.bg_soft })

  hi("Visual",       { bg = p.bg_sel })
  hi("VisualNOS",    { bg = p.bg_sel })

  hi("Search",       { fg = p.on_accent, bg = p.accent_bg })
  hi("IncSearch",    { fg = p.on_accent, bg = p.gold_bg })
  hi("CurSearch",    { fg = p.on_accent, bg = p.gold_bg, bold = true })
  hi("Substitute",   { fg = p.bg, bg = p.clay })

  hi("Pmenu",        { fg = p.fg, bg = p.bg_soft })
  hi("PmenuSel",     { fg = p.fg_alt, bg = p.sage_dark })
  hi("PmenuSbar",    { bg = p.bg_hi })
  hi("PmenuThumb",   { bg = p.border })

  hi("StatusLine",   { fg = p.fg, bg = p.bg_hi })
  hi("StatusLineNC", { fg = p.fg_muted, bg = p.bg_soft })
  hi("TabLine",      { fg = p.fg_muted, bg = p.bg_soft })
  hi("TabLineFill",  { bg = p.bg })
  hi("TabLineSel",   { fg = p.sage, bg = p.bg_hi, bold = true })
  hi("WinBar",       { fg = p.fg, bg = p.bg })
  hi("WinBarNC",     { fg = p.fg_muted, bg = p.bg })
  hi("WinSeparator", { fg = p.border })

  hi("Folded",       { fg = p.fg_muted, bg = p.bg_soft })
  hi("FoldColumn",   { fg = p.border })

  hi("MatchParen",   { fg = p.sage, bg = p.bg_sel, bold = true })

  hi("Directory",    { fg = p.sage })
  hi("Title",        { fg = p.sage, bold = true })
  hi("Question",     { fg = p.info })
  hi("MoreMsg",      { fg = p.teal })
  hi("WarningMsg",   { fg = p.gold })
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
  hi("Added",        { fg = p.sage })
  hi("Changed",      { fg = p.gold })
  hi("Removed",      { fg = p.red })

  -- ── Diagnostics ────────────────────────────────────
  hi("DiagnosticError",        { fg = p.red })
  hi("DiagnosticWarn",         { fg = p.gold })
  hi("DiagnosticInfo",         { fg = p.info })
  hi("DiagnosticHint",         { fg = p.teal })
  hi("DiagnosticOk",           { fg = p.sage })
  hi("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
  hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = p.gold })
  hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = p.info })
  hi("DiagnosticUnderlineHint",  { undercurl = true, sp = p.teal })
  hi("DiagnosticVirtualTextError", { fg = p.red, bg = p.diff_del_bg })
  hi("DiagnosticVirtualTextWarn",  { fg = p.gold, bg = p.diff_chg_bg })
  hi("DiagnosticVirtualTextInfo",  { fg = p.info, bg = p.bg_soft })
  hi("DiagnosticVirtualTextHint",  { fg = p.teal, bg = p.bg_soft })

  -- ── Syntax (generic Vim) ───────────────────────────
  hi("Comment",        { fg = p.fg_muted, italic = true })
  hi("Constant",       { fg = p.gold })
  hi("String",         { fg = p.olive })
  hi("Character",      { fg = p.olive })
  hi("Number",         { fg = p.teal })
  hi("Boolean",        { fg = p.gold })
  hi("Float",          { fg = p.teal })
  hi("Identifier",     { fg = p.fg })
  hi("Function",       { fg = p.sage })
  hi("Statement",      { fg = p.clay })
  hi("Conditional",    { fg = p.clay })
  hi("Repeat",         { fg = p.clay })
  hi("Label",          { fg = p.gold })
  hi("Operator",       { fg = p.fg_dim })
  hi("Keyword",        { fg = p.clay })
  hi("Exception",      { fg = p.clay })
  hi("PreProc",        { fg = p.mauve })
  hi("Include",        { fg = p.clay })
  hi("Define",         { fg = p.mauve })
  hi("Macro",          { fg = p.mauve })
  hi("PreCondit",      { fg = p.mauve })
  hi("Type",           { fg = p.lavender })
  hi("StorageClass",   { fg = p.clay })
  hi("Structure",      { fg = p.lavender })
  hi("Typedef",        { fg = p.lavender })
  hi("Special",        { fg = p.gold })
  hi("SpecialChar",    { fg = p.mauve })
  hi("Tag",            { fg = p.sage })
  hi("Delimiter",      { fg = p.fg_dim })
  hi("SpecialComment", { fg = p.fg_muted, bold = true })
  hi("Debug",          { fg = p.gold })
  hi("Underlined",     { fg = p.slate, underline = true })
  hi("Bold",           { bold = true })
  hi("Italic",         { italic = true })
  hi("Error",          { fg = p.red })
  hi("Todo",           { fg = p.on_accent, bg = p.sage, bold = true })

  -- ── Tree-sitter ────────────────────────────────────
  hi("@comment",              { link = "Comment" })
  hi("@comment.todo",         { link = "Todo" })
  hi("@comment.note",         { fg = p.info })
  hi("@comment.warning",      { fg = p.gold })
  hi("@comment.error",        { fg = p.red })
  hi("@string",               { link = "String" })
  hi("@string.escape",        { fg = p.mauve })
  hi("@string.regex",         { fg = p.mauve })
  hi("@string.regexp",        { fg = p.mauve })
  hi("@string.special",       { fg = p.mauve })
  hi("@character",            { link = "Character" })
  hi("@number",               { link = "Number" })
  hi("@boolean",              { link = "Boolean" })
  hi("@float",                { link = "Float" })
  hi("@function",             { fg = p.sage })
  hi("@function.builtin",     { fg = p.sage, italic = true })
  hi("@function.call",        { fg = p.sage })
  hi("@function.macro",       { fg = p.mauve })
  hi("@function.method",      { fg = p.sage })
  hi("@function.method.call", { fg = p.sage })
  hi("@method",               { fg = p.sage })
  hi("@method.call",          { fg = p.sage })
  hi("@constructor",          { fg = p.lavender })
  hi("@parameter",            { fg = p.fg_dim, italic = true })
  hi("@variable.parameter",   { fg = p.fg_dim, italic = true })
  hi("@keyword",              { fg = p.clay })
  hi("@keyword.function",     { fg = p.clay })
  hi("@keyword.operator",     { fg = p.clay })
  hi("@keyword.return",       { fg = p.clay })
  hi("@keyword.import",       { fg = p.clay })
  hi("@keyword.conditional",  { fg = p.clay })
  hi("@keyword.repeat",       { fg = p.clay })
  hi("@keyword.exception",    { fg = p.clay })
  hi("@conditional",          { fg = p.clay })
  hi("@repeat",               { fg = p.clay })
  hi("@label",                { fg = p.gold })
  hi("@operator",             { fg = p.fg_dim })
  hi("@exception",            { fg = p.clay })
  hi("@variable",             { fg = p.fg })
  hi("@variable.builtin",     { fg = p.mauve, italic = true })
  hi("@variable.member",      { fg = p.fg })
  hi("@type",                 { fg = p.lavender })
  hi("@type.builtin",         { fg = p.lavender, italic = true })
  hi("@type.definition",      { fg = p.lavender })
  hi("@type.qualifier",       { fg = p.clay })
  hi("@namespace",            { fg = p.slate })
  hi("@module",               { fg = p.slate })
  hi("@include",              { fg = p.clay })
  hi("@field",                { fg = p.fg })
  hi("@property",             { fg = p.fg })
  hi("@constant",             { fg = p.gold })
  hi("@constant.builtin",     { fg = p.gold, italic = true })
  hi("@constant.macro",       { fg = p.mauve })
  hi("@tag",                  { fg = p.sage })
  hi("@tag.attribute",        { fg = p.gold })
  hi("@tag.delimiter",        { fg = p.fg_muted })
  hi("@punctuation.bracket",  { fg = p.fg_dim })
  hi("@punctuation.delimiter",{ fg = p.fg_dim })
  hi("@punctuation.special",  { fg = p.mauve })
  hi("@markup.heading",       { fg = p.sage, bold = true })
  hi("@markup.raw",           { fg = p.olive })
  hi("@markup.link",          { fg = p.slate, underline = true })
  hi("@markup.link.url",      { fg = p.slate, underline = true })
  hi("@markup.italic",        { italic = true })
  hi("@markup.strong",        { bold = true })
  hi("@markup.list",          { fg = p.teal })
  hi("@text.title",           { fg = p.sage, bold = true })
  hi("@text.literal",         { fg = p.olive })
  hi("@text.uri",             { fg = p.slate, underline = true })
  hi("@text.emphasis",        { italic = true })
  hi("@text.strong",          { bold = true })
  hi("@text.todo",            { link = "Todo" })
  hi("@text.note",            { fg = p.info })
  hi("@text.warning",         { fg = p.gold })
  hi("@text.danger",          { fg = p.red })
  hi("@text.diff.add",        { fg = p.sage })
  hi("@text.diff.delete",     { fg = p.red })

  -- ── LSP semantic tokens ────────────────────────────
  hi("@lsp.type.comment",     { link = "Comment" })
  hi("@lsp.type.keyword",     { link = "Keyword" })
  hi("@lsp.type.string",      { link = "String" })
  hi("@lsp.type.number",      { link = "Number" })
  hi("@lsp.type.type",        { link = "Type" })
  hi("@lsp.type.function",    { link = "Function" })
  hi("@lsp.type.method",      { fg = p.sage })
  hi("@lsp.type.property",    { fg = p.fg })
  hi("@lsp.type.variable",    { fg = p.fg })
  hi("@lsp.type.parameter",   { fg = p.fg_dim, italic = true })
  hi("@lsp.type.namespace",   { fg = p.slate })
  hi("@lsp.type.enum",        { fg = p.lavender })
  hi("@lsp.type.enumMember",  { fg = p.gold })
  hi("@lsp.type.struct",      { fg = p.lavender })
  hi("@lsp.type.interface",   { fg = p.lavender })
  hi("@lsp.type.decorator",   { fg = p.mauve })
  hi("@lsp.type.macro",       { fg = p.mauve })

  hi("LspReferenceText",      { bg = p.bg_hi })
  hi("LspReferenceRead",      { bg = p.bg_hi })
  hi("LspReferenceWrite",     { bg = p.bg_hi, underline = true })
  hi("LspInlayHint",          { fg = p.fg_muted, bg = p.bg_soft, italic = true })

  -- ── Git signs (gitsigns.nvim) ──────────────────────
  hi("GitSignsAdd",          { fg = p.sage })
  hi("GitSignsChange",       { fg = p.gold })
  hi("GitSignsDelete",       { fg = p.red })
  hi("GitSignsCurrentLineBlame", { fg = p.fg_muted, italic = true })

  -- ── Telescope ──────────────────────────────────────
  hi("TelescopeBorder",       { fg = p.border, bg = p.bg })
  hi("TelescopeTitle",        { fg = p.sage, bold = true })
  hi("TelescopePromptBorder", { fg = p.sage })
  hi("TelescopePromptTitle",  { fg = p.on_accent, bg = p.sage, bold = true })
  hi("TelescopePromptPrefix", { fg = p.sage })
  hi("TelescopeSelection",    { bg = p.bg_sel })
  hi("TelescopeMatching",     { fg = p.gold, bold = true })
  hi("TelescopeResultsNormal",{ fg = p.fg })

  -- ── nvim-cmp / blink.cmp ───────────────────────────
  hi("CmpItemAbbr",           { fg = p.fg })
  hi("CmpItemAbbrMatch",      { fg = p.sage, bold = true })
  hi("CmpItemAbbrMatchFuzzy", { fg = p.sage })
  hi("CmpItemAbbrDeprecated", { fg = p.fg_muted, strikethrough = true })
  hi("CmpItemKindFunction",   { fg = p.sage })
  hi("CmpItemKindMethod",     { fg = p.sage })
  hi("CmpItemKindVariable",   { fg = p.fg })
  hi("CmpItemKindKeyword",    { fg = p.clay })
  hi("CmpItemKindText",       { fg = p.fg_muted })
  hi("CmpItemKindSnippet",    { fg = p.gold })
  hi("CmpItemKindClass",      { fg = p.lavender })
  hi("CmpItemKindInterface",  { fg = p.lavender })
  hi("CmpItemKindModule",     { fg = p.slate })
  hi("CmpItemKindProperty",   { fg = p.fg })
  hi("CmpItemKindUnit",       { fg = p.teal })
  hi("CmpItemKindValue",      { fg = p.teal })
  hi("CmpItemKindEnum",       { fg = p.lavender })
  hi("CmpItemKindConstant",   { fg = p.gold })
  hi("CmpItemKindField",      { fg = p.fg })
  hi("BlinkCmpMenuBorder",    { fg = p.border, bg = p.bg_soft })
  hi("BlinkCmpLabelMatch",    { fg = p.sage, bold = true })
  hi("BlinkCmpLabelDeprecated", { fg = p.fg_muted, strikethrough = true })

  -- ── Neo-tree / snacks picker ───────────────────────
  hi("NeoTreeNormal",       { fg = p.fg, bg = p.bg_soft })
  hi("NeoTreeNormalNC",     { fg = p.fg, bg = p.bg_soft })
  hi("NeoTreeDirectoryName",{ fg = p.sage })
  hi("NeoTreeDirectoryIcon",{ fg = p.sage })
  hi("NeoTreeRootName",     { fg = p.sage_soft, bold = true })
  hi("NeoTreeGitModified",  { fg = p.gold })
  hi("NeoTreeGitAdded",     { fg = p.sage })
  hi("NeoTreeGitDeleted",   { fg = p.red })
  hi("SnacksPickerMatch",   { fg = p.sage, bold = true })
  hi("SnacksPickerDir",     { fg = p.fg_muted })

  -- ── Indent-blankline ───────────────────────────────
  hi("IblIndent",  { fg = p.border })
  hi("IblScope",   { fg = p.sage_deep })

  -- ── Which-key ──────────────────────────────────────
  hi("WhichKey",          { fg = p.sage })
  hi("WhichKeyGroup",     { fg = p.teal })
  hi("WhichKeyDesc",      { fg = p.fg })
  hi("WhichKeySeparator", { fg = p.fg_muted })

  -- ── Notify ─────────────────────────────────────────
  hi("NotifyERRORBorder", { fg = p.red })
  hi("NotifyERRORTitle",  { fg = p.red })
  hi("NotifyERRORIcon",   { fg = p.red })
  hi("NotifyWARNBorder",  { fg = p.gold })
  hi("NotifyWARNTitle",   { fg = p.gold })
  hi("NotifyWARNIcon",    { fg = p.gold })
  hi("NotifyINFOBorder",  { fg = p.info })
  hi("NotifyINFOTitle",   { fg = p.info })
  hi("NotifyINFOIcon",    { fg = p.info })

  -- ── Terminal ANSI ──────────────────────────────────
  vim.g.terminal_color_0  = p.bg_hi
  vim.g.terminal_color_1  = p.clay
  vim.g.terminal_color_2  = p.sage
  vim.g.terminal_color_3  = p.gold
  vim.g.terminal_color_4  = p.slate
  vim.g.terminal_color_5  = p.mauve
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
