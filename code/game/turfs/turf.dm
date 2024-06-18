/turf
	name = "ship"
	icon = 'icons/turf/floors.dmi'
	level = BELOW_PLATING_LEVEL
	luminosity = 1
	var/dynamic_lighting = TRUE
	var/diffused = 0 //If above zero, shields can't be on this turf. Set by floor diffusers only. Not a boolean, can go above 1
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1
	var/temperature = T20C      // Initial turf temperature.
	var/blocks_air = FALSE // Does this turf contain air/let air through?
	var/seismic_activity = 1 // SEISMIC_MIN
	var/thermite = FALSE
	var/is_hole = FALSE // If true, turf is open to vertical transitions through it
	var/is_wall = FALSE // True for wall turfs, but also true if they contain a low wall object
	var/is_simulated = TRUE
	var/is_wet = FALSE
	var/is_transparent = FALSE
	var/_initialized_transparency = FALSE //used only for roundstard update_icon
	// Initial air contents (in moles)
	var/oxygen = MOLES_O2STANDARD
	var/carbon_dioxide = 0
	var/nitrogen = MOLES_N2STANDARD
	var/plasma = 0
	// ZAS stuff
	var/zone/zone
	var/open_directions
	var/needs_air_update = FALSE
	var/datum/gas_mixture/air

	var/has_resources
	var/list/resources // Mining resources (for the large drills)
	var/list/initial_gas
	var/list/decals
	var/list/affecting_lights // List of light sources affecting this turf
	var/tmp/has_opaque_atom = FALSE // Not to be confused with opacity, this will be TRUE if there's any opaque atom on the tile
	var/tmp/lighting_corners_initialised = FALSE
	var/tmp/list/datum/lighting_corner/corners
	var/tmp/atom/movable/lighting_overlay/lighting_overlay // Our lighting overlay
	var/list/image/obfuscations = new()
	var/image/wet_overlay = null
	var/obj/landmark/loot_biomes/biome



	#ifdef ZASDBG
	var/list/ZAS_debug_overlays
	#endif

/turf/New()
	..()
	updateVisibility(src)
	levelupdate()

/turf/Initialize(mapload, ...)
	if(opacity)
		has_opaque_atom = TRUE
	turfs += src

	// TODO: Check which areas are on the ship, but marked improperly, and remove this code
	var/area/A = loc
	if(!A.ship_area)
		if(z in GLOB.maps_data.station_levels)
			A.set_ship_area()
	. = ..() // Calls /atom/proc/Initialize()

/turf/Destroy()
	turfs -= src
	updateVisibility(src)
	..()
	return QDEL_HINT_IWILLGC

/turf/proc/is_solid_structure() // Unrelated to density, checks if the turf can support a structure
	return TRUE

/turf/proc/is_space() // Is this a '/turf/space', or a '/turf/open' with '/turf/space' below?
	return FALSE

/turf/proc/can_build_cable(mob/user) // , floors override that
	return FALSE

/turf/attackby(obj/item/I, mob/user, params)
	if(!is_simulated)
		return
	if(istype(I, /obj/item/stack/cable_coil) && can_build_cable(user))
		var/obj/item/stack/cable_coil/coil = I
		coil.turf_place(src, user)
		return
	return ..()

/turf/attack_hand(mob/user)
	//QOL feature, clicking on turf can toogle doors
	var/obj/machinery/door/airlock/AL = locate(/obj/machinery/door/airlock) in src.contents
	if(AL)
		AL.attack_hand(user)
		return TRUE
	var/obj/machinery/door/holy/HD = locate(/obj/machinery/door/holy) in src.contents
	if(HD)
		HD.attack_hand(user)
		return TRUE
	var/obj/machinery/door/firedoor/FD = locate(/obj/machinery/door/firedoor) in src.contents
	if(FD)
		FD.attack_hand(user)
		return TRUE
	if(!(user.canmove) || user.restrained() || !(user.pulling))
		return FALSE
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return FALSE
	if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
		return FALSE
	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return TRUE

/turf/Enter(atom/movable/O, atom/oldloc)
	ASSERT(O)
	if(movement_disabled && ismob(usr) && usr.ckey != movement_disabled_exception)
		to_chat(usr, SPAN_WARNING("Movement is admin-disabled.")) //This is to identify lag problems
		return

