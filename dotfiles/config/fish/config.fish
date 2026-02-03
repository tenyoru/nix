# Fish configuration

# Disable greeting
set -g fish_greeting

# Vi keybindings
fish_vi_key_bindings

# Clipboard bindings (vi mode)
bind yy fish_clipboard_copy
bind Y fish_clipboard_copy
bind p fish_clipboard_paste

# Theme
theme_gruvbox dark hard

# Environment
set -gx EDITOR nvim
set -gx VISUAL nvim

# Aliases
alias vim nvim
alias v nvim
alias g git
alias ll 'ls -la'
alias la 'ls -A'
alias .. 'cd ..'
alias ... 'cd ../..'

# FZF configuration
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
