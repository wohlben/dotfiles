if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
	source /usr/local/bin/virtualenvwrapper.sh
	alias mkvenv="mkvirtualenv --python python3"
	alias rmvenv=rmvirtualenv
	alias cvenv=workon
	export WORKON_HOME=~/pythonENVS
fi

