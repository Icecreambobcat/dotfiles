# Yabai maintenance commands. Sourcing this file only defines functions.

yabai_upgrade() {
    print -u2 "yabai_upgrade is disabled while the local yabai installation is active."
    print -u2 "Use yabai_local_rollback once upstream supports macOS 27."
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

yabai_local_migrate() {
    emulate -L zsh
    setopt err_return pipe_fail

    local repo="$HOME/Documents/Projects/yabai"
    local target="/opt/homebrew/bin/yabai"
    local tccutil="/opt/homebrew/bin/tccutil"
    local cert="${YABAI_CERT:-yabai-cert}"
    local old_binary

    cd "$repo" || return 1

    [[ "$(git branch --show-current)" == "macos27compat" ]] || {
        print -u2 "error: expected branch macos27compat"
        return 1
    }

    [[ -z "$(git status --porcelain)" ]] || {
        print -u2 "error: repository has uncommitted changes"
        return 1
    }

    security find-identity -v -p codesigning |
        grep -F "\"$cert\"" >/dev/null || {
            print -u2 "error: valid code-signing identity '$cert' not found"
            return 1
        }

    old_binary="$(realpath "$(command -v yabai)")" || return 1

    print "Migrating from:"
    print "  $old_binary"
    print "Installing local commit:"
    git log -1 --oneline

    make install-local YABAI_CERT="$cert" || return 1

    sudo "$tccutil" -r "$old_binary"
    sudo "$tccutil" -i "$target"
    sudo "$tccutil" -e "$target"

    launchctl stop com.apple.tccd 2>/dev/null || true
    sudo launchctl kickstart -k system/com.apple.tccd.system

    "$target" --restart-service

    print
    print "Local yabai migration complete:"
    ls -l "$target"
    codesign -dvv "$target" 2>&1 |
        grep -E 'Identifier=|Authority=|Signature='
    plutil -extract CFBundleVersion raw \
        /Library/ScriptingAdditions/yabai.osax/Contents/Info.plist
    launchctl print "gui/$UID/com.asmvik.yabai" |
        grep -E 'state =|program =|pid ='
}

yabai_local_rollback() {
    emulate -L zsh
    setopt err_return pipe_fail

    local repo="$HOME/Documents/Projects/yabai"
    local target="/opt/homebrew/bin/yabai"
    local tccutil="/opt/homebrew/bin/tccutil"
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

    sudo "$tccutil" -r "$target"

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

    sudo "$tccutil" -i "$brew_binary"
    sudo "$tccutil" -e "$brew_binary"

    launchctl stop com.apple.tccd 2>/dev/null || true
    sudo launchctl kickstart -k system/com.apple.tccd.system

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
