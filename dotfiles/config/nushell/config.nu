# config.nu
#
# Installed by:
# version = "0.104.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

$env.config = {
    show_banner: false
    edit_mode: vi
}

# Add .local/bin to PATH
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME | path join ".local/bin"))

# Aliases - add your custom aliases below
# Syntax: alias <name> = <command>

# Example aliases (uncomment or modify as needed):
alias ll = ls -la
alias la = ls -a
alias dev = cd ~/dev
alias .. = cd ..
alias ... = cd ../..
# alias gs = git status
# alias ga = git add
# alias gc = git commit
# alias gp = git push

# Initialize zoxide
source ($nu.default-config-dir | path join "zoxide.nu")

# justfile
def "nu-complete just" [] {
    (^just --dump --unstable --dump-format json | from json).recipes | transpose recipe data | flatten | where {|row| $row.private == false } | select recipe doc parameters | rename value description
}

# Just: A Command Runner
export extern "just" [
    ...recipe: string@"nu-complete just", # Recipe(s) to run, may be with argument(s)
]