fx_version 'cerulean'
game 'gta5'

author 'X'
description 'Standalone Inventory System'
version '1.0.0'

ui_page 'html/index.html'

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

shared_scripts {
    'config.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/icons/*.png'
}

-- Dependencies (remove if not needed)
-- dependencies {
--     'es_extended'
-- }