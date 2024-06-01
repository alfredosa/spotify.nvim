local curl = require 'plenary.curl'
local cjson = require 'cjson.safe'

local M = {}

-- Function to get Spotify access token using client credentials flow
function M.get_spotify_access_token()
  local spotify_base64 = os.getenv 'SPOTIFY_BASE64'
  local token_url = 'https://accounts.spotify.com/api/token'
  local body = 'grant_type=client_credentials'

  local headers = {
    ['Authorization'] = 'Basic ' .. spotify_base64,
    ['Content-Type'] = 'application/x-www-form-urlencoded',
  }

  local response = curl.post(token_url, {
    body = body,
    headers = headers,
  })
  if response.status == 200 then
    PT(response.body)
    local parsed_response = cjson.decode(response.body)
    if parsed_response and parsed_response.access_token then
      return parsed_response.access_token
    else
      print 'Failed to obtain access token'
      return nil
    end
  else
    print('Failed to obtain access token. Status:', response.status)
    return nil
  end
end

-- Function to retrieve the current song from Spotify
function M.get_current_song()
  local ACCESS_TOKEN = M.get_spotify_access_token()
  print('Access Token received: ' .. ACCESS_TOKEN)
  local SPOTIFY_API_URL = 'https://api.spotify.com/v1/me/player/currently-playing'

  local headers = {
    ['Authorization'] = 'Bearer ' .. ACCESS_TOKEN,
  }

  local response = curl.get(SPOTIFY_API_URL, {
    headers = headers,
  })

  PT(response)

  if response.status == 200 then
    print 'API call successful'
    print('Response body:', response.body)
    return response.body
  else
    print 'API call failed'
    return nil
  end
end

-- Call the function to retrieve the current song
return M
