# Yabai maintenance commands. Sourcing this file only defines functions.

yabai_upgrade() {
    print -u2 "yabai_upgrade is disabled while the local yabai installation is active."
    print -u2 "Use yabai_local_migrate to update from christian/master."
    print -u2 "yabai_local_rollback returns to Homebrew, not the previous local build."
    return 1

    # yabai --stop-service
    # yabai --uninstall-service
    # sudo yabai --uninstall-sa
    # sudo /opt/homebrew/bin/tccutil -r $(realpath $(which yabai))
    # brew unpin yabai
    # brew reinstall asmvik/formulae/yabai
    # brew pin yabai
    # codesign -fs "${YABAI_CERT:-yabai-cert}" "$(brew --prefix yabai)/bin/yabai"
    # echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
    # sudo /opt/homebrew/bin/tccutil -i $(realpath $(which yabai))
    # sudo /opt/homebrew/bin/tccutil -e $(realpath $(which yabai))
    # launchctl stop com.apple.tccd && sudo launchctl kickstart -k system/com.apple.tccd.system
    # yabai --start-service
}

# All operations target the separate christian-sc26 worktree.
# The original macos27compat checkout is kept for the Homebrew-return helper.
_yabai_maintenance() {
    command python3 "$HOME/.config/zsh/scripts/yabai-maintenance.py" "$@"
}

# Fetch and fast-forward christian/master, then build and sign without activation.
yabai_local_prepare() {
    _yabai_maintenance prepare "$@"
}

# Activate the verified staged build; prompts for sudo before stopping anything.
# Optional: --refresh-tcc performs the targeted Accessibility refresh.
yabai_local_install() {
    _yabai_maintenance install "$@"
}

# Normal update command: fetch latest, build, sign, then install.
yabai_local_migrate() {
    _yabai_maintenance update "$@"
}

# Explicit permission recovery with the third-party tool, not Apple's tccutil.
# Restart yabai after running this if it was stopped by an Accessibility error.
yabai_tcc_refresh() {
    _yabai_maintenance tcc-refresh "$@"
}

yabai_local_rollback() {
    emulate -L zsh
    setopt err_return pipe_fail

    local repo="$HOME/Documents/Projects/yabai"
    local target="/opt/homebrew/bin/yabai"
    local formula="asmvik/formulae/yabai"
    local cert="${YABAI_CERT:-yabai-cert}"
    local brew_binary hash

    cd "$repo" || return 1

    security find-identity -v -p codesigning |
        grep -F "\"$cert\"" >/dev/null || {
            print -u2 "error: valid code-signing identity '$cert' not found"
            return 1
        }

    make uninstall-local || return 1

    _yabai_maintenance tcc-remove "$target"

    brew unpin yabai 2>/dev/null || true
    brew reinstall "$formula"
    brew pin yabai

    codesign -fs "$cert" "$(brew --prefix yabai)/bin/yabai"

    brew_binary="$(realpath "$(command -v yabai)")" || return 1
    hash="$(shasum -a 256 "$target" | awk '{print $1}')"

    printf '%s ALL=(root) NOPASSWD: sha256:%s %s --load-sa\n' \
        "$USER" "$hash" "$target" |
        sudo tee /private/etc/sudoers.d/yabai >/dev/null

    sudo chmod 0440 /private/etc/sudoers.d/yabai
    sudo visudo -cf /private/etc/sudoers.d/yabai

    _yabai_maintenance tcc-refresh "$brew_binary"

    sudo "$target" --load-sa
    "$target" --start-service

    print
    print "Homebrew yabai restored:"
    print "  executable: $target"
    print "  resolved:   $brew_binary"
    yabai --version
    codesign -dvv "$target" 2>&1 |
        grep -E 'Identifier=|Authority=|Signature='
    launchctl print "gui/$UID/com.asmvik.yabai" |
        grep -E 'state =|program =|pid ='
}
