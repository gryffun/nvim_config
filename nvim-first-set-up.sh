unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

echo ${machine}

if [ "$machine" == "Mac" ]; then
    cd ~/.local/share/nvim/lsp_servers/lua_ls/meta/3rd
    git clone https://github.com/LuaLS/LLS-Addons.git
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    mkdir -p ~/.local/share/lua_ls/addons
    cd ~/.local/share/lua_ls/addons
    git clone https://github.com/LuaLS/LLS-Addons.git
else
    echo "Machine not Mac or Linux. Cancelling set up"
fi
