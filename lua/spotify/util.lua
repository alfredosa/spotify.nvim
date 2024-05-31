local util = {}

function util.check_api_key()
  local api_key = os.getenv 'SPOTIFY_API_KEY'
  if not api_key then
    error 'SPOTIFY_API_KEY environment variable is not set!'
  end
  return api_key
end

return util
