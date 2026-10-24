#!/usr/bin/env python3
"""Build and deploy the Christian-SC26 worktree without changing yabai/skhd config."""

import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import platform
import pwd
import re
import shutil
import socket
import struct
import subprocess
import sys
import tempfile
import time

HOME = Path.home()
REPO = HOME / "Documents/Projects/yabai-christian"
TARGET = Path("/opt/homebrew/bin/yabai")
STAGED = REPO / "bin/yabai"
MANIFEST = REPO / "bin/local-install.json"
STATE = HOME / ".local/state/yabai"
PLIST = HOME / "Library/LaunchAgents/com.asmvik.yabai.plist"
OSAX = Path("/Library/ScriptingAdditions/yabai.osax")
SUDOERS = Path("/private/etc/sudoers.d/yabai")
TCCUTIL = "/opt/homebrew/bin/tccutil"
TCCDB = "/Library/Application Support/com.apple.TCC/TCC.db"
SERVICE = f"gui/{os.getuid()}/com.asmvik.yabai"
USER = pwd.getpwuid(os.getuid()).pw_name
CONFIGS = [HOME / ".config/yabai/yabairc", HOME / ".config/skhd/skhdrc"]
SETTINGS = (
    "mouse_follows_focus focus_follows_mouse window_zoom_persist window_placement "
    "window_shadow window_opacity window_opacity_duration active_window_opacity "
    "normal_window_opacity window_animation_duration window_animation_easing "
    "insert_feedback_color split_ratio auto_balance mouse_modifier mouse_action1 "
    "mouse_action2 mouse_drop_action top_padding bottom_padding left_padding "
    "right_padding window_gap external_bar layout"
).split()
REMOTE_URL = "https://github.com/Christian-SC26/yabai.git"
ALL_CAPABILITIES = 0x7f
# On macOS 27 the fork intentionally omits DPPM, whole-Space moves and
# the unused private window-focus hook. Keep every other advertised bit required.
OPTIONAL_ON_27 = 0x02 | 0x10 | 0x20


def run(*args, check=True, show=False, timeout=30, cwd=None):
    result = subprocess.run(
        [str(a) for a in args], cwd=cwd, text=True,
        stdout=None if show else subprocess.PIPE,
        stderr=None if show else subprocess.PIPE, timeout=timeout,
        env={**os.environ, "GIT_OPTIONAL_LOCKS": "0", "MAKEFLAGS": ""},
    )
    if check and result.returncode:
        detail = "" if show else (result.stderr or result.stdout or "").strip()
        raise RuntimeError(f"{' '.join(map(str, args))}: exit {result.returncode}\n{detail}")
    return result


def git(*args):
    return run("git", *args, cwd=REPO).stdout.strip()


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def requirement(path):
    result = run("/usr/bin/codesign", "-d", "-r-", path)
    for line in (result.stdout + result.stderr).splitlines():
        if line.startswith("designated => "):
            return line
    raise RuntimeError(f"No designated requirement found for {path}")


def check_repo():
    if git("branch", "--show-current") != "christian-sc26":
        raise RuntimeError("Expected christian-sc26 in the Christian worktree")
    if git("remote", "get-url", "christian") != REMOTE_URL:
        raise RuntimeError("The christian remote points somewhere unexpected")
    if git("rev-parse", "--abbrev-ref", "@{upstream}") != "christian/master":
        raise RuntimeError("Expected tracking branch christian/master")
    if git("-c", "core.fsmonitor=false", "status", "--porcelain"):
        raise RuntimeError("The Christian worktree has uncommitted changes")


def payload_version():
    header = (REPO / "src/osax/common.h").read_text()
    match = re.search(r'#define\s+OSAX_VERSION\s+"([^"]+)"', header)
    if not match:
        raise RuntimeError("Cannot read the expected payload version")
    return match.group(1)


def check_signature(path):
    run("/usr/bin/codesign", "--verify", "--strict", "--all-architectures", path)
    if requirement(path) != requirement(TARGET):
        raise RuntimeError("Signing identity/identifier differs from the installed binary")
    arches = run("/usr/bin/lipo", "-archs", path).stdout.split()
    if not {"arm64", "x86_64"}.issubset(arches):
        raise RuntimeError("Expected a universal arm64/x86_64 binary")


