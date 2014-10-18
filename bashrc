# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

source $HOME/dotfiles/alias
source $HOME/dotfiles/export
if [ -f $HOME/dotfiles/local/bashrc ]; then
  source $HOME/dotfiles/local/bashrc
fi

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

function git_branch_with_format {
  if [[ "`git rev-parse --is-inside-work-tree 2>/dev/null`" = "true" ]]; then
    _branch=`gbn 2>/dev/null`
    if [[ -n ${_branch} ]]; then
      echo "(${_branch})"
    fi
  fi
}

PS1='\n\[\033[0;37m\][\[\033[0;33m\]\u\[\033[0;31m\]@\[\033[0;34m\]\h \[\033[01;36m\]\w\[\033[0;37m\]] \[\033[$(git_status)m\]`git_branch_with_format`\[\033[00m\]`git_not_pushed`\n\$ '

peco --version 2> /dev/null
if [ "$?" == "0" ]; then
  bind '"\C-r":"history -n 1 | eval \"tail -r\" | peco\n"'
fi

