-- Require the sketchybar module
sbar = require("sketchybar")

local Aerospace = require("aerospace")
local aerospace = Aerospace.new()
while not aerospace:is_initialized() do
  os.execute("sleep 0.1")
end
sbar.aerospace = aerospace

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
require("bar")
require("default")
require("items")
sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
