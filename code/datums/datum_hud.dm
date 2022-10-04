/datum/hud
	var/name
	var/list/HUDneed //for "active" elements (health)
//	var/list/HUDprocess = list()
	var/list/slot_data //inventory stuff (for mob variable HUDinventory)
	var/icon/icon = null //what dmi we use
	var/list/HUDfrippery //for nice view
	var/list/HUDoverlays //tech stuff (flash overlay, pain overlay, etc.)
//	var/Xbags
//	var/Ybags
	var/list/StorageData //for storage bags
	var/list/IconUnderlays //underlays data for HUD objects
	var/MinStyleFlag = FALSE //that HUD style have compact version?

	// plane master / openspace overlay vars
	var/old_z
	var/list/obj/screen/plane_master/plane_masters = list() // see "appearance_flags" in the ref, assoc list of "[plane]" = object
	var/list/obj/screen/openspace_overlay/openspace_overlays = list()

/datum/hud/proc/updatePlaneMasters(mob/mymob)
	if(!mymob || !mymob.client)
		return

	var/atom/player = mymob
	if(mymob.client.virtual_eye)
		player = mymob.client.virtual_eye

	var/turf/T = get_turf(player)
	if(!T)
		return

	var/z = T.z

	if(z == old_z)
		return

	old_z = z

	var/datum/level_data/LD = z_levels[z]

	for(var/pmaster in plane_masters)
		var/obj/screen/plane_master/instance = plane_masters[pmaster]
		mymob.client.screen -= instance
		qdel(instance)

	plane_masters.Cut()

	for(var/over in openspace_overlays)
		var/obj/screen/openspace_overlay/instance = openspace_overlays[over]
		mymob.client.screen -= instance
		qdel(instance)

	openspace_overlays.Cut()

	if(!LD)
		return;


	var/local_z = z-(LD.original_level-1)
	for(var/zi in 1 to local_z)
		for(var/mytype in subtypesof(/obj/screen/plane_master))
			var/obj/screen/plane_master/instance = new mytype()

			instance.plane = calculate_plane(zi,instance.plane)

			plane_masters["[zi]-[mytype]"] = instance
			mymob.client.screen += instance
			instance.backdrop(mymob)

		for(var/pl in list(GAME_PLANE,FLOOR_PLANE))
			if(zi < local_z)
				var/zdiff = local_z-(zi-1)

				var/obj/screen/openspace_overlay/oover = new
				oover.plane = calculate_plane(zi,pl)
				oover.alpha = min(255,zdiff*50 + 30)
				openspace_overlays["[zi]-[oover.plane]"] = oover
				mymob.client.screen += oover


/mob/update_plane()
	..()
	if(hud_used)
		hud_used.updatePlaneMasters(src)


/datum/hud/New(mob/mymob)
	if(mymob)
		updatePlaneMasters(mymob)

