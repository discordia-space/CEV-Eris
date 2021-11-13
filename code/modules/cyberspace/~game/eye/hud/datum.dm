/datum/hud/cybereye
	name = "cyberspace_eye"
	icon = 'icons/obj/cyberspace/hud/common.dmi'
	HUDneed = list(
		"Jack Out" = /obj/screen/movable/cyberspace_eye/exit{name = "Jack Out";screen_loc = "EAST:-4,NORTH:-4"},
		"Intent" = /obj/screen/movable/cyberspace_eye/intent{name = "Intent";screen_loc = "EAST:-4,SOUTH:4"},
		"HP Counter" = /obj/screen/movable/cyberspace_eye/counter/health{screen_loc = "EAST:-4,SOUTH+1:4"},
		"Move Up" = /obj/screen/movable/cyberspace_eye/z_mover{name = "Move Up";icon_state = "up";screen_loc = "WEST:4,SOUTH+1:4";direction = UP},
		"Move Down" = /obj/screen/movable/cyberspace_eye/z_mover{name = "Move Down";icon_state = "down";screen_loc = "WEST:4,SOUTH:4"; direction = DOWN},
//		"QP Counter" = list("type"	=	/obj/screen/movable/cyberspace_eye/counter/QuantumPointsCounter, "loc" = "WEST:4,SOUTH+1:11")
	)
	var/use_panels = TRUE //Unable refactor to list, because data used not only in panel generation

	var/datum/HUD_panel/ChipPanel = new/datum/HUD_panel{icon = 'icons/obj/cyberspace/hud/common.dmi';\
		template = "WEST,CENTER+%Y";\
		states = list("border_right", "border_left");\
		dirs_of_edges = EAST;\
		direction = list(1, 1);\
		}()
	var/datum/HUD_panel/HardwarePanel = new/datum/HUD_panel{icon = 'icons/obj/cyberspace/hud/common.dmi';\
		template = "EAST,CENTER+%Y";\
		states = list("border_left", "border_right");\
		dirs_of_edges = WEST;\
		direction = list(1, 1);\
		}()
//	var/datum/HUD_panel/GripPanel = new("CENTER+%X,SOUTH", list("border_left", "border_right"), NORTH, list(1, 1))
//	var/datum/HUD_panel/ProgramPanel = new("CENTER+%X,NORTH", list("border_right", "border_left"), SOUTH, list(1, 1))

/datum/HUD_panel
	var/icon
	var/template = "0,0"
	var/list/states //First and last endge
	var/list/dirs_of_edges //Direction OR List
	var/list/direction // X, Y

