local wezterm = require 'wezterm'
-- local act = wezterm.action

local module = {}

function module.setup(c)
    c.window_decorations = "RESIZE"
    c.hide_tab_bar_if_only_one_tab = true

    c.font_size = 12.0
    c.initial_rows =  40
    c.initial_cols = 120
    -- c.integrated_title_buttons = { 'Maximize', 'Close' }

    c.default_cursor_style = 'BlinkingUnderline'
    c.cursor_blink_rate = 500
    c.cursor_thickness=3
    c.pane_focus_follows_mouse = true

    -- c.color_scheme = 'Batman'
    c.colors = {
      tab_bar = {
        -- The color of the inactive tab bar edge/divider
        inactive_tab_edge = '#575757',

          -- The color of the strip that goes along the top of the window
          -- (does not apply when fancy tab bar is in use)
          -- background = '#0b0022',

          -- The active tab is the one that has focus in the window
          active_tab = {
              bg_color = 'orange', -- '#2b2042',
              fg_color = 'black', -- '#c0c0c0',

              -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
              -- label shown for this tab.
              -- The default is "Normal"
              intensity = 'Bold',
          },

          -- Inactive tabs are the tabs that do not have focus
          inactive_tab = {
              bg_color = '#1b1032',
              fg_color = '#808080',
          },

          -- You can configure some alternate styling when the mouse pointer
          -- moves over inactive tabs
          inactive_tab_hover = {
              bg_color = '#3b3052',
              fg_color = '#909090',
              -- italic = true,
          },

          -- The new tab button that let you create new tabs
          new_tab = {
              bg_color = '#1b1032',
              fg_color = 'white',
          },

          -- You can configure some alternate styling when the mouse pointer
          -- moves over the new tab button
          new_tab_hover = {
              bg_color = 'orange',
              fg_color = 'black',
          },
      },
    }

    c.inactive_pane_hsb = {
        saturation = 0.8,
        brightness = 0.4,
    }


    c.window_frame = {
      -- The font used in the tab bar.
      -- Roboto Bold is the default; this font is bundled
      -- with wezterm.
      -- Whatever font is selected here, it will have the
      -- main font setting appended to it to pick up any
      -- fallback fonts you may have used there.
      -- font = wezterm.font { family = 'Roboto', weight = 'Bold' },

      -- The size of the font in the tab bar.
      -- Default to 10.0 on Windows but 12.0 on other systems
      font_size = 14.0,

      -- The overall background color of the tab bar when the window is focused
      active_titlebar_bg = 'black', -- '#333333',

      -- The overall background color of the tab bar when the window is not focused
      -- inactive_titlebar_bg = 'grey', -- '#333333',

      -- border_left_width    = 1 ,
      -- border_right_width   = 1 ,
      -- border_bottom_height = 1 ,
      -- border_top_height    = 1 ,
      -- border_left_color    = 'white',
      -- border_right_color   = 'white',
      -- border_bottom_color  = 'white',
      -- border_top_color     = 'white',
    }

    c.enable_scroll_bar = false
    c.window_padding = {
      left = 2,
      right = 2,
      top = 4,
      bottom = 2,
    }

    c.window_background_image = wezterm.config_dir .. "/bg.jpg"
    c.window_background_image_hsb = {
        -- Darken the background image by reducing it to 1/3rd
        brightness = 0.4,

        -- You can adjust the hue by scaling its value.
        -- a multiplier of 1.0 leaves the value unchanged.
        hue = 1.0,

        -- You can adjust the saturation also.
        saturation = 1.0,
    }
end

-- The filled in variant of the < symbol
-- local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
-- The filled in variant of the > symbol
-- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab)
  local title = tab.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end

  local pane = tab.active_pane
  local title = pane.title
  -- if pane.domain_name and pane.domain_name ~= "local" then
  --   title = title .. ' (' .. pane.domain_name .. ')'
  -- end
  -- local process_title = pane.foreground_process_name
  -- return string.gsub( process_title, '(.*[/\\])(.*)', '%2' )
  return title
end

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

wezterm.on( 'format-tab-title', function( tab, tabs, panes, config, hover, max_width )

    local index = ""
    if #tabs > 1 then
        index = string.format( "%d", tab.tab_index + 1 )
    end

    local title = tab_title(tab)
    local pane = tab.active_pane

    local background = '#1b1032'
    local foreground = '#808080'

    if tab.is_active then
      background = '#2b2042'
      foreground = 'darkblue'
    elseif hover then
      background = '#3b3052'
      foreground = 'blue'
    end

    local edge_background = '#0b0022'
    local edge_foreground = background

    local t = {
        -- { Background = { Color = edge_background } },
        { Text = " " },

        -- { Background = { Color = edge_background } },
        { Foreground = { Color = "darkgreen" } },
        { Text = index .. " " },
        -- { Text = SOLID_RIGHT_ARROW },

    }

    local flags = ""
    if pane.is_zoomed then
        flags = flags .. "↕ "
    end
    for _, pane in ipairs(tab.panes) do
        if pane.has_unseen_output then
            flags = flags .. "! "
            break
        end
    end
    if flags ~= "" then
        for _, i in pairs({
            { Foreground = { Color = "red" } },
            { Text = flags },
        }) do
            table.insert(t, i)
        end
    end

    local s = pane.domain_name
    local p = "SSH:"
    local domain = (s:sub(0, #p) == p) and s:sub(#p+1) or s
    if domain and domain ~= "local" then
        for _, i in pairs({
            { Text = " " },
            { Foreground = { Color = "yellow" } },
            -- { Background = { Color = "lightblue" } },
            { Text = domain .. ": " },
        }) do
            table.insert(t, i)
        end
    end

    for _, i in pairs({
        { Foreground = { Color = foreground } },
        { Text = title },
    }) do
        table.insert(t, i)
    end

  -- for _, i in pairs({
  --     { Text = " " },
  -- }) do
  --     table.insert(t, i)
  -- end

  return t
end )

-- wezterm.on(
--   'format-tab-title2',
--   function(tab, tabs, panes, config, hover, max_width)
--     local edge_background = '#0b0022'
--     local background = '#1b1032'
--     local foreground = '#808080'
--
--     if tab.is_active then
--       background = '#2b2042'
--       foreground = '#c0c0c0'
--     elseif hover then
--       background = '#3b3052'
--       foreground = '#909090'
--     end
--
--     local edge_foreground = background
--
--     local title = tab_title(tab)
--
--     -- ensure that the titles fit in the available space,
--     -- and that we have room for the edges.
--     title = wezterm.truncate_right(title, max_width - 2)
--
--     return {
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = SOLID_LEFT_ARROW },
--       { Background = { Color = background } },
--       { Foreground = { Color = foreground } },
--       { Text = title },
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = SOLID_RIGHT_ARROW },
--     }
--   end
-- )

return module
