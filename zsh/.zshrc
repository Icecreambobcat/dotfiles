clear
if [ $TERM = "xterm-kitty" ]; then
    # unimatrix -c cyan -wfo -s 95 -u '▁▂▃▄▅▆▇█' -l muuuuuuuu
    fastfetch
    echo -e "\033[1;91m--> INCOMING_MSG: \033[1;94mVim keybinds are enabled. Brought to you by yours truely, \033[1;92mIcecreambobcat.\n\033[0m"
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:plugins:alias-finder' autoload yes
zstyle :omz:plugins:ssh-agent quiet yes
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain

ENABLE_CORRECTION="false"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
HIST_STAMPS="dd.mm.yyyy"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

plugins=(
    git
    gh
    pyenv
    poetry
    # poetry-env
    brew
    kitty
    macos
    python
    safe-paste
    thefuck
    themes
    virtualenv
    vi-mode
    aliases
    # alias-finder
    command-not-found
    colored-man-pages
    ssh
    ssh-agent
    zoxide
    cp
    docker-compose
    docker
    fzf
    gitignore
    gpg-agent
    rust
    xcode
)

source $ZSH/oh-my-zsh.sh

# Autosuggestions and config items
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^ ' autosuggest-accept
bindkey -M menuselect '^[' undo

# Load other comps
fpath+=~/.config/zsh/comps

# load PROS completions
source "$HOME/Library/Application Support/PROS/autocomplete/pros-complete.zsh"
# Well its a bit of a hack but on well it works
_pros_completion_silent() {
  _pros_completion "$@" 2>/dev/null
}
compdef _pros_completion_silent pros

ZSH_THEME_TERM_TITLE_IDLE="~"
ZSH_THEME_TERM_TAB_TITLE_IDLE="~"

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

poetry_env() {
    eval $(poetry env activate)
}

# alias lg="lazygit"
alias lazygit="lg"
alias ld="lazydocker"
alias kd="kdash"
alias n="nvim"
alias la="eza -1 -l --icons=auto --classify=auto --git --git-repos --no-user --no-permissions"
alias j="zellij"
alias pipes="pipes.sh -t 3"
alias clock="tty-clock -sScb -C 6 -f '%A, %d %B, %Y'"
alias um="unimatrix -c cyan -fa -s 95 -u '▁▂▃▄▅▆▇█' -l muuuuuuuu"
alias ummm="unimatrix -c cyan -fa -s 95 -u '▁▂▃▄▅▆▇█' -l mggggGGGGccccCCCCuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"
alias sbr="sketchybar --reload"
alias steam_thing="launchctl remove com.valvesoftware.steam.ipctool"

alias pros='PYTHONWARNINGS="ignore:pkg_resources is deprecated as an API" pros'
alias prosv5='PYTHONWARNINGS="ignore:pkg_resources is deprecated as an API" pros'

t() { command tre "$@" -e nvim && source "/tmp/tre_aliases_$USER" 2>/dev/null; }

ff() { clear && fastfetch && echo -e "\033[1;91m--> INCOMING_MSG: \033[1;94mVim keybinds are enabled. Brought to you by yours truely, \033[1;92mIcecreambobcat.\n\033[0m" }

f() {
    fzf --style full \
        --border --padding 1,2 \
        --border-label ' FZF finder ' --input-label ' Input ' --header-label ' File Type ' \
        --preview 'fzf-preview.sh {}' \
    --bind 'result:transform-list-label:
        if [[ -z $FZF_QUERY ]]; then
          echo " $FZF_MATCH_COUNT items "
        else
          echo " $FZF_MATCH_COUNT matches for [$FZF_QUERY] "
        fi
    ' \
        --bind 'focus:transform-preview-label:[[ -n {} ]] && printf " Previewing [%s] " {}' \
        --bind 'focus:+transform-header:file --brief {} || echo "No file selected"' \
        --bind 'ctrl-r:change-list-label( Reloading the list )+reload(sleep 2; git ls-files)' \
        --color 'border:#aaaaaa,label:#cccccc' \
        --color 'preview-border:#9999cc,preview-label:#ccccff' \
        --color 'list-border:#669966,list-label:#99cc99' \
        --color 'input-border:#996666,input-label:#ffcccc' \
        --color 'header-border:#6699cc,header-label:#99ccff'
}

w () {
    ~/.config/zsh/scripts/fzf.zsh "$@"
}

yabai_upgrade() {
    yabai --stop-service
    yabai --uninstall-service
    sudo yabai --uninstall-sa
    sudo /opt/homebrew/bin/tccutil -r $(realpath $(which yabai))
    brew unpin yabai
    brew reinstall asmvik/formulae/yabai
    brew pin yabai
    codesign -fs "${YABAI_CERT:-yabai-cert}" "$(brew --prefix yabai)/bin/yabai"
    echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
    sudo /opt/homebrew/bin/tccutil -i $(realpath $(which yabai))
    sudo /opt/homebrew/bin/tccutil -e $(realpath $(which yabai))
    launchctl stop com.apple.tccd && sudo launchctl kickstart -k system/com.apple.tccd.system
    yabai --start-service
}

y () {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

zr () { zellij run --name "$*" -- zsh -ic "$*";}
zrf () { zellij run --name "$*" --floating -- zsh -ic "$*";}
zri () { zellij run --name "$*" --in-place -- zsh -ic "$*";}
ze () { zellij edit "$*";}
zef () { zellij edit --floating "$*";}
zei () { zellij edit --in-place "$*";}
zpipe () {
    if [ -z "$1" ]; then
        zellij pipe;
    else
        zellij pipe -p $1;
    fi
}

lg () {
    local ctxfile
    ctxfile=$(mktemp -t difft_ctx.XXXXXX)
    echo 3 > "$ctxfile"
    export DIFFTCTXFILE="$ctxfile"
    command lazygit "$@"
    unset DIFFTCTXFILE
    rm -f "$ctxfile"
}

gitnr () {
    if [[ $1 == 'create' && 'git rev-parse --is-inside-work-tree >/dev/null 2>&1' ]]; then
        shift
        command gitnr create "$@" -f $(git rev-parse --show-toplevel)/.gitignore
    elif [[ $# == 0 ]]; then
        command gitnr -h
    else
        command gitnr "$@"
    fi
}

source <(fzf --zsh)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autopair/autopair.zsh
