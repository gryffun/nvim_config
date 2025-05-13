# Lightweight nvim set up

requirements:
- git (obviously)
- curl
- openssl
- tar 
- gcc or some other c compiler
- libstdc++ (alpine) / libstdc++6 (debian)
- npm (for node)
- node (for treesitter)

Run the appropriate commands for these for your OS

## Linux Config

Should just work with some luck if you're using Linux. Just cd to .config for your user and run:
> git clone https://github.com/gryffun/nvim_config nvim

## Windows Config

You might have to do some shenanigans but it'll probably be fine
First you have to open the command shell in %APPDATA%/Local then, just like Linux, run:
> git clone https://github.com/gryffun/nvim_config nvim