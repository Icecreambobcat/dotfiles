# Added by Toolbox App
export PATH="$PATH:/Users/icecreambobcat/Library/Application Support/JetBrains/Toolbox/scripts"

export PATH="/opt/homebrew/opt/arm-gcc-bin@15/bin:$PATH"
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="$PATH:/Users/icecreambobcat/.local/bin"
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/ffmpeg-full/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
export CMAKE_PREFIX_PATH="/opt/homebrew/opt/llvm"
export GPG_TTY=$(tty)
export YABAI_CERT="yabai-cert"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_COMPLETION_OPTS='--border --info=inline-right'
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'
export FZF_BASE="$(realpath "$(which fzf)")"

export FZF_CTRL_T_OPTS="--layout=reverse --border=none"
export FZF_CTRL_R_OPTS="--layout=reverse --border=none"
export FZF_ALT_C_OPTS="--layout=reverse --border=none"
export FZF_DEFAULT_OPTS="--highlight-line \
  --info=inline-right \
  --ansi \
  --border \
  --color=bg+:#283457 \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

export PYTHON_HISTORY=/dev/null


export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

eval "$(brew shellenv)"
