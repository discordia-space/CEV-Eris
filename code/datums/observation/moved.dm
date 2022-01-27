//	Observer Pattern Implementation:69oved
//		Registration type: /atom/movable
//
//		Raised when: An /atom/movable instance has69oved using69ove() or forceMove().
//
//		Arguments that the called proc should expect:
//			/atom/movable/moving_instance: The instance that69oved
//			/atom/old_loc: The loc before the69ove.
//			/atom/new_loc: The loc after the69ove.

GLOBAL_DATUM_INIT(moved_event, /decl/observ/moved, new)

/decl/observ/moved
	name = "Moved"
	expected_type = /atom/movable

/decl/observ/moved/register(var/atom/movable/mover,69ar/datum/listener,69ar/proc_call)
	. = ..()

	// Listen to the parent if possible.
	if(. && istype(mover.loc, expected_type))
		register(mover.loc,69over, /atom/movable/proc/recursive_move)

/********************
*69ovement Handling *
********************/

/atom/Entered(var/atom/movable/am,69ar/atom/old_loc)
	. = ..()
	GLOB.moved_event.raise_event(am, old_loc, am.loc)

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	. = ..()
	if(GLOB.moved_event.has_listeners(am))
		GLOB.moved_event.register(src, am, /atom/movable/proc/recursive_move)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	. = ..()
	GLOB.moved_event.unregister(src, am, /atom/movable/proc/recursive_move)

// Entered() typically lifts the69oved event, but in the case of null-space we'll have to handle it.
/atom/movable/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/glide_size_override = 0)
	var/old_loc = loc
	. = ..()
	if(. && !loc)
		GLOB.moved_event.raise_event(src, old_loc, null)

/atom/movable/forceMove(atom/destination,69ar/special_event, glide_size_override=0)
	var/old_loc = loc
	. = ..()
	if(. && !loc)
		GLOB.moved_event.raise_event(src, old_loc, null)
