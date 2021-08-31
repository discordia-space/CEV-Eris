/atom/movable
	layer = OBJ_LAYER
	var/last_move
	var/anchored = FALSE
	// var/elevation = 2    - not used anywhere
	var/move_speed = 10
	var/l_move_time = 1
	var/m_flag = 1
	var/throwing = 0
	var/thrower
	var/turf/throw_source
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0
	var/mob/pulledby
	var/item_state // Used to specify the item state for the on-mob overlays.
	var/inertia_dir = 0
	var/can_anchor = TRUE

	//spawn_values
	var/price_tag = 0 // The item price in credits. atom/movable so we can also assign a price to animals and other things.
	var/surplus_tag = FALSE //If true, attempting to export this will net you a greatly reduced amount of credits, but we don't want to affect the actual price tag for selling to others.
	var/spawn_tags
	var/rarity_value = 1 //min:1
	var/spawn_frequency = 0 //min:0
	var/accompanying_object	//path or text "obj/item,/obj/item/device"
	var/prob_aditional_object = 100
	var/spawn_blacklisted = FALSE
	var/bad_type //path

/atom/movable/Del()
	if(isnull(gc_destroyed) && loc)
		testing("GC: -- [type] was deleted via del() rather than qdel() --")
		crash_with("GC: -- [type] was deleted via del() rather than qdel() --") // stick a stack trace in the runtime logs
//	else if(isnull(gcDestroyed))
//		testing("GC: [type] was deleted via GC without qdel()") //Not really a huge issue but from now on, please qdel()
//	else
//		testing("GC: [type] was deleted via GC with qdel()")
	..()

/atom/movable/Destroy()
	. = ..()
	for(var/atom/movable/AM in contents)
		qdel(AM)

	if(loc)
		loc.handle_atom_del(src)

	forceMove(null)
	if (pulledby)
		if (pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null

/atom/movable/Bump(var/atom/A, yes)
	if(src.throwing)
		src.throw_impact(A)
		src.throwing = 0

	spawn(0)
		if (A && yes)
			A.last_bumped = world.time
			A.Bumped(src)
		return
	..()
	return

/atom/movable/proc/entered_with_container(var/atom/old_loc)
	return

/atom/movable/proc/forceMove(atom/destination, var/special_event, glide_size_override=0)
	if(loc == destination)
		return 0

	if (glide_size_override)
		set_glide_size(glide_size_override)

	var/is_origin_turf = isturf(loc)
	var/is_destination_turf = isturf(destination)
	// It is a new area if:
	//  Both the origin and destination are turfs with different areas.
	//  When either origin or destination is a turf and the other is not.
	var/is_new_area = (is_origin_turf ^ is_destination_turf) || (is_origin_turf && is_destination_turf && loc.loc != destination.loc)

	var/atom/origin = loc
	loc = destination

	if(origin)
		origin.Exited(src, destination)
		if(is_origin_turf)
			for(var/atom/movable/AM in origin)
				AM.Uncrossed(src)
			if(is_new_area && is_origin_turf)
				origin.loc.Exited(src, destination)

	if(destination)
		destination.Entered(src, origin, special_event)
		if(is_destination_turf) // If we're entering a turf, cross all movable atoms
			for(var/atom/movable/AM in loc)
				if(AM != src)
					AM.Crossed(src)
			if(is_new_area && is_destination_turf)
				destination.loc.Entered(src, origin)

	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, origin, loc)

	// Only update plane if we're located on map
	if(isturf(loc))
		// if we wasn't on map OR our Z coord was changed
		if( !isturf(origin) || (get_z(loc) != get_z(origin)) )
			update_plane()

	return 1


//called when src is thrown into hit_atom
/atom/movable/proc/throw_impact(atom/hit_atom, var/speed)
	if(isliving(hit_atom))
		var/mob/living/M = hit_atom
		M.hitby(src,speed)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.last_move)
		O.hitby(src,speed)

	else if(isturf(hit_atom))
		src.throwing = 0
		var/turf/T = hit_atom
		if(T.density)
			spawn(2)
				step(src, turn(src.last_move, 180))
			if(isliving(src))
				var/mob/living/M = src
				M.turf_collision(T, speed)

