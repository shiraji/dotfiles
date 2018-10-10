# incr.zshのimport
# 基本、incrは補完設定より前に読み込むこと。
# 後にすると、補完機能が使えなくなる。
source $HOME/.zsh/incr-0.2.zsh

# 履歴ファイルの保存先
HISTFILE=$HOME/.zsh-history

# メモリに保存される履歴の件数。(保存数だけ履歴を検索できる)
HISTSIZE=100000

# HISTFILE で指定したファイルに保存される履歴の件数
SAVEHIST=100000

# zsh: do you wish to see all NNN possibilitiesをサイズではなく、
# 画面に表示できるかどうかの判別するようにする。
# 表示できない場合は、too many matches.にする。
LISTMAX=0

## 補完機能の強化
autoload -U compinit
compinit

## プロンプトの設定
autoload colors
colors

## コアダンプサイズを制限
limit coredumpsize 102400

## 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr

## 色を使う
setopt prompt_subst

## ビープを鳴らさない
setopt nobeep

## 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs

## 補完候補一覧でファイルの種別をマーク表示
setopt list_types

## サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_resume

## 補完候補を一覧表示
setopt auto_list

## 補完候補を詰めて表示
setopt list_packed

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

## cd 時に自動で push
setopt autopushd

## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

## ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob

## TAB で順に補完候補を切り替える
setopt auto_menu

## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history

## =command を command のパス名に展開する
setopt equals

## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst

## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify

# ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort

## 出力時8ビットを通す
setopt print_eight_bit

## ヒストリを共有
setopt share_history

## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1

## 補完候補の色づけ
#eval `dircolors`
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

## ディレクトリ名だけで cd
setopt auto_cd

## カッコの対応などを自動的に補完
setopt auto_param_keys

## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

## スペルチェック
setopt correct

## エイリアス
setopt complete_aliases

## 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash

# propmtの設定
function set_prompt() {
  if [ -z "$SHORT_PROMPT" ]; then
    PROMPT='
[%F{yellow}%n%f%F{red}@%f%F{blue}%m%f %F{cyan}%~%f]`git-current-branch-status`
%(?.%F{green}.%F{red})%#%f '
    # 左側に時間を表示する。
    RPROMPT="[%F{magenta}%D %*%f]"
  else
    # SHORT_PROMPTが設定されていた場合、詳細情報を表示しない。
    PROMPT='%(?.%F{green}.%F{red})%#%f '
    RPROMPT=''
  fi
}

#プロンプトを表示直前に呼び出す
precmd() {
  set_prompt
}

# コマンドがない場合に呼ばれる。abort/edit/no/yesが選択肢。
SPROMPT="%r is correct? [a,e,n,y]: "

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

function peco-select-history() {
    BUFFER=$(\history -n 1 | \
        eval "tail -r" | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# export関連をimport
source $HOME/dotfiles/shell/export

# alias関連をimport
source $HOME/dotfiles/shell/alias

# それぞれの環境で必要な設定を読み込む
if [ -f $HOME/dotfiles/local/zshrc ]; then
  source $HOME/dotfiles/local/zshrc
fi

source $HOME/dotfiles/shell/gradle_zsh_comp


# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi
