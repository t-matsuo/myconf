-- WezTerm 設定ファイル

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ウィンドウバーを消す
config.window_decorations = "RESIZE"

-- デフォルトシェル
config.default_prog = { "C:\\cygwin\\bin\\bash.exe", "-l" }
-- config.default_domain = 'WSL:ubuntu'

local act = wezterm.action
config.keys = {
  -- Ctrl+Shift+Space でランチャーメニュー
  {
    key = 'Space',
    mods = 'CTRL|SHIFT',
    action = act.ShowLauncher,
  },
}

config.launch_menu = {
  {
    label = 'Cygwin',
    args = { 'C:\\cygwin\\bin\\bash.exe', '-i' },
  },
  {
    label = 'WSL(Rocky9)',
    domain = { DomainName = 'WSL:ubuntu' },
  },
  {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  },
  {
    label = 'cmd',
    args = { 'cmd.exe' },
  },
}

-- タブのタイトルを設定
wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane
  local domain = pane.domain_name
  local title = pane.title
  -- Cygwin
  if title == 'bash.exe' then
    return 'Cygwin'
  end
  -- WSL
  if domain == 'WSL:ubuntu' then
    return 'ubuntu'
  end
  -- PowerShell
  if title == 'powershell.exe' then
    return 'PowerShell'
  end
  -- Cmd
  if title == 'cmd.exe' then
    return 'Cmd'
  end

  return title
end)

-- フォント
config.font = wezterm.font("PlemolJP")
config.font_size = 12

-- ウィンドウサイズ
config.initial_cols = 120
config.initial_rows = 28

-- カラースキーマ
--config.color_scheme = 'Gruvbox Dark'
--config.color_scheme = 'Gruvbox Dark (Gogh)'
--config.color_scheme = 'OneDark'
--config.color_scheme = 'Tokyo Night'
config.color_scheme = 'Nord'
--config.color_scheme = 'Catppuccin Mocha'
--config.color_scheme = 'Catppuccin Macchiato'
--config.color_scheme = 'AdventureTime'

return config
