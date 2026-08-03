-- ruster config — managed by the Settings page (:settings, save with :w).
-- Safe to hand-edit; comments and layout are regenerated on save.
-- Advanced scripting (keymaps, plugins) goes in init.lua, loaded after this.

-- Editing, indentation, and paradigm
ruster.config.general = {
  tabstop = 4,  -- Spaces a tab represents
  softtabstop = 4,  -- Spaces inserted on Tab
  expandtab = false,  -- Insert spaces instead of tabs
  shiftwidth = 4,  -- Spaces per indent step
  editmode = "neovim",  -- Modal (neovim) or modeless (emacs)
  editorconfig = true,  -- Apply project .editorconfig files
  line_ending = "lf",  -- Line ending for new files
  theme = "catppuccin-mocha",  -- Named color theme
}

-- GUI font, size, colors, and window
ruster.config.gui = {
  font = "",  -- Font file/path; empty = auto-detect a Nerd font
  font_size = 20,  -- GUI glyph size in px
  line_height = 24,  -- Row height in px
  padding_x = 8,  -- Left padding in px
  padding_y = 4,  -- Top padding in px
  window_width = 800,  -- Initial window width
  window_height = 600,  -- Initial window height
  target_fps = 60,  -- Render loop frame cap
  cursor_kind = "block",  -- Block or bar cursor
  cursor_anim = false,  -- Animate cursor movement
  cursor_anim_speed = 12.0,  -- Smooth-cursor easing speed
}

-- Line-number gutter
ruster.config.gutter = {
  number = false,  -- Show absolute line numbers
  relativenumber = false,  -- Show relative line numbers
}

-- Which-key hint panel
ruster.config.whichkey = {
  enabled = true,  -- Show the which-key hint panel
  timeoutlen = 300,  -- Delay before the panel appears
  command_palette = "center",  -- Where the :-Tab command palette appears: a centered box or docked at the bottom
}

-- Language server features
ruster.config.lsp = {
  format_on_save = false,  -- Run LSP formatting on :w
  diagnostics = true,  -- Show LSP diagnostics
  hover = true,  -- Enable hover popups
  autostart = true,  -- Launch a server when a file opens
}

-- Embedded terminal
ruster.config.terminal = {
  shell = "",  -- Program for :term; empty = platform default
  scrollback = 10000,  -- Lines of history retained
  default_mode = "insert",  -- Initial mode for a new terminal
}

-- File explorer
ruster.config.dired = {
  show_hidden = false,  -- Show dotfiles in the file explorer
}

-- Sidebar panel
ruster.config.sidebar = {
  auto_open = false,  -- Open the sidebar automatically on startup
}

-- Notifications and messages
ruster.config.noice = {
  mini = true,  -- Show transient toasts in the cmdline row
  notify = true,  -- Show the stacking panel for warnings and errors
  split = true,  -- Allow :Noice split to open the *noice* history buffer
  info_timeout = 2000,  -- How long info toasts stay up
  success_timeout = 2000,  -- How long success toasts stay up
  warning_timeout = 5000,  -- How long warnings stay up; errors are persistent
  max_history = 1000,  -- Messages retained for :messages and :Noice split
}

-- Git integration
ruster.config.git = {
  signs = true,  -- Mark added/changed/removed lines in the gutter
}

-- TODO comment markers
ruster.config.todo = {
  keywords = "TODO,FIXME,HACK,NOTE,XXX",  -- Comma-separated markers highlighted in comments; empty disables
}

-- Build command
ruster.config.build = {
  command = "",  -- Command for :build; empty = detect from the project type
}

-- Test command
ruster.config.test = {
  command = "",  -- Command for :test; empty = detect from the project type
}

-- Debug adapter
ruster.config.dap = {
  adapter = "",  -- Adapter program for :debug; empty = detect from the file's language
}

-- Saved sessions (open files and window layout)
ruster.config.session = {
  autoload = false,  -- Reopen the project's saved files and layout on startup
  autosave = true,  -- Write the session when the editor exits
}

-- Per-element color overrides (empty = theme)
ruster.config.colors = {
  bg = "",  -- Override editor background
  fg = "",  -- Override default text color
  gutter = "",  -- Override line-number color
  gutter_bg = "",  -- Override the gutter background
  cursor_bg = "",  -- Block cursor background color
  selection_bg = "",  -- Text selection highlight background
  selection_fg = "",  -- Override text drawn over the selection
  cursor_fg = "",  -- Override the glyph under the block cursor
  divider = "",  -- Override window header lines and picker separators
  statusline_fg = "",  -- Override statusline text color
  statusline_bg = "",  -- Override statusline background
  accent = "",  -- Override accent (titles, prompts)
  accent_fg = "",  -- Override text drawn on accent bars
  whichkey_bg = "",  -- Override the which-key panel background
  whichkey_fg = "",  -- Override the which-key panel text
  whichkey_key = "",  -- Override the which-key key-letter accent
  cmdline_bg = "",  -- Override the cmdline background
  cmdline_fg = "",  -- Override the cmdline text
  mode_normal_bg = "",  -- Statusline background in Normal mode
  mode_normal_fg = "",  -- Statusline text color in Normal mode
  mode_insert_bg = "",  -- Statusline background in Insert mode
  mode_insert_fg = "",  -- Statusline text color in Insert mode
  mode_visual_bg = "",  -- Statusline background in Visual mode
  mode_visual_fg = "",  -- Statusline text color in Visual mode
  mode_cmdline_bg = "",  -- Statusline background in Cmdline mode
  mode_cmdline_fg = "",  -- Statusline text color in Cmdline mode
  mode_emacs_bg = "",  -- Statusline background in Emacs mode
  mode_emacs_fg = "",  -- Statusline text color in Emacs mode
}

