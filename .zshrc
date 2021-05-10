# some configs you can use.

ZSH_THEME="essembeh"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gcloud)


alias g='git'
alias s='git status --short --branch'
alias ss='git status'
alias a='git add'
alias ch='git checkout'
alias gdf='git diff'
alias l='ls -F'
alias ll='ls -lF'
alias lsal='ls -al'
alias la='ls -al'
alias f='git fetch'
alias cm='git commit'
alias log='git log --graph --all --format="%x09 %C(cyan bold)%an %C(red)%ad %x09 %C(yellow)%h %C(reset)%C(blue reverse)%d%C(reset) %C(blue)%s" --date=format:"[%Y-%m-%d %H:%M:%S]"'
alias b='git branch'
alias ..='cd ..'
alias cl='clear'
alias py='python'
alias lg="git log --oneline --pretty=format:'%C(yellow)%h %C(red)[%cd]  %C(white)<%an> %d %C(blue)%s' --abbrev-commit --date=format:'%Y-%m-%d %H:%M:%S'"


# docker alias
alias dc='docker'
alias dcps='docker ps'
alias dcpsa='docker ps -a'
alias img='docker image ls'
alias cmps='docker-compose'

alias scls='screen -ls'
alias sc='screen'
alias scr='screen -r'
alias tm='tmux'
alias tmnew='tmux new -s'
alias tmls='tmux ls'
alias tma='tmux a -t'
alias tmks='tmux kill-session -t'
alias hs="history -d"
alias tp="top -n 10 -s 3"

alias rm="rm -iv"

alias tmsname="tmux display-message -p '#S'"

setopt no_beep
