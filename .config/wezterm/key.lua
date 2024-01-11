local wezterm = require 'wezterm'
local act = wezterm.action

local EDITOR=os.getenv("EDITOR") or '/opt/homebrew/bin/nvim'

local module = {}
function module.setup(c)
    
c.use_dead_keys = false
local PREFIX='CMD'
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  PREFIX='CTRL|SHIFT'
  c.disable_default_key_bindings = false
  c.hide_tab_bar_if_only_one_tab = false
  -- Configs for Windows only
  -- font_dirs = {
  --     'C:\\Users\\whoami\\.dotfiles\\.fonts'
  -- }
  -- default_prog = {'wsl.exe', '~', '-d', 'Ubuntu-20.04'}
end

if wezterm.target_triple == 'aarch64-apple-darwin' then
  c.disable_default_key_bindings = true
  -- Configs for OSX only
  -- font_dirs    = { '$HOME/.dotfiles/.fonts' }
end

local keys = {
  { key = "UpArrow",   mods = "ALT", action = act.ScrollToPrompt(-1) },
  { key = "DownArrow", mods = "ALT", action = act.ScrollToPrompt(1) },
  
  -- 
  { key = 'Enter', mods = 'ALT'        , action = act.ToggleFullScreen                                 } ,

  { key = "\\",mods = 'ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } } ,
  { key = '-', mods = 'ALT', action = act.SplitVertical   { domain = 'CurrentPaneDomain' } } ,

  { key = 'z', mods = 'ALT', action = act.TogglePaneZoomState                              } ,

  { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left'                   }              ,
  { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right'                  }              ,
  { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up'                     }              ,
  { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down'                   }              ,

  -- open
  { key = 'n', mods = 'ALT', action = act.SpawnWindow },
  { key = 't', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain' },

  -- close
  { key = 'W', mods = 'ALT', action = act.CloseCurrentPane { confirm = true } }              ,
  { key = 'w', mods = 'ALT', action = act.CloseCurrentTab  { confirm = true } }              ,
  { key = 'F4',mods = 'ALT', action = act.CloseCurrentTab  { confirm = false } }              ,
  { key = 'q', mods = 'ALT', action = act.QuitApplication },
  -- { key = 'r', mods = 'ALT', action = act.ResetTerminal },
  
  -- mode
  { key = '[', mods = 'ALT', action = act.ActivateCopyMode },
  { key = 'f', mods = 'ALT', action = act.QuickSelect },
  { key = '/', mods = 'ALT', action = act.Search { Regex = '' }, },
  { key = 'd', mods = 'ALT', action = act.ShowDebugOverlay },

  -- 
  { key = "UpArrow",   mods = "ALT", action = act.ScrollToPrompt(-1) },
  { key = "DownArrow", mods = "ALT", action = act.ScrollToPrompt(1) },

  
  -- jump
  { key = 's', mods = 'ALT', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES', title='SESSIONS' } },
  { key = 'p', mods = 'ALT', action = act.ActivateCommandPalette      } ,
  { key = 'P', mods = 'ALT', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS', title='TABS' }},

  {
    key = ',',  mods = 'ALT', 
    action = act.SpawnCommandInNewWindow {
      label='WezTerm Config',
      domain = 'DefaultDomain',
      args = { EDITOR, '-p', wezterm.config_file },
      position = {
          x = 800,
          y = 0,
      },
    }
  },
  { key = 'r', mods = 'ALT', action = act.ReloadConfiguration },

  -- same as OS level 
  { key = 'Tab'  , mods = 'CTRL'       , action = act.ActivateTabRelative( 1)                       } ,
  { key = 'Tab'  , mods = 'CTRL|SHIFT' , action = act.ActivateTabRelative(-1)                       } ,

  { key = 'Enter', mods = PREFIX       , action = act.ToggleFullScreen                   } ,
  { key = '+'    , mods = PREFIX       , action = act.IncreaseFontSize                              } ,
  { key = '-'    , mods = PREFIX       , action = act.DecreaseFontSize                              } ,
  { key = '0'    , mods = PREFIX       , action = act.ResetFontSize                                 } ,

  { key = 'c'    , mods = PREFIX       , action = act.CopyTo 'Clipboard'                            } ,
  { key = 'v'    , mods = PREFIX       , action = act.PasteFrom 'Clipboard'                         } ,

  { key = 'n'    , mods = PREFIX       , action = act.SpawnWindow                                   } ,
  { key = 't'    , mods = PREFIX       , action = act.SpawnTab 'DefaultDomain'                      } ,
  { key = 'q'    , mods = PREFIX       , action = act.QuitApplication                    } ,
  { key = 'w'    , mods = PREFIX       , action = act.CloseCurrentTab { confirm = false }} ,

  -- special features
  { key = 'u', mods = 'ALT', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
  -- TODO how to convert to html so paste into onenote / outlook
  {
    key = 'c',
    mods = 'ALT',
    action = wezterm.action_callback(function(window, pane)
        local ansi = window:get_selection_escapes_for_pane(pane)
        window:copy_to_clipboard(ansi)
    end),
  },


  {
    mods = 'ALT', key = 'm',
    action = act.SpawnCommandInNewWindow {
      args = { '/opt/homebrew/bin/mc', '-u' },
      position = {
          x = 100,
          y = 400,
      },
    },
  },

  {
    mods = 'ALT', key = 'T', 
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

}

-- tab selection
for i = 1, 9 do
  table.insert(keys, {
    key = tostring(i), mods = 'ALT', action = act.ActivateTab(i - 1),
  })
end
  table.insert(keys, {
    key = '0', mods = 'ALT', action = act.ActivateLastTab
  })

c.keys = keys


c.mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = act.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
}

end

return module
