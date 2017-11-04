/datum/hud
	var/name
	var/list/HUDneed//для "активных" элементов (прим. здоровье)
//	var/list/HUDprocess = list()
	var/list/slot_data//inventory styff (for mob variable HUDinventory)
	var/icon/icon = null //what dmi we use
	var/list/HUDfrippery //for nice view
	var/list/HUDoverlays //tech stuff (flash overlay, pain overlay, etc.)
//	var/Xbags
//	var/Ybags
	var/list/ConteinerData // for space_orient_objs and slot_orient_objs
	var/list/IconUnderlays //underlays data for HUD objects
	var/MinStyleFlag = FALSE //that HUD style have compact version?


/datum/hud/human
	name = "ErisStyle"
	icon = 'icons/mob/screen/ErisStyleHolo.dmi'
	//Xbags, Ybags for space_orient_objs
	//Others for slot_orient_objs
	MinStyleFlag = TRUE
	ConteinerData = list(
		"Xspace" = 5,
		"Yspace" = 2,
		"ColCount" = 7,
		"Xslot" = 5,
		"Yslot" = 2
	)


	HUDoverlays = list(
		"damageoverlay" = list("type" = /obj/screen/damageoverlay, "loc" = "1,1", "icon" =  'icons/mob/screen1_full.dmi'),
		"flash" =  list("type" = /obj/screen/full_1_tile_overlay, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"pain" = list("type" = /obj/screen/full_1_tile_overlay, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"drugeffect" = list("type" = /obj/screen/drugoverlay, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"glassesoverlay" = list("type" = /obj/screen/glasses_overlay, "loc" = "1,1", "icon_state" = "blank")
	)

	HUDneed = list(
		"health"      = list("type" = /obj/screen/health,    "loc" = "16,6", "minloc" = "15,7", "background" = "back1"),
		"nutrition"   = list("type" = /obj/screen/nutrition,  "loc" = "16,5", "minloc" = "15,6", "background" = "back1"),
		"bodytemp"    = list("type" = /obj/screen/bodytemp,   "loc" = "16,7", "minloc" = "15,8", "background" = "back1"),
		"pressure"    = list("type" = /obj/screen/pressure,   "loc" = "16,13", "minloc" = "15,14", "background" = "back1"),
		"toxin"       = list("type" = /obj/screen/toxin,      "loc" = "16,10", "minloc" = "15,11", "background" = "back1"),
		"oxygen"      = list("type" = /obj/screen/oxygen,     "loc" = "16,12", "minloc" = "15,13", "background" = "back1"),
		"fire"        = list("type" = /obj/screen/fire,       "loc" = "16,9", "minloc" = "15,10", "background" = "back1"),
		"throw"       = list("type" = /obj/screen/HUDthrow,   "loc" = "16,1", "minloc" = "14,2", "background" = "back13"),
		"pull"        = list("type" = /obj/screen/pull,       "loc" = "15:16,1", "minloc" = "15,2", "background" = "back13"),
		"drop"        = list("type" = /obj/screen/drop,       "loc" = "16:16,1", "minloc" = "14:16,2", "background" = "back13"),
		"resist"      = list("type" = /obj/screen/resist,     "loc" = "15,1", "minloc" = "15:16,2", "background" = "back13"),
		"m_intent"    = list("type" = /obj/screen/mov_intent, "loc" = "15,0", "minloc" = "14,1", "background" = "back1"),
		"equip"       = list("type" = /obj/screen/equip,      "loc" = "8,1", "minloc" = "7,2", "background" = "back14-l"),
		"intent"      = list("type" = /obj/screen/intent,     "loc" = "13:16,0", "minloc" = "12:16,1", "background" = "back1"),
		"help"        = list("type" = /obj/screen/fastintent/help,     "loc" = "13,0", "minloc" = "12,1", "background" = "back15"),
		"disarm"      = list("type" = /obj/screen/fastintent/disarm,   "loc" = "13,0:-16", "minloc" = "12,1:-16", "background" = "back15"),
		"harm"        = list("type" = /obj/screen/fastintent/harm,     "loc" = "14:16,0:-16", "minloc" = "13:16,1", "background" = "back15"),
		"grab"        = list("type" = /obj/screen/fastintent/grab,     "loc" = "14:16,0", "minloc" = "13:16,1:-16", "background" = "back15"),
		"damage zone" = list("type" = /obj/screen/zone_sel,   "loc" = "16,0", "minloc" = "15,1", "background" = "back1"),
		"internal"    = list("type" = /obj/screen/internal,   "loc" = "16,14", "minloc" = "15,15", "background" = "back1"),
		"swap hand"   = list("type" = /obj/screen/swap,       "loc" = "8,1", "minloc" = "7,2"),
		"toggle gun mode"   = list("type" = /obj/screen/gun/mode,      "loc" = "16,2", "minloc" = "15,3", "background" = "back1"),
		"allow movement"   = list("type" = /obj/screen/gun/move,       "loc" = "16,3", "minloc" = "15,4", "background" = "back1"),
		"allow item use"   = list("type" = /obj/screen/gun/item,       "loc" = "15,2", "minloc" = "14,3", "background" = "back1"),
		"allow radio use"   = list("type" = /obj/screen/gun/radio,      "loc" = "15,3", "minloc" = "14,4", "background" = "back1"),
		"toggle invetory"   = list("type" = /obj/screen/toggle_invetory,       "loc" = "2,0", "minloc" = "1,1", "background" = "back1")
		)

	slot_data = list (
		"Uniform" =   list("loc" = "2,1", "minloc" = "1,2",            "state" = "center",  "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Suit" =   list("loc" = "3,1", "minloc" = "2,2",              "state" = "equip",   "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Mask" =         list("loc" = "3,2", "minloc" = "2,3",        "state" = "mask",    "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Gloves" =       list("loc" = "4,1", "minloc" = "3,2",        "state" = "gloves",  "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Glasses" =         list("loc" = "2,2", "minloc" = "1,3",     "state" = "glasses", "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Left Ear" =        list("loc" = "4,2", "minloc" = "3,3",     "state" = "ears0",   "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Right Ear" =        list("loc" = "4,3", "minloc" = "3,4",    "state" = "ears1",   "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Hat" =         list("loc" = "3,3", "minloc" = "2,4",         "state" = "hair",    "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Shoes" =        list("loc" = "3,0", "minloc" = "2,1",        "state" = "shoes", "background" = "back1"),
		"Suit Storage" = list("loc" = "4,0", "minloc" = "3,1",        "state" = "suit-belt", "background" = "back1"),
		"Back" =         list("loc" = "7,0", "minloc" = "6,1",        "state" = "back", "background" = "back1"),
		"ID" =           list("loc" = "5,0", "minloc" = "4,1",        "state" = "id", "background" = "back1"),
		"Left Pocket" =     list("loc" = "10,0", "minloc" = "9,1",    "state" = "pocket_l", "background" = "back1"),
		"Right Pocket" =     list("loc" = "11,0", "minloc" = "10,1",  "state" = "pocket_r", "background" = "back1"),
		"Belt" =         list("loc" = "6,0", "minloc" = "5,1",        "state" = "belt", "background" = "back1"),
		"Left Hand" =       list("loc" = "9,0", "minloc" = "8,1",     "state" = "hand-l", "type" = /obj/screen/inventory/hand, "background" = "back1"),
		"Right Hand" =       list("loc" = "8,0", "minloc" = "7,1",    "state" = "hand-r", "type" = /obj/screen/inventory/hand, "background" = "back1")
		)

	HUDfrippery = list(
		list("loc" = "1,0", "icon_state" = "frame0-3", ),
		list("loc" = "1,0", "icon_state" = "frame3-4", ),
		list("loc" = "1,1", "icon_state" = "frame2-2",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,2", "icon_state" = "frame2-3",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,3", "icon_state" = "frame2-1",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,1", "icon_state" = "frame1-3", "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,2", "icon_state" = "frame1-7",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,3", "icon_state" = "frame1-5",  "hideflag" = TOGGLE_INVENTORY_FLAG),
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
		//list("loc" = "2,3", "icon_state" = "block",  "hideflag" = TOGGLE_INVENTORY_FLAG),


/datum/hud/human/New()

	IconUnderlays = list(
		"back0" = new /image(src.icon, "t0"),
		"back1" = new /image(src.icon, "t1"),
		"back2" = new /image(src.icon, "t2"),
		"back3" = new /image(src.icon, "t3"),
		"back4" = new /image(src.icon, "t4"),
		"back5" = new /image(src.icon, "t5"),
		"back6" = new /image(src.icon, "t6"),
		"back7" = new /image(src.icon, "t7"),
		"back8" = new /image(src.icon, "t8"),
		"back9" = new /image(src.icon, "t9"),
		"back10" = new /image(src.icon, "t10"),
		"back11" = new /image(src.icon, "t11"),
		"back12" = new /image(src.icon, "t12"),
		"back13" = new /image(src.icon, "t13"),
		"back14-l" = new /image(src.icon, "t14-l"),
		"back14-m" = new /image(src.icon, "t14-m"),
		"back14-r" = new /image(src.icon, "t14-r"),
		"back15" = new /image(src.icon, "t15")
	)

	for (var/p in IconUnderlays)
		var/image/I = IconUnderlays[p]
		I.alpha = 200


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
		"Uniform" =   list("loc" = "2,1",  "name" = "Uniform",         "state" = "center",  "toggle" = 1),
		"Suit" =   list("loc" = "3,1",  "name" = "Suit",            "state" = "equip",   "toggle" = 1),
		"Mask" =         list("loc" = "3,2",  "name" = "Mask",            "state" = "mask",    "toggle" = 1),
		"Gloves" =       list("loc" = "4,1",  "name" = "Gloves",          "state" = "gloves",  "toggle" = 1),
		"Glasses" =         list("loc" = "2,2",  "name" = "Glasses",         "state" = "glasses", "toggle" = 1),
		"Left Ear" =        list("loc" = "4,2",  "name" = "Left Ear",        "state" = "ears0",   "toggle" = 1),
		"Right Ear" =        list("loc" = "4,3",  "name" = "Right Ear",       "state" = "ears1",   "toggle" = 1),
		"Hat" =         list("loc" = "3,3",  "name" = "Hat",             "state" = "hair",    "toggle" = 1),
		"Shoes" =        list("loc" = "3,0",  "name" = "Shoes",           "state" = "shoes",   "toggle" = 1),
		"Suit Storage" = list("loc" = "4,0",  "name" = "Suit Storage",    "state" = "suit-belt"),
		"Back" =         list("loc" = "7,0",  "name" = "Back",            "state" = "back"),
		"ID" =           list("loc" = "5,0",  "name" = "ID",              "state" = "id"),
		"Left Pocket" =     list("loc" = "10,0",  "name" = "Left Pocket",     "state" = "pocket_l"),
		"Right Pocket" =     list("loc" = "11,0", "name" = "Right Pocket",    "state" = "pocket_r"),
		"Belt" =         list("loc" = "6,0",  "name" = "Belt",            "state" = "belt"),
		"Left Hand" =       list("loc" = "9,0",  "name" = "Left Hand",       "state" = "hand", "dir" = NORTH, "type" = /obj/screen/inventory/hand),
		"Right Hand" =       list("loc" = "8,0",  "name" = "Right Hand",      "state" = "hand", "dir" = SOUTH, "type" = /obj/screen/inventory/hand)
		)