def record_stage():
    check_repo()
    check_signature(STAGED)
    data = {
        "commit": git("rev-parse", "HEAD"), "sha256": sha(STAGED),
        "payload": payload_version(), "requirement": requirement(STAGED),
        "version": run(STAGED, "--version").stdout.strip(),
        "macos": platform.mac_ver()[0],
    }
    MANIFEST.write_text(json.dumps(data, indent=2) + "\n")
    print(f"Prepared {data['version']} at {data['commit'][:12]}; not installed.")
    return data


def prepare():
    check_repo()
    git("fetch", "christian", "master")
    git("merge", "--ff-only", "--no-edit", "refs/remotes/christian/master")
    run("make", "-j1", "clean", cwd=REPO, show=True, timeout=120)
    run("make", "-j1", "install", cwd=REPO, show=True, timeout=600)
    run("/usr/bin/codesign", "-fs", os.environ.get("YABAI_CERT", "yabai-cert"),
        "-i", "com.asmvik.yabai", STAGED, show=True)
    return record_stage()


def check_stage():
    check_repo()
    data = json.loads(MANIFEST.read_text())
    if data["commit"] != git("rev-parse", "HEAD") or data["sha256"] != sha(STAGED):
        raise RuntimeError("Prepared source or binary changed; run yabai_local_prepare")
    if data["macos"] != platform.mac_ver()[0] or data["payload"] != payload_version():
        raise RuntimeError("OS or payload version changed; prepare again")
    check_signature(STAGED)
    if data["requirement"] != requirement(STAGED):
        raise RuntimeError("Prepared signature changed")
    return data


def handshake(expected=None):
    path = f"/tmp/yabai-sa_{USER}.socket"
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
        sock.settimeout(3)
        sock.connect(path)
        sock.sendall(bytes([1, 0, 1]))
        data = b""
        while len(data) < 4096:
            chunk = sock.recv(4096 - len(data))
            if not chunk:
                break
            data += chunk
            zero = data.find(b"\0")
            if zero >= 0 and len(data) >= zero + 5:
                break
    version, zero, rest = data.partition(b"\0")
    if not zero or len(rest) < 4:
        raise RuntimeError("Malformed scripting-addition handshake")
    version = version.decode()
    mask = struct.unpack("<I", rest[:4])[0]
    if expected and version != expected:
        raise RuntimeError(f"Loaded payload {version}, expected {expected}")
    major = int(platform.mac_ver()[0].split(".")[0])
    required = ALL_CAPABILITIES & ~OPTIONAL_ON_27 if major == 27 else ALL_CAPABILITIES
    if mask & required != required:
        raise RuntimeError(f"Required payload capabilities missing: {mask:#x}")
    return version, mask


def config_hashes():
    return {str(p): sha(p) for p in CONFIGS}


def query(*args):
    return run(TARGET, "-m", *args, timeout=5).stdout.strip()


def baseline():
    return {
        "settings": {key: query("config", key) for key in SETTINGS},
        "rules": json.loads(query("rule", "--list")),
        "signals": json.loads(query("signal", "--list")),
        "files": config_hashes(),
    }


def same_entries(before, after):
    if len(before) != len(after):
        return False
    # Ignore internal/index fields, but require all previous user-facing fields.
    return all(
        all(new.get(k) == v for k, v in old.items() if k not in {"index", "flags"})
        for old, new in zip(before, after)
    )


def verify_settings(before):
    current = baseline()
    if before["files"] != current["files"]:
        raise RuntimeError("yabai/skhd configuration files changed during installation")
    if before["settings"] != current["settings"]:
        changed = [k for k in SETTINGS if before["settings"][k] != current["settings"][k]]
        raise RuntimeError("Runtime configuration differs: " + ", ".join(changed))
    for key in ("rules", "signals"):
        if not same_entries(before[key], current[key]):
            raise RuntimeError(f"Runtime {key} differ from the previous installation")


def wait_until(test, seconds=20):
    # Bounded readiness wait used by the interactive installer, not a background job.
    deadline = time.monotonic() + seconds
    last = None
    while True:
        try:
            value = test()
            if value:
                return value
        except (RuntimeError, OSError, ValueError, subprocess.TimeoutExpired) as exc:
            last = exc
        if time.monotonic() >= deadline:
            raise RuntimeError(f"Readiness check timed out: {last or 'condition not met'}")
        time.sleep(0.25)


def dock_pids():
    result = run("/usr/bin/pgrep", "-u", str(os.getuid()), "-x", "Dock", check=False)
    return set(result.stdout.split())


