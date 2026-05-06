# ~/.bashrc

# Ubuntu defaults
[ -f ~/.bashrc.d/skel.bash ] && . ~/.bashrc.d/skel.bash

# Environment and PATH
[ -f ~/.bashrc.d/env.bash ] && . ~/.bashrc.d/env.bash

# Navigation
[ -f ~/.bashrc.d/navigation.bash ] && . ~/.bashrc.d/navigation.bash

# Aliases
[ -f ~/.bashrc.d/aliases.bash ] && . ~/.bashrc.d/aliases.bash

# Functions
[ -f ~/.bashrc.d/functions.bash ] && . ~/.bashrc.d/functions.bash

# fzf
[ -f ~/.bashrc.d/fzf.bash ] && . ~/.bashrc.d/fzf.bash

# Prompt
[ -f ~/.bashrc.d/prompt.bash ] && . ~/.bashrc.d/prompt.bash

# MOTD
command -v fastfetch &>/dev/null && fastfetch --logo small --logo-color-1 yellow
