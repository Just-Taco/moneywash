fx_version 'adamant'

game 'gta5'


server_scripts {
    "lib/Tunnel.lua",
	"lib/Proxy.lua",
	"@vrp/lib/utils.lua",
    'config.lua',
	'server/main.lua'
	
}

client_scripts {
    "lib/Tunnel.lua",
	"lib/Proxy.lua",
    'config.lua',
	'client/main.lua'
}

ui_page "html/index.html"
files({
    'html/index.html',
    'html/index.js',
    'html/main.css'
})