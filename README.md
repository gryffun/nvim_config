# Lightweight nvim set up

## Notes
Dependencies for install (that I can remember):
- git (obviously)
- curl
- openssl
- tar
- gcc or some other c compiler
- libstdc++ / libstdc++6
- npm (for node)
- node (for treesitter)

Run the appropriate commands for these for your OS.

Neovim plugins are manages with [lazy.nvim](https://github.com/folke/lazy.nvim) for this config.

Treesitter configures its parsers to a direcory outside the normal "lazy" folder things are installed to in this config. This is just because I was having some troubles in windows with treesitter and wanted the parsers separate. It installs the .so/dll to the nvim-data/site/parsers (which on linux is just nvim in .local/share).

## Linux (and probably Mac) Config

Should just work with some luck if you're using Linux. Just cd to .config for your user and run:
<pre> git clone https://github.com/gryffun/nvim_config nvim </pre>

## Windows Config

Theres a bit more shenanigans here
First you have to open the command shell in %APPDATA%/Local then, just like Linux, run:
<pre> git clone https://github.com/gryffun/nvim_config nvim </pre>


### Installing Language Parsers
[Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter) is a pain in the ass and (at least on my system) doesn't compile its parsers to .dll files and throws an error:

> Error detected while processing BufNewFile Autocommands for "*":                                                        Error executing lua callback: C:/Program Files/Neovim/share/nvim/runtime/filetype.lua:36: BufNewFile Autocommands for "*"..FileType Autocommands for "*": Vim(append):Error executing lua callback: ...m Files/Neovim/share/nvim/runtime/lua/vim/treesitter.lua:431: Parser could not be created for buffer 1 and language "css"

The best way around this I have managed to find is compiling the parsers with [Tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md).
#### Compilation steps
1. If you don't already have it, The [Tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md) can be installed with:
<pre> npm install -g tree-sitter-cli </pre>

2. Then go to their [list of parsers](https://github.com/tree-sitter/tree-sitter/wiki/List-of-parsers) and clone one of them anywhere on disk:
<pre> git clone https://you're/parser/repo/here </pre>

3. Either open a terminal inside of, or cd into the **newly cloned folder**.

4. Copy paste into Powershell: <pre> tree-sitter generate </pre> in Powershell

5. Then you need to run (replacing the link with your information): <pre> tree-sitter build %AppData%\Local\nvim-data\site\parser\parser\the_language_name_in_lowecase.dll . </pre>


## Linking Unity (if you like that kind of thing)
Unity does not support Neovim.

There may be convoluted ways to set it up so that you get all the functionality and integration of the supported IDEs but the easiest way I have found is to use [VSCode Neovim](https://github.com/vscode-neovim/vscode-neovim).

This is available as an extension on VSCode and then all you have to do is set it to your External Script Editor. That's in:
> Edit/Preferences/External Tools

This nvim set up is configured so that it should work with VSCode out of the box, but if you have a custom init.lua it may not. Certain plugins need to be disabled to work well with VSCode, so bear that in mind. You might have to read some [VSCode Neovim](https://github.com/vscode-neovim/vscode-neovim) documentation to figure out what can and can't work.


## Hints for Noobs (and me if I forget something :P)
Neovim cares about certain file placements. This will cover things that are used in set up and explain some stuff. It will probably grow over time so if you have questions maybe I'll answer them in the future.

### Config files
Neovim sets its self up every time it is run from some config files that you can customise to your hearts content. Thats what this repo does, but its all what I like. Its worth knowing where these are located and whatnot so you can customise it yourself. Its a really awesome feature of vim and not that hard to get your head around.

Neovim looks for either a init.lua/init.vim file at the config location for your OS. Init.lua is interpreted as Lua and .vim is interpreted as vimscript. Mine is in Lua so I'll call it init.lua from now on, but know both are viable forms for the config. It also looks for a data folder which on windows is called nvim-data and is located alongside the config folder. On Linux its also called nvim, but its located elsewhere.

If you're copying this repo you should clone it at the destination the folder is supposed to be at. There is no need to create the nvim folder there.

If you're making your own however, you should create these folders if they don't already exist (though the data one at least probably does).

#### Windows
On windows the init.lua is looked for at:<br>
**[~](# "Hint: If you didn't know, this is a shorthand for user home. On windows thats C:\Users\YOU!")\Appdata\Local\nvim**

and nvim-data is looked for at:<br>
**[~](# "Hint: If you didn't know, this is a shorthand for user home. On windows thats C:\Users\YOU!")\Appdata\Local\nvim-data**

#### Linux/Mac
Init.lua is looked for inside:<br>
**[~](# "Hint: If you didn't know, this is a shorthand for user home.")/.config/nvim**

and the data is stored at:<br>
**[~](# "Hint: If you didn't know, this is a shorthand for user home.")/.local/share/nvim**

