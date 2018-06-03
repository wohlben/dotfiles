function main-packages(){
  sudo dnf install powerline-fonts git zsh i3 sqlite
}

function install-editors(){
  atom-repo
  code-repo

  dnf install code atom
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
  sudo dnf install snapd

  sudo ln -s /var/lib/snapd/snap /snap

  sudo snap install insomnia
}
