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

// 25.05.25 - CFW - Porting Soj slowdown based on tile, experimental
	//Slowdown when on the tile, not moving TO the tile! Set to negitives to be a speed boost (i.e roads)
	var/tally_addition_decl = 0


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

/decl/flooring/shale
	name = "coarse shale"
	desc = "Dark toned basaltic dust."
	icon = 'icons/turf/flooring/dirt.dmi'
	icon_base = "shale"
	has_base_range = 3
	damage_temperature = T0C+120
	flags = TURF_REMOVE_SHOVEL | TURF_EDGES_EXTERNAL | TURF_HAS_CORNERS
	build_type = null
	footstep_sound = "asteroid"
	floor_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

//==========Snow==============\\

/decl/flooring/snow
	name = "snow"
	desc = "You could do lines of this all day."
	icon = 'icons/turf/snow.dmi'
	icon_base = "snow"
	has_base_range = 3
	damage_temperature = T0C+30
	flags = TURF_REMOVE_SHOVEL | TURF_EDGES_EXTERNAL | TURF_HAS_CORNERS | TURF_HIDES_THINGS
	plating_type = /decl/flooring/snow
	footstep_sound = "snow"
	floor_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

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
// 04.03.25 - CFW deleting cement bag parts due to instability
/*
	if (istype(I, /obj/item/cement_bag))
		var/obj/item/cement_bag/CB = I
		if(CB.inuse)
			to_chat(user, SPAN_NOTICE("You cant poor the [src] that fast!"))
			return
		if(!T.wet)
			to_chat(user, SPAN_NOTICE("The floor needs to be wet before pooring [src]!"))
			return
		CB.inuse = TRUE
		to_chat(user, SPAN_NOTICE("You start pooring and smoothing the [src]..."))
		if(do_after(user,60))
			new /obj/effect/flooring_type_spawner/concrete(T)
			qdel(CB)
		else
			to_chat(user, SPAN_NOTICE("You must stand still to finish the job!"))
			CB.inuse = FALSE
*/

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

/decl/flooring/wood/wild1
	icon_base = "wooden_floor_s1"
	build_type = /obj/item/stack/tile/wood/ashen/red

/decl/flooring/wood/wild2
	icon_base = "wooden_floor_s2"
	build_type = /obj/item/stack/tile/wood/ashen/dull

/decl/flooring/wood/wild3
	icon_base = "wooden_floor_s3"
	build_type = /obj/item/stack/tile/wood/ashen

/decl/flooring/wood/wild4
	icon_base = "wooden_floor_s4"
	build_type = /obj/item/stack/tile/wood/old

/decl/flooring/wood/wild5
	icon_base = "wooden_floor_s5"
	build_type = /obj/item/stack/tile/wood/old/veridical

/decl/flooring/wood/wood_old
	icon = 'icons/turf/flooring/wood_old.dmi'
	icon_base = "wood"
	build_type = /obj/item/stack/tile/wood/wood_old

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


// 25.05.25 - CFW - Porting Soj turfs
/*Beach/Water*/

/decl/flooring/beach/sand
	name = "sand"
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "sand"
	flags = TURF_REMOVE_SHOVEL | TURF_CAN_BURN
	build_type = null
	footstep_sound = "asteroid"
	plating_type = /decl/flooring/dirt

/decl/flooring/beach/desert
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "desert"

/decl/flooring/beach/drywater
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "sand1"

/decl/flooring/beach/coastline
	icon = 'icons/turf/flooring/beach2.dmi'
	icon_base = "sandwater"

/decl/flooring/beach/water
	name = "water"
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "water"
	resistance = RESISTANCE_TOUGH
	health = 9999999
	tally_addition_decl = 0.1 //Walking in water makes ya slower

/decl/flooring/beach/water/coastwater
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "beach"

/decl/flooring/beach/water/coastwatercorner
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "beachcorner"

/decl/flooring/beach/water/swamp
	name = "murky water"
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seashallow_swamp"
	footstep_sound = "water"

/decl/flooring/beach/water/jungle
	name = "murky water"
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seashallow_jungle1"
	footstep_sound = "water"

/decl/flooring/beach/water/flooded
	name = "murky water"
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seashallow_jungle2"
	footstep_sound = "water"

/decl/flooring/beach/water/ice
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seashallow_frozen"
	footstep_sound = "water"
	tally_addition_decl = -0.1 //Walking on ice makes ya faster

