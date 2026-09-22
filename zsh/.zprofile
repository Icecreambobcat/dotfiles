# Initialise Homebrew before applying explicit PATH overrides.
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# First match wins. Prefer the full media tools and remove duplicate entries.
typeset -U path PATH
path=(
    /opt/homebrew/opt/imagemagick-full/bin
    /opt/homebrew/opt/ffmpeg-full/bin
    /opt/homebrew/bin
    /opt/homebrew/sbin
    /opt/homebrew/opt/make/libexec/gnubin
    /opt/homebrew/opt/rustup/bin
    /opt/homebrew/opt/llvm/bin
    /opt/homebrew/opt/sqlite/bin
    /opt/homebrew/opt/arm-gcc-bin@15/bin
    $path
    "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
    "$HOME/.local/bin"
    "$HOME/.lmstudio/bin"
    /Applications/Obsidian.app/Contents/MacOS
)

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib -L/opt/homebrew/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include -I/opt/homebrew/include"
export CMAKE_PREFIX_PATH="/opt/homebrew/opt/llvm"
export GPG_TTY=$(tty)
export YABAI_CERT="yabai-cert"

export PYTHON_HISTORY=/dev/null

# Login environment only; the Oh My Zsh pyenv plugin handles interactive init.
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && path=("$PYENV_ROOT/bin" $path)
eval "$(pyenv init --path)"
