function install-docker(){
	set -x
	sudo dnf install dnf-plugins-core
	if [ ! -f /etc/yum.repos.d/docker-ce.repo ]; then
		sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	fi
	sudo dnf install docker-ce
	set +x
}

function install-ansible(){
	set -x
	sudo dnf install ansible
	if [ ! -L ~/ansible ]; then
		ln -s ~/scripts/ansible ~/ansible
	fi
	if [ ! -L /etc/ansible/ansible.cfg ]; then
		sudo rm -i /etc/ansible/ansible.cfg
		sudo ln -s ~/ansible/ansible.cfg /etc/ansible/ansible.cfg
	fi
	set +x
}
function install-wireguard(){
	set -x
	sudo dnf copr enable jdoss/wireguard
	sudo dnf install wireguard-dkms wireguard-tools
	set +x
}

function main-packages(){
  set -x
  sudo dnf install powerline-fonts git zsh i3 sqlite
  set +x
}

function install-editors(){
  set -x
  atom-repo
  code-repo

  dnf install code atom
  set +x
}

function atom-repo(){
  if [ ! -f /etc/yum.repos.d/atom.repo ]; then
    sudo rpm --import https://packagecloud.io/AtomEditor/atom/gpgkey
    sudo sh -c "cat << EOF > /etc/yum.repos.d/atom.repo
[Atom]
name=Atom Editor
baseurl=https://packagecloud.io/AtomEditor/atom/el/7/$basearch
enabled=1
gpgcheck=0
repo_gpgcheck=1
gpgkey=https://packagecloud.io/AtomEditor/atom/gpgkey
EOF"
  else
    echo "atom repo already added"
  fi
}

function code-repo(){
  if [ ! -f /etc/yum.repos.d/vscode.repo ]; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c "cat << EOF > /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF"
  else
    echo "code repo already exists"
  fi
}

function install-stuff(){
  set -x
  sudo dnf install snapd

  sudo ln -s /var/lib/snapd/snap /snap

  sudo snap install insomnia

  sudo dnf install gnome-tweak-tool pavucontrol
  set +x
}
