fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '4.0.0'
author 'WaveShield'
description 'WaveShield, The Best FiveM Anti-Cheat'
discord 'https://discord.gg/waveshield'
website 'https://waveshield.xyz'

ui_page 'web/ui.html'

client_scripts {
    "resource/include.lua",
    "resource/waveshield.js",
    "resource/client/main.lua",
}

server_scripts {
    "resource/include.lua",
    "resource/waveshield.js",
    "resource/server/exports.lua",
    "resource/server/auth.lua",
    "web/server.js",
}

files {
    'web/ui.html',
    'web/ui.js'
}

dependencies {
    "/server:14317",
-- Zm1hLnd0Zg==
    "/onesync",
-- V1dXV1dXV1dXV1dXV1dXV1cgZm1h
}