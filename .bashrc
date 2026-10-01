#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias ls='ls --color=auto'
#alias grep='grep --color=auto'

#PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '
#PS1='\[\033[38;2;184;187;38m\]\u\[\033[0m\]@\[\033[38;2;254;128;25m\]\h\[\033[0m\]:\[\033[38;2;137;180;250m\]\w\[\033[0m\]\[\033[38;2;251;57;52m\]\$ \[\033[0m\]'
__git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/^/ (/;s/$/)/'
}
PS1='\[\e[34m\]\w\[\e[0m\]\[\e[33m\]$(__git_branch)\[\e[0m\] \$ '

export MANPAGER="bat -plman"
export PATH="$HOME/.local/bin:$PATH"

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

fetchit
echo ""
source ~/.color
source -- ~/.local/share/blesh/ble.sh
