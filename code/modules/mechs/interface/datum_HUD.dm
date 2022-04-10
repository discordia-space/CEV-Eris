/datum/hud/exosuits
	name = "exosuits"
	icon = MECH_HUD_ICON
	HUDneed = list(
		"maintence"					=	list("type"	=	/obj/screen/movable/exosuit/toggle/maint,		"loc" = "WEST:4,CENTER-3:11"),
		"exit from suit"			=	list("type"	=	/obj/screen/movable/exosuit/eject,				"loc" = "WEST:4,CENTER-3:25"),
		"hatch"						=	list("type"	=	/obj/screen/movable/exosuit/toggle/hatch,		"loc" = "WEST:4,CENTER-3:36"),
		"hatch open"				=	list("type"	=	/obj/screen/movable/exosuit/toggle/hatch_open,	"loc" = "WEST:4,CENTER-3:47"),
		"mech radio"				=	list("type"	=	/obj/screen/movable/exosuit/radio,				"loc" = "WEST:4,CENTER-3:58"),
		"rename mech"				=	list("type"	=	/obj/screen/movable/exosuit/rename,				"loc" = "WEST:4,CENTER-3:69"),
		"mech camera"				=	list("type"	=	/obj/screen/movable/exosuit/toggle/camera,		"loc" = "WEST:4,CENTER-3:80"),
		"mech health"				=	list("type"	=	/obj/screen/movable/exosuit/health,				"loc" = "WEST:4,BOTTOM+3"),
		"mech power"				=	list("type"	=	/obj/screen/movable/exosuit/power,				"loc" = "WEST+1:4,BOTTOM+3"),
		"strafe"					=	list("type"	=	/obj/screen/movable/exosuit/toggle/strafe,		"loc" = "WEST:4,CENTER-3:92"),
		"air"						=	list("type"	=	/obj/screen/movable/exosuit/toggle/air,         "loc" = "WEST:4,CENTER-3:00"),
		"mech heat gauge"			=	list("type"	=	/obj/screen/movable/exosuit/heat,				"loc" = "WEST:4,BOTTOM+4")
	)
