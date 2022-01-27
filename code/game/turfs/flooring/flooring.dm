var/list/floorin69_types

/proc/69et_floorin69_data(var/floorin69_path)
	if(!floorin69_types)
		floorin69_types = list()
		for(var/path in typesof(/decl/floorin69))
			floorin69_types69"69path69"69 = new path
	return floorin69_types69"69floorin69_path69"69

// State69alues:
// 69icon_base69: initial base icon_state without ed69es or corners.
// if has_base_ran69e is set, append 0-has_base_ran69e ie.
//   69icon_base6969has_base_ran69e69
// 69icon_base69_broken: dama69ed overlay.
// if has_dama69e_ran69e is set, append 0-dama69e_ran69e for state ie.
//   69icon_base69_broken69has_dama69e_ran69e69
// 69icon_base69_ed69es: directional overlays for ed69es.
// 69icon_base69_corners: directional overlays for non-ed69e corners.

/decl/floorin69
	var/name = "floor"
	var/desc
	var/icon
	var/icon_base

	var/footstep_sound = "floor"
	var/hit_sound = null
	var/footstep_type

	var/has_base_ran69e
	var/has_dama69e_ran69e
	var/has_burn_ran69e
	var/dama69e_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	var/build_type      // Unbuildable if not set.69ust be /obj/item/stack.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/fla69s = TURF_CAN_BURN | TURF_CAN_BREAK
	var/can_paint

	var/is_platin69 = FALSE

	//Platin69 types, can be overridden
	var/platin69_type = /decl/floorin69/reinforced/platin69

	//Resistance is subtracted from all incomin69 dama69e
	var/resistance = RESISTANCE_FRA69ILE

	//Dama69e the floor can take before bein69 destroyed
	var/health = 50

	var/removal_time = WORKTIME_FAST * 0.75

	//Floorin69 Icon69ars
	var/smooth_nothin69 = FALSE //True/false only, optimisation
	//If true, all smoothin69 lo69ic is entirely skipped

	//The rest of these x_smooth69ars use one of the followin69 options
	//SMOOTH_NONE: I69nore all of type
	//SMOOTH_ALL: Smooth with all of type
	//SMOOTH_WHITELIST: I69nore all except types on this list
	//SMOOTH_BLACKLIST: Smooth with all except types on this list
	//SMOOTH_69REYLIST: Objects only: Use both lists

	//How we smooth with other floorin69
	var/floor_smooth = SMOOTH_ALL
	var/list/floorin69_whitelist = list() //Smooth with nothin69 except the contents of this list
	var/list/floorin69_blacklist = list() //Smooth with everythin69 except the contents of this list

	//How we smooth with walls
	var/wall_smooth = SMOOTH_NONE
	//There are no lists for walls at this time

	//How we smooth with space and openspace tiles
	var/space_smooth = SMOOTH_ALL
	//There are no lists for spaces

	/*
	How we smooth with69ovable atoms
	These are checked after the above turf based smoothin69 has been handled
	SMOOTH_ALL or SMOOTH_NONE are treated the same here. Both of those will just i69nore atoms
	Usin69 the white/blacklists will override what the turfs concluded, to force or deny smoothin69

	Movable atom lists are69uch69ore complex, to account for69any possibilities
	Each entry in a list, is itself a list consistin69 of three items:
		Type: The typepath to allow/deny. This will be checked a69ainst istype, so all subtypes are included
		Priority: Used when items in two opposite lists conflict. The one with the hi69hest priority wins out.
		Vars: An associative list of69ariables (varnames in text) and desired69alues
			Code will look for the desired69ars on the tar69et item and only call it a69atch if all desired69alues69atch
			This can be used, for example, to check that objects are dense and anchored
			there are no safety checks on this, it will probably throw runtimes if you69ake typos

	Common example:
	Don't smooth with dense anchored objects except airlocks

	smooth_movable_atom = SMOOTH_69REYLIST
	movable_atom_blacklist = list(
		list(/obj, list("density" = TRUE, "anchored" = TRUE), 1)
		)
	movable_atom_whitelist = list(
	list(/obj/machinery/door/airlock, list(), 2)
	)

	*/
	var/smooth_movable_atom = SMOOTH_NONE
	var/list/movable_atom_whitelist = list()
	var/list/movable_atom_blacklist = list()

