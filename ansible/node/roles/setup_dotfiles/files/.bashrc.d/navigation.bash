# Directory navigation

# Auto-cd: type a directory name to cd into it (bash 4.0+)
shopt -s autocd 2>/dev/null

# Typo correction for cd and tab-completion
shopt -s cdspell 2>/dev/null
shopt -s dirspell 2>/dev/null

# Dot aliases
alias -- -='cd -'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
