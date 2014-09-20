# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="original"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git ruby ubuntu bunder apt-get rails emoji-clock)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:$HOME/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games


# 補完関数の表示を強化する
# http://qiita.com/PSP_T/items/ed2d36698a5cc314557d
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT
# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''


# manの補完をセクション番号別に表示させる
zstyle ':completion:*:manuals' separate-sections true


# [linux] open command URL
# Used Web browser : google chrome
# OSから近い処理に(検索をメインで使用するもの、CUIまたは、CUI開発言語周り、リポジトリなど)
# http://qiita.com/y_uuki/items/55651f44f91123f1881c
# url: $1, delimiter: $2, prefix: $3, words: $4..
function web_search {
  local url=$1       && shift
  local delimiter=$1 && shift
  local prefix=$1    && shift
  local query

  while [ -n "$1" ]; do
    if [ -n "$query" ]; then
      query="${query}${delimiter}${prefix}$1"
    else
      query="${prefix}$1"
    fi
    shift
  done

  xdg-open "${url}${query}"
}

# search in quiita
function qiita () {
  web_search "http://qiita.com/search?utf8=✓&q=" "+" "" $@
}

# search in goolge
function google () {
  web_search "https://www.google.co.jp/search?&q=" "+" "" $@
}

# search in metacpan
function perldoc() {
  command perldoc $1 2>/dev/null
  [ $? -ne 0 ] && web_search "https://metacpan.org/search?q=" "+" "" $@
  return 0
}

# search in rurima
function rurima () {
  web_search "http://rurema.clear-code.com" "/" "query:" $@
}

# search in rubygems
function gems () {
  web_search "http://rubygems.org/search?utf8=✓&query=" "+" "" $@
}

# search in github
function github () {
  web_search "https://github.com/search?type=Code&q=" "+" "" $@
}

# search in php.net
function phpdoc () {
  web_search "https://php.net/" "+" "" $*
}


# ls & git status : Enter alias
# http://qiita.com/yuyuchu3333/items/e9af05670c95e2cc5b4d
function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    chpwd
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
    fi
    zle reset-prompt
    return 0
}
zle -N do_enter
bindkey '^m' do_enter


# cd nothing
# http://qiita.com/puriketu99/items/e3c85fbe0fc4b939d0e2
setopt auto_cd
function chpwd() { ls_abbrev }

# short ls script
# http://qiita.com/yuyuchu3333/items/e9af05670c95e2cc5b4d
ls_abbrev() {
    if [[ ! -r $PWD ]]; then
        return
    fi
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}


# cheat-sheet
# http://qiita.com/PSP_T/items/ed2d36698a5cc314557d
cheat-sheet () { zle -M "`cat ~/zsh/cheat-sheet.conf`" }
zle -N cheat-sheet
bindkey "^[^h" cheat-sheet

git-cheat () { zle -M "`cat ~/zsh/git-cheat.conf`" }
zle -N git-cheat
bindkey "^[^g" git-cheat


#zaw.zsh
#http://yagays.github.io/blog/2013/05/20/zaw-zsh/
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

source $HOME/.zsh/zaw/zaw.zsh
zstyle ':filter-select' case-insensitive yes #絞り込みをcase-insensitiveに
bindkey '^@' zaw-cdr # zaw-cdrをbindkey


# alias

# tmux wrapper schript(tmux alias)
# tmux
alias tm='tmuxx'
alias tma='tmux attach -t'
alias tmn='tmux new-session -s'


#linux(ubuntu) only exection zsh-script & alias

#!zsh
#rm alias
alias rm='$HOME/bin/mvTrash'