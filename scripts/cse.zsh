#!/usr/bin/env zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title CSE SSHFS
# @raycast.mode silent

# Documentation:
# @raycast.author Icecreambobcat
# @raycast.authorURL https://github.com/Icecreambobcat

set -euo pipefail

if [[ -f "$HOME/.cse_vars" ]]; then
  source "$HOME/.cse_vars"
fi

if [[ -z "${CSE_ZID:-}" || -z "${CSE_MOUNTPOINT:-}" ]]; then
  echo "CSE_ZID or CSE_MOUNTPOINT is not set"
  exit 1
fi

if [[ ! -d "$CSE_MOUNTPOINT" ]]; then
  echo "CSE_MOUNTPOINT does not exist or is not a directory"
  exit 1
fi

if ! command -v sshfs >/dev/null 2>&1; then
  echo "sshfs is not installed"
  exit 1
fi

if mount | grep "$CSE_MOUNTPOINT" >/dev/null; then
  diskutil unmount "$CSE_MOUNTPOINT"
else
  sshfs -o idmap=user -C ${CSE_ZID}@login${CSE_ZID: -1}.cse.unsw.edu.au: ${CSE_MOUNTPOINT}
fi
