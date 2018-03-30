USER=wohlben

if [ "$(whoami)" != "root" ]; then
	echo "can't do anything without sudo"
	exit
fi

if [ ! -f /etc/sudoers.d/$USER ]; then
	echo "adding $USER to sudoers"
	echo "$USER  ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER
else
	echo "User already has a sudoers file"
fi

# i3wm key
if [ ! -f /etc/apt/trusted.gpg.d/sur5r-keyring-2015.gpg ]; then
	echo "adding i3 apt key"
	/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2017.01.02_all.deb keyring.deb SHA256:4c3c6685b1181d83efe3a479c5ae38a2a44e23add55e16a328b8c8560bf05e5f
	dpkg -i ./keyring.deb
	rm ./keyring.deb
else
	echo "i3 apt key already exists"
fi

# i3wm repo
if [ ! -f /etc/apt/sources.list.d/sur5r-i3.list ]; then
	echo "adding i3 repo"
	. /etc/lsb-release
	echo "deb http://debian.sur5r.net/i3/ $DISTRIB_CODENAME universe" >> /etc/apt/sources.list.d/sur5r-i3.list
else
	echo "i3 repo already exists"
fi


apt_dependencies=(git i3 zsh sqlite3 fonts-powerline)
installed_packages=$(apt list --installed 2> /dev/null | grep -Po "(.*?)(?=\/)")
for dependency in "${apt_dependencies[@]}"; do
	if [[ ! "${installed_packages[@]}" =~ "$dependency" ]]; then
			echo "$dependency doesnt exist"
			echo "updating apt repository cache and installing it"
			apt-get update -q > /dev/null
			apt-get install -qy ${apt_dependencies[@]}
			break
	fi
done
echo -e "apt dependecies should be installed, if it failed use this: \n  apt install ${apt_dependencies[@]}"


if [ ! -d ~/.dotfiles ]; then
	echo "cloning dotfiles repo"
	git clone --recursive https://github.com/wohlben/dotfiles ~/.dotfiles
	chown $USER:$USER ~/.dotfiles -R
else
	echo "dotfiles repo already exists"
fi

echo "symlinking config files to dotfiles repo"
ln -sf ~/.dotfiles/vimrc ~/.vimrc
ln -sf ~/.dotfiles/zshrc ~/.zshrc
ln -sf ~/.dotfiles/gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/vim ~/.vim
test -L ~/.config/i3 || ( rm -rf ~/.config/i3 && echo "removed nonsymlink i3 config file" )
ln -sf ~/.dotfiles/i3 ~/.config/

if [[ "$(grep $USER /etc/passwd | cut -d ':' -f 7)" != "/usr/bin/zsh" ]]; then
	echo "setting zsh as default shell"
	chsh  -s /usr/bin/zsh $USER
else
	echo "zsh is already default shell for $USER"
fi