//	..()

	if(!isturf(O.loc) || isobserver(O))
		return TRUE

	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in O.loc)
		if(!(obstacle.flags & ON_BORDER) && (O != obstacle) && (oldloc != obstacle))
			if(!obstacle.CheckExit(O, src))
				O.Bump(obstacle, 1)
				return FALSE

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in O.loc)
		if((border_obstacle.flags & ON_BORDER) && (O != border_obstacle) && (oldloc != border_obstacle))
			if(!border_obstacle.CheckExit(O, src))
				O.Bump(border_obstacle, 1)
				return FALSE

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CanPass(O, O.loc, 1, 0) && (oldloc != border_obstacle))
				O.Bump(border_obstacle, 1)
				return FALSE

	//Then, check the turf itself
	if(!CanPass(O, src))
		O.Bump(src, 1)
		return FALSE

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(!(obstacle.flags & ON_BORDER))
			if(!obstacle.CanPass(O, O.loc, 1, 0) && (oldloc != obstacle))
				O.Bump(obstacle, 1)
				return FALSE
	return TRUE


/turf/Entered(atom/movable/Obj, atom/OldLoc)
	..()
	for(var/entry in Obj.light_sources)
		var/datum/light_source/light_source = entry
		light_source.source_atom.update_light()
	if(is_simulated)
		if(isliving(Obj))
			var/mob/living/M = Obj

			for(var/atom/movable/updatee in M.update_on_move)
				updatee.entered_with_container(OldLoc)

			if(!M.lying)
				var/obj/effect/plant/plant = locate() in contents
				if(plant)
					plant.trodden_on(M)
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					H.handle_footstep(src) // Footstep sounds. This proc is in footsteps.dm
					var/list/bloodDNA = null // Tracking blood
					var/bloodcolor = ""
					if(H.shoes)
						var/obj/item/clothing/shoes/S = H.shoes
						if(istype(S))
							// Following proc call exists solely for clown shoes
							// TODO: This is silly, we can do better
							S.handle_movement(src,(MOVING_QUICKLY(H) ? 1 : 0))
							if(S.track_blood && S.blood_DNA)
								bloodDNA = S.blood_DNA
								bloodcolor=S.blood_color
								S.track_blood--
					else
						if(H.track_blood && H.feet_blood_DNA)
							bloodDNA = H.feet_blood_DNA
							bloodcolor = H.feet_blood_color
							H.track_blood--

					if(bloodDNA)
						src.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,H.dir,0,bloodcolor) // Coming
						var/turf/from = get_step(H,reverse_direction(H.dir))
						if(istype(from) && from)
							from.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,0,H.dir,bloodcolor) // Going
						bloodDNA = null

					var/obj/item/implant/core_implant/cruciform/C = H.get_core_implant(/obj/item/implant/core_implant/cruciform)
					if(C && C.active)
						var/obj/item/cruciform_upgrade/upgrade = C.upgrade
						if(upgrade && upgrade.active && istype(upgrade, CUPGRADE_CLEANSING_PSESENCE))
							clean_ultimate(H)
				if(is_wet)
					if(M.buckled || (is_wet == 1 && MOVING_DELIBERATELY(M)))
						return

					var/slip_dist = 1
					var/slip_stun = 6
					var/floor_type = "wet"

					switch(is_wet)
						if(2) // Lube
							floor_type = "slippery"
							slip_dist = 4
							slip_stun = 10
						if(3) // Ice
							floor_type = "icy"
							slip_stun = 4

					if(locate(/obj/structure/multiz/ladder) in get_turf(M.loc))  // Avoid slipping on ladder tiles
						visible_message(SPAN_DANGER("\The [M] supports themself with the ladder to avoid slipping."))

					else if(locate(/obj/structure/multiz/stairs) in get_turf(M.loc))  // Avoid slipping on stairs tiles
						visible_message(SPAN_DANGER("\The [M] supports themself with the handrail to avoid slipping."))

					else if(M.slip("the [floor_type] floor",slip_stun))
						for(var/i = 0;i<slip_dist;i++)
							step(M, M.dir)
							sleep(1)

		// TODO: Contamination is ancient and utterly useless mechanic, remove in a separate PR --KIROV
		else if(isitem(Obj) && vsc.plc.CLOTH_CONTAMINATION)
			var/obj/item/I = Obj
			if(I.can_contaminate())
				var/datum/gas_mixture/env = return_air(1)
				if(!env)
					return
				for(var/g in env.gas)
					if(gas_data.flags[g] & XGM_GAS_CONTAMINANT && env.gas[g] > gas_data.overlay_limit[g] + 1)
						I.contaminate()
						break

	// If an opaque movable atom moves around we need to potentially update visibility.
		if(Obj && Obj.opacity)
			has_opaque_atom = TRUE // Make sure to do this before reconsider_lights(), incase we're on instant updates. Guaranteed to be on in this case.
			reconsider_lights()

		update_openspace()

	if(ismob(Obj))
		var/mob/M = Obj
		M.update_floating()
		if(M.check_gravity() || M.incorporeal_move)
			M.inertia_dir = 0
		else
			if(!M.allow_spacemove())
				inertial_drift(M)
			else
				if(M.allow_spacemove() == TRUE)
					M.update_floating(FALSE)
					M.inertia_dir = 0
				else if(M.check_dense_object())
					M.inertia_dir = 0

		if(isliving(M))
			var/mob/living/L = M
			L.handle_footstep(src)

	// This is awful // TODO: Replace with something sane in a separate PR --KIROV
	var/objects = 0
	if(Obj && (Obj.flags & PROXMOVE))
		for(var/atom/movable/thing in range(1))
			if(objects > 100)
				break
			objects++
			spawn(0)
				if(Obj)
					Obj.HasProximity(thing, 1)
					if((thing && Obj) && (thing.flags & PROXMOVE))
						thing.HasProximity(Obj, 1)


