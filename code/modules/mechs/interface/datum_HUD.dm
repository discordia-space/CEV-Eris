/datum/hud/exosuits
	name = "exosuits"
	icon = MECHA_HUD_ICON
	HUDneed = list(
		"mech_damage_zone"			=	list("type" =	/obj/screen/zone_sel,							"loc" = "15,5"),
		"mech_maintence"			=	list("type" =	/obj/screen/movable/exosuit/toggle/maint,		"loc" = "EAST+1:12,CENTER+3:11"),
		"mech_exitfromsuit"			=	list("type" =	/obj/screen/movable/exosuit/eject,				"loc" = "EAST+1:12,CENTER+3:25"),
		"mech_hatch"				=	list("type" =	/obj/screen/movable/exosuit/toggle/hatch,		"loc" = "EAST+1:12,CENTER+3:36"),
		"mech_hatch_open"			=	list("type" =	/obj/screen/movable/exosuit/toggle/hatch_open,	"loc" = "EAST+1:12,CENTER+3:47"),
		"mech_radio"				=	list("type" =	/obj/screen/movable/exosuit/radio,				"loc" = "EAST+1:12,CENTER+3:58"),
		"mech_rename"				=	list("type" =	/obj/screen/movable/exosuit/rename,				"loc" = "EAST+1:12,CENTER+3:69"),
		"mech_camera"				=	list("type" =	/obj/screen/movable/exosuit/toggle/camera,		"loc" = "EAST+1:12,CENTER+3:70"),
		"mech_hud_health"			=	list("type" =	/obj/screen/movable/exosuit/health,				"loc" = "EAST+2,BOTTOM+5"),
		"mech_hud_power"			=	list("type" =	/obj/screen/movable/exosuit/power,				"loc" = "14,6"),
		"mech_hud_open"				=	list("type" =	/obj/screen/movable/exosuit/toggle/hatch_open,	"loc" = "1,7"),
		"mech_hard_point_selector"	=	list("type" =	/obj/screen/movable/exosuit/hardpoints_show,	"loc" = "EAST+4,CENTER+3")
	)