def replace_binary(source):
    fd, name = tempfile.mkstemp(prefix=".yabai-new-", dir=TARGET.parent)
    os.close(fd)
    try:
        shutil.copy2(source, name)
        os.chmod(name, 0o755)
        run("/usr/bin/codesign", "--verify", "--strict", "--all-architectures", name)
        os.replace(name, TARGET)
    finally:
        Path(name).unlink(missing_ok=True)


def update_sudoers(directory):
    if not re.fullmatch(r"[A-Za-z0-9_-]+", USER):
        raise RuntimeError("Unsupported sudoers username")
    rule = directory / "new-sudoers"
    rule.write_text(
        f"{USER} ALL=(root) NOPASSWD: sha256:{sha(TARGET)} {TARGET} --load-sa\n"
    )
    os.chmod(rule, 0o600)
    run("sudo", "/usr/sbin/visudo", "-cf", rule)
    temporary = SUDOERS.with_name(f".yabai-new-{os.getpid()}")
    try:
        run("sudo", "/usr/bin/install", "-o", "root", "-g", "wheel", "-m", "0440", rule, temporary)
        run("sudo", "/bin/mv", "-f", temporary, SUDOERS)
        run("sudo", "/usr/sbin/visudo", "-cf", SUDOERS)
    finally:
        run("sudo", "/bin/rm", "-f", temporary, check=False)


def load_payload(expected):
    old_dock = dock_pids()
    # Force fresh embedded artifacts, including updates that reuse OSAX_VERSION.
    run("sudo", TARGET, "--uninstall-sa", show=True)
    run("sudo", TARGET, "--load-sa", show=True)
    wait_until(lambda: dock_pids() and not (dock_pids() & old_dock))
    result = run("sudo", TARGET, "--load-sa", check=False, show=True)
    if result.returncode not in (0, 1):
        raise RuntimeError(f"Payload loader exited {result.returncode}")
    version, mask = wait_until(lambda: handshake(expected))
    if result.returncode == 1 and mask & ALL_CAPABILITIES == ALL_CAPABILITIES:
        raise RuntimeError("Loader failed despite complete capabilities; do not mask that failure")
    print(f"Loaded payload {version}; capabilities {mask:#x}.")
    if mask & ALL_CAPABILITIES != ALL_CAPABILITIES:
        print("Accepted partial support: whole-Space movement/private SA focus are optional.")
        print("The unmodified fork may still display its unsupported-payload warning.")


def tcc_entry(client, remove_only=False):
    if not client.startswith("/"):
        raise RuntimeError("TCC recovery requires an absolute executable path")
    run("sudo", "-v", show=True)
    args = ["sudo", TCCUTIL, "-r", client]
    if not remove_only:
        args += ["-i", client, "-e", client]
    result = run(*args, check=False, show=True)
    if result.returncode not in (0, 1):
        raise RuntimeError(f"tccutil exited {result.returncode}")
    escaped = client.replace("'", "''")
    condition = f"service='kTCCServiceAccessibility' AND client='{escaped}'"
    sql = f"SELECT count(*) FROM access WHERE {condition}"
    if not remove_only:
        sql += " AND client_type=1 AND auth_value=2 AND csreq IS NULL"
    count = run("sudo", "/usr/bin/sqlite3", "-readonly", TCCDB, sql + ";").stdout.strip()
    if count != ("0" if remove_only else "1"):
        raise RuntimeError("TCC entry did not reach the requested state")
    # The installed third-party script exits 1 even after committing successfully.
    # Accept that only after checking the exact entry in the database.
    if not remove_only:
        run("/bin/launchctl", "stop", "com.apple.tccd", check=False)
        run("sudo", "/bin/launchctl", "kickstart", "-k", "system/com.apple.tccd.system")
    print("Targeted Accessibility entry verified.")


