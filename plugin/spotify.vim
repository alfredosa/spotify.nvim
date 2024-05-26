" plugin/spotify.vim
lua require('spotify')

command! SpotifyPlay lua require('spotify').play()
command! SpotifyPause lua require('spotify').pause()
command! SpotifyNext lua require('spotify').next()