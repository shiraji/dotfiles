# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

source $HOME/dotfiles/shell/alias
source $HOME/dotfiles/shell/export
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

function root_non_root_sign_color() {
  if [[ "$1" == "0" ]]; then
    echo "1;32"
  else
    echo "1;31"
  fi
}

set_prompt() {
  _last_exist_status=$?
  if [ -z "$SHORT_PROMPT" ]; then
    PS1='\[\033[0;37m\][\[\033[0;33m\]\u\[\033[0;31m\]@\[\033[0;34m\]\h \[\033[01;36m\]\w\[\033[0;37m\]] \[\033[$(git_status)m\]`git_branch_with_format`\[\033[00m\]`git_not_pushed`\n\[\033[$(root_non_root_sign_color $_last_exist_status)m\]\$\[\033[00m\] '
  else
    PS1="\[\033[$(root_non_root_sign_color $_last_exist_status)m\]\$\[\033[00m\] "
  fi
}

PROMPT_COMMAND='set_prompt'

peco --version 2> /dev/null
if [ "$?" -eq "0" ]; then
  bind '"\C-r":"history -n 1 | eval \"tail -r\" | peco\n"'
fi

source $HOME/dotfiles/shell/gradle_bash_comp

# The next line updates PATH for the Google Cloud SDK.
if [ -f $HOME/google-cloud-sdk/path.bash.inc ]; then . $HOME/google-cloud-sdk/path.bash.inc; fi

# The next line enables shell command completion for gcloud.
if [ -f $HOME/google-cloud-sdk/completion.bash.inc ]; then . $HOME/google-cloud-sdk/completion.bash.inc; fi