//Floorin69 Procs
/decl/floorin69/proc/69et_platin69_type(var/turf/location)
	return platin69_type

//Used to check if we can build the specified type of floor ontop of this one
/decl/floorin69/proc/can_build_floor(var/decl/floorin69/newfloor)
	return FALSE

//Used when someone attacks the floor
/decl/floorin69/proc/attackby(var/obj/item/I,69ar/mob/user,69ar/turf/T)
	return FALSE

/decl/floorin69/proc/Entered(mob/livin69/M as69ob)
	return

/decl/floorin69/69rass
	name = "69rass"
	desc = "Do they smoke 69rass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/floorin69/69rass.dmi'
	icon_base = "69rass"
	has_base_ran69e = 3
	dama69e_temperature = T0C+80
	fla69s = TURF_REMOVE_SHOVEL | TURF_ED69ES_EXTERNAL | TURF_HAS_CORNERS | TURF_HIDES_THIN69S
	build_type = /obj/item/stack/tile/69rass
	platin69_type = /decl/floorin69/dirt
	footstep_sound = "69rass"
	floor_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

/decl/floorin69/dirt
	name = "dirt"
	desc = "Do they smoke 69rass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/floorin69/dirt.dmi'
	icon_base = "dirt"
	fla69s = TURF_REMOVE_SHOVEL | TURF_HIDES_THIN69S
	build_type = null //Todo: add ba69s of fertilised soil or somethin69 to create dirt floors
	footstep_sound = "69ravel"

/decl/floorin69/asteroid
	name = "coarse sand"
	desc = "69ritty and unpleasant."
	icon = 'icons/turf/floorin69/asteroid.dmi'
	icon_base = "asteroid"
	fla69s = TURF_REMOVE_SHOVEL | TURF_CAN_BURN | TURF_CAN_BREAK
	build_type = null
	footstep_sound = "asteroid"

//=========PLATIN69==========\\

/decl/floorin69/reinforced/platin69
	name = "platin69"
	descriptor = "platin69"
	icon = 'icons/turf/floorin69/platin69.dmi'
	icon_base = "platin69"
	build_type = /obj/item/stack/material/steel
	fla69s = TURF_REMOVE_WELDER | TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_CAN_BURN | TURF_CAN_BREAK
	can_paint = 1
	platin69_type = /decl/floorin69/reinforced/platin69/under
	is_platin69 = TRUE
	footstep_sound = "platin69"
	space_smooth = FALSE
	removal_time = 150
	health = 100
	has_base_ran69e = 18
	floor_smooth = SMOOTH_BLACKLIST
	floorin69_blacklist = list(/decl/floorin69/reinforced/platin69/under,/decl/floorin69/reinforced/platin69/hull) //Smooth with everythin69 except the contents of this list
	smooth_movable_atom = SMOOTH_69REYLIST
	movable_atom_blacklist = list(
		list(/obj, list("density" = TRUE, "anchored" = TRUE), 1)
		)
	movable_atom_whitelist = list(list(/obj/machinery/door/airlock, list(), 2))

//Normal platin69 allows anythin69, except other types of platin69
/decl/floorin69/reinforced/platin69/can_build_floor(var/decl/floorin69/newfloor)
	if (istype(newfloor, /decl/floorin69/reinforced/platin69))
		return FALSE
	return TRUE

/decl/floorin69/reinforced/platin69/69et_platin69_type(var/turf/location)
	if (turf_is_upper_hull(location))
		return null
	return platin69_type

//==========UNDERPLATIN69==============\\

/decl/floorin69/reinforced/platin69/under
	name = "underplatin69"
	icon = 'icons/turf/floorin69/platin69.dmi'
	descriptor = "support beams"
	icon_base = "under"
	build_type = /obj/item/stack/material/steel //Same type as the normal platin69, we'll use can_build_floor to control it
	fla69s = TURF_REMOVE_WRENCH | TURF_CAN_BURN | TURF_CAN_BREAK | TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS
	can_paint = 1
	platin69_type = /decl/floorin69/reinforced/platin69/hull
	is_platin69 = TRUE
	removal_time = 250
	health = 200
	has_base_ran69e = 0
	resistance = RESISTANCE_ARMOURED
	footstep_sound = "catwalk"
	space_smooth = SMOOTH_ALL
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

//Underplatin69 can only be up69raded to normal platin69
/decl/floorin69/reinforced/platin69/under/can_build_floor(var/decl/floorin69/newfloor)
	if (newfloor.type == /decl/floorin69/reinforced/platin69)
		return TRUE
	return FALSE

/decl/floorin69/reinforced/platin69/under/attackby(var/obj/item/I,69ar/mob/user,69ar/turf/T)
	if (istype(I, /obj/item/stack/rods))
		.=TRUE
		var/obj/item/stack/rods/R = I
		if(R.amount <= 3)
			return
		else
			R.use(3)
			to_chat(user, SPAN_NOTICE("You start connectin69 69R.name69s to 69src.name69, creatin69 catwalk ..."))
			if(do_after(user,60))
				T.alpha = 0
				var/obj/structure/catwalk/CT = new /obj/structure/catwalk(T)
				T.contents += CT

/decl/floorin69/reinforced/platin69/under/69et_platin69_type(turf/location)
	if (turf_is_lower_hull(location)) //Hull platin69 is only on the lowest level of the ship
		return platin69_type
	else if (turf_is_upper_hull(location))
		return /decl/floorin69/reinforced/platin69
	else return null

/decl/floorin69/reinforced/platin69/under/69et_platin69_type(turf/location)
	if (turf_is_lower_hull(location)) //Hull platin69 is only on the lowest level of the ship
		return platin69_type
	else if (turf_is_upper_hull(location))
		return /decl/floorin69/reinforced/platin69
	else return null

/decl/floorin69/reinforced/platin69/under/Entered(mob/livin69/M)
	for(var/obj/structure/catwalk/C in 69et_turf(M))
		return

	//BSTs need this or they 69enerate tons of soundspam while flyin69 throu69h the ship
	if(!ishuman(M)||69.incorporeal_move || !has_69ravity(69et_turf(M)))
		return
	var/mob/livin69/carbon/human/our_trippah =69
	if(MOVIN69_69UICKLY(M))
		if(prob(50 - our_trippah.stats.69etStat(STAT_CO69) * 2)) // The art of calculatin69 the69ectors re69uired to avoid trippin69 on the69etal beams re69uires bi69 69uantities of brain power
			our_trippah.adjustBruteLoss(5)
			our_trippah.trip(src, 6)
			return

//============HULL PLATIN69=========\\

/decl/floorin69/reinforced/platin69/hull
	name = "hull"
	descriptor = "outer hull"
	icon = 'icons/turf/floorin69/hull.dmi'
	icon_base = "hullcenter"
	fla69s = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_WELDER | TURF_CAN_BURN | TURF_CAN_BREAK
	build_type = /obj/item/stack/material/plasteel
	has_base_ran69e = 35
	//try_update_icon = 0
	platin69_type = null
	is_platin69 = TRUE
	health = 350
	resistance = RESISTANCE_HEAVILY_ARMOURED
	removal_time = 169INUTES //Cuttin69 throu69h the hull is69ery slow work
	footstep_sound = "hull"
	wall_smooth = SMOOTH_ALL
	space_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

//Hull can up69rade to underplatin69
/decl/floorin69/reinforced/platin69/hull/can_build_floor(var/decl/floorin69/newfloor)
	return FALSE //Not allowed to build directly on hull, you69ust first remove it and then build on the underplatin69

/decl/floorin69/reinforced/platin69/hull/69et_platin69_type(var/turf/location)
	if (turf_is_lower_hull(location)) //Hull platin69 is only on the lowest level of the ship
		return null
	else if (turf_is_upper_hull(location))
		return /decl/floorin69/reinforced/platin69/under
	else
		return null //This should never happen, hull platin69 should only be on the exterior

//==========CARPET==============\\

/decl/floorin69/carpet
	name = "red carpet"
	desc = "Imported and comfy."
	icon = 'icons/turf/floorin69/carpet.dmi'
	icon_base = "carpet"
	footstep_sound = "carpet"
	build_type = /obj/item/stack/tile/carpet
	dama69e_temperature = T0C+200
	fla69s = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN | TURF_HIDES_THIN69S
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

/decl/floorin69/carpet/bcarpet
	name = "black carpet"
	icon_base = "bcarpet"
	build_type = /obj/item/stack/tile/carpet/bcarpet

/decl/floorin69/carpet/blucarpet
	name = "blue carpet"
	icon_base = "blucarpet"
	build_type = /obj/item/stack/tile/carpet/blucarpet

/decl/floorin69/carpet/turcarpet
	name = "tur69uoise carpet"
	icon_base = "turcarpet"
	build_type = /obj/item/stack/tile/carpet/turcarpet

/decl/floorin69/carpet/sblucarpet
	name = "silver blue carpet"
	icon_base = "sblucarpet"
	build_type = /obj/item/stack/tile/carpet/sblucarpet

/decl/floorin69/carpet/69aycarpet
	name = "clown carpet"
	icon_base = "69aycarpet"
	build_type = /obj/item/stack/tile/carpet/69aycarpet

/decl/floorin69/carpet/purcarpet
	name = "purple carpet"
	icon_base = "purcarpet"
	build_type = /obj/item/stack/tile/carpet/purcarpet

/decl/floorin69/carpet/oracarpet
	name = "oran69e carpet"
	icon_base = "oracarpet"
	build_type = /obj/item/stack/tile/carpet/oracarpet

//==========TILIN69==============\\

/decl/floorin69/tilin69
	name = "floor"
	desc = "Scuffed from the passa69e of countless 69reyshirts."
	icon = 'icons/turf/floorin69/tiles.dmi'
	icon_base = "tiles"
	has_dama69e_ran69e = 2 //RECHECK THIS.69AYBE69ISTAKE
	dama69e_temperature = T0C+1400
	fla69s = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN | TURF_HIDES_THIN69S
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	resistance = RESISTANCE_FRA69ILE

	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

/decl/floorin69/tilin69/steel
	name = "floor"
	icon_base = "tiles"
	icon = 'icons/turf/floorin69/tiles_steel.dmi'
	build_type = /obj/item/stack/tile/floor/steel
	footstep_sound = "floor"

/decl/floorin69/tilin69/steel/panels
	icon_base = "panels"
	build_type = /obj/item/stack/tile/floor/steel/panels

/decl/floorin69/tilin69/steel/techfloor
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/floor/steel/techfloor

/decl/floorin69/tilin69/steel/techfloor_69rid
	icon_base = "techfloor_69rid"
	build_type = /obj/item/stack/tile/floor/steel/techfloor_69rid

/decl/floorin69/tilin69/steel/brown_perforated
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/steel/brown_perforated

/decl/floorin69/tilin69/steel/69ray_perforated
	icon_base = "69ray_perforated"
	build_type = /obj/item/stack/tile/floor/steel/69ray_perforated

/decl/floorin69/tilin69/steel/car69o
	icon_base = "car69o"
	build_type = /obj/item/stack/tile/floor/steel/car69o

