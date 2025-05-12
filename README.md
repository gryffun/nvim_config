# Lightweight nvim set up

Should autoinstall lazy.nvim to handle plugins. Simply place the contents of this repo in the .config/nvim directory on linux, or %Appdata%/Local/nvim folder on windows

requirements:
- git (obviously)
- curl
- openssl

Set up for lua servers on nvim for windows. If you dont care about lua delete the server set up in lsp.lua for the lspconfig
> cd $env:LOCALAPPDATA\nvim-data\lsp_servers\lua_ls\meta\3rd<br>
> git clone https://github.com/LuaLS/LLS-Addons.git

