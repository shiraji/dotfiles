# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

source $HOME/dotfiles/.alias

function git_status {
	st=`git status 2> /dev/null`
	if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
		color="1;32"
	elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
		color="1;33"
	elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
		color="1;35"
	else
		color="1;31"
	fi
	echo $color
}

source $HOME/dotfiles/.common

PS1='\[\033[0;37m\][\[\033[0;33m\]\u\[\033[0;31m\]@\[\033[0;34m\]\h \[\033[01;36m\]\W\[\033[0;37m\]] \[\033[$(git_status)m\]$(git_branch)\[\033[00m\]`git_not_pushed`\$ '
