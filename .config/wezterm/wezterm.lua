local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local c = wezterm.config_builder()

c.adjust_window_size_when_changing_font_size = false
require('gui').setup(c)
require('key').setup(c)
require('tab')

ssh_domains = {}
ssh_targets = wezterm.default_ssh_domains()
for k, dom in ipairs(ssh_targets) do
  if not dom.name:match("(t|_T)$") and not dom.name:match("2HOME") and not dom.name:find("_")  and not dom.name:find("%.") then
      -- print("-> ", dom.name)
      table.insert(ssh_domains, dom)
  end
end
c.ssh_domains = ssh_domains
-- c.cursor_blink_ease_in = "Linear"
-- c.cursor_blink_ease_out = "Linear"

c.unix_domains = {
  {
    -- The name; must be unique amongst all domains
    name = 'mux',

    -- The path to the socket.  If unspecified, a resonable default
    -- value will be computed.

    -- socket_path = "/some/path",

    -- If true, do not attempt to start this server if we try and fail to
    -- connect to it.

    -- no_serve_automatically = false,

    -- If true, bypass checking for secure ownership of the
    -- socket_path.  This is not recommended on a multi-user
    -- system, but is useful for example when running the
    -- server inside a WSL container but with the socket
    -- on the host NTFS volume.

    -- skip_permissions_check = false,
  },
}

wezterm.on('open-uri', function(window, pane, uri)
    print("url",uri)
    local start, match_end = uri:find('file://')
    if start == 1 then
        local path = uri:sub(match_end + 1)
        local fname =  path:match( "([^/]+)$" )
        if fname:find("%.") then
            window:perform_action(
              wezterm.action.SendString('v '.. path ..'\n'),
              pane
            )
        else 
            window:perform_action(
              wezterm.action.SendString('cd '.. path ..'\nll\n'),
              pane
            )
        end
        return false
    end
    -- prevent the default action from opening in a browser
  -- otherwise, by not specifying a return value, we allow later
  -- handlers and ultimately the default action to caused the
  -- URI to be opened in the browser
end)


-- local tab, pane, window = mux.spawn_window({
-- cwd = "xxx"
-- })
-- tab:set_title "xxx"
-- pane:split()
-- local tab = window:spawn_tab {
-- cwd = "xxx"
-- }
-- tab:set_title "xxx"
-- local tab = window:spawn_tab {
-- cwd = "xxx"
-- }
-- tab:set_title "xxx"

c.launch_menu = {
  {
    label = 'top',
    args = { 'top' },
  },
  {
    label = 'htop',
    args = { 'htop' },
  },
  {
    label = 'btm',
    args = { 'btm' },
  },
  {
    -- Optional label to show in the launcher. If omitted, a label
    -- is derived from the `args`
    label = 'Bash',
    -- The argument array to spawn.  If omitted the default program
    -- will be used as described in the documentation above
    args = { 'bash', '-l' },

    -- You can specify an alternative current working directory;
    -- if you don't specify one then a default based on the OSC 7
    -- escape sequence will be used (see the Shell Integration
    -- docs), falling back to the home directory.
    -- cwd = "/some/path"

    -- You can override environment variables just for this command
    -- by setting this here.  It has the same semantics as the main
    -- set_environment_variables configuration option described above
    -- set_environment_variables = { FOO = "bar" },
  },
}

c.scrollback_lines = 10000



return c
