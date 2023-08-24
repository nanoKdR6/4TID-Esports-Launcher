fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'nanoKid - GitHub: https://github.com/nanoKidR6/4TID-Esports-Repo'

version '1.0.1'

client_script {
	'client.lua',
	'config.lua'
}

server_script {
	'config.lua',
	'server.lua'
}

files {
	'stream/*.ytyp',
	'stream/*.ydr',
}

data_file 'DLC_ITYP_REQUEST' 'stream/pm_tree_crystal_cctv.ytyp'
