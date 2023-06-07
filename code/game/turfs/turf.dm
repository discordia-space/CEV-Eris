/turf
	icon = 'icons/turf/floors.dmi'
	level = BELOW_PLATING_LEVEL
	var/holy = 0
	var/diffused = 0 //If above zero, shields can't be on this turf. Set by floor diffusers only
	//This is not a boolean. Multiple diffusers can stack and set it to 2, 3, etc

	// Initial air contents (in moles)
	var/oxygen = 0
	var/carbon_dioxide = 0
	var/nitrogen = 0
	var/plasma = 0

	var/list/initial_gas

	var/footstep_type

	//Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//Properties for both
	var/temperature = T20C      // Initial turf temperature.
	var/blocks_air = 0          // Does this turf contain air/let air through?

	// General properties.
	var/icon_old
	var/pathweight = 1          // How much does it cost to pathfind over this turf?
	var/blessed = 0             // Has the turf been blessed?

	var/list/decals

	var/movement_delay

	var/is_hole = FALSE			// If true, turf is open to vertical transitions through it.
								// This is a more generic way of handling open space turfs
	var/is_wall = FALSE 	//True for wall turfs, but also true if they contain a low wall object

/turf/New()
	..()
	for(var/atom/movable/AM as mob|obj in src)
		spawn( 0 )
			src.Entered(AM)
			return

/turf/Initialize()
	turfs += src
	var/area/A = loc
	if (!A.ship_area)
		if (z in GLOB.maps_data.station_levels)
			A.set_ship_area()

	. = ..()

/turf/Destroy()
	turfs -= src
	..()
	return QDEL_HINT_IWILLGC

/turf/proc/is_solid_structure()
	return 1

/turf/proc/is_space()
	return 0

/turf/proc/is_intact()
	return 0

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

/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		to_chat(usr, SPAN_WARNING("Movement is admin-disabled.")) //This is to identify lag problems
		return

	..()

	if (!mover || !isturf(mover.loc) || isobserver(mover))
		return 1

	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in mover.loc)
		if(!(obstacle.flags & ON_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.flags & ON_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Bump(border_obstacle, 1)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Bump(border_obstacle, 1)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Bump(src, 1)
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(!(obstacle.flags & ON_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Bump(obstacle, 1)
				return 0
	return 1 //Nothing found to block so return success!

var/const/enterloopsanity = 100
/turf/Entered(atom/atom as mob|obj)

	if(movement_disabled)
		to_chat(usr, SPAN_WARNING("Movement is admin-disabled.")) //This is to identify lag problems
		return
	..()

	if(!istype(atom, /atom/movable))
		return

	var/atom/movable/A = atom

	if(ismob(A))
		var/mob/M = A

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

	var/objects = 0
	if(A && (A.flags & PROXMOVE))
		for(var/atom/movable/thing in range(1))
			if(objects > enterloopsanity) break
			objects++
			spawn(0)
				if(A)
					A.HasProximity(thing, 1)
					if ((thing && A) && (thing.flags & PROXMOVE))
						thing.HasProximity(A, 1)
	return

/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature, volume)
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
	for(var/turf/simulated/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/CardinalTurfs()
	var/L[] = new()
	for(var/turf/simulated/T in AdjacentTurfs())
		if(T.x == src.x || T.y == src.y)
			L.Add(T)
	return L

/turf/proc/Distance(turf/t)
	if(get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return get_dist(src,t)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/contains_dense_objects(unincludehumans)
	if(density)
		return 1
	for(var/atom/A in src)
		if(A.density && !(A.flags & ON_BORDER) && (unincludehumans && !ishuman(A)))
			return 1
	return 0

/turf/get_footstep_sound(var/mobtype)

	var/sound

	var/obj/structure/catwalk/catwalk = locate(/obj/structure/catwalk) in src
	if(catwalk)
		sound = footstep_sound("catwalk")
	else
		sound =  footstep_sound("floor")

	return sound

/turf/simulated/floor/get_footstep_sound(var/mobtype)

	var/sound

	var/obj/structure/catwalk/catwalk = locate(/obj/structure/catwalk) in src
	sound =  footstep_sound("floor")
	if(catwalk)
		sound = footstep_sound("catwalk")
	else if(flooring)
		sound = footstep_sound(flooring.footstep_sound)
	else if(initial_flooring)
		var/decl/flooring/floor = decls_repository.get_decl(initial_flooring)
		sound = footstep_sound(floor.footstep_sound)

	return sound

/turf/AllowDrop()
	return TRUE