/decl/floorin69/tilin69/steel/brown_platform
	icon_base = "brown_platform"
	build_type = /obj/item/stack/tile/floor/steel/brown_platform

/decl/floorin69/tilin69/steel/69ray_platform
	icon_base = "69ray_platform"
	build_type = /obj/item/stack/tile/floor/steel/69ray_platform

/decl/floorin69/tilin69/steel/dan69er
	icon_base = "dan69er"
	build_type = /obj/item/stack/tile/floor/steel/dan69er

/decl/floorin69/tilin69/steel/69olden
	icon_base = "69olden"
	build_type = /obj/item/stack/tile/floor/steel/69olden

/decl/floorin69/tilin69/steel/bluecorner
	icon_base = "bluecorner"
	build_type = /obj/item/stack/tile/floor/steel/bluecorner

/decl/floorin69/tilin69/steel/oran69ecorner
	icon_base = "oran69ecorner"
	build_type = /obj/item/stack/tile/floor/steel/oran69ecorner

/decl/floorin69/tilin69/steel/cyancorner
	icon_base = "cyancorner"
	build_type = /obj/item/stack/tile/floor/steel/cyancorner

/decl/floorin69/tilin69/steel/violetcorener
	icon_base = "violetcorener"
	build_type = /obj/item/stack/tile/floor/steel/violetcorener

/decl/floorin69/tilin69/steel/monofloor
	icon_base = "monofloor"
	build_type = /obj/item/stack/tile/floor/steel/monofloor
	has_base_ran69e = 15

/decl/floorin69/tilin69/steel/bar_flat
	icon_base = "bar_flat"
	build_type = /obj/item/stack/tile/floor/steel/bar_flat

/decl/floorin69/tilin69/steel/bar_dance
	icon_base = "bar_dance"
	build_type = /obj/item/stack/tile/floor/steel/bar_dance

/decl/floorin69/tilin69/steel/bar_li69ht
	icon_base = "bar_li69ht"
	build_type = /obj/item/stack/tile/floor/steel/bar_li69ht

/decl/floorin69/tilin69/white
	name = "floor"
	icon_base = "tiles"
	icon = 'icons/turf/floorin69/tiles_white.dmi'
	build_type = /obj/item/stack/tile/floor/white
	footstep_sound = "tile" //those are69ade from plastic, so they sound different

/decl/floorin69/tilin69/white/panels
	icon_base = "panels"
	build_type = /obj/item/stack/tile/floor/white/panels

/decl/floorin69/tilin69/white/techfloor
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/floor/white/techfloor

/decl/floorin69/tilin69/white/techfloor_69rid
	icon_base = "techfloor_69rid"
	build_type = /obj/item/stack/tile/floor/white/techfloor_69rid

/decl/floorin69/tilin69/white/brown_perforated
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/white/brown_perforated

/decl/floorin69/tilin69/white/69ray_perforated
	icon_base = "69ray_perforated"
	build_type = /obj/item/stack/tile/floor/white/69ray_perforated

/decl/floorin69/tilin69/white/car69o
	icon_base = "car69o"
	build_type = /obj/item/stack/tile/floor/white/car69o

/decl/floorin69/tilin69/white/brown_platform
	icon_base = "brown_platform"
	build_type = /obj/item/stack/tile/floor/white/brown_platform

/decl/floorin69/tilin69/white/69ray_platform
	icon_base = "69ray_platform"
	build_type = /obj/item/stack/tile/floor/white/69ray_platform

/decl/floorin69/tilin69/white/dan69er
	icon_base = "dan69er"
	build_type = /obj/item/stack/tile/floor/white/dan69er

/decl/floorin69/tilin69/white/69olden
	icon_base = "69olden"
	build_type = /obj/item/stack/tile/floor/white/69olden

/decl/floorin69/tilin69/white/bluecorner
	icon_base = "bluecorner"
	build_type = /obj/item/stack/tile/floor/white/bluecorner

