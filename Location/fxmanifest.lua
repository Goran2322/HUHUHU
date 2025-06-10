fx_version 'cerulean'
game 'gta5'

author 'X'
description 'Standalone Player Info HUD with Persistent Playtime'
version '1.0.0'

dependencies {
    'pma_voice' -- Ensure PMA-Voice loads first
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}