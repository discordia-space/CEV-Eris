var/list/flooring_types

/proc/get_flooring_data(var/flooring_path)
	if(!flooring_types)
		flooring_types = list()
		for(var/path in typesof(/decl/flooring))
			flooring_types["[path]"] = new path
	return flooring_types["[flooring_path]"]

// State values:
// [icon_base]: initial base icon_state without edges or corners.
// if has_base_range is set, append 0-has_base_range ie.
//   [icon_base][has_base_range]
// [icon_base]_broken: damaged overlay.
// if has_damage_range is set, append 0-damage_range for state ie.
//   [icon_base]_broken[has_damage_range]
// [icon_base]_edges: directional overlays for edges.
// [icon_base]_corners: directional overlays for non-edge corners.

/decl/flooring
	var/name = "floor"
	var/desc
	var/icon
	var/icon_base

	var/footstep_sound = "floor"
	var/hit_sound = null
	var/footstep_type

	var/has_base_range
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	var/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/flags = TURF_CAN_BURN | TURF_CAN_BREAK
	var/can_paint

	var/is_plating = FALSE

	//Plating types, can be overridden
	var/plating_type = /decl/flooring/reinforced/plating

	//Resistance is subtracted from all incoming damage
	var/resistance = RESISTANCE_FRAGILE

	//Damage the floor can take before being destroyed
	var/health = 50

	var/removal_time = WORKTIME_FAST * 0.75

	//Flooring Icon vars
	var/smooth_nothing = FALSE //True/false only, optimisation
	//If true, all smoothing logic is entirely skipped

	//The rest of these x_smooth vars use one of the following options
	//SMOOTH_NONE: Ignore all of type
	//SMOOTH_ALL: Smooth with all of type
	//SMOOTH_WHITELIST: Ignore all except types on this list
	//SMOOTH_BLACKLIST: Smooth with all except types on this list
	//SMOOTH_GREYLIST: Objects only: Use both lists

	//How we smooth with other flooring
	var/floor_smooth = SMOOTH_ALL
	var/list/flooring_whitelist = list() //Smooth with nothing except the contents of this list
	var/list/flooring_blacklist = list() //Smooth with everything except the contents of this list

	//How we smooth with walls
	var/wall_smooth = SMOOTH_NONE
	//There are no lists for walls at this time

	//How we smooth with space and openspace tiles
	var/space_smooth = SMOOTH_ALL
	//There are no lists for spaces

	/*
	How we smooth with movable atoms
	These are checked after the above turf based smoothing has been handled
	SMOOTH_ALL or SMOOTH_NONE are treated the same here. Both of those will just ignore atoms
	Using the white/blacklists will override what the turfs concluded, to force or deny smoothing

	Movable atom lists are much more complex, to account for many possibilities
	Each entry in a list, is itself a list consisting of three items:
		Type: The typepath to allow/deny. This will be checked against istype, so all subtypes are included
		Priority: Used when items in two opposite lists conflict. The one with the highest priority wins out.
		Vars: An associative list of variables (varnames in text) and desired values
			Code will look for the desired vars on the target item and only call it a match if all desired values match
			This can be used, for example, to check that objects are dense and anchored
			there are no safety checks on this, it will probably throw runtimes if you make typos

	Common example:
	Don't smooth with dense anchored objects except airlocks

	smooth_movable_atom = SMOOTH_GREYLIST
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

//Flooring Procs
/decl/flooring/proc/get_plating_type(var/turf/location)
	return plating_type

//Used to check if we can build the specified type of floor ontop of this one
/decl/flooring/proc/can_build_floor(var/decl/flooring/newfloor)
	return FALSE

//Used when someone attacks the floor
/decl/flooring/proc/attackby(var/obj/item/I, var/mob/user, var/turf/T)
	return FALSE

/decl/flooring/proc/Entered(mob/living/M as mob)
	return

/decl/flooring/grass
	name = "grass"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "grass"
	has_base_range = 3
	damage_temperature = T0C+80
	flags = TURF_REMOVE_SHOVEL | TURF_EDGES_EXTERNAL | TURF_HAS_CORNERS | TURF_HIDES_THINGS
	build_type = /obj/item/stack/tile/grass
	plating_type = /decl/flooring/dirt
	footstep_sound = "grass"
	floor_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

/decl/flooring/dirt
	name = "dirt"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/flooring/dirt.dmi'
	icon_base = "dirt"
	flags = TURF_REMOVE_SHOVEL | TURF_HIDES_THINGS
	build_type = null //Todo: add bags of fertilised soil or something to create dirt floors
	footstep_sound = "gravel"

/decl/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	flags = TURF_REMOVE_SHOVEL | TURF_CAN_BURN | TURF_CAN_BREAK
	build_type = null
	footstep_sound = "asteroid"

//=========PLATING==========\\

/decl/flooring/reinforced/plating
	name = "plating"
	descriptor = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_base = "plating"
	build_type = /obj/item/stack/material/steel
	flags = TURF_REMOVE_WELDER | TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_CAN_BURN | TURF_CAN_BREAK
	can_paint = 1
	plating_type = /decl/flooring/reinforced/plating/under
	is_plating = TRUE
	footstep_sound = "plating"
	space_smooth = FALSE
	removal_time = 150
	health = 200
	has_base_range = 18
	floor_smooth = SMOOTH_BLACKLIST
	flooring_blacklist = list(/decl/flooring/reinforced/plating/under,/decl/flooring/reinforced/plating/hull) //Smooth with everything except the contents of this list
	smooth_movable_atom = SMOOTH_GREYLIST
	movable_atom_blacklist = list(
		list(/obj, list("density" = TRUE, "anchored" = TRUE), 1)
		)
	movable_atom_whitelist = list(list(/obj/machinery/door/airlock, list(), 2))

//Normal plating allows anything, except other types of plating
/decl/flooring/reinforced/plating/can_build_floor(var/decl/flooring/newfloor)
	if (istype(newfloor, /decl/flooring/reinforced/plating))
		return FALSE
	return TRUE

/decl/flooring/reinforced/plating/get_plating_type(var/turf/location)
	if (turf_is_upper_hull(location))
		return null
	return plating_type

//==========UNDERPLATING==============\\

/decl/flooring/reinforced/plating/under
	name = "underplating"
	icon = 'icons/turf/flooring/plating.dmi'
	descriptor = "support beams"
	icon_base = "under"
	build_type = /obj/item/stack/material/steel //Same type as the normal plating, we'll use can_build_floor to control it
	flags = TURF_REMOVE_WRENCH | TURF_CAN_BURN | TURF_CAN_BREAK | TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS
	can_paint = 1
	plating_type = /decl/flooring/reinforced/plating/hull
	is_plating = TRUE
	removal_time = 250
	health = 500
	has_base_range = 0
	resistance = RESISTANCE_ARMOURED
	footstep_sound = "catwalk"
	space_smooth = SMOOTH_ALL
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

//Underplating can only be upgraded to normal plating
/decl/flooring/reinforced/plating/under/can_build_floor(var/decl/flooring/newfloor)
	if (newfloor.type == /decl/flooring/reinforced/plating)
		return TRUE
	return FALSE

/decl/flooring/reinforced/plating/under/attackby(var/obj/item/I, var/mob/user, var/turf/T)
	if (istype(I, /obj/item/stack/rods))
		.=TRUE
		var/obj/item/stack/rods/R = I
		if(R.amount <= 2)
			return
		else
			R.use(2)
			to_chat(user, SPAN_NOTICE("You start connecting [R.name]s to [src.name], creating catwalk..."))
			if(do_after(user, (20 * user.stats.getMult(STAT_MEC, STAT_LEVEL_EXPERT))))
				T.alpha = 0
				var/obj/structure/catwalk/CT = new /obj/structure/catwalk(T)
				T.contents += CT

/decl/flooring/reinforced/plating/under/get_plating_type(turf/location)
	if (turf_is_lower_hull(location)) //Hull plating is only on the lowest level of the ship
		return plating_type
	else if (turf_is_upper_hull(location))
		return /decl/flooring/reinforced/plating
	else return null

/decl/flooring/reinforced/plating/under/get_plating_type(turf/location)
	if (turf_is_lower_hull(location)) //Hull plating is only on the lowest level of the ship
		return plating_type
	else if (turf_is_upper_hull(location))
		return /decl/flooring/reinforced/plating
	else return null

/decl/flooring/reinforced/plating/under/Entered(mob/living/M)
	for(var/obj/structure/catwalk/C in get_turf(M))
		return

	//BSTs need this or they generate tons of soundspam while flying through the ship
	if(!ishuman(M)|| M.incorporeal_move || !has_gravity(get_turf(M)))
		return
	if(MOVING_QUICKLY(M))
		if(prob(5) && M.slip(null, 6))
			M.adjustBruteLoss(5)
			playsound(M, 'sound/effects/bang.ogg', 50, 1)
			to_chat(M, SPAN_WARNING("You tripped over!"))
			return

//============HULL PLATING=========\\

/decl/flooring/reinforced/plating/hull
	name = "hull"
	descriptor = "outer hull"
	icon = 'icons/turf/flooring/hull.dmi'
	icon_base = "hullcenter"
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_WELDER | TURF_CAN_BURN | TURF_CAN_BREAK
	build_type = /obj/item/stack/material/plasteel
	has_base_range = 35
	//try_update_icon = 0
	plating_type = null
	is_plating = TRUE
	health = 1200
	resistance = RESISTANCE_HEAVILY_ARMOURED
	removal_time = 1 MINUTES //Cutting through the hull is very slow work
	footstep_sound = "hull"
	wall_smooth = SMOOTH_ALL
	space_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

//Hull can downgrade to underplating
/decl/flooring/reinforced/plating/hull/can_build_floor(var/decl/flooring/newfloor)
	return FALSE //Not allowed to build directly on hull, you must first remove it and then build on the underplating

/decl/flooring/reinforced/plating/hull/get_plating_type(var/turf/location)
	if (turf_is_lower_hull(location)) //Hull plating is only on the lowest level of the ship
		return null
	else if (turf_is_upper_hull(location))
		return /decl/flooring/reinforced/plating/under
	else
		return null //This should never happen, hull plating should only be on the exterior

//==========CARPET==============\\

/decl/flooring/carpet
	name = "red carpet"
	desc = "Imported and comfy."
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_base = "carpet"
	footstep_sound = "carpet"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN | TURF_HIDES_THINGS
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

/decl/flooring/carpet/bcarpet
	name = "black carpet"
	icon_base = "bcarpet"
	build_type = /obj/item/stack/tile/carpet/bcarpet

/decl/flooring/carpet/blucarpet
	name = "blue carpet"
	icon_base = "blucarpet"
	build_type = /obj/item/stack/tile/carpet/blucarpet

/decl/flooring/carpet/turcarpet
	name = "turquoise carpet"
	icon_base = "turcarpet"
	build_type = /obj/item/stack/tile/carpet/turcarpet

/decl/flooring/carpet/sblucarpet
	name = "silver blue carpet"
	icon_base = "sblucarpet"
	build_type = /obj/item/stack/tile/carpet/sblucarpet

/decl/flooring/carpet/gaycarpet
	name = "clown carpet"
	icon_base = "gaycarpet"
	build_type = /obj/item/stack/tile/carpet/gaycarpet

/decl/flooring/carpet/purcarpet
	name = "purple carpet"
	icon_base = "purcarpet"
	build_type = /obj/item/stack/tile/carpet/purcarpet

/decl/flooring/carpet/oracarpet
	name = "orange carpet"
	icon_base = "oracarpet"
	build_type = /obj/item/stack/tile/carpet/oracarpet

//==========TILING==============\\

/decl/flooring/tiling
	name = "floor"
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "tiles"
	has_damage_range = 2 //RECHECK THIS. MAYBE MISTAKE
	damage_temperature = T0C+1400
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN | TURF_HIDES_THINGS
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	health = 100
	resistance = RESISTANCE_FRAGILE

	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

/decl/flooring/tiling/steel
	name = "floor"
	icon_base = "tiles"
	icon = 'icons/turf/flooring/tiles_steel.dmi'
	build_type = /obj/item/stack/tile/floor/steel
	footstep_sound = "floor"

/decl/flooring/tiling/steel/panels
	icon_base = "panels"
	build_type = /obj/item/stack/tile/floor/steel/panels

/decl/flooring/tiling/steel/techfloor
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/floor/steel/techfloor

/decl/flooring/tiling/steel/techfloor_grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/steel/techfloor_grid

/decl/flooring/tiling/steel/brown_perforated
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/steel/brown_perforated

/decl/flooring/tiling/steel/gray_perforated
	icon_base = "gray_perforated"
	build_type = /obj/item/stack/tile/floor/steel/gray_perforated

/decl/flooring/tiling/steel/cargo
	icon_base = "cargo"
	build_type = /obj/item/stack/tile/floor/steel/cargo

/decl/flooring/tiling/steel/brown_platform
	icon_base = "brown_platform"
	build_type = /obj/item/stack/tile/floor/steel/brown_platform

/decl/flooring/tiling/steel/gray_platform
	icon_base = "gray_platform"
	build_type = /obj/item/stack/tile/floor/steel/gray_platform

/decl/flooring/tiling/steel/danger
	icon_base = "danger"
	build_type = /obj/item/stack/tile/floor/steel/danger

/decl/flooring/tiling/steel/golden
	icon_base = "golden"
	build_type = /obj/item/stack/tile/floor/steel/golden

/decl/flooring/tiling/steel/bluecorner
	icon_base = "bluecorner"
	build_type = /obj/item/stack/tile/floor/steel/bluecorner

/decl/flooring/tiling/steel/orangecorner
	icon_base = "orangecorner"
	build_type = /obj/item/stack/tile/floor/steel/orangecorner

/decl/flooring/tiling/steel/cyancorner
	icon_base = "cyancorner"
	build_type = /obj/item/stack/tile/floor/steel/cyancorner

/decl/flooring/tiling/steel/violetcorener
	icon_base = "violetcorener"
	build_type = /obj/item/stack/tile/floor/steel/violetcorener

/decl/flooring/tiling/steel/monofloor
	icon_base = "monofloor"
	build_type = /obj/item/stack/tile/floor/steel/monofloor
	has_base_range = 15

/decl/flooring/tiling/steel/bar_flat
	icon_base = "bar_flat"
	build_type = /obj/item/stack/tile/floor/steel/bar_flat

/decl/flooring/tiling/steel/bar_dance
	icon_base = "bar_dance"
	build_type = /obj/item/stack/tile/floor/steel/bar_dance

/decl/flooring/tiling/steel/bar_light
	icon_base = "bar_light"
	build_type = /obj/item/stack/tile/floor/steel/bar_light

/decl/flooring/tiling/white
	name = "floor"
	icon_base = "tiles"
	icon = 'icons/turf/flooring/tiles_white.dmi'
	build_type = /obj/item/stack/tile/floor/white
	footstep_sound = "tile" //those are made from plastic, so they sound different

/decl/flooring/tiling/white/panels
	icon_base = "panels"
	build_type = /obj/item/stack/tile/floor/white/panels

/decl/flooring/tiling/white/techfloor
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/floor/white/techfloor

/decl/flooring/tiling/white/techfloor_grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/white/techfloor_grid

/decl/flooring/tiling/white/brown_perforated
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/white/brown_perforated

/decl/flooring/tiling/white/gray_perforated
	icon_base = "gray_perforated"
	build_type = /obj/item/stack/tile/floor/white/gray_perforated

/decl/flooring/tiling/white/cargo
	icon_base = "cargo"
	build_type = /obj/item/stack/tile/floor/white/cargo

/decl/flooring/tiling/white/brown_platform
	icon_base = "brown_platform"
	build_type = /obj/item/stack/tile/floor/white/brown_platform

/decl/flooring/tiling/white/gray_platform
	icon_base = "gray_platform"
	build_type = /obj/item/stack/tile/floor/white/gray_platform

/decl/flooring/tiling/white/danger
	icon_base = "danger"
	build_type = /obj/item/stack/tile/floor/white/danger

/decl/flooring/tiling/white/golden
	icon_base = "golden"
	build_type = /obj/item/stack/tile/floor/white/golden

/decl/flooring/tiling/white/bluecorner
	icon_base = "bluecorner"
	build_type = /obj/item/stack/tile/floor/white/bluecorner

/decl/flooring/tiling/white/orangecorner
	icon_base = "orangecorner"
	build_type = /obj/item/stack/tile/floor/white/orangecorner

/decl/flooring/tiling/white/cyancorner
	icon_base = "cyancorner"
	build_type = /obj/item/stack/tile/floor/white/cyancorner

/decl/flooring/tiling/white/violetcorener
	icon_base = "violetcorener"
	build_type = /obj/item/stack/tile/floor/white/violetcorener

/decl/flooring/tiling/white/monofloor
	icon_base = "monofloor"
	build_type = /obj/item/stack/tile/floor/white/monofloor
	has_base_range = 15

/decl/flooring/tiling/dark
	name = "floor"
	icon_base = "tiles"
	icon = 'icons/turf/flooring/tiles_dark.dmi'
	build_type = /obj/item/stack/tile/floor/dark
	footstep_sound = "floor"

/decl/flooring/tiling/dark/panels
	icon_base = "panels"
	build_type = /obj/item/stack/tile/floor/dark/panels

/decl/flooring/tiling/dark/techfloor
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/floor/dark/techfloor

/decl/flooring/tiling/dark/techfloor_grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/dark/techfloor_grid

/decl/flooring/tiling/dark/brown_perforated
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/dark/brown_perforated

/decl/flooring/tiling/dark/gray_perforated
	icon_base = "gray_perforated"
	build_type = /obj/item/stack/tile/floor/dark/gray_perforated

/decl/flooring/tiling/dark/cargo
	icon_base = "cargo"
	build_type = /obj/item/stack/tile/floor/dark/cargo

/decl/flooring/tiling/dark/brown_platform
	icon_base = "brown_platform"
	build_type = /obj/item/stack/tile/floor/dark/brown_platform

/decl/flooring/tiling/dark/gray_platform
	icon_base = "gray_platform"
	build_type = /obj/item/stack/tile/floor/dark/gray_platform

/decl/flooring/tiling/dark/danger
	icon_base = "danger"
	build_type = /obj/item/stack/tile/floor/dark/danger

/decl/flooring/tiling/dark/golden
	icon_base = "golden"
	build_type = /obj/item/stack/tile/floor/dark/golden

/decl/flooring/tiling/dark/bluecorner
	icon_base = "bluecorner"
	build_type = /obj/item/stack/tile/floor/dark/bluecorner

/decl/flooring/tiling/dark/orangecorner
	icon_base = "orangecorner"
	build_type = /obj/item/stack/tile/floor/dark/orangecorner

/decl/flooring/tiling/dark/cyancorner
	icon_base = "cyancorner"
	build_type = /obj/item/stack/tile/floor/dark/cyancorner

/decl/flooring/tiling/dark/violetcorener
	icon_base = "violetcorener"
	build_type = /obj/item/stack/tile/floor/dark/violetcorener

/decl/flooring/tiling/dark/monofloor
	icon_base = "monofloor"
	build_type = /obj/item/stack/tile/floor/dark/monofloor
	has_base_range = 15

/decl/flooring/tiling/cafe
	name = "floor"
	icon_base = "cafe"
	icon = 'icons/turf/flooring/tiles.dmi'
	build_type = /obj/item/stack/tile/floor/cafe
	footstep_sound = "floor"

/decl/flooring/tiling/techmaint
	name = "floor"
	icon_base = "techmaint"
	icon = 'icons/turf/flooring/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/techmaint
	footstep_sound = "floor"

	floor_smooth = SMOOTH_WHITELIST
	flooring_whitelist = list(/decl/flooring/tiling/techmaint_perforated, /decl/flooring/tiling/techmaint_panels)

/decl/flooring/tiling/techmaint_perforated
	name = "floor"
	icon_base = "techmaint_perforated"
	icon = 'icons/turf/flooring/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/techmaint/perforated
	footstep_sound = "floor"

	floor_smooth = SMOOTH_WHITELIST
	flooring_whitelist = list(/decl/flooring/tiling/techmaint, /decl/flooring/tiling/techmaint_panels)

/decl/flooring/tiling/techmaint_panels
	name = "floor"
	icon_base = "techmaint_panels"
	icon = 'icons/turf/flooring/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/techmaint/panels
	footstep_sound = "floor"

	floor_smooth = SMOOTH_WHITELIST
	flooring_whitelist = list(/decl/flooring/tiling/techmaint_perforated, /decl/flooring/tiling/techmaint)

/decl/flooring/tiling/techmaint_cargo
	name = "floor"
	icon_base = "techmaint_cargo"
	icon = 'icons/turf/flooring/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/techmaint/cargo
	footstep_sound = "floor"

//==========MISC==============\\

/decl/flooring/wood
	name = "wooden floor"
	desc = "Polished redwood planks."
	footstep_sound = "wood"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	smooth_nothing = TRUE
	flags = TURF_CAN_BREAK | TURF_CAN_BURN | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER | TURF_HIDES_THINGS

/decl/flooring/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with steel rods."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "reinforced"
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE | TURF_CAN_BURN | TURF_CAN_BREAK | TURF_HIDES_THINGS |TURF_HIDES_THINGS
	build_type = /obj/item/stack/rods
	build_cost = 2
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = 1
	resistance = RESISTANCE_TOUGH
	footstep_sound = "plating"

/decl/flooring/reinforced/circuit
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_base = "bcircuit"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS |TURF_HIDES_THINGS
	can_paint = 1

	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

/decl/flooring/reinforced/circuit/green
	name = "processing strata"
	icon_base = "gcircuit"

/decl/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	icon_base = "cult"
	build_type = null
	has_damage_range = 6
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_HIDES_THINGS
	can_paint = null

//==========Derelict==============\\

/decl/flooring/tiling/derelict
	name = "floor"
	icon_base = "derelict1"
	icon = 'icons/turf/flooring/derelict.dmi'
	footstep_sound = "floor"

/decl/flooring/tiling/derelict/white_red_edges
	name = "floor"
	icon_base = "derelict1"
	build_type = /obj/item/stack/tile/derelict/white_red_edges

/decl/flooring/tiling/derelict/white_small_edges
	name = "floor"
	icon_base = "derelict2"
	build_type = /obj/item/stack/tile/derelict/white_small_edges

/decl/flooring/tiling/derelict/red_white_edges
	name = "floor"
	icon_base = "derelict3"
	build_type = /obj/item/stack/tile/derelict/red_white_edges

/decl/flooring/tiling/derelict/white_big_edges
	name = "floor"
	icon_base = "derelict4"
	build_type = /obj/item/stack/tile/derelict/white_big_edges
