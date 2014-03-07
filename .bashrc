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

function git_branch {
	_branch=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'`
	echo $_branch
}

function git_not_pushed {
  if [[ "`git rev-parse --is-inside-work-tree 2>/dev/null`" = "true" ]]; then
    _head="`git rev-parse --verify -q HEAD 2>/dev/null`"
    if [[ $? -eq 0 ]]; then
      _branch=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
      _remote=`git show-ref origin/${_branch} | cut -d ' '  -f1`
      if [[ -n "${_remote}" ]]; then
        if [[ "${_head}" = "${_remote}" ]]; then
          return
        fi
        echo "*"
      fi
    fi
  fi
}

PS1='\[\033[0;37m\][\[\033[0;33m\]\u\[\033[0;31m\]@\[\033[0;34m\]\h \[\033[01;36m\]\W\[\033[0;37m\]] \[\033[$(git_status)m\]$(git_branch)$(git_not_pushed)\[\033[00m\]\$ '
