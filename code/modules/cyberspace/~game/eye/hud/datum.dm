/datum/hud/cybereye
	name = "cyberspace_eye"
	icon = 'icons/obj/cyberspace/hud/common.dmi'
	HUDneed = list(
		"Jack Out"			=	list("type"	=	/obj/screen/movable/cyberspace_eye/exit,							"loc" = "EAST,NORTH"),
		"QP Counter"		=	list("type"	=	/obj/screen/movable/cyberspace_eye/counter/QuantumPointsCounter,	"loc" = "WEST:4,SOUTH+1:11")
	)
	var/use_borders = TRUE

	var/datum/HUD_border/ChipPanel = new("WEST,CENTER+%Y", list("border_right", "border_left"), EAST, list(1, 1))
	var/datum/HUD_border/HardwarePanel = new("EAST,CENTER+%Y", list("border_left", "border_right"), WEST, list(1, 1))
	var/datum/HUD_border/GripPanel = new("CENTER+%X,SOUTH", list("border_left", "border_right"), NORTH, list(1, 1))
	var/datum/HUD_border/ProgramPanel = new("CENTER+%X,NORTH", list("border_right", "border_left"), SOUTH, list(1, 1))

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