/decl/flooring/beach/water/ocean
	name = "salt water"
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seadeep"
	footstep_sound = "water"

/decl/flooring/beach/water/jungledeep
	name = "murky water"
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seashallow_jungle3"
	footstep_sound = "water"

/decl/flooring/beach/water/shallow
	name = "shallow water"
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seashallow"
	footstep_sound = "water"

/decl/flooring/grass2
	name = "grass"
	icon = 'icons/turf/flooring/grass.dmi'
	build_type = null
	footstep_sound = "grass"
	resistance = RESISTANCE_TOUGH
	plating_type = /decl/flooring/dirt

/decl/flooring/grass2/virgoforest
	icon_base = "grass-light"

/decl/flooring/grass2/virgoforestdark
	icon_base = "grass-dark"

/decl/flooring/grass2/sif
	icon_base = "grass_sif"

/decl/flooring/grass2/sifdark
	icon_base = "grass_sif_dark"

/decl/flooring/grass2/jungle
	icon_base = "grass_jungle"

/decl/flooring/grass2/snow_grass
	icon_base = "snowgrass_nes"

/decl/flooring/grass2/snowjungle
	icon_base = "snowjungle"

/decl/flooring/grass2/plowed_snow
	icon_base = "plowed_snow"

/decl/flooring/grass2/dry
	icon_base = "grass_dry"

/decl/flooring/grass2/colonial1
	icon_base = "cmgrass1"

/decl/flooring/grass2/colonial2
	icon_base = "cmgrass2"

/decl/flooring/grass2/colonial3
	icon_base = "cmgrass3"

/decl/flooring/grass2/colonialjungle1
	icon_base = "junglegrass1"

/decl/flooring/grass2/colonialjungle2
	icon_base = "junglegrass2"

/decl/flooring/grass2/colonialjungle3
	icon_base = "junglegrass3"

/decl/flooring/grass2/colonialjungle4
	icon_base = "junglegrass4"

/decl/flooring/grass2/colonialbeach
	icon_base = "grassbeach"

/decl/flooring/grass2/colonialbeach/corner
	icon_base = "gbcorner"

/*Snow*/
/decl/flooring/snow
	name = "snow"
	icon = 'icons/turf/flooring/snows.dmi'
	icon_base = "snow"
	has_base_range = 4
	flags = TURF_REMOVE_SHOVEL | TURF_EDGES_EXTERNAL | TURF_HAS_CORNERS
	plating_type = /decl/flooring/dirt
	footstep_sound = "snow"
	floor_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

/*Ice Water*/
/decl/flooring/icewater
	name = "frozen water"
	desc = "Frozen water, solid enough to stand on, looks too thick to dig through without machines."
	icon = 'icons/turf/flooring/icewater.dmi'
	icon_base = "ice_water"
	has_base_range = 2
	flags = TURF_EDGES_EXTERNAL | TURF_HAS_CORNERS
	plating_type = /decl/flooring/dirt
	footstep_sound = "ice"
	floor_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE
	resistance = RESISTANCE_TOUGH
	health = 9999999
	tally_addition_decl = -0.1 //walking on ice makes ya go faster

/*Dirt*/
/decl/flooring/dirt
	name = "dirt"
	icon = 'icons/turf/flooring/dirt.dmi'
	icon_base = "dirt"
	build_type = null
	footstep_sound = "gravel"
	resistance = RESISTANCE_TOUGH
	health = 9999999

/decl/flooring/dirt/dark
	icon_base = "dirtnewdark"

/decl/flooring/dirt/dark/plough
	icon_base = "dirt_ploughed"

/decl/flooring/dirt/flood
	icon_base = "flood_dirt"

/decl/flooring/dirt/flood/plough
	icon_base = "flood_dirt_ploughed"

/decl/flooring/dirt/dust
	icon_base = "dust"

/decl/flooring/dirt/ground
	icon_base = "desert"

/decl/flooring/dirt/coast
	icon_base = "dirtbeach"

/decl/flooring/dirt/coast/corner
	icon_base = "dirtbeachcorner1"

/decl/flooring/dirt/coast/corner2
	icon_base = "dirtbeachcorner2"

/decl/flooring/dirt/burned
	icon_base = "burned_dirt"

/decl/flooring/dirt/mud
	icon_base = "mud_dark"
	tally_addition_decl = 0.1

/decl/flooring/dirt/mud/light
	icon_base = "mud_light"
	tally_addition_decl = 0.1

