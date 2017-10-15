sudoCommands=( apt dpkg ifconfig netstat visudo docker )

for command in "${sudoCommands[@]}"
do
	hash $command 2> /dev/null && alias $command="sudo ${command}"
done

alias gadd='git add --all && git commit && git push --all'

alias pgcli="/home/ben/pythonENVS/pgcli/bin/pgcli -d scraper"

