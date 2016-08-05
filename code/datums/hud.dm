/datum/hud
	var/name
	var/list/HUDneed = list()//для "активных" элементов (прим. здоровье)
//	var/list/HUDprocess = list()
	var/list/slot_data = list()//для инвентаря
	var/icon/icon = null
	var/HUDfrippery = list()
	var/list/HUDoverlays = list()

/datum/hud/human
	name = "ErisStyle"
	icon = 'icons/mob/screen/ErisStyle.dmi'

	HUDoverlays = list(
		"damageoverlay" = list("type" = /obj/screen/damageoverlay, "loc" = "1,1", "icon" =  'icons/mob/screen1_full.dmi'),
		"flash" =  list("type" = /obj/screen, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"pain" = list("type" = /obj/screen, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank")
	)

	HUDneed = list(
		"health"      = list("type" = /obj/screen/health,     "loc" = "15,6"),
		"nutrition"   = list("type" = /obj/screen/nutrition,  "loc" = "15,5"),
		"bodytemp"    = list("type" = /obj/screen/bodytemp,   "loc" = "15,7"),
		"pressure"    = list("type" = /obj/screen/pressure,   "loc" = "15,13"),
		"toxin"       = list("type" = /obj/screen/toxin,      "loc" = "15,10"),
		"oxygen"      = list("type" = /obj/screen/oxygen,     "loc" = "15,12"),
		"fire"        = list("type" = /obj/screen/fire,       "loc" = "15,9"),
		"throw"       = list("type" = /obj/screen/HUDthrow,   "loc" = "15,1"),
		"pull"        = list("type" = /obj/screen/pull,       "loc" = "14,1"),
		"drop"        = list("type" = /obj/screen/drop,       "loc" = "15:-16,1"),
		"resist"      = list("type" = /obj/screen/resist,     "loc" = "14:16,1"),
		"m_intent"    = list("type" = /obj/screen/mov_intent, "loc" = "14,0"),
		"equip"       = list("type" = /obj/screen/equip,      "loc" = "7,1"),
		"intent"      = list("type" = /obj/screen/intent,     "loc" = "12:16,0"),
		"help"        = list("type" = /obj/screen/fastintent/help,     "loc" = "12,0"),
		"disarm"      = list("type" = /obj/screen/fastintent/disarm,   "loc" = "12,0"),
		"harm"        = list("type" = /obj/screen/fastintent/harm,     "loc" = "13,0"),
		"grab"        = list("type" = /obj/screen/fastintent/grab,     "loc" = "13,0"),
		"damage zone" = list("type" = /obj/screen/zone_sel,   "loc" = "15,0"),
		"internal"    = list("type" = /obj/screen/internal,   "loc" = "15,14"),
		"swap hand"   = list("type" = /obj/screen/swap,       "loc" = "7,1"),
		"toggle gun mode"   = list("type" = /obj/screen/gun/mode,       "loc" = "15,2"),
		"allow movement"   = list("type" = /obj/screen/gun/move,       "loc" = "15,3"),
		"allow item use"   = list("type" = /obj/screen/gun/item,       "loc" = "14,2"),
		"allow radio use"   = list("type" = /obj/screen/gun/radio,       "loc" = "14,3"),
		)

//		"painoverlay" = list("type" = /obj/screen/damageoverlay, "loc" = "WEST,SOUTH to EAST,NORTH", "icon" =  'icons/mob/screen1_full.dmi')

	/*slot_position = list(
		"i_clothing" =   "WEST:6,SOUTH+1:7",
		"o_clothing" =   "WEST+1:8,SOUTH+1:7",
		"mask" =         "WEST+1:8,SOUTH+2:9",
		"gloves" =       "WEST+2:10,SOUTH+1:7",
		"eyes" =         "WEST:6,SOUTH+2:9",
		"l_ear" =        "WEST+2:10,SOUTH+2:9",
		"r_ear" =        "WEST+2:10,SOUTH+3:11",
		"head" =         "WEST+1:8,SOUTH+3:11",
		"shoes" =        "WEST+1:8,SOUTH:5",
		"suit storage" = "WEST+2:10,SOUTH:5",
		"back" =         "CENTER-2:14,SOUTH:5",
		"id" =           "WEST+3:12,SOUTH:5",
		"storage1" =     "CENTER+1:16,SOUTH:5",
		"storage2" =     "CENTER+2:16,SOUTH:5",
		"belt" =         "WEST+4:14,SOUTH:5"
		)*/
	slot_data = list (
		"i_clothing" =   list("loc" = "1,1",  "name" = "Uniform",         "state" = "center",  "toggle" = 1),
		"o_clothing" =   list("loc" = "2,1",  "name" = "Suit",            "state" = "equip",   "toggle" = 1),
		"mask" =         list("loc" = "2,2",  "name" = "Mask",            "state" = "mask",    "toggle" = 1),
		"gloves" =       list("loc" = "3,1",  "name" = "Gloves",          "state" = "gloves",  "toggle" = 1),
		"eyes" =         list("loc" = "1,2",  "name" = "Glasses",         "state" = "glasses", "toggle" = 1),
		"l_ear" =        list("loc" = "3,2",  "name" = "Left Ear",        "state" = "ears0",   "toggle" = 1),
		"r_ear" =        list("loc" = "3,3",  "name" = "Right Ear",       "state" = "ears1",   "toggle" = 1),
		"head" =         list("loc" = "2,3",  "name" = "Hat",             "state" = "hair",    "toggle" = 1),
		"shoes" =        list("loc" = "2,0",  "name" = "Shoes",           "state" = "shoes",   "toggle" = 1),
		"suit storage" = list("loc" = "3,0",  "name" = "Suit Storage",    "state" = "suit-belt"),
		"back" =         list("loc" = "6,0",  "name" = "Back",            "state" = "back"),
		"id" =           list("loc" = "4,0",  "name" = "ID",              "state" = "id"),
		"storage1" =     list("loc" = "9,0",  "name" = "Left Pocket",     "state" = "pocket_l"),
		"storage2" =     list("loc" = "10,0", "name" = "Right Pocket",    "state" = "pocket_r"),
		"belt" =         list("loc" = "5,0",  "name" = "Belt",            "state" = "belt"),
		"l_hand" =       list("loc" = "8,0",  "name" = "Left Hand",       "state" = "hand", "dir" = NORTH, "type" = /obj/screen/inventory/hand),
		"r_hand" =       list("loc" = "7,0",  "name" = "Right Hand",      "state" = "hand", "dir" = SOUTH, "type" = /obj/screen/inventory/hand)
		)

	HUDfrippery = list(
		list("loc" = "0,0", "icon_state" = "frame0", "dir" = EAST),
		list("loc" = "0,0", "icon_state" = "frame3", "dir" = EAST),
		list("loc" = "0,1", "icon_state" = "frame2", "dir" = NORTH),
		list("loc" = "0,2", "icon_state" = "frame2", "dir" = EAST),
		list("loc" = "0,3", "icon_state" = "frame2", "dir" = SOUTH),
		list("loc" = "0,1", "icon_state" = "frame1", "dir" = NORTHEAST),
		list("loc" = "0,2", "icon_state" = "frame1", "dir" = EAST),
		list("loc" = "0,3", "icon_state" = "frame1", "dir" = SOUTHEAST),
		list("loc" = "4,1", "icon_state" = "frame1", "dir" = NORTHWEST),
		list("loc" = "4,2", "icon_state" = "frame1", "dir" = WEST),
		list("loc" = "4,3", "icon_state" = "frame1", "dir" = SOUTHWEST),
		list("loc" = "7,1:14", "icon_state" = "frame1", "dir" = NORTH),
		list("loc" = "8,1:14", "icon_state" = "frame1", "dir" = SOUTH),
		list("loc" = "14,4", "icon_state" = "frame1", "dir" = NORTH),
		list("loc" = "15,4", "icon_state" = "frame1", "dir" = SOUTH),
		list("loc" = "15,4", "icon_state" = "frame3", "dir" = NORTH),
		list("loc" = "15,4", "icon_state" = "frame0", "dir" = NORTH),
		list("loc" = "15,8", "icon_state" = "frame0", "dir" = SOUTH),
		list("loc" = "15,8", "icon_state" = "frame3", "dir" = NORTH),
		list("loc" = "15,8", "icon_state" = "frame0", "dir" = NORTH),
		list("loc" = "15,11", "icon_state" = "frame0", "dir" = SOUTH),
		list("loc" = "15,11", "icon_state" = "frame3", "dir" = NORTH),
		list("loc" = "15,11", "icon_state" = "frame0", "dir" = NORTH),
		list("loc" = "15,15", "icon_state" = "frame0", "dir" = SOUTH),
		list("loc" = "15,15", "icon_state" = "frame3", "dir" = SOUTH),
		list("loc" = "11,0", "icon_state" = "frame3", "dir" = WEST),
		list("loc" = "11,0", "icon_state" = "frame0", "dir" = EAST),
		list("loc" = "11,0", "icon_state" = "frame0", "dir" = WEST),
		list("loc" = "1,3", "icon_state" = "display", "dir" = WEST)
		)