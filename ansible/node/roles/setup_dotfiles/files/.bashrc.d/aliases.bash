# Custom aliases

alias python="python3"
alias eb="$EDITOR ~/.bashrc"
alias sb="source ~/.bashrc"

# Safer defaults
alias cp="cp -iv"
alias mv="mv -iv"
alias mkdir="mkdir -pv"

# Git
alias g="git"
alias gp="git push"
alias gl="git pull"
alias gdev="git checkout dev && git pull"

# Bun
alias bi="bun install"
alias bb="bun run build"

# Systemd
alias sc="sudo systemctl"
alias jcf="sudo journalctl -f"

# Networking
alias ports="ss -tulnp"

# bat (Ubuntu installs as batcat)
if command -v batcat &>/dev/null; then
    alias bat="batcat"
fi