/*Rock*/
/decl/flooring/rock
	name = "rock"
	icon = 'icons/turf/flooring/dirt.dmi'
	icon_base = "rock"
	build_type = null
	footstep_sound = "gravel"
	resistance = RESISTANCE_TOUGH
	health = 9999999

/decl/flooring/rock/alt
	icon_base = "rock_alt"

/decl/flooring/rock/grey
	icon_base = "rock_grey"

/decl/flooring/rock/dark
	icon_base = "rock_dark"

/decl/flooring/rock/old
	icon_base = "rock_old"

/decl/flooring/rock/manmade/ruin1
	icon_base = "stone_old"

/decl/flooring/rock/manmade/ruin2
	icon_base = "stone_old1"

/decl/flooring/rock/manmade/ruin3
	icon_base = "stone_old2"

/decl/flooring/rock/seafloor
	icon_base = "seafloor"

/decl/flooring/rock/manmade/concrete
	name = "concrete"
	icon_base = "concrete6"
	tally_addition_decl = -0.1

/decl/flooring/rock/manmade/asphalt
	name = "asphalt"
	icon_base = "asphalt"
	tally_addition_decl = -0.1

/decl/flooring/rock/manmade/road
	name = "road"
	icon_base = "road_1"
	tally_addition_decl = -0.1

/*POOL - basic pool tile details*/
/decl/flooring/pool
	name = "poolwater"
	icon = 'icons/turf/flooring/tiles_white.dmi'
	icon_base = "tiles"
	build_type = null
	footstep_sound = "water"
	resistance = RESISTANCE_TOUGH
	health = 9999999

// TILE INDUSTERAL

/decl/flooring/industrial
	icon = 'icons/turf/flooring/tiles_industeral.dmi'
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN | TURF_HIDES_THINGS
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	resistance = RESISTANCE_FRAGILE

	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

	damage_temperature = T0C+200
	footstep_sound = "floor"
	var/can_repair = FALSE
	var/repair_into = /obj/effect/flooring_type_spawner/concrete

// 04.03.25 - CFW - Deleting Cement Bag procs due to instability
/*
/decl/flooring/industrial/attackby(var/obj/item/I, var/mob/user, var/turf/T)
	if(can_repair)
		if(istype(I, /obj/item/cement_bag))
			var/obj/item/cement_bag/CB = I
			if(CB.inuse)
				to_chat(user, SPAN_NOTICE("You cant poor the [src] that fast!"))
				return
			if(!T.wet)
				to_chat(user, SPAN_NOTICE("The floor needs to be wet before pooring [src]!"))
				return
			CB.inuse = TRUE
			to_chat(user, SPAN_NOTICE("You start pooring and smoothing the [src]..."))
			if(do_after(user,60))
				new repair_into(T)
				qdel(CB)
			else
				to_chat(user, SPAN_NOTICE("You must stand still to finish the job!"))
				CB.inuse = FALSE
*/

//concrete

/decl/flooring/industrial/concrete_small
	name = "concrete slab"
	desc = "Placed down slab of stone mixed with sand and heated into an aged design."
	icon_base = "concrete_small"
	has_base_range = 5
	can_repair = TRUE
	descriptor = "concrete"
	repair_into = /obj/effect/flooring_type_spawner/concrete_small_fixed
	build_type = /obj/item/stack/tile/concrete_small

/decl/flooring/industrial/concrete_small_fixed
	name = "concrete slab"
	desc = "Placed down slab of stone mixed with sand and heated into an aged design."
	icon_base = "concrete_small"
	descriptor = "concrete"
	build_type = /obj/item/stack/tile/concrete_small_fixed
	tally_addition_decl = -0.1

//bricks

/decl/flooring/industrial/concrete_bricks
	name = "concrete bricks"
	desc = "A bunch of concrete bricks placed down as flooring."
	icon_base = "concrete_bricks"
	has_base_range = 8
	can_repair = TRUE
	descriptor = "concrete"
	repair_into = /obj/effect/flooring_type_spawner/concrete_bricks_fixed
	build_type = /obj/item/stack/tile/concrete_bricks

/decl/flooring/industrial/concrete_bricks_fixed
	name = "concrete bricks"
	desc = "A bunch of concrete bricks placed down as flooring."
	icon_base = "concrete_bricks"
	descriptor = "concrete"
	build_type = /obj/item/stack/tile/concrete_bricks_fixed
	tally_addition_decl = -0.1

