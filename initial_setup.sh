USER=wohlben
HOME_DIRECTORY="/home/wohlben"
source /etc/os-release

function ubuntu-git(){
  apt install git
}
function fedora-git(){
  dnf install git
}

if [ "$(whoami)" != "root" ]; then
	echo "can't do anything without sudo"
	exit
fi

# SUDOERS
if [ ! -f /etc/sudoers.d/$USER ]; then
	echo "adding $USER to sudoers"
	echo "$USER  ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER
else
	echo "User already has a sudoers file"
fi


### INSTALLATION
${ID}-git

# DOTFILES
if [ ! -d ${HOME_DIRECTORY}/.dotfiles ]; then
	echo "cloning dotfiles repo"
	git clone --recursive https://github.com/wohlben/dotfiles ${HOME_DIRECTORY}/.dotfiles
	chown $USER:$USER ${HOME_DIRECTORY}/.dotfiles -R
else
	echo "dotfiles repo already exists"
fi

# DEPENDENCIES
source ${HOME_DIRECTORY}/.dotfiles/scripts/${ID}.sh
main-packages

# FZF
if [ ! -f ${HOME_DIRECTORY}/.dotfiles/fzf/bin/fzf ]; then
	echo "installing fzf"
	${HOME_DIRECTORY}/.dotfiles/fzf/install
else
	echo "fzf already exists"
fi

# GIT WIP
if [ ! -L ${HOME_DIRECTORY}/apps/git-wip ]; then
	echo "linking git-wip"
	ln -s ${HOME_DIRECTORY}/.dotfiles/git-wip/git-wip ${HOME_DIRECTORY}/apps/git-wip
else
	echo "git-wip already linked"
fi

### CONFIG
echo "symlinking config files to dotfiles repo"
ln -sf ${HOME_DIRECTORY}/.dotfiles/vimrc ${HOME_DIRECTORY}/.vimrc
ln -sf ${HOME_DIRECTORY}/.dotfiles/zshrc ${HOME_DIRECTORY}/.zshrc
ln -sf ${HOME_DIRECTORY}/.dotfiles/gitconfig ${HOME_DIRECTORY}/.gitconfig
ln -sf ${HOME_DIRECTORY}/.dotfiles/vim ${HOME_DIRECTORY}/.vim
test -L ${HOME_DIRECTORY}/.dotfiles/vim/vim && unlink ${HOME_DIRECTORY}/.dotfiles/vim/vim
test -L ${HOME_DIRECTORY}/.config/i3 || ( rm -rf ${HOME_DIRECTORY}/.config/i3 && echo "removed nonsymlink i3 config file" )
ln -sf ${HOME_DIRECTORY}/.dotfiles/i3 ${HOME_DIRECTORY}/.config/

if [[ "$(grep $USER /etc/passwd | cut -d ':' -f 7)" != "/usr/bin/zsh" ]]; then
	echo "setting zsh as default shell"
	chsh  -s /usr/bin/zsh $USER
else
	echo "zsh is already default shell for $USER"
fi

### FINISHING
cat << EOF

finish installation:

source /etc/os-release
source ${HOME_DIRECTORY}/.dotfiles/scripts/${ID}.sh
install-editors
install-stuff
----


xrandr --status
--> xrandr --output DISPLAY --mode RESOLUTION --pos 0x0 ...
sed -e "s/xrandr --.*/${NEW_COMMAND}/"
EOF
