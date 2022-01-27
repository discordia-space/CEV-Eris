/*
The overmap system allows adding69ew69aps to the big 'galaxy'69ap.
There's overmap zlevel, that looks like a69ap. On it, token objects (overmap objects) are69oved, representing ship69ovement etc.
No actual turfs are69oved, you would69eed exploration shuttles or teleports to69ove atoms between different sectors/ships.
Unless stated otherwise, you just69eed to place any of things below somewhere on the69ap and they'll handle the rest.

*************************************************************
# How to69ake69ew sector
*************************************************************
0.69ap whatever.
1.69ake /obj/effect/overmap/sector/69whatever69
	If you want explorations shuttles be able to dock here, remember to set waypoints lists
2. Put /obj/effect/overmap/sector/69whatever69 on the69ap. Even if it's69ultiz, only one is69eeded, on any z.
3. Done.

*************************************************************
# How to69ake69ew ship
*************************************************************
0.69ap whatever.
1.69ake /obj/effect/overmap/ship/69whatever69
	If you want explorations shuttles be able to dock here, remember to set waypoints lists
2. Put /obj/effect/overmap/ship/69whatever69 on the69ap. If it's69ultiz, only one is69eeded, on any z.
3. Put Helm Console anywhere on the69ap.
4. Put Engines Control Console anywhere on the69ap.
5. Put some engines hooked up to gas supply anywhere on the69ap.
6. Done.

*************************************************************
# Overmap object
*************************************************************
/obj/effect/overmap
### WHAT IT DOES
Lets overmap know this place should be represented on the69ap as a sector/ship.
If this zlevel (or any of connected ones for69ultiz) doesn't have this object, you won't be able to travel there by ovemap69eans.
### HOW TO USE
1. Create subtype for your ship/sector. Use /ship one for ships.
2. Put it anywhere on the ship/sector69ap. It will do the rest on its own during init.
If your thing is69ultiz, only one is69eeded per69ultiz sector/ship.

If it's player's69ain base (e.g Exodus), set 'base'69ar to 1, so it adds itself to station_levels list.
If this place cannot be reached or left with EVA, set 'in_space'69ar to 0
If you want exploration shuttles (look below) to be able to dock here, set up waypoints lists.
generic_waypoints is list of landmark_tags of waypoints any shttle should be able to69isit.
restricted_waypoints is list of 'shuttle69ame = list(landmark_tags)' pairs for waypoints only those shuttles can69isit

*************************************************************
# Helm console
*************************************************************
/obj/machinery/computer/helm
### WHAT IT DOES
Lets you steer ship around on overmap.
Lets you use autopilot.
### HOW TO USE
Just place it anywhere on the ship.

*************************************************************
# Engines control console
*************************************************************
/obj/machinery/computer/engines
### WHAT IT DOES
Lets use set thrust limits for engines of your ship.
Lets you shutdown/restart the engines.
Lets you check status of engines.
### HOW TO USE
Just place it anywhere on the ship.

*************************************************************
# Thermal engines
*************************************************************
/obj/machinery/atmospherics/unary/engine
### WHAT IT DOES
Lets your ship69ove on the69ap at all.
### HOW TO USE
Put them on69ap, hook up to pipes with any gas. Heavier gas (CO2/plasma) +69ore pressure =69ore thrust.

*************************************************************
# Exploration shuttle terminal
*************************************************************
/obj/machinery/computer/shuttle_control/explore
### WHAT IT DOES
Lets you control shuttles that can change destinations and69isit other sectors/ships.
### HOW TO USE
1. Define starting shuttle landmark.
2. Define a /datum/shuttle/autodock/overmap for your shuttle. Same as69ormal shuttle, aside from 'range'69ar - how69any squares on overmap it can travel on its own.
3. Place console anywhere on the ship/sector. Set shuttle_tag to shuttle's69ame.
4. Use. You can select destinations if you're in range (on same tile by defualt) on the69ap and sector has waypoints lists defined
*/