//bricks - not odditie

/decl/flooring/industrial/bricks
	name = "bricks"
	desc = "A bunch of stone bricks placed down as flooring."
	icon_base = "brick"
	has_base_range = 8
	can_repair = TRUE
	descriptor = "brick"
	repair_into = /obj/effect/flooring_type_spawner/bricks_fixed
	build_type = /obj/item/stack/tile/bricks

/decl/flooring/industrial/bricks_fixed
	name = "bricks"
	desc = "A bunch of stone bricks placed down as flooring."
	icon_base = "brick"
	descriptor = "brick"
	build_type = /obj/item/stack/tile/bricks_fixed
	tally_addition_decl = -0.1

//ornate

/decl/flooring/industrial/ornate
	name = "ornate flooring"
	desc = "Dark tiles with some painting on it."
	icon_base = "ornate"
	has_base_range = 3
	can_repair = TRUE
	descriptor = "ornate"
	repair_into = /obj/effect/flooring_type_spawner/ornate_fixed
	build_type = /obj/item/stack/tile/ornate

/decl/flooring/industrial/ornate_fixed
	name = "ornate flooring"
	desc = "Dark tiles with some painting on it."
	icon_base = "ornate"
	descriptor = "ornate"
	build_type = /obj/item/stack/tile/ornate_fixed
	tally_addition_decl = -0.1

//sierra

/decl/flooring/industrial/sierra
	name = "ornate flooring"
	desc = "Dark tiles with some painting on it."
	icon_base = "sierra"
	has_base_range = 3
	can_repair = TRUE
	descriptor = "ornate"
	repair_into = /obj/effect/flooring_type_spawner/sierra_fixed
	build_type = /obj/item/stack/tile/sierra

/decl/flooring/industrial/sierra_fixed
	name = "ornate flooring"
	desc = "Dark tiles with some painting on it."
	icon_base = "sierra"
	descriptor = "ornate"
	build_type = /obj/item/stack/tile/sierra_fixed
	tally_addition_decl = -0.1

//ceramic

/decl/flooring/industrial/ceramic
	name = "ceramic"
	desc = "Hardened clay slates locked together as flooring."
	icon_base = "ceramic"
	has_base_range = 2
	can_repair = TRUE
	descriptor = "ceramic"
	repair_into = /obj/effect/flooring_type_spawner/ceramic_fixed
	build_type = /obj/item/stack/tile/ceramic

/decl/flooring/industrial/ceramic_fixed
	name = "ceramic"
	desc = "Hardened clay slates locked together as flooring."
	icon_base = "ceramic"
	descriptor = "ceramic"
	build_type = /obj/item/stack/tile/ceramic_fixed
	tally_addition_decl = -0.1

//gray slate

/decl/flooring/industrial/grey_slates_long
	name = "grey slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "grey_long"
	has_base_range = 6
	can_repair = TRUE
	repair_into = /obj/effect/flooring_type_spawner/grey_slates_long_fixed
	build_type = /obj/item/stack/tile/grey_slates_long

/decl/flooring/industrial/grey_slates_long_fixed
	name = "grey slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "grey_long"
	build_type = /obj/item/stack/tile/grey_slates_long_fixed
	tally_addition_decl = -0.1

//blue slate

/decl/flooring/industrial/blue_slates_long
	name = "blue slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "blue_long"
	has_base_range = 6
	can_repair = TRUE
	repair_into = /obj/effect/flooring_type_spawner/blue_slates_long_fixed
	build_type = /obj/item/stack/tile/blue_slates_long

/decl/flooring/industrial/blue_slates_long_fixed
	name = "blue slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "blue_long"
	build_type = /obj/item/stack/tile/blue_slates_long_fixed
	tally_addition_decl = -0.1

//gray slates

/decl/flooring/industrial/grey_slates
	name = "grey slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "grey"
	has_base_range = 8
	can_repair = TRUE
	repair_into = /obj/effect/flooring_type_spawner/grey_slates_fixed
	build_type = /obj/item/stack/tile/grey_slates

/decl/flooring/industrial/grey_slates_fixed
	name = "grey slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "grey"
	build_type = /obj/item/stack/tile/grey_slates_fixed
	tally_addition_decl = -0.1

//blue slates

/decl/flooring/industrial/blue_slates
	name = "blue slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "blue"
	has_base_range = 8
	can_repair = TRUE
	repair_into = /obj/effect/flooring_type_spawner/blue_slates_fixed
	build_type = /obj/item/stack/tile/blue_slates

