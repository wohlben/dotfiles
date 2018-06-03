function main-packages(){
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

}

function install-editors(){
  :
}

function install-stuff(){
  :
}
