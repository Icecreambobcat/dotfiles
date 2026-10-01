os.execute([[
  if [ ! -d "$HOME/.local/share/sketchybar_lua/" ]; then
    (
      workdir=$(mktemp -d "${TMPDIR:-/tmp}/sketchybar-sbarlua.XXXXXXXX") || exit 1
      trap 'rm -rf -- "$workdir"' 0
      trap 'exit 129' HUP
      trap 'exit 130' INT
      trap 'exit 143' TERM
      git clone https://github.com/FelixKratz/SbarLua.git "$workdir/source" &&
        cd "$workdir/source" &&
        make install
    )
  fi
]])
local HOME = os.getenv("HOME")
package.cpath = package.cpath .. ";" .. HOME .. "/.local/share/sketchybar_lua/?.so"

-- Require the sketchybar module
sbar = require("sketchybar")

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
sbar.hotload(true)
require("bar")
require("default")
require("items")
sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