/decl/floorin69/tilin69/white/oran69ecorner
	icon_base = "oran69ecorner"
	build_type = /obj/item/stack/tile/floor/white/oran69ecorner

/decl/floorin69/tilin69/white/cyancorner
	icon_base = "cyancorner"
	build_type = /obj/item/stack/tile/floor/white/cyancorner

/decl/floorin69/tilin69/white/violetcorener
	icon_base = "violetcorener"
	build_type = /obj/item/stack/tile/floor/white/violetcorener

/decl/floorin69/tilin69/white/monofloor
	icon_base = "monofloor"
	build_type = /obj/item/stack/tile/floor/white/monofloor
	has_base_ran69e = 15

/decl/floorin69/tilin69/dark
	name = "floor"
	icon_base = "tiles"
	icon = 'icons/turf/floorin69/tiles_dark.dmi'
	build_type = /obj/item/stack/tile/floor/dark
	footstep_sound = "floor"

/decl/floorin69/tilin69/dark/panels
	icon_base = "panels"
	build_type = /obj/item/stack/tile/floor/dark/panels

/decl/floorin69/tilin69/dark/techfloor
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/floor/dark/techfloor

/decl/floorin69/tilin69/dark/techfloor_69rid
	icon_base = "techfloor_69rid"
	build_type = /obj/item/stack/tile/floor/dark/techfloor_69rid

/decl/floorin69/tilin69/dark/brown_perforated
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/dark/brown_perforated

/decl/floorin69/tilin69/dark/69ray_perforated
	icon_base = "69ray_perforated"
	build_type = /obj/item/stack/tile/floor/dark/69ray_perforated

/decl/floorin69/tilin69/dark/car69o
	icon_base = "car69o"
	build_type = /obj/item/stack/tile/floor/dark/car69o

/decl/floorin69/tilin69/dark/brown_platform
	icon_base = "brown_platform"
	build_type = /obj/item/stack/tile/floor/dark/brown_platform

/decl/floorin69/tilin69/dark/69ray_platform
	icon_base = "69ray_platform"
	build_type = /obj/item/stack/tile/floor/dark/69ray_platform

/decl/floorin69/tilin69/dark/dan69er
	icon_base = "dan69er"
	build_type = /obj/item/stack/tile/floor/dark/dan69er

/decl/floorin69/tilin69/dark/69olden
	icon_base = "69olden"
	build_type = /obj/item/stack/tile/floor/dark/69olden

/decl/floorin69/tilin69/dark/bluecorner
	icon_base = "bluecorner"
	build_type = /obj/item/stack/tile/floor/dark/bluecorner

/decl/floorin69/tilin69/dark/oran69ecorner
	icon_base = "oran69ecorner"
	build_type = /obj/item/stack/tile/floor/dark/oran69ecorner

/decl/floorin69/tilin69/dark/cyancorner
	icon_base = "cyancorner"
	build_type = /obj/item/stack/tile/floor/dark/cyancorner

/decl/floorin69/tilin69/dark/violetcorener
	icon_base = "violetcorener"
	build_type = /obj/item/stack/tile/floor/dark/violetcorener

/decl/floorin69/tilin69/dark/monofloor
	icon_base = "monofloor"
	build_type = /obj/item/stack/tile/floor/dark/monofloor
	has_base_ran69e = 15

/decl/floorin69/tilin69/cafe
	name = "floor"
	icon_base = "cafe"
	icon = 'icons/turf/floorin69/tiles.dmi'
	build_type = /obj/item/stack/tile/floor/cafe
	footstep_sound = "floor"

/decl/floorin69/tilin69/techmaint
	name = "floor"
	icon_base = "techmaint"
	icon = 'icons/turf/floorin69/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/techmaint
	footstep_sound = "floor"

	floor_smooth = SMOOTH_WHITELIST
	floorin69_whitelist = list(/decl/floorin69/tilin69/techmaint_perforated, /decl/floorin69/tilin69/techmaint_panels)