/decl/flooring/industrial/blue_slates_fixed
	name = "blue slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "blue"
	build_type = /obj/item/stack/tile/blue_slates_fixed
	tally_addition_decl = -0.1

//navy slate

/decl/flooring/industrial/navy_slates
	name = "navy slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "navy"
	has_base_range = 7
	can_repair = TRUE
	repair_into = /obj/effect/flooring_type_spawner/navy_slates_fixed
	build_type = /obj/item/stack/tile/navy_slates

/decl/flooring/industrial/navy_slates_fixed
	name = "navy slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "navy"
	build_type = /obj/item/stack/tile/navy_slates_fixed
	tally_addition_decl = -0.1

//fancy

/decl/flooring/industrial/fancy_slates
	name = "disk slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "fancy"
	has_base_range = 7
	can_repair = TRUE
	repair_into = /obj/effect/flooring_type_spawner/fancy_slates_fixed
	build_type = /obj/item/stack/tile/fancy_slates

/decl/flooring/industrial/fancy_slates_fixed
	name = "disk slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "fancy"
	build_type = /obj/item/stack/tile/fancy_slates_fixed
	tally_addition_decl = -0.1

//navy

/decl/flooring/industrial/navy_large_slates
	name = "large navy slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "navy_large"
	has_base_range = 3
	can_repair = TRUE
	repair_into = /obj/effect/flooring_type_spawner/navy_large_slates_fixed
	build_type = /obj/item/stack/tile/navy_large_slates

/decl/flooring/industrial/navy_large_slates_fixed
	name = "large navy slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "navy_large_fixed"
	build_type = /obj/item/stack/tile/navy_large_slates_fixed
	tally_addition_decl = -0.1

//ashen

/decl/flooring/industrial/black_large_slates
	name = "large black slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "black_large"
	has_base_range = 3
	can_repair = TRUE
	repair_into = /obj/effect/flooring_type_spawner/black_large_slates_fixed
	build_type = /obj/item/stack/tile/black_large_slates

/decl/flooring/industrial/black_large_slates_fixed
	name = "large black slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "black_large_fixed"
	build_type = /obj/item/stack/tile/black_large_slates_fixed
	tally_addition_decl = -0.1

//Green

/decl/flooring/industrial/green_large_slates
	name = "green large slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "green_large"
	has_base_range = 3
	can_repair = TRUE
	repair_into = /obj/effect/flooring_type_spawner/green_large_slates_fixed
	build_type = /obj/item/stack/tile/green_large_slates

/decl/flooring/industrial/green_large_slates_fixed
	name = "green large slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "green_large_fixed"
	build_type = /obj/item/stack/tile/green_large_slates_fixed
	tally_addition_decl = -0.1

//slabs

/decl/flooring/industrial/white_large_slates
	name = "white large slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "white_large"
	has_base_range = 3
	can_repair = TRUE
	repair_into = /obj/effect/flooring_type_spawner/white_large_slates_fixed
	build_type = /obj/item/stack/tile/white_large_slates

/decl/flooring/industrial/white_large_slates_fixed
	name = "white large slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "white_large_fixed"
	build_type = /obj/item/stack/tile/white_large_slates_fixed
	tally_addition_decl = -0.1

//checker

/decl/flooring/industrial/checker_large
	name = "white and black large slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "checker_large"
	has_base_range = 3
	can_repair = TRUE
	repair_into = /obj/effect/flooring_type_spawner/checker_large_fixed
	build_type = /obj/item/stack/tile/checker_large

/decl/flooring/industrial/checker_large_fixed
	name = "white and black large slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "checker_large_fixed"
	build_type = /obj/item/stack/tile/checker_large_fixed
	tally_addition_decl = -0.1

//cafe

/decl/flooring/industrial/cafe_large
	name = "white and red large slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "cafe_large"
	has_base_range = 3
	can_repair = TRUE
	repair_into = /obj/effect/flooring_type_spawner/cafe_large_fixed
	build_type = /obj/item/stack/tile/cafe_large

/decl/flooring/industrial/cafe_large_fixed
	name = "white and red large slates"
	desc = "Cut down and thinned rock slates used for flooring."
	icon_base = "cafe_large_fixed"
	build_type = /obj/item/stack/tile/cafe_large_fixed
	tally_addition_decl = -0.1