def install_prepared(refresh_tcc=False):
    data = check_stage()
    if TARGET.is_symlink():
        raise RuntimeError("Expected the existing regular-file source install, not a Homebrew symlink")
    run("sudo", "-v", show=True)  # Fail before disrupting the service if no terminal is available.
    run("sudo", "/usr/sbin/visudo", "-c")
    before = baseline()
    old_version, _ = handshake()
    plist_hash = sha(PLIST)
    run("/bin/launchctl", "print", SERVICE)
    rollback = Path(tempfile.mkdtemp(prefix="switch-", dir=STATE))
    os.chmod(rollback, 0o700)
    disrupted = False
    keep = False
    try:
        shutil.copy2(TARGET, rollback / "yabai")
        run("sudo", "/bin/cp", "-p", SUDOERS, rollback / "sudoers")
        run("sudo", "/usr/bin/ditto", OSAX, rollback / "yabai.osax")
        # Snapshot only for this transaction; remove after success or successful rollback.
        (rollback / "baseline.json").write_text(json.dumps(before))
        disrupted = True
        run("/bin/launchctl", "bootout", SERVICE)
        replace_binary(STAGED)
        update_sudoers(rollback)
        load_payload(data["payload"])
        if refresh_tcc:
            tcc_entry(str(TARGET))
        run("/bin/launchctl", "bootstrap", f"gui/{os.getuid()}", PLIST)
        wait_until(lambda: verify_settings(before) is None)
        handshake(data["payload"])
        if sha(TARGET) != data["sha256"] or sha(PLIST) != plist_hash:
            raise RuntimeError("Installed binary or service file differs from the verified inputs")
        print(f"Installed {data['version']} ({data['commit'][:12]}).")
        print("Verified payload, configuration values, rules, signals and unchanged config/service files.")
        print("Interactive hotkeys, animations and scratchpads still need a normal-use check.")
    except BaseException:
        if disrupted:
            print("Installation failed; restoring the previous binary, rule and payload.", file=sys.stderr)
            try:
                run("/bin/launchctl", "bootout", SERVICE, check=False)
                replace_binary(rollback / "yabai")
                run("sudo", "/usr/bin/install", "-o", "root", "-g", "wheel", "-m", "0440",
                    rollback / "sudoers", SUDOERS)
                run("sudo", "/usr/sbin/visudo", "-cf", SUDOERS)
                old_dock = dock_pids()
                run("sudo", TARGET, "--uninstall-sa", show=True)
                run("sudo", "/usr/bin/ditto", rollback / "yabai.osax", OSAX)
                run("/usr/bin/pkill", "-u", str(os.getuid()), "-x", "Dock")
                wait_until(lambda: dock_pids() and not (dock_pids() & old_dock))
                result = run("sudo", TARGET, "--load-sa", check=False, show=True)
                version, mask = wait_until(lambda: handshake(old_version))
                if result.returncode not in (0, 1) or (
                    result.returncode == 1 and mask & ALL_CAPABILITIES == ALL_CAPABILITIES
                ):
                    raise RuntimeError("Old payload loader failed")
                run("/bin/launchctl", "bootstrap", f"gui/{os.getuid()}", PLIST)
                wait_until(lambda: verify_settings(before) is None)
                print("Previous installation restored.", file=sys.stderr)
            except BaseException as exc:
                keep = True
                print(f"Rollback needs attention: {exc}\nRecovery files retained at {rollback}", file=sys.stderr)
        raise
    finally:
        if not keep:
            # Directory is this process's newly created transaction snapshot.
            result = run("sudo", "/bin/rm", "-rf", rollback, check=False)
            if result.returncode:
                print(f"Could not remove temporary recovery files: {rollback}", file=sys.stderr)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=[
        "prepare", "record-stage", "check-stage", "install", "update",
        "tcc-refresh", "tcc-remove", "verify",
    ])
    parser.add_argument("client", nargs="?", default=str(TARGET))
    parser.add_argument("--refresh-tcc", action="store_true")
    args = parser.parse_args()
    if os.getuid() == 0:
        raise RuntimeError("Run as the normal user, not with sudo")
    STATE.mkdir(parents=True, exist_ok=True, mode=0o700)
    with (STATE / "maintenance.lock").open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        if args.action == "prepare":
            prepare()
        elif args.action == "record-stage":
            record_stage()
        elif args.action == "check-stage":
            data = check_stage()
            print(f"Prepared and verified: {data['version']} ({data['commit'][:12]}); not an activation check.")
        elif args.action in ("install", "update"):
            if args.action == "update":
                prepare()
            install_prepared(args.refresh_tcc)
        elif args.action in ("tcc-refresh", "tcc-remove"):
            tcc_entry(args.client, args.action == "tcc-remove")
        elif args.action == "verify":
            print(run(TARGET, "--version").stdout.strip())
            version, mask = handshake()
            print(f"Loaded payload {version}; capabilities {mask:#x}")
            run("/bin/launchctl", "print", SERVICE)
            print("Daemon query:", query("config", "layout"))


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, OSError, ValueError, subprocess.TimeoutExpired) as exc:
        print(f"error: {exc}", file=sys.stderr)
        sys.exit(1)
