local util = {}

-- Function to check if the Spotify API key is set
function util.check_api_key()
  local client_id = os.getenv 'SPOTIFY_BASE64'

  if not client_id then
    error 'SPOTIFY_CLIENT_ID or SPOTIFY_CLIENT_SECRET environment variable is not set!'
  end

  return client_id
end

return util
