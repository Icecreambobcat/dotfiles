# Interactive FZF and zoxide picker settings; source before Oh My Zsh.

# Shared fd arguments keep all four picker modes consistent.
typeset _fzf_fd='fd --strip-cwd-prefix --follow --exclude .git --exclude Library --exclude Sikarugir'

export FZF_ALL_NORMAL="$_fzf_fd"
export FZF_ALL_HIDDEN="$_fzf_fd --hidden"
export FZF_DIRS_NORMAL="$_fzf_fd --type d"
export FZF_DIRS_HIDDEN="$_fzf_fd --type d --hidden"

unset _fzf_fd

export FZF_DEFAULT_COMMAND="$FZF_ALL_NORMAL"
export FZF_CTRL_T_COMMAND="$FZF_ALL_NORMAL"
export FZF_ALT_C_COMMAND="$FZF_DIRS_NORMAL"

export FZF_COMPLETION_OPTS='--border=none --info=inline-right --walker-skip .git,Library,Sikarugir --prompt="> " --bind "ctrl-h:ignore"'
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'

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
