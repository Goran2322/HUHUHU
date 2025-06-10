fx_version 'cerulean'
game 'gta5'

author 'X'
description 'Custom Chat System'
version '1.0.0'

ui_page 'ui.html'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

files {
    'ui.html'
}

-- Don't provide 'chat' to avoid conflicts with txAdmin
-- provide 'chat'