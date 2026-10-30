# Homebrew-managed yabai. Keep upgrades explicit with brew pin/unpin.
yabai_upgrade() {
    emulate -L zsh
    setopt err_return pipe_fail

    local formula="christian-sc26/formulae/yabai"
    local binary="/opt/homebrew/bin/yabai"
    local tcc="/opt/homebrew/bin/tccutil"
    local db="/Library/Application Support/com.apple.TCC/TCC.db"
    local old_binary new_binary rc

    old_binary="$(realpath "$binary")"
    sudo -v
    yabai --stop-service
    yabai --uninstall-service
    sudo "$binary" --uninstall-sa
    brew unpin "$formula"
    if brew reinstall "$formula"; then
        brew pin "$formula"
    else
        rc=$?
        brew pin "$formula"
        yabai --start-service
        return "$rc"
    fi

    new_binary="$(realpath "$binary")"
    echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 "$binary" | cut -d " " -f 1) $binary --load-sa" | sudo tee /private/etc/sudoers.d/yabai >/dev/null

    # This Python tccutil can return 1 after committing; verify the database.
    sudo "$tcc" -r "$old_binary" || [[ $? == 1 ]]
    sudo "$tcc" -r "$new_binary" -i "$new_binary" -e "$new_binary" || [[ $? == 1 ]]
    [[ "$(sudo sqlite3 -readonly "$db" "SELECT count(*) FROM access WHERE service='kTCCServiceAccessibility' AND client='$new_binary' AND client_type=1 AND auth_value=2 AND csreq IS NULL;")" == 1 ]]
    launchctl stop com.apple.tccd || true
    sudo launchctl kickstart -k system/com.apple.tccd.system

    sudo "$binary" --load-sa
    "$binary" --start-service
    "$binary" --version
}
