/datum/hud
	var/name
	var/list/HUDneed//для "активных" элементов (прим. здоровье)
//	var/list/HUDprocess = list()
	var/list/slot_data//для инвентаря
	var/icon/icon = null
	var/list/HUDfrippery
	var/list/HUDoverlays
//	var/Xbags
//	var/Ybags
	var/list/ConteinerData
/datum/hud/human
	name = "ErisStyle"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	//Xbags,Ybags for space_orient_objs
	//Others for slot_orient_objs
	ConteinerData = list(
		"Xspace" = 2,
		"Yspace" = 4,
		"ColCount" = 7,
		"Xslot" = 5,
		"Yslot" = 2
	)
//	Xbags = 2
//	Ybags = 4
//to:do переместить все существующие оверлеи сюда, если возможно.
	HUDoverlays = list(
		"damageoverlay" = list("type" = /obj/screen/damageoverlay, "loc" = "1,1", "icon" =  'icons/mob/screen1_full.dmi'),
		"flash" =  list("type" = /obj/screen, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"pain" = list("type" = /obj/screen, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"drugeffect" = list("type" = /obj/screen/drugoverlay, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"glassesoverlay" = list("type" = /obj/screen/glasses_overlay, "loc" = "1,1", "icon_state" = "blank")
	)
//"vision" = list("type" = /obj/screen, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank")
	HUDneed = list(
		"health"      = list("type" = /obj/screen/health,     "loc" = "16,6"),
		"nutrition"   = list("type" = /obj/screen/nutrition,  "loc" = "16,5"),
		"bodytemp"    = list("type" = /obj/screen/bodytemp,   "loc" = "16,7"),
		"pressure"    = list("type" = /obj/screen/pressure,   "loc" = "16,13"),
		"toxin"       = list("type" = /obj/screen/toxin,      "loc" = "16,10"),
		"oxygen"      = list("type" = /obj/screen/oxygen,     "loc" = "16,12"),
		"fire"        = list("type" = /obj/screen/fire,       "loc" = "16,9"),
		"throw"       = list("type" = /obj/screen/HUDthrow,   "loc" = "16,1"),
		"pull"        = list("type" = /obj/screen/pull,       "loc" = "15,1"),
		"drop"        = list("type" = /obj/screen/drop,       "loc" = "16:-16,1"),
		"resist"      = list("type" = /obj/screen/resist,     "loc" = "15:16,1"),
		"m_intent"    = list("type" = /obj/screen/mov_intent, "loc" = "15,0"),
		"equip"       = list("type" = /obj/screen/equip,      "loc" = "8,1"),
		"intent"      = list("type" = /obj/screen/intent,     "loc" = "13:16,0"),
		"help"        = list("type" = /obj/screen/fastintent/help,     "loc" = "13,0"),
		"disarm"      = list("type" = /obj/screen/fastintent/disarm,   "loc" = "13,0"),
		"harm"        = list("type" = /obj/screen/fastintent/harm,     "loc" = "14,0"),
		"grab"        = list("type" = /obj/screen/fastintent/grab,     "loc" = "14,0"),
		"damage zone" = list("type" = /obj/screen/zone_sel,   "loc" = "16,0"),
		"internal"    = list("type" = /obj/screen/internal,   "loc" = "16,14"),
		"swap hand"   = list("type" = /obj/screen/swap,       "loc" = "8,1"),
		"toggle gun mode"   = list("type" = /obj/screen/gun/mode,       "loc" = "16,2"),
		"allow movement"   = list("type" = /obj/screen/gun/move,       "loc" = "16,3"),
		"allow item use"   = list("type" = /obj/screen/gun/item,       "loc" = "15,2"),
		"allow radio use"   = list("type" = /obj/screen/gun/radio,       "loc" = "15,3"),
		"toggle invetory"   = list("type" = /obj/screen/toggle_invetory,       "loc" = "2,0")
		)

//		"painoverlay" = list("type" = /obj/screen/damageoverlay, "loc" = "WEST,SOUTH to EAST,NORTH", "icon" =  'icons/mob/screen1_full.dmi')

	slot_data = list (
		"i_clothing" =   list("loc" = "2,1",  "name" = "Uniform",         "state" = "center",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		"o_clothing" =   list("loc" = "3,1",  "name" = "Suit",            "state" = "equip",   "hideflag" = TOGGLE_INVENTORY_FLAG),
		"mask" =         list("loc" = "3,2",  "name" = "Mask",            "state" = "mask",    "hideflag" = TOGGLE_INVENTORY_FLAG),
		"gloves" =       list("loc" = "4,1",  "name" = "Gloves",          "state" = "gloves",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		"eyes" =         list("loc" = "2,2",  "name" = "Glasses",         "state" = "glasses", "hideflag" = TOGGLE_INVENTORY_FLAG),
		"l_ear" =        list("loc" = "4,2",  "name" = "Left Ear",        "state" = "ears0",   "hideflag" = TOGGLE_INVENTORY_FLAG),
		"r_ear" =        list("loc" = "4,3",  "name" = "Right Ear",       "state" = "ears1",   "hideflag" = TOGGLE_INVENTORY_FLAG),
		"head" =         list("loc" = "3,3",  "name" = "Hat",             "state" = "hair",    "hideflag" = TOGGLE_INVENTORY_FLAG),
		"shoes" =        list("loc" = "3,0",  "name" = "Shoes",           "state" = "shoes"),
		"suit storage" = list("loc" = "4,0",  "name" = "Suit Storage",    "state" = "suit-belt"),
		"back" =         list("loc" = "7,0",  "name" = "Back",            "state" = "back"),
		"id" =           list("loc" = "5,0",  "name" = "ID",              "state" = "id"),
		"storage1" =     list("loc" = "10,0",  "name" = "Left Pocket",     "state" = "pocket_l"),
		"storage2" =     list("loc" = "11,0", "name" = "Right Pocket",    "state" = "pocket_r"),
		"belt" =         list("loc" = "6,0",  "name" = "Belt",            "state" = "belt"),
		"l_hand" =       list("loc" = "9,0",  "name" = "Left Hand",       "state" = "hand-l", "type" = /obj/screen/inventory/hand),
		"r_hand" =       list("loc" = "8,0",  "name" = "Right Hand",      "state" = "hand-r", "type" = /obj/screen/inventory/hand)
		)

	HUDfrippery = list(
		list("loc" = "1,0", "icon_state" = "frame0-3",),
		list("loc" = "1,0", "icon_state" = "frame3-4",),
		list("loc" = "1,1", "icon_state" = "frame2-2",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,2", "icon_state" = "frame2-3",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,3", "icon_state" = "frame2-1",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,1", "icon_state" = "frame1-3", "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,2", "icon_state" = "frame1-7",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,3", "icon_state" = "frame1-5",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "2,3", "icon_state" = "display",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "5,1", "icon_state" = "frame1-2",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "5,2", "icon_state" = "frame1-6",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "5,3", "icon_state" = "frame1-4", "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "8,1:13", "icon_state" = "frame1-8"),
		list("loc" = "9,1:13", "icon_state" = "frame1-1"),
		list("loc" = "12,0", "icon_state" = "frame3-2"),
		list("loc" = "12,0", "icon_state" = "frame0-2"),
		list("loc" = "12,0", "icon_state" = "frame0-3"),
		list("loc" = "15,4", "icon_state" = "frame1-8"),
		list("loc" = "16,4", "icon_state" = "frame1-1"),
		list("loc" = "16,4", "icon_state" = "frame3-3"),
		list("loc" = "16,4", "icon_state" = "frame0-4"),
		list("loc" = "16,8", "icon_state" = "frame0-1"),
		list("loc" = "16,8", "icon_state" = "frame3-3"),
		list("loc" = "16,8", "icon_state" = "frame0-4"),
		list("loc" = "16,11", "icon_state" = "frame0-1"),
		list("loc" = "16,11", "icon_state" = "frame3-3"),
		list("loc" = "16,11", "icon_state" = "frame0-4"),
		list("loc" = "16,15", "icon_state" = "frame0-1"),
		list("loc" = "16,15", "icon_state" = "frame3-1")
		)

/datum/hud/cyborg
	name = "BorgStyle"
	icon = 'icons/mob/screen1_robot.dmi'


	HUDoverlays = list(
		"flash" =  list("type" = /obj/screen, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"blind" =  list("type" = /obj/screen, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
	)

	HUDneed = list(
		"cell"      = list("type" = /obj/screen/silicon/cell,     "loc" = "15,14"),
		"health"      = list("type" = /obj/screen/health/cyborg,     "loc" = "15,6"),
		"damage zone" = list("type" = /obj/screen/zone_sel,   "loc" = "15,1"),
		"radio" = list("type" = /obj/screen/silicon/radio,   "loc" = "13,1"),
		"store" = list("type" = /obj/screen/silicon/store,   "loc" = "9,1"),
		"panel" = list("type" = /obj/screen/silicon/panel,   "loc" = "15,2"),
		"intent"      = list("type" = /obj/screen/intent,     "loc" = "14,1"),
		"inventory"      = list("type" = /obj/screen/silicon/inventory,     "loc" = "5,1"),
		"module"      = list("type" = /obj/screen/silicon/module_select,     "loc" = "14,2")
	)

	slot_data = list(
		"inv1" = list("type" = /obj/screen/silicon/module,     "loc" = "6,1", "module_num" = 1, "icon_state" = "inv1"),
		"inv2" = list("type" = /obj/screen/silicon/module,     "loc" = "7,1", "module_num" = 2, "icon_state" = "inv2"),
		"inv3" = list("type" = /obj/screen/silicon/module,     "loc" = "8,1", "module_num" = 3, "icon_state" = "inv3")
	)

/datum/hud/Xenos
	name = "Xenos"
	icon = 'icons/mob/screen1_alien.dmi'

	HUDneed = list(
		"health"      = list("type" = /obj/screen/health,     "loc" = "16,6"),
		"nutrition"   = list("type" = /obj/screen/nutrition,  "loc" = "16,5"),
		"bodytemp"    = list("type" = /obj/screen/bodytemp,   "loc" = "16,7"),
		"pressure"    = list("type" = /obj/screen/pressure,   "loc" = "16,13"),
		"toxin"       = list("type" = /obj/screen/toxin,      "loc" = "16,10"),
		"oxygen"      = list("type" = /obj/screen/oxygen,     "loc" = "16,12"),
		"fire"        = list("type" = /obj/screen/fire,       "loc" = "16,9"),
		"throw"       = list("type" = /obj/screen/HUDthrow,   "loc" = "16,1"),
		"pull"        = list("type" = /obj/screen/pull,       "loc" = "15,1"),
		"drop"        = list("type" = /obj/screen/drop,       "loc" = "16:-16,1"),
		"resist"      = list("type" = /obj/screen/resist,     "loc" = "15:16,1"),
		"m_intent"    = list("type" = /obj/screen/mov_intent, "loc" = "15,0"),
		"equip"       = list("type" = /obj/screen/equip,      "loc" = "8,1"),
		"intent"      = list("type" = /obj/screen/intent,     "loc" = "13:16,0"),
		"help"        = list("type" = /obj/screen/fastintent/help,     "loc" = "13,0"),
		"disarm"      = list("type" = /obj/screen/fastintent/disarm,   "loc" = "13,0"),
		"harm"        = list("type" = /obj/screen/fastintent/harm,     "loc" = "14,0"),
		"grab"        = list("type" = /obj/screen/fastintent/grab,     "loc" = "14,0"),
		"damage zone" = list("type" = /obj/screen/zone_sel,   "loc" = "16,0"),
		"internal"    = list("type" = /obj/screen/internal,   "loc" = "16,14"),
		"swap hand"   = list("type" = /obj/screen/swap,       "loc" = "8,1"),
		"toggle gun mode"   = list("type" = /obj/screen/gun/mode,       "loc" = "16,2"),
		"allow movement"   = list("type" = /obj/screen/gun/move,       "loc" = "16,3"),
		"allow item use"   = list("type" = /obj/screen/gun/item,       "loc" = "15,2"),
		"allow radio use"   = list("type" = /obj/screen/gun/radio,       "loc" = "15,3"),
		)

	slot_data = list (
		"i_clothing" =   list("loc" = "2,1",  "name" = "Uniform",         "state" = "center",  "toggle" = 1),
		"o_clothing" =   list("loc" = "3,1",  "name" = "Suit",            "state" = "equip",   "toggle" = 1),
		"mask" =         list("loc" = "3,2",  "name" = "Mask",            "state" = "mask",    "toggle" = 1),
		"gloves" =       list("loc" = "4,1",  "name" = "Gloves",          "state" = "gloves",  "toggle" = 1),
		"eyes" =         list("loc" = "2,2",  "name" = "Glasses",         "state" = "glasses", "toggle" = 1),
		"l_ear" =        list("loc" = "4,2",  "name" = "Left Ear",        "state" = "ears0",   "toggle" = 1),
		"r_ear" =        list("loc" = "4,3",  "name" = "Right Ear",       "state" = "ears1",   "toggle" = 1),
		"head" =         list("loc" = "3,3",  "name" = "Hat",             "state" = "hair",    "toggle" = 1),
		"shoes" =        list("loc" = "3,0",  "name" = "Shoes",           "state" = "shoes",   "toggle" = 1),
		"suit storage" = list("loc" = "4,0",  "name" = "Suit Storage",    "state" = "suit-belt"),
		"back" =         list("loc" = "7,0",  "name" = "Back",            "state" = "back"),
		"id" =           list("loc" = "5,0",  "name" = "ID",              "state" = "id"),
		"storage1" =     list("loc" = "10,0",  "name" = "Left Pocket",     "state" = "pocket_l"),
		"storage2" =     list("loc" = "11,0", "name" = "Right Pocket",    "state" = "pocket_r"),
		"belt" =         list("loc" = "6,0",  "name" = "Belt",            "state" = "belt"),
		"l_hand" =       list("loc" = "9,0",  "name" = "Left Hand",       "state" = "hand", "dir" = NORTH, "type" = /obj/screen/inventory/hand),
		"r_hand" =       list("loc" = "8,0",  "name" = "Right Hand",      "state" = "hand", "dir" = SOUTH, "type" = /obj/screen/inventory/hand)
		)
