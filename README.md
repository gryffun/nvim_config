# Fun Funny Fun Neovim Config
(idc what u say i have fun makin it)

## Notes

This is my personal Neovim config as it grows over time. It also has some tips and things I learned along the way. I recommend reading this if you're planning on using this config or if you're really new to Neovim it might be good for reference too.

Dependencies for install (that I can remember):

| OS                  | Install Command Prefix                           | Packages                                                                 |
| ------------------- | ------------------------------------------------ | ------------------------------------------------------------------------ |
| **Ubuntu / Debian** | `sudo apt-get update && sudo apt-get install -y` | git curl openssl tar build-essential libstdc++6 npm nodejs ripgrep cmake |
| **Fedora / RHEL**   | `sudo dnf install -y` (or `yum`)                 | git curl openssl tar libstdc++ npm nodejs ripgrep cmake          	    |
| **macOS**           | `brew install`                                   | git curl openssl tar libstdc++ npm node ripgrep cmake                    |
| **Arch Linux**      | `sudo pacman -Syu`                               | git curl openssl tar libstdc++ npm nodejs ripgrep cmake                  |


If you're on Windows you need the same but installing it might be less clear in some cases (e.g. ripgrep) and I can't member. I run **winget install** then the packages, but some of them might not be found. You should probably just fix the dependencies as they become an issue in that case. Here are the links to things which might be different though:
- [ripgrep](https://github.com/BurntSushi/ripgrep) for Telescope Live Grep
- [cmake](https://cmake.org/) to build some of the plugins


You also **need a c compiler** like gcc or clang.

Neovim plugins are manages with [lazy.nvim](https://github.com/folke/lazy.nvim) for this config.

Treesitter configures its parsers to a direcory outside the normal "lazy" folder things are installed to in this config. This is just because I was having some troubles in windows with treesitter and wanted the parsers separate. It installs the .so/dll to the nvim-data/site/parsers (which on linux is just nvim in .local/share).

### Formatter

There is a formatter installed for your scripts, but this won't run right off the bat. You need to install them, and know which ones you want installed. These are configured in plugins.lua under "stevearc/conform.nvim". You can change these to any supported by Mason as far as I know. They have to be changed in plugin.lua. Then ensure they are installed. To install it type :Mason in Neovim and go to the [5th tab](# "Hit 5 on your keyboard with Mason's UI open"). Then go down the list and find the ones you want to use.



## Linux (and probably Mac) Config

Should just work with some luck if you're using Linux. Just cd to .config for your user and run:

<pre> git clone https://github.com/gryffun/nvim_config nvim </pre>



## Windows Config

Theres a bit more shenanigans here
First you have to open the command shell in %APPDATA%/Local then, just like Linux, run:

<pre> git clone https://github.com/gryffun/nvim_config nvim </pre>

### Installing Language Parsers

[Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter) is a pain in the ass and (at least on my system) doesn't compile its parsers to .dll files and throws an error:

> Error detected while processing BufNewFile Autocommands for "_": Error executing lua callback: C:/Program Files/Neovim/share/nvim/runtime/filetype.lua:36: BufNewFile Autocommands for "_"..FileType Autocommands for "\*": Vim(append):Error executing lua callback: ...m Files/Neovim/share/nvim/runtime/lua/vim/treesitter.lua:431: Parser could not be created for buffer 1 and language "css"

The best way around this I have managed to find is compiling the parsers with [Tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md).

#### Compilation steps

1. If you don't already have it, The [Tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md) can be installed with:
<pre> npm install -g tree-sitter-cli </pre>

2. Then go to their [list of parsers](https://github.com/tree-sitter/tree-sitter/wiki/List-of-parsers) and clone one of them anywhere on disk:
<pre> git clone https://you're/parser/repo/here </pre>

3. Either open a terminal inside of, or cd into the **newly cloned folder**.

4. Copy paste into Powershell: <pre> tree-sitter generate </pre> in Powershell

5. Then you need to run (replacing the link with your information): <pre> tree-sitter build %AppData%\Local\nvim-data\site\parser\parser\the_language_name_in_lowecase.dll . </pre>

----

## Linking Unity (if you like that kind of thing)

Unity does not support Neovim by default.

There may be other convoluted ways to set it up so that you get all the functionality and integration of the supported IDEs but I've found 2 ways.

I use option 2 which links to another git repo by me.

### Option 1

One is to use VSCode as an intermediate between Neovim and Unity using[VSCode Neovim](https://github.com/vscode-neovim/vscode-neovim).
This is available as an extension on VSCode.
Then all you have to do is set it to your External Script Editor. That's in:
> Edit/Preferences/External Tools

This nvim set up is configured so that it should work with VSCode out of the box, but if you have a custom init.lua it may not. Certain plugins need to be disabled to work well with VSCode, so bear that in mind. You might have to read some [VSCode Neovim](https://github.com/vscode-neovim/vscode-neovim) documentation to figure out what can and can't work.

### Option 2

If you're on windows use [my Neovim launcher](https://github.com/gryffun/unity-neovim-launcher) or something like it. I didn't find any better solutions myself while looking. A better explanation of how it works is on that git. 

You can also make your own and I have some information there on what the problems are you have to solve. Its not very hard once all the problems are understood, but be aware there are some hoops to jump through to get unity to pass the right information if you want to go that route.

I haven't configured it for Linux yet but I suspect that a .sh will probably work instead of an exe which is required on windows.
Here is another resource where someone does something similar for Godot on Linux: [nvim-godot](https://github.com/niscolas/nvim-godot).
If you want to make it for Linux I recommend looking at my launcher just to see what problems I had to solve so you're aware of what similar things you might encounter.

-----

## Hints for Noobs (and me if I forget something :P)

Neovim cares about certain file placements. This will cover things that are used in set up and explain some stuff. It will probably grow over time so if you have questions maybe I'll answer them in the future.

### Config files

Neovim sets its self up every time it is run from some config files that you can customise to your hearts content. Thats what this repo does, but its all what I like. Its worth knowing where these are located and whatnot so you can customise it yourself. Its a really awesome feature of vim and not that hard to get your head around.

Neovim looks for either a init.lua/init.vim file at the config location for your OS. Init.lua is interpreted as Lua and .vim is interpreted as vimscript. Mine is in Lua so I'll call it init.lua from now on, but know both are viable forms for the config. It also looks for a data folder which on windows is called nvim-data and is located alongside the config folder. On Linux its also called nvim, but its located elsewhere.

If you're copying this repo you should clone it at the destination the folder is supposed to be at. There is no need to create the nvim folder there.

If you're making your own however, you should create these folders if they don't already exist (though the data one at least probably does).

#### Windows

On windows the init.lua is looked for at:<br>
**[~](# "Hint: If you didn't know, this is a shorthand for user home. On windows thats C:\\Users\\YOU!")\Appdata\Local\nvim**

and nvim-data is looked for at:<br>
**[~](# "Hint: If you didn't know, this is a shorthand for user home. On windows thats C:\\Users\\YOU!")\Appdata\Local\nvim-data**

#### Linux/Mac

Init.lua is looked for inside:<br>
**[~](# "Hint: If you didn't know, this is a shorthand for user home.")/.config/nvim**

and the data is stored at:<br>
**[~](# "Hint: If you didn't know, this is a shorthand for user home.")/.local/share/nvim**

### Text Editor Features for Languages

Neovim doesn't detect your langauge and load all the relevant things by default like VSCode would. This is manually configured and set up by you. Luckily [Mason](https://github.com/mason-org/mason.nvim) makes this easy. You need to know some stuff to make it nice but heres a quick run down.

> Run the Mason UI by typing :Mason in Neovim.

Syntax Highlighting is handled by [Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter). It will install langauge parsers for you. If you're on Linux this should automatically happen when you open a file of that langauge's type. If you're on Windows I've found it to be a little more complicated but I've described how I did it in the Windows Config section above.

The Language Server Protocol (LSP) is how your text editor (Neovim here) is going to communicate all that cool stuff like autocompletion or function definitions from external libraries.
Its important to have this installed for the language you're editing. This is handled in this package through [Mason](https://github.com/mason-org/mason.nvim) which is opened with the Neovim command :Mason. Install your relevant LSPs here by going to the second tab by pressing 2 on your keyboard.

Debug Adapter Protocols (DAP) can also be installed through :Mason. I don't currently use this in Neovim so there is no set up in this config for it. I may include this in future, in which case you won't see this. If you want to set it up yourself I recommend going to [nvim-dap](https://github.com/mfussenegger/nvim-dap) and following its documentation.

Linters are useful because they enforce standards in code. I have no standards so I don't use them. Seriously tho I haven't installed one cause they get in my way in this set up and I get a lot of the main functionality I want from this config anyway. If you want to set it up for yourself you can use [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim). I'm not entirely sure how to go about setting it up but I'm sure the documentation is fine for it probably maybe.

Formatters will determine if your language will be formatted on save. Again, you need to know which ones you need and these can be installed through [Mason](https://github.com/mason-org/mason.nvim). A list of ones which are to be used can be found either in the :Mason tab 5 or at the [conform.nvim](https://github.com/stevearc/conform.nvim) formatters section. This is the nvim package this config uses too conveniently. If you want to add more formatters and are using this config that plugin is located in lua/core/plugins.lua and just add it to the list that is already there in the same format.



### Useful copy/pastes

For if you're on linux and don't have a .local or .config. Useful if on containers. cd to your home and then:

<pre> mkdir .config && mkdir -p .local/share/nvim </pre>