//decided whether a movable atom being thrown can pass through the turf it is in.
/atom/movable/proc/hit_check(var/speed)
	if(src.throwing)
		for(var/atom/A in get_turf(src))
			if(A == src) continue
			if(isliving(A))
				if(A:lying) continue
				src.throw_impact(A,speed)
			if(isobj(A))
				if(A.density && !A.throwpass)	// **TODO: Better behaviour for windows which are dense, but shouldn't always stop movement
					src.throw_impact(A,speed)

/atom/movable/proc/throw_at(atom/target, range, speed, thrower)
	if(!target || !src)	return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target

	set_dir(pick(cardinal))
	src.throwing = 1
	if(target.allow_spin && src.allow_spin)
		SpinAnimation(5,1)
	src.thrower = thrower
	src.throw_source = get_turf(src)	//store the origin turf

	if(usr)
		if(HULK in usr.mutations)
			src.throwing = 2 // really strong throw!

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)

	var/dx
	if (target.x > src.x)
		dx = EAST
	else
		dx = WEST

	var/dy
	if (target.y > src.y)
		dy = NORTH
	else
		dy = SOUTH
	var/dist_travelled = 0
	var/dist_since_sleep = 0
	var/area/a = get_area(src.loc)
	if(dist_x > dist_y)
		var/error = dist_x/2 - dist_y

		while(src && target &&((((src.x < target.x && dx == EAST) || (src.x > target.x && dx == WEST)) && dist_travelled < range) || (a && a.has_gravity == 0)  || istype(src.loc, /turf/space)) && src.throwing && istype(src.loc, /turf))
			// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < 0)
				var/atom/step = get_step(src, dy)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				hit_check(speed)
				error += dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dx)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				hit_check(speed)
				error -= dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			a = get_area(src.loc)
	else
		var/error = dist_y/2 - dist_x
		while(src && target &&((((src.y < target.y && dy == NORTH) || (src.y > target.y && dy == SOUTH)) && dist_travelled < range) || (a && a.has_gravity == 0)  || istype(src.loc, /turf/space)) && src.throwing && istype(src.loc, /turf))
			// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < 0)
				var/atom/step = get_step(src, dx)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				hit_check(speed)
				error += dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dy)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				hit_check(speed)
				error -= dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)

			a = get_area(src.loc)

	//done throwing, either because it hit something or it finished moving
	src.throwing = 0
	src.thrower = null
	src.throw_source = null

	var/turf/new_loc = get_turf(src)
	if(new_loc)
		if(isobj(src))
			src.throw_impact(new_loc,speed)
		new_loc.Entered(src)

//Overlays
/atom/movable/overlay
	var/atom/master
	anchored = TRUE

/atom/movable/overlay/New()
	for(var/x in src.verbs)
		src.verbs -= x
	..()

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return

/atom/movable/proc/touch_map_edge()
	if(z in GLOB.maps_data.sealed_levels)
		return

	if(config.use_overmap)
		overmap_spacetravel(get_turf(src), src)
		return

	var/move_to_z = src.get_transit_zlevel()
	var/move_to_x = x
	var/move_to_y = y
	if(move_to_z)
		if(x <= TRANSITIONEDGE)
			move_to_x = world.maxx - TRANSITIONEDGE - 2
			move_to_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (x >= (world.maxx - TRANSITIONEDGE + 1))
			move_to_x = TRANSITIONEDGE + 1
			move_to_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (y <= TRANSITIONEDGE)
			move_to_y = world.maxy - TRANSITIONEDGE -2
			move_to_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		else if (y >= (world.maxy - TRANSITIONEDGE + 1))
			move_to_y = TRANSITIONEDGE + 1
			move_to_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		forceMove(locate(move_to_x, move_to_y, move_to_z))

//by default, transition randomly to another zlevel
/atom/movable/proc/get_transit_zlevel()
	var/list/candidates = GLOB.maps_data.accessable_levels.Copy()
	candidates.Remove("[src.z]")

	//If something was ejected from the ship, it does not end up on another part of the ship.
	if (z in GLOB.maps_data.station_levels)
		for (var/n in GLOB.maps_data.station_levels)
			candidates.Remove("[n]")

	if(!candidates.len)
		return null
	return text2num(pickweight(candidates))


