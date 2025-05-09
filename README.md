LSP servers require Node.js and npm

Linux install:
> sudo apt install node npm


Using LSPs with Treesitter requires markdown to be installed, so run:
> :TSInstall markdown


Set up for lua servers on nvim for windows. If you dont care about lua delete the server set up in lsp.lua for the lspconfig
> cd $env:LOCALAPPDATA\nvim-data\lsp_servers\lua_ls\meta\3rd<br>
> git clone https://github.com/LuaLS/LLS-Addons.git

