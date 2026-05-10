-- wezterm.lua — Catppuccin Mocha, translucent, JetBrains Mono, polished.

local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- ============================================================================
-- Theme
-- ============================================================================
config.color_scheme = 'Catppuccin Mocha'
-- Alternate theme to swap in: change the line above to one of:
--   config.color_scheme = 'Tokyo Night Moon'
--   config.color_scheme = 'Catppuccin Latte'

-- ============================================================================
-- Font
-- ============================================================================
config.font = wezterm.font_with_fallback {
  { family = 'JetBrains Mono', weight = 'Regular' },
  { family = 'Symbols Nerd Font Mono' },     -- icons for eza, etc.
  { family = 'Apple Color Emoji' },
}
config.font_size = 18.0
config.line_height = 1.1
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }   -- ligatures on

-- ============================================================================
-- Window
-- ============================================================================
config.window_background_opacity = 0.92
config.macos_window_background_blur = 30
config.window_padding = { left = 12, right = 12, top = 12, bottom = 12 }
config.window_decorations = 'RESIZE'
config.window_close_confirmation = 'NeverPrompt'
config.adjust_window_size_when_changing_font_size = false
config.initial_cols = 140
config.initial_rows = 38

-- ============================================================================
-- Tab bar
-- ============================================================================
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32
config.tab_bar_at_bottom = false

wezterm.on('format-tab-title', function(tab)
  local title = tab.active_pane.current_working_dir
  if title then
    title = title.file_path or tostring(title)
    title = title:match('([^/]+)/?$') or title
  else
    title = tab.active_pane.title or '~'
  end
  return ' ' .. title .. ' '
end)

-- ============================================================================
-- Cursor (soft fade rather than hard blink)
-- ============================================================================
config.default_cursor_style = 'SteadyBar'
config.cursor_blink_rate = 800
config.cursor_blink_ease_in = 'EaseOut'
config.cursor_blink_ease_out = 'EaseOut'

-- ============================================================================
-- Bell — disable audible, very subtle visual flash
-- ============================================================================
config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 75,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 75,
  target = 'BackgroundColor',
}
-- Mocha's surface0 with low alpha — a flash you can ignore.
config.colors = {
  visual_bell = '#313244',
}

-- ============================================================================
-- Inactive panes — dim slightly so the focused pane stands out
-- ============================================================================
config.inactive_pane_hsb = {
  brightness = 0.85,
  saturation = 0.9,
}

-- ============================================================================
-- Performance
-- ============================================================================
config.front_end = 'WebGpu'
config.max_fps = 120
config.animation_fps = 60

-- ============================================================================
-- Shell — explicit login zsh
-- ============================================================================
config.default_prog = { '/bin/zsh', '-l' }

-- ============================================================================
-- Keybindings — mac-native CMD where possible
-- ============================================================================
config.keys = {
  -- Tabs
  { key = 't', mods = 'CMD',       action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CMD',       action = act.CloseCurrentPane { confirm = false } },
  { key = '[', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },

  -- Splits
  { key = 'd', mods = 'CMD',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },

  -- Pane navigation (CMD + arrow)
  { key = 'LeftArrow',  mods = 'CMD', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CMD', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'CMD', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'CMD', action = act.ActivatePaneDirection 'Down' },

  -- Window
  { key = 'Enter', mods = 'CMD', action = act.ToggleFullScreen },
  { key = 'k',     mods = 'CMD', action = act.ClearScrollback 'ScrollbackAndViewport' },

  -- Copy mode
  { key = 'Space', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },

  -- Command palette
  { key = 'p', mods = 'CMD|SHIFT', action = act.ActivateCommandPalette },
}

-- CMD+1..9 to switch to tab N
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CMD',
    action = act.ActivateTab(i - 1),
  })
end

-- ============================================================================
-- Misc niceties
-- ============================================================================
config.scrollback_lines = 50000
config.enable_scroll_bar = false
config.check_for_updates = false
config.audible_bell = 'Disabled'
config.warn_about_missing_glyphs = false

return config
