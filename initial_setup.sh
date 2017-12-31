USER=wohlben

test -f /etc/sudoers.d/$USER || echo "$USER  ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER

# i3wm key
test -f /etc/apt/trusted.gpg.d/sur5r-keyring-2015.gpg || \
	( /usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2017.01.02_all.deb keyring.deb SHA256:4c3c6685b1181d83efe3a479c5ae38a2a44e23add55e16a328b8c8560bf05e5f && \
	dpkg -i ./keyring.deb && rm ./keyring.deb )

# i3wm repo
test -f /etc/apt/sources.list.d/sur5r-i3.list || \
	echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" >> /etc/apt/sources.list.d/sur5r-i3.list

apt-get update -q > /dev/null && apt-get install -qy git i3 zsh sqlite3 fonts-powerline

cd /home/$USER || exit 2
test -d .dotfiles || ( git clone --recursive https://github.com/wohlben/dotfiles .dotfiles && \
	chown $USER:$USER dotfiles -R )

ln -sf .dotfiles/vimrc .vimrc
ln -sf .dotfiles/zshrc .zshrc
ln -sf .dotfiles/gitconfig .gitconfig
ln -sf .dotfiles/vim .vim
test -L .config/i3 || rm -rf .config/i3
ln -sf ../.dotfiles/i3 .config/

if [[ "$(grep $USER /etc/passwd | cut -d ':' -f 7)" != "/usr/bin/zsh" ]]; then
	chsh  -s /usr/bin/zsh $USER
fi