/datum/hud/human
	name = "ErisStyle"
	icon = 'icons/mob/screen/ErisStyleHolo.dmi'
	//Xbags, Ybags for space_orient_objs
	//Others for slot_orient_objs
	MinStyleFlag = TRUE
	StorageData = list(
		"Xspace" = 4.5*32, //in pixels
		"Yspace" = 1.5*32, //in pixels
		"ColCount" = 7,
	)


	HUDoverlays = list(
		"flash"      = list("type" = /obj/screen/full_1_tile_overlay, "loc" = "WEST,SOUTH-1 to EAST+1,NORTH", "minloc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"pain"       = list("type" = /obj/screen/full_1_tile_overlay, "loc" = "WEST,SOUTH-1 to EAST+1,NORTH", "minloc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"drugeffect" = list("type" = /obj/screen/drugoverlay,         "loc" = "WEST,SOUTH-1 to EAST+1,NORTH", "minloc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"damageoverlay"  = list("type" = /obj/screen/damageoverlay,   "loc" = "1,1:-32", "icon" =  'icons/mob/screen1_full.dmi'),
		"glassesoverlay" = list("type" = /obj/screen/glasses_overlay, "loc" = "1,1:-32", "icon_state" = "blank"),
	)

	HUDneed = list(
//status
	"nutrition"          = list("type" = /obj/screen/nutrition,         "loc" = "EAST+1:1,BOTTOM+3:25",   "minloc" = "RIGHT:1,5:26",  "background" = "back17"),
	"neural system accumulation" = list("type" = /obj/screen/nsa,       "loc" = "EAST+1:1,BOTTOM+4:6",    "minloc" = "RIGHT:1,6:7",   "background" = "back17"),
	"body temperature"   = list("type" = /obj/screen/bodytemp,          "loc" = "EAST+1:1,BOTTOM+4:19",   "minloc" = "RIGHT:1,6:20",  "background" = "back17"),
	"health"             = list("type" = /obj/screen/health,            "loc" = "EAST+1,BOTTOM+5",        "minloc" = "RIGHT,7",       "background" = "back1"),
	"sanity"             = list("type" = /obj/screen/sanity,            "loc" = "EAST+1,BOTTOM+6",        "minloc" = "RIGHT,8:-2",    "background" = "back1"),
	"oxygen"             = list("type" = /obj/screen/oxygen,            "loc" = "EAST+1:1,BOTTOM+7",      "minloc" = "RIGHT:1,9:-3",  "background" = "back18"),
	"fire"               = list("type" = /obj/screen/fire,              "loc" = "EAST+1:16,BOTTOM+7",     "minloc" = "RIGHT:16,9:-3", "background" = "back18"),
	"pressure"           = list("type" = /obj/screen/pressure,          "loc" = "EAST+1:1,BOTTOM+7:15",   "minloc" = "RIGHT:1,9:12",  "background" = "back18"),
	"toxin"              = list("type" = /obj/screen/toxin,             "loc" = "EAST+1:16,BOTTOM+7:15",  "minloc" = "RIGHT:16,9:12", "background" = "back18"),
	"internal"           = list("type" = /obj/screen/internal,          "loc" = "EAST+1,BOTTOM+8:-2",     "minloc" = "RIGHT,10:-5",   "background" = "back15"),
//corner buttons
	"jump"               = list("type" = /obj/screen/jump,              "loc" = "EAST+1,BOTTOM+1:-6", "minloc" = "RIGHT,3:-6",   "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back17-1"),
	"look up"            = list("type" = /obj/screen/look_up,           "loc" = "EAST,BOTTOM+1:13",   "minloc" = "RIGHT-1,2:13", "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back17-1"),
	"throw"              = list("type" = /obj/screen/HUDthrow,          "loc" = "EAST+1,BOTTOM+1:13", "minloc" = "RIGHT,2:13",   "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back17-1"),
	"pull"               = list("type" = /obj/screen/pull,              "loc" = "EAST-1,BOTTOM+1:13", "minloc" = "RIGHT-2,2:13", "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back17-1"),
	"drop"               = list("type" = /obj/screen/drop,              "loc" = "EAST+1,BOTTOM+1",    "minloc" = "RIGHT,2",      "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back17-1"),
	"resist"             = list("type" = /obj/screen/resist,            "loc" = "EAST-1,BOTTOM+1",    "minloc" = "RIGHT-2,2",    "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back17-1"),
	"rest"               = list("type" = /obj/screen/rest,              "loc" = "EAST,BOTTOM+1",      "minloc" = "RIGHT-1,2",    "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back17-1"),
	"move intent"        = list("type" = /obj/screen/mov_intent,        "loc" = "EAST,BOTTOM",        "minloc" = "RIGHT-1,1",    "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back1"),
	"implant bionics"    = list("type" = /obj/screen/implant_bionics,   "loc" = "EAST-2,BOTTOM-1",    "minloc" = "12,1",         "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back13"),
	"craft menu"         = list("type" = /obj/screen/craft_menu,        "loc" = "EAST-2:16,BOTTOM",   "minloc" = "12:16,1",      "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back13"),
	"wield"              = list("type" = /obj/screen/wield,             "loc" = "EAST-2:16,BOTTOM+1", "minloc" = "12:16,2",      "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back13"),
	"intent"             = list("type" = /obj/screen/intent,            "loc" = "EAST-1,BOTTOM",      "minloc" = "13,1",         "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back1"),
	"damage zone"        = list("type" = /obj/screen/zone_sel,          "loc" = "EAST+1,BOTTOM",      "minloc" = "RIGHT,1",      "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back1"),
//hand buttons
	"equip"              = list("type" = /obj/screen/equip,             "loc" = "8,1",                "minloc" = "7,2",          "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back14-l"),
	"swap hand"          = list("type" = /obj/screen/swap,              "loc" = "8,1",                "minloc" = "7,2",          "hideflag" = TOGGLE_BOTTOM_FLAG),
	"right arm bionics"  = list("type" = /obj/screen/bionics/r_arm,     "loc" = "7:19,1",             "minloc" = "6:20,2",       "background" = "back16"),
	"left arm bionics"   = list("type" = /obj/screen/bionics/l_arm,     "loc" = "10,1",               "minloc" = "9:-1,2",       "background" = "back16"),

	"toggle inventory"    = list("type" = /obj/screen/toggle_invetory,   "loc" = "2,0",                "minloc" = "1,1",          "hideflag" = TOGGLE_BOTTOM_FLAG, "background" = "back1")

	)

	slot_data = list (
		"Uniform" =   list("loc" = "2,1", "minloc" = "1,2",           "state" = "center",  "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Suit" =   list("loc" = "3,1", "minloc" = "2,2",              "state" = "equip",   "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Mask" =         list("loc" = "3,2", "minloc" = "2,3",        "state" = "mask",    "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Gloves" =       list("loc" = "4,1", "minloc" = "3,2",        "state" = "gloves",  "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Glasses" =         list("loc" = "2,2", "minloc" = "1,3",     "state" = "glasses", "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Left Ear" =        list("loc" = "4,2", "minloc" = "3,3",     "state" = "ears0",   "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Right Ear" =        list("loc" = "4,3", "minloc" = "3,4",    "state" = "ears1",   "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Hat" =         list("loc" = "3,3", "minloc" = "2,4",         "state" = "hair",    "hideflag" = TOGGLE_INVENTORY_FLAG, "background" = "back1"),
		"Shoes" =        list("loc" = "3,0", "minloc" = "2,1",        "state" = "shoes",   "hideflag" = TOGGLE_BOTTOM_FLAG,    "background" = "back1"),
		"Suit Storage" = list("loc" = "4,0", "minloc" = "3,1",        "state" = "suit-belt","hideflag" = TOGGLE_BOTTOM_FLAG,   "background" = "back1"),
		"Back" =         list("loc" = "7,0", "minloc" = "6,1",        "state" = "back",    "hideflag" = TOGGLE_BOTTOM_FLAG,    "background" = "back1"),
		"ID" =           list("loc" = "5,0", "minloc" = "4,1",        "state" = "id",      "hideflag" = TOGGLE_BOTTOM_FLAG,    "background" = "back1"),
		"Left Pocket" =     list("loc" = "10,0", "minloc" = "9,1",    "state" = "pocket_l","hideflag" = TOGGLE_BOTTOM_FLAG,    "background" = "back1"),
		"Right Pocket" =     list("loc" = "11,0", "minloc" = "10,1",  "state" = "pocket_r","hideflag" = TOGGLE_BOTTOM_FLAG,    "background" = "back1"),
		"Belt" =         list("loc" = "6,0", "minloc" = "5,1",        "state" = "belt",    "hideflag" = TOGGLE_BOTTOM_FLAG,    "background" = "back1"),
		"Left Hand" =       list("loc" = "9,0", "minloc" = "8,1",     "state" = "hand-l",  "hideflag" = TOGGLE_BOTTOM_FLAG, "type" = /obj/screen/inventory/hand, "background" = "back1"),
		"Right Hand" =       list("loc" = "8,0", "minloc" = "7,1",    "state" = "hand-r",  "hideflag" = TOGGLE_BOTTOM_FLAG, "type" = /obj/screen/inventory/hand, "background" = "back1")
		)

	HUDfrippery = list(
		list("loc" = "1,0", "icon_state" = "frame0-3", "hideflag" = TOGGLE_BOTTOM_FLAG),
		list("loc" = "1,0", "icon_state" = "frame3-4", "hideflag" = TOGGLE_BOTTOM_FLAG),
		list("loc" = "1,1", "icon_state" = "frame2-2",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,2", "icon_state" = "frame2-3",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,3", "icon_state" = "frame2-1",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,1", "icon_state" = "frame1-3", "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,2", "icon_state" = "frame1-7",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "1,3", "icon_state" = "frame1-5",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "5,1", "icon_state" = "frame1-2",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "5,2", "icon_state" = "frame1-6",  "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "5,3", "icon_state" = "frame1-4", "hideflag" = TOGGLE_INVENTORY_FLAG),
		list("loc" = "8,1:13", "icon_state" = "frame1-8", "hideflag" = TOGGLE_BOTTOM_FLAG),
		list("loc" = "9,1:13", "icon_state" = "frame1-1", "hideflag" = TOGGLE_BOTTOM_FLAG),
		list("loc" = "12,0", "icon_state" = "frame3-2", "hideflag" = TOGGLE_BOTTOM_FLAG),
		list("loc" = "12,0", "icon_state" = "frame0-2", "hideflag" = TOGGLE_BOTTOM_FLAG),
		list("loc" = "12,0", "icon_state" = "frame0-3", "hideflag" = TOGGLE_BOTTOM_FLAG),
		list("loc" = "EAST+1,BOTTOM+2:25", "icon_state" = "frame1-1"),
		list("loc" = "EAST+1,BOTTOM+2:25", "icon_state" = "frame3-3"),
		list("loc" = "EAST+1,BOTTOM+2:25", "icon_state" = "frame0-4"),
		list("loc" = "EAST+1,BOTTOM+8:14", "icon_state" = "frame0-1"),
		list("loc" = "EAST+1,BOTTOM+8:14", "icon_state" = "frame3-1")
		)
		//list("loc" = "2,3", "icon_state" = "block",  "hideflag" = TOGGLE_INVENTORY_FLAG),


/datum/hud/human/New()
	..()
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
		"back15" = new /image(src.icon, "t15"),
		"back16" = new /image(src.icon, "t16"),
		"back17" = new /image(src.icon, "t17"),
		"back17-1" = new /image(src.icon, "t17-1"),
		"back18" = new /image(src.icon, "t18"),
	)

	for (var/p in IconUnderlays)
		var/image/I = IconUnderlays[p]
		I.alpha = 200


/datum/hud/cyborg
	name = "BorgStyle"
	icon = 'icons/mob/screen1_robot.dmi'


	HUDoverlays = list(
		"flash" 		=  list("type" = /obj/screen/full_1_tile_overlay, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"blind" 		=  list("type" = /obj/screen/full_1_tile_overlay, "loc" = "WEST,SOUTH to EAST,NORTH", "icon_state" = "blank"),
		"glassesoverlay" = list("type" = /obj/screen/silicon/glasses_overlay, "loc" = "1,1", )
	)

	HUDneed = list(
		"cell"      = list("type" = /obj/screen/silicon/cell,     "loc" = "15,14"),
		"health"      = list("type" = /obj/screen/health/cyborg,     "loc" = "15,6"),
		"damage zone" = list("type" = /obj/screen/zone_sel,   "loc" = "15,1"),
		"pull"   = list("type" = /obj/screen/silicon/pull, "loc" = "12,1"),
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
