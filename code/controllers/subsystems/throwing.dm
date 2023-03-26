// This ideally would be part of a physics system that handles everything step by step instead of separated , but
// im too lazy to actually code it in a meaningfull amount of time.
// This is better than sleepy throwing anyway.


#define I_TARGET 1 /// Index for target
#define I_SPEED 2 /// Index for speed
#define I_RANGE 3 /// Index for range
#define I_MOVED 4 /// Index for amount of turfs we alreathrowing_queue[thing][I_DY] moved by
#define I_DIST_X 5
#define I_DIST_Y 6
#define I_DX 7
#define I_DY 8
#define I_ERROR 9
#define I_TURF_CLICKED 10
#define I_THROWFLAGS 11

SUBSYSTEM_DEF(throwing)
	name = "throwing"
	wait = 1 // very small
	priority = FIRE_PRIORITY_THROWING
	var/list/throwing_queue = list()

/datum/controller/subsystem/throwing/fire(resumed = FALSE)
	for(var/atom/movable/thing as anything in throwing_queue)
		//if(MC_TICK_CHECK)
		//	return
		if(QDELETED(thing))
			throwing_queue -= thing
			continue
		if(!istype(thing.loc, /turf))
			thing.throwing = FALSE
			thing.thrower = null
			thing.throw_source = null
			thing.pass_flags -= throwing_queue[thing][I_THROWFLAGS]
			throwing_queue -= thing
			continue
		var/tiles_to_move = throwing_queue[thing][I_SPEED]
		var/area/cur_area = get_area(thing.loc)
		if(cur_area && cur_area.has_gravity)
			if(tiles_to_move + throwing_queue[thing][I_MOVED] > throwing_queue[thing][I_RANGE])
				tiles_to_move = min(throwing_queue[thing][I_RANGE] - throwing_queue[thing][I_MOVED], tiles_to_move)
		if(tiles_to_move < 1)
			thing.throwing = FALSE
			thing.thrower = null
			thing.throw_source = null
			thing.pass_flags -= throwing_queue[thing][I_THROWFLAGS]
			var/turf/new_loc = get_turf(thing)
			if(new_loc && isobj(src))
				thing.throw_impact(new_loc,throwing_queue[thing][I_SPEED])
				new_loc.Entered(src)
			throwing_queue -= thing
			continue
		var/turf/to_move
		while(tiles_to_move > 0)
			if(QDELETED(thing))
				throwing_queue -= thing
				break
			if(!istype(thing.loc, /turf))
				thing.throwing = FALSE
			cur_area = get_area(thing.loc)
			if(cur_area && cur_area.has_gravity)
				if(thing.loc == throwing_queue[thing][I_TURF_CLICKED])
					thing.throwing = FALSE
			if(!thing.throwing)
				thing.thrower = null
				thing.throw_source = null
				thing.pass_flags -= throwing_queue[thing][I_THROWFLAGS]
				throwing_queue -= thing
				break


			if(throwing_queue[thing][I_DIST_X] > throwing_queue[thing][I_DIST_Y])
				if(throwing_queue[thing][I_ERROR] < 0)
					to_move = get_step(thing, throwing_queue[thing][I_DY])
					throwing_queue[thing][I_ERROR] += throwing_queue[thing][I_DIST_X]
				else
					to_move = get_step(thing, throwing_queue[thing][I_DX])
					throwing_queue[thing][I_ERROR] -= throwing_queue[thing][I_DIST_Y]
			else
				if(throwing_queue[thing][I_ERROR] < 0)
					to_move = get_step(thing, throwing_queue[thing][I_DX])
					throwing_queue[thing][I_ERROR] += throwing_queue[thing][I_DIST_Y]
				else
					to_move = get_step(thing, throwing_queue[thing][I_DY])
					throwing_queue[thing][I_ERROR] -= throwing_queue[thing][I_DIST_X]
			if(!to_move)
				thing.throwing = FALSE
				thing.thrower = null
				thing.throw_source = null
				var/turf/new_loc = get_turf(thing)
				thing.pass_flags -= throwing_queue[thing][I_THROWFLAGS]
				if(new_loc && isobj(src))
					thing.throw_impact(new_loc,throwing_queue[thing][I_SPEED])
					new_loc.Entered(src)
				throwing_queue -= thing
				break
			else
				thing.Move(to_move)
			// The proc below is very poorly written and i couldn't be bothered to rewrite all of its underlying
			// code. Its why i use thing.throwing to actually check wheter we should keep going or not.
			// reached a map corner or something we can't move towards
			thing.hit_check(throwing_queue[thing][I_SPEED])
			tiles_to_move--
			throwing_queue[thing][I_MOVED]++
			to_move = null
