-- /Users/alfredosuarez/codehub/spotify.nvim/lua/spotify_plugin/init.lua

local util = require 'spotify.util'
local Popup = require 'nui.popup'
local spotify_api = require 'spotify.spotify'
local M = {}

-- Default configurations
local defaults = {
  api_key = nil,
  floating_window = true,
  floating_window_opts = {
    border = 'rounded',
    width = 40,
    height = 7,
    position = '100%',
  },
}

-- Global flag
SpotifyFloatingEnabled = true

-- Setup function with API key check
function M.setup(opts)
  -- Merge user options with defaults
  M.config = vim.tbl_deep_extend('force', defaults, opts or {})

  local client_id = util.check_api_key()

  -- Store API key in the configuration
  M.config.api_key = client_id

  print 'Spotify plugin configured successfully!'
  M.create_floating_window()
end

-- Create the floating window
function M.create_floating_window()
  local popup = Popup {
    position = M.config.floating_window_opts.position,
    anchor = M.config.floating_window_opts.anchor,
    relative = 'editor',
    size = {
      width = M.config.floating_window_opts.width,
      height = M.config.floating_window_opts.height,
    },
    enter = true,
    focusable = false, -- Do not steal focus from the editor
    border = M.config.floating_window_opts.border,
    win_options = {
      winblend = 10,
      winhighlight = 'Normal:Normal,FloatBorder:SpecialChar',
    },
  }

  -- Mount the popup to the current buffer
  popup:mount()

  -- Set content of the popup
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, {
    'Spotify',
    '.................',
    'Song: [Song Name]',
    'Artist: [Artist Name]',
  })

  -- Store the popup reference
  M.floating_window = popup
  M.floating_window:hide()

  M.mounted = false
end

-- Update the content of the floating window
function M.update_floating_window(song, artist)
  if M.floating_window then
    vim.api.nvim_buf_set_lines(M.floating_window.bufnr, 2, 4, false, {
      'Song: ' .. song,
      'Artist: ' .. artist,
    })
  end
end

-- Function to toggle the visibility of the floating window
function M.toggle_floating_window()
  if M.mounted then
    M.floating_window:hide()
    M.mounted = false
  else
    M.floating_window:show()
    M.mounted = true
  end
end

-- Spotify controls (placeholders, add your implementation)
function M.play()
  print 'Playing Spotify...'
  -- Add API call logic here
  M.handle_spotify_event { type = 'play', song = 'Call me Maybe', artist = 'Carly Ray Jackson' }
end

function M.pause()
  print 'Pausing Spotify...'
end

function M.next()
  print 'Skipping to next track on Spotify...'
  -- Add API call logic here
end

function M.prev()
  print 'Back to previous track on Spotify...'
  -- Add API call logic here
end

-- Function to handle Spotify events and update the floating window
function M.handle_spotify_event(event)
  if event.type == 'play' then
    spotify_api.get_current_song()
    M.update_floating_window(event.song, event.artist)
  elseif event.type == 'pause' then
    -- Handle pause event
  elseif event.type == 'next' then
    -- Handle next event
  elseif event.type == 'prev' then
    -- Handle previous event
  end
end

return M