/atom/movable/proc/set_glide_size(glide_size_override = 0, var/min = 0.2, var/max = world.icon_size/2)
	if (!glide_size_override || glide_size_override > max)
		glide_size = 0
	else
		glide_size = max(min, glide_size_override)

/*	for (var/atom/movable/AM in contents)
		AM.set_glide_size(glide_size, min, max)

*/
//This proc should never be overridden elsewhere at /atom/movable to keep directions sane.
// Spoiler alert: it is, in moved.dm
/atom/movable/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	if (glide_size_override > 0)
		set_glide_size(glide_size_override)

	// To prevent issues, diagonal movements are broken up into two cardinal movements.

	// Is this a diagonal movement?
	SEND_SIGNAL(src, COMSIG_MOVABLE_PREMOVE, src)
	if (Dir & (Dir - 1))
		if (Dir & NORTH)
			if (Dir & EAST)
				// Pretty simple really, try to move north -> east, else try east -> north
				// Pretty much exactly the same for all the other cases here.
				if (step(src, NORTH))
					step(src, EAST)
				else
					if (step(src, EAST))
						step(src, NORTH)
			else
				if (Dir & WEST)
					if (step(src, NORTH))
						step(src, WEST)
					else
						if (step(src, WEST))
							step(src, NORTH)
		else
			if (Dir & SOUTH)
				if (Dir & EAST)
					if (step(src, SOUTH))
						step(src, EAST)
					else
						if (step(src, EAST))
							step(src, SOUTH)
				else
					if (Dir & WEST)
						if (step(src, SOUTH))
							step(src, WEST)
						else
							if (step(src, WEST))
								step(src, SOUTH)
	else
		var/atom/oldloc = src.loc
		var/olddir = dir //we can't override this without sacrificing the rest of movable/New()

		. = ..()

		if(Dir != olddir)
			dir = olddir
			set_dir(Dir)

		src.move_speed = world.time - src.l_move_time
		src.l_move_time = world.time
		src.m_flag = 1

		if (oldloc != src.loc && oldloc && oldloc.z == src.z)
			src.last_move = get_dir(oldloc, src.loc)

		// Only update plane if we're located on map
		if(isturf(loc))
			// if we wasn't on map OR our Z coord was changed
			if( !isturf(oldloc) || (get_z(loc) != get_z(oldloc)) )
				update_plane()
				onTransitZ(get_z(oldloc, get_z(loc)))

		SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, oldloc, loc)

// Wrapper of step() that also sets glide size to a specific value.
/proc/step_glide(atom/movable/AM, newdir, glide_size_override)
	AM.set_glide_size(glide_size_override)
	return step(AM, newdir)

//We're changing zlevel
/atom/movable/proc/onTransitZ(old_z, new_z)//uncomment when something is receiving this signal
	/*SEND_SIGNAL(src, COMSIG_MOVABLE_Z_CHANGED, old_z, new_z)
	for(var/atom/movable/AM in src) // Notify contents of Z-transition. This can be overridden IF we know the items contents do not care.
		AM.onTransitZ(old_z,new_z)*/

/mob/living/proc/update_z(new_z) // 1+ to register, null to unregister
	if (registered_z != new_z)
		if (registered_z)
			SSmobs.mob_living_by_zlevel[registered_z] -= src
		if (new_z)
			SSmobs.mob_living_by_zlevel[new_z] += src
		registered_z = new_z

// if this returns true, interaction to turf will be redirected to src instead
/atom/movable/proc/preventsTurfInteractions()
	return FALSE

///Sets the anchored var and returns if it was sucessfully changed or not.
/atom/movable/proc/set_anchored(anchorvalue)
	SHOULD_CALL_PARENT(TRUE)
	if(anchored == anchorvalue || !can_anchor)
		return FALSE
	anchored = anchorvalue
	SEND_SIGNAL(src, COMSIG_ATOM_UNFASTEN, anchored)
	. = TRUE

/atom/movable/proc/update_overlays()
	SHOULD_CALL_PARENT(TRUE)
	. = list()
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_OVERLAYS, .)
