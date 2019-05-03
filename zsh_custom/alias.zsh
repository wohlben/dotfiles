sudoCommands=( apt dpkg ifconfig netstat visudo docker )

for command in "${sudoCommands[@]}"
do
	hash $command 2> /dev/null && alias $command="sudo ${command}"
done

alias gadd='git add --all && git commit && git push --all'

# alias pgcli="/home/ben/pythonENVS/pgcli/bin/pgcli -d scraper"

alias i3settings="unset XDG_CURRENT_DESKTOP; unity-control-center"

function gitp(){
	if [[ $1 == ush ]]; then
		shift
		git push $*
	fi
}

alias enable_tv="bash ~/.dotfiles/monitor_settings.sh tv"
