// This ideally would be part of a physics system that handles everything step by step instead of separated , but
// im too lazy to actually code it in a meaningfull amount of time.
// This is better than sleepy throwing anyway.


#define I_TARGET 1 /// Index for target
#define I_SPEED 2 /// Index for speed
#define I_RANGE 3 /// Index for range
#define I_MOVED 4 /// Index for amount of turfs we already moved by

SUBSYSTEM_DEF(throwing)
	name = "throwing"
	wait = 1 // very small
	priority = FIRE_PRIORITY_THROWING
	var/list/throwing_queue[50]

/datum/controller/subsystem/throwing/fire(resumed = FALSE)
	for(var/atom/movable/thing as anything in throwing_queue)
		if(MC_TICK_CHECK)
			return
		if(QDELETED(thing))
			throwing_queue -= thing
			continue
		if(!istype(thing.loc, /turf))
			throwing_queue -= thing
			thing.throwing = FALSE
			thing.thrower = null
			thing.throw_source = null
			continue
		var/tiles_to_move = throwing_queue[thing][I_SPEED]
		if((get_area(thing.loc)):has_gravity)
			if(tiles_to_move + throwing_queue[thing][I_MOVED] > throwing_queue[thing][I_RANGE])
				tiles_to_move = throwing_queue[thing][I_RANGE] - throwing_queue[thing][I_MOVED] - tiles_to_move
		if(tiles_to_move < 1)
			throwing_queue -= thing
			thing.throwing = FALSE
			thing.thrower = null
			thing.throw_source = null
			var/turf/new_loc = get_turf(thing)
			if(new_loc && isobj(src))
				thing.throw_impact(new_loc,throwing_queue[thing][I_SPEED])
				new_loc.Entered(src)
			continue
		var/dist_x = abs(throwing_queue[thing][I_TARGET]:x - thing.x)
		var/dist_y = abs(throwing_queue[thing][I_TARGET]:y - thing.y)
		var/dx = throwing_queue[thing][I_TARGET]:x > thing.x ? EAST : WEST
		var/dy = throwing_queue[thing][I_TARGET]:y > thing.y ? NORTH : SOUTH
		var/turf/to_move
		while(tiles_to_move > 0)
			if(QDELETED(thing))
				throwing_queue -= thing
				break
			if(!istype(thing.loc, /turf) || !thing.throwing)
				throwing_queue -= thing
				thing.throwing = FALSE
				thing.thrower = null
				thing.throw_source = null
				break
			if(dist_y > dist_x)
				to_move = get_step(thing, dy)
				if(to_move)
					thing.Move(to_move, dy)
			else
				to_move = get_step(thing, dx)
				if(to_move)
					thing.Move(to_move, dx)
			// The proc below is very poorly written and i couldn't be bothered to rewrite all of its underlying
			// code. Its why i use thing.throwing to actually check wheter we should keep going or not.
			thing.hit_check(throwing_queue[thing][I_SPEED])
			// reached a map corner or something we can't move towards
			if(!to_move)
				throwing_queue -= thing
				thing.throwing = FALSE
				thing.thrower = null
				thing.throw_source = null
				var/turf/new_loc = get_turf(thing)
				if(new_loc && isobj(src))
					thing.throw_impact(new_loc,throwing_queue[thing][I_SPEED])
					new_loc.Entered(src)
				break
			tiles_to_move--
			throwing_queue[thing][I_MOVED]++

	/*
	if(!target || !src)	return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target

	set_dir(pick(cardinal))
	src.throwing = 1
	if(target.allow_spin && src.allow_spin)
		SpinAnimation(5,1)
	src.thrower = thrower
	src.throw_source = get_turf(src)	//store the origin turf

//	if(usr)
//		if(HULK in usr.mutations)
//			src.throwing = 2 // really strong throw!

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
*/
