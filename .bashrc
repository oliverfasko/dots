#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias ls='ls --color=auto'
#alias grep='grep --color=auto'
#PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '

PS1='\[\033[38;2;148;226;213m\]\d \t\[\033[0m\] \[\033[38;2;166;227;161m\]\u\[\033[0m\]:\[\033[38;2;192;191;188m\]\w\[\033[0m\]\[\033[38;2;205;214;244m\]\$ \[\033[0m\]'

export MANPAGER="bat -plman"

# aliases
alias ..='cd ..'
alias cd..='cd ..'

alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -A'
alias lla='lsd -lA'

alias update='yay -Syu'

alias cat='bat'
alias grep='batgrep'

alias v="nvim"
alias vs='nvim $(fzf -m --preview="bat --color=always {}")'

fastfetch
echo ""
source ~/.color