/decl/floorin69/tilin69/techmaint_perforated
	name = "floor"
	icon_base = "techmaint_perforated"
	icon = 'icons/turf/floorin69/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/techmaint/perforated
	footstep_sound = "floor"

	floor_smooth = SMOOTH_WHITELIST
	floorin69_whitelist = list(/decl/floorin69/tilin69/techmaint, /decl/floorin69/tilin69/techmaint_panels)

/decl/floorin69/tilin69/techmaint_panels
	name = "floor"
	icon_base = "techmaint_panels"
	icon = 'icons/turf/floorin69/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/techmaint/panels
	footstep_sound = "floor"

	floor_smooth = SMOOTH_WHITELIST
	floorin69_whitelist = list(/decl/floorin69/tilin69/techmaint_perforated, /decl/floorin69/tilin69/techmaint)

/decl/floorin69/tilin69/techmaint_car69o
	name = "floor"
	icon_base = "techmaint_car69o"
	icon = 'icons/turf/floorin69/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/techmaint/car69o
	footstep_sound = "floor"

//==========MISC==============\\

/decl/floorin69/wood
	name = "wooden floor"
	desc = "Polished redwood planks."
	footstep_sound = "wood"
	icon = 'icons/turf/floorin69/wood.dmi'
	icon_base = "wood"
	has_dama69e_ran69e = 6
	dama69e_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	smooth_nothin69 = TRUE
	fla69s = TURF_CAN_BREAK | TURF_CAN_BURN | TURF_IS_FRA69ILE | TURF_REMOVE_SCREWDRIVER | TURF_HIDES_THIN69S

/decl/floorin69/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with steel rods."
	icon = 'icons/turf/floorin69/tiles.dmi'
	icon_base = "reinforced"
	fla69s = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE | TURF_CAN_BURN | TURF_CAN_BREAK | TURF_HIDES_THIN69S |TURF_HIDES_THIN69S
	build_type = /obj/item/stack/rods
	build_cost = 2
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = 1
	resistance = RESISTANCE_TOU69H
	footstep_sound = "platin69"

/decl/floorin69/reinforced/circuit
	name = "processin69 strata"
	icon = 'icons/turf/floorin69/circuit.dmi'
	icon_base = "bcircuit"
	build_type = null
	fla69s = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS |TURF_HIDES_THIN69S
	can_paint = 1

	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

/decl/floorin69/reinforced/circuit/69reen
	name = "processin69 strata"
	icon_base = "69circuit"

/decl/floorin69/reinforced/cult
	name = "en69raved floor"
	desc = "Unsettlin69 whispers waver from the surface..."
	icon = 'icons/turf/floorin69/cult.dmi'
	icon_base = "cult"
	build_type = null
	has_dama69e_ran69e = 6
	fla69s = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_HIDES_THIN69S
	can_paint = null

//==========Derelict==============\\

/decl/floorin69/tilin69/derelict
	name = "floor"
	icon_base = "derelict1"
	icon = 'icons/turf/floorin69/derelict.dmi'
	footstep_sound = "floor"

/decl/floorin69/tilin69/derelict/white_red_ed69es
	name = "floor"
	icon_base = "derelict1"
	build_type = /obj/item/stack/tile/derelict/white_red_ed69es

/decl/floorin69/tilin69/derelict/white_small_ed69es
	name = "floor"
	icon_base = "derelict2"
	build_type = /obj/item/stack/tile/derelict/white_small_ed69es

/decl/floorin69/tilin69/derelict/red_white_ed69es
	name = "floor"
	icon_base = "derelict3"
	build_type = /obj/item/stack/tile/derelict/red_white_ed69es

/decl/floorin69/tilin69/derelict/white_bi69_ed69es
	name = "floor"
	icon_base = "derelict4"
	build_type = /obj/item/stack/tile/derelict/white_bi69_ed69es
