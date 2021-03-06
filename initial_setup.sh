HOME_DIRECTORY=~
source /etc/os-release

function askExecute(){
	local cmd="$1"
	which $cmd
	if [[ "$SHELL" == "/usr/bin/zsh" ]]; then
		vared -p "do that?" -c verifyEx
	else
		read -rp "do that?" verifyEx
	fi
	if [[ "$verifyEx" == "y" ]]; then
		$cmd
	else
		echo not doing that
	fi
}

function definePM(){
	declare -A packageManagers
	packageManagers=( ["fedora"]="dnf" ["ubuntu"]="apt" )
	export PACKAGEMANAGER="${packageManagers[${ID}]}"
	unset packageManagers
}

function installGit(){
	sudo $PACKAGEMANAGER install git

}

function enforceSudoers(){
	if [ ! -f /etc/sudoers.d/$USER ]; then
		echo "adding $USER to sudoers"
		sudo sh -c "echo \"$USER  ALL=(ALL:ALL) NOPASSWD: ALL\" > /etc/sudoers.d/$USER"
	else
		echo "User already has a sudoers file"
	fi
}

function enforceDotfiles(){
	if [ ! -d ${HOME_DIRECTORY}/.dotfiles ]; then
		echo "cloning dotfiles repo"
		git clone --recursive https://github.com/wohlben/dotfiles ${HOME_DIRECTORY}/.dotfiles
		chown $USER:$USER ${HOME_DIRECTORY}/.dotfiles -R
	else
		echo "dotfiles repo already exists"
	fi
}
function sourceCommands(){
	source ${HOME_DIRECTORY}/.dotfiles/scripts/${ID}.sh
}


function installFZF(){
	if [ ! -f ${HOME_DIRECTORY}/.dotfiles/fzf/bin/fzf ]; then
		echo "installing fzf"
		${HOME_DIRECTORY}/.dotfiles/fzf/install
	else
		echo "fzf already exists"
	fi
}

function installGitWip(){
	if [ ! -L ${HOME_DIRECTORY}/apps/git-wip ]; then
		echo "linking git-wip"
		ln -s ${HOME_DIRECTORY}/.dotfiles/git-wip/git-wip ${HOME_DIRECTORY}/apps/git-wip
	else
		echo "git-wip already linked"
	fi
}

function setSymlink(){
	local file=$1
	local dest_file=${2:-$1}
	local src=${HOME_DIRECTORY}/.dotfiles/$file
	local dest=${HOME_DIRECTORY}/$dest_file
	if [[ -L $dest ]]; then
		local actual_src=$(readlink $dest)
		if [[ $src != $actual_src ]]; then
			unlink $dest
		else
			echo $file has already been linked
			return
		fi
	else
		rm -rf $dest
		echo removed nonsymlink $dest
	fi
	ln -s $src $dest
}

function enforceConfigSymlinks(){
	echo "symlinking config files to dotfiles repo"
	setSymlink vimrc .vimrc
	setSymlink zshrc .zshrc
	setSymlink gitconfig .gitconfig
	setSymlink gitignore .gitignore
	setSymlink vim .vim
	test -L ${HOME_DIRECTORY}/.dotfiles/vim/vim && unlink ${HOME_DIRECTORY}/.dotfiles/vim/vim
	setSymlink i3 .config/i3
	setSymlink terminator .config/terminator
}

function enforceDefaultShell(){
	if [[ "$(grep $USER /etc/passwd | cut -d ':' -f 7)" != "/usr/bin/zsh" ]]; then
		echo "setting zsh as default shell"
		chsh  -s /usr/bin/zsh $USER
	else
		echo "zsh is already default shell for $USER"
	fi
}

function finishSetup(){
cat << EOF

finish installation:
----
i3 monitor setup
#####

xrandr --current
--> xrandr --output DISPLAY --mode RESOLUTION --pos 0x0 ...
sed -e "s/xrandr --.*/${NEW_COMMAND}/"
EOF
}

### INSTALLATION
function main(){
	definePM	
	askExecute "installGit"
	askExecute "enforceDotfiles"
	askExecute "sourceCommands"
	askExecute "enforceSudoers"
	askExecute "main-packages"
	askExecute "installFZF"
	askExecute "installGitWip"
	askExecute "enforceConfigSymlinks"
	askExecute "enforceDefaultShell"
	askExecute "install-editors"
	askExecute "install-stuff"
	finishSetup
}