/turf/Exited(atom/movable/Obj, atom/newloc)
	..() // /atom/Exited()
	update_openspace()
	if(Obj && Obj.opacity)
		recalc_atom_opacity() // Make sure to do this before reconsider_lights(), incase we're on instant updates.
		reconsider_lights()

/turf/proc/adjacent_fire_act(turf/floor/source, temperature, volume)
	return

/turf/proc/is_plating()
	return FALSE

/turf/proc/inertial_drift(atom/movable/A as mob|obj)
	if(!(A.last_move))	return
	if((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if(M.allow_spacemove() == TRUE)
			M.inertia_dir  = 0
			return
		spawn(5)
			if((M && !(M.anchored) && !(M.pulledby) && (M.loc == src)))
				if(M.inertia_dir)
					step_glide(M, M.inertia_dir, DELAY2GLIDESIZE(5))
					return
				M.inertia_dir = M.last_move
				step(M, M.inertia_dir, DELAY2GLIDESIZE(5))
	return

/turf/proc/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && !is_plating())
		SEND_SIGNAL_OLD(O, COMSIG_TURF_LEVELUPDATE, !is_plating())

/turf/proc/AdjacentTurfs()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/CardinalTurfs()
	var/L[] = new()
	for(var/turf/T in AdjacentTurfs())
		if(T.x == x || T.y == y)
			L.Add(T)
	return L

/turf/proc/Distance(turf/t) // TODO: This proc is only used by extremely outdated bot pathfinding, which probably should be removed
	if(get_dist(src, t) == 1)
		var/cost = (x - t.x) * (x - t.x) + (y - t.y) * (y - t.y)
		var/pathweight = is_hole ? 100000 : 1
		var/t_pathweight = is_hole ? 100000 : 1
		cost *= (pathweight+t_pathweight)/2
		return cost
	return get_dist(src, t)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/contains_dense_objects(unincludehumans)
	if(density)
		return TRUE
	for(var/atom/A in src)
		if(A.density && !(A.flags & ON_BORDER) && (unincludehumans && !ishuman(A)))
			return TRUE

/turf/get_footstep_sound()
	var/obj/structure/catwalk/catwalk = locate(/obj/structure/catwalk) in src
	if(catwalk)
		. = footstep_sound("catwalk")
	else
		. = footstep_sound("floor")

/turf/floor/get_footstep_sound()
	var/obj/structure/catwalk/catwalk = locate(/obj/structure/catwalk) in src
	if(catwalk)
		. = footstep_sound("catwalk")
	else if(flooring)
		. = footstep_sound(flooring.footstep_sound)
	else if(initial_flooring)
		var/decl/flooring/floor = decls_repository.get_decl(initial_flooring)
		. = footstep_sound(floor.footstep_sound)
	else
		. = footstep_sound("floor")

/turf/AllowDrop()
	return TRUE
