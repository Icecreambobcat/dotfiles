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
export PATH="/opt/homebrew/opt/imagemagick-full/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib -L/opt/homebrew/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include -I/opt/homebrew/include"
export CMAKE_PREFIX_PATH="/opt/homebrew/opt/llvm"
export GPG_TTY=$(tty)
export YABAI_CERT="yabai-cert"

export FZF_ALL_HIDDEN='fd --strip-cwd-prefix --hidden --follow --exclude .git --exclude Library'
export FZF_ALL_NORMAL='fd --strip-cwd-prefix --follow --exclude .git --exclude Library'
export FZF_DIRS_HIDDEN='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git --exclude Library'
export FZF_DIRS_NORMAL='fd --type d --strip-cwd-prefix --follow --exclude .git --exclude Library'

export FZF_DEFAULT_COMMAND="$FZF_ALL_NORMAL"
export FZF_CTRL_T_COMMAND="$FZF_ALL_NORMAL"
export FZF_ALT_C_COMMAND="$FZF_DIRS_NORMAL"

export FZF_COMPLETION_OPTS='--border=none --info=inline-right --walker-skip .git,Library --prompt="> " --bind "ctrl-h:ignore"'
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'
export FZF_BASE="$(realpath "$(which fzf)")"

export FZF_CTRL_T_OPTS="--layout=reverse --border=none"
export FZF_CTRL_R_OPTS="--layout=reverse --border=none --prompt='> ' --bind \"ctrl-h:ignore\""

export FZF_ALT_C_OPTS="--layout=reverse --border=none --prompt=' > ' \
  --bind \"ctrl-h:transform:
[[ \$FZF_PROMPT == ' > ' ]] &&
echo 'change-prompt(󰘓 > )+reload($FZF_DIRS_HIDDEN)' ||
echo 'change-prompt( > )+reload($FZF_DIRS_NORMAL)'
\"
"

export FZF_DEFAULT_OPTS=" --highlight-line \
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
  --prompt=' > ' \
    --bind \"ctrl-h:transform:
[[ \$FZF_PROMPT == ' > ' ]] &&
echo 'change-prompt(󰘓 > )+reload($FZF_ALL_HIDDEN)' ||
echo 'change-prompt( > )+reload($FZF_ALL_NORMAL)'
\"
"

export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS \
  --exact \
  --no-sort \
  --bind=ctrl-z:ignore,btab:up,tab:down \
  --cycle \
  --keep-right \
  --height=45% \
  --layout=reverse \
  --tabstop=1 \
  --prompt='> ' \
  --exit-0 \
  --bind \"ctrl-h:ignore\" \
  --preview=\"CLICOLOR=1 CLICOLOR_FORCE=1 SHELL=sh command -p ls -Cp {2..}\" \
  --preview-window=down,30%"

export YAZI_ZOXIDE_OPTS="$_ZO_FZF_OPTS --height=100%"

export PYTHON_HISTORY=/dev/null


export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

eval "$(brew shellenv)"
