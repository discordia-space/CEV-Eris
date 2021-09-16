/datum/hud/cybereye
	name = "cyberspace_eye"
	icon = 'icons/obj/cyberspace/hud/common.dmi'
	HUDneed = list(
		"Jack Out" = /obj/screen/movable/cyberspace_eye/exit{name = "Jack Out";screen_loc = "EAST,NORTH"},
		"Intent" = /obj/screen/movable/cyberspace_eye/intent{name = "Intent";screen_loc = "EAST,SOUTH"},
		"Move Up" = /obj/screen/movable/cyberspace_eye/z_mover{name = "Move Up";icon_state = "up";screen_loc = "WEST,SOUTH+1";direction = UP},
		"Move Down" = /obj/screen/movable/cyberspace_eye/z_mover{name = "Move Down";icon_state = "down";screen_loc = "WEST,SOUTH"; direction = DOWN},
//		"QP Counter"=	list("type"	=	/obj/screen/movable/cyberspace_eye/counter/QuantumPointsCounter, "loc" = "WEST:4,SOUTH+1:11")
	)
	var/use_panels = TRUE //Unable refactor to list, because data used not only in panel generation

	var/datum/HUD_border/ChipPanel = new("WEST,CENTER+%Y", list("border_right", "border_left"), EAST, list(1, 1))
	var/datum/HUD_border/HardwarePanel = new("EAST,CENTER+%Y", list("border_left", "border_right"), WEST, list(1, 1))
//	var/datum/HUD_border/GripPanel = new("CENTER+%X,SOUTH", list("border_left", "border_right"), NORTH, list(1, 1))
//	var/datum/HUD_border/ProgramPanel = new("CENTER+%X,NORTH", list("border_right", "border_left"), SOUTH, list(1, 1))

/datum/HUD_border
	var/template
	var/list/states //First and last endge
	var/list/dirs_of_edges //Direction OR List
	var/list/direction // X, Y
	New(_template, _states, _dir, _locDirections)
		template = _template
		states = _states
		dirs_of_edges = _dir
		direction = _locDirections
