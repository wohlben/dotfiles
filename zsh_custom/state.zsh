
function dps(){

	local proj=${1:-novels}
	cd ~/code/$proj
	if [[ $proj == "novels" ]]; then
		nohup pipenv run terminator -l scrapes &!
		exit 
	else
		pipenv shell
	fi
}
_dps(){
	local dirs=( $(find ~/code/ -name Pipfile | grep -Po "(?<=code\/)(.*)(?=\/Pipfile)") )
	_describe "projects " dirs
}

compdef _dps dps
