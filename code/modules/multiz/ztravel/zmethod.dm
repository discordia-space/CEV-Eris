/*
	These datums are used to handle ztravel in multiz/movement.dm. That is, vertical movement between
	floors/zlevels. This system is designed to handle jetpacks, climbing, superhuman jumping, etc.
	In future it can be expanded to flight and grappling hooks

	Each vertical_travel_method datum details one possible method of motion

	Each one contains a proc used to query whether the mob is currently able to ztravel via this method
	Each one also contains an optional animation proc which is run asynchronously (in a spawn call)
		This animation proc is used to do pixel offsets, scaling, etc

	For now, one of every possible method is created and used to test, then deleted if it can't run
	This design offers a future possibility of optimisation by having each mob store a list of methods
	which they could possibly use, based on equipment. And only checking those

	The #1 rule when writing a VTM datum: Always call parent, using .=..() at the top of your function
	Unless you're reeeally sure what you're doing
*/
/datum/vertical_travel_method
	//The mob who is attempting to travel
	var/mob/M

	//A thing that we use to aid our travels.
	//in the case of climbing, this would be the wall we climb up
	var/atom/subject

	//The direction we're attempting to travel. This must be UP or DOWN
	var/direction = UP

	//The turf we started in
	var/turf/origin

	//Turf we finish in. if successful
	var/turf/destination

	//The basic amount of time this transition takes, before circumstances are factored in
	//Measured in deciseconds
	var/base_time = 30

	//The actual/total amount of time it will take
	var/duration

	//The world time that the mob started doing the transition
	var/start_time = 0

	//The needhand flag on the do_after
	//This will be true for climbing, but false for jumping and jetpacks
	var/needs_hands = TRUE

	//If true, this vtm will call tick() once every decisecond while it is in process
	var/do_tick = FALSE

	//Text describing what the mob is doing
	var/start_verb_visible = "%m starts moving %dward"
	var/start_verb_personal = "You start moving %dward"

	var/end_verb_visible = "%m arrives from %d2"
	var/end_verb_personal = "You arrive from %d2"


	//If true, the user is trying to ztravel in an environment with gravity
	var/gravity = FALSE


	//Animation cache
	//These values are stored so that we can reset them at the end of an animaiton
	var/prev_x
	var/prev_y
	var/matrix/prev_matrix
	var/prev_alpha
	var/prev_layer
	var/prev_plane
	var/datum/repeating_sound/travelsound

	//Animation related vars


	//Set true by the animation proc when it starts, and routinely checked
	//Set false by the main thread when it finishes or aborts a ztravel operation
	//Animations should check this var and terminate themselves appropriately
	var/animating = FALSE


/datum/vertical_travel_method/New(var/mob/living/L)
	M = L
	cache_values()


/*****************************
	Data Handling
******************************/
/datum/vertical_travel_method/proc/cache_values()
	prev_x = M.pixel_x
	prev_y = M.pixel_y
	prev_matrix = M.transform
	prev_alpha = M.alpha
	prev_layer = M.layer
	prev_plane = M.plane
	origin = get_turf(M)



/datum/vertical_travel_method/proc/reset_values()
	M.pixel_x = prev_x
	M.pixel_y = prev_y
	M.transform = prev_matrix
	M.alpha = prev_alpha
	M.layer = prev_layer
	M.plane = prev_plane
	if (travelsound)
		travelsound.stop()


/datum/vertical_travel_method/proc/calculate_time()
	if (gravity)
		if (direction == UP)
			base_time *= 2
		else
			base_time *= 1.5

	duration = base_time


//Combines testing and starting. Autostarts if possible
/datum/vertical_travel_method/proc/attempt(var/mob/living/L, var/dir)
	.=can_perform(L, dir)
	if (.)
		spawn()
			start()

/datum/vertical_travel_method/proc/can_perform(var/mob/living/L, var/dir)
	if (dir != direction)
		direction = dir

	//Late specification of subject mob
	if (L != M)
		M = L
		cache_values()

	if (!get_destination())
		return FALSE

	return TRUE


/datum/vertical_travel_method/proc/start(var/dir)
	direction = dir
	calculate_time()
	announce_start()

	spawn()
		start_animation()

	spawn()
		handle_ticking()

	if (!do_after(M, time, M, needs_hands))
		abort()
		return
	finish()

/datum/vertical_travel_method/proc/abort()
	animating = FALSE
	if (gravity)
		M.fall_impact()

/datum/vertical_travel_method/proc/finish()
	animating = FALSE
	M.forceMove(destination)
	announce_end()


/datum/vertical_travel_method/proc/get_destination()
	destination = (direction == UP) ? GetAbove(origin) : GetBelow(origin)
	return destination


/*****************************
	Animation and Messages
******************************/
/datum/vertical_travel_method/proc/announce_start()
	var/visible = format_message(start_verb_visible)

	var/personal = format_message(start_verb_personal)

	M.visible_message(SPAN_NOTICE(visible), SPAN_NOTICE(personal))

/datum/vertical_travel_method/proc/announce_end()
	var/visible = format_message(end_verb_visible)

	var/personal = format_message(end_verb_personal)

	M.visible_message(SPAN_NOTICE(visible), SPAN_NOTICE(personal))

/datum/vertical_travel_method/proc/format_message(var/string)
	string = replacetext(string, "%m", M.name)
	string = replacetext(string, "%d3", direction == UP ? "ascen" : "descen")
	string = replacetext(string, "%d2", direction == UP ? "above" : "below")
	string = replacetext(string, "%d", dir2text(direction))
	string = replacetext(string, "%s", subject.name)
	return string


/datum/vertical_travel_method/proc/start_animation()
	animating = TRUE //This must be set true at start, and false when we're done


//Returns a value in the range 0..1, representing progress between start and finish time
/datum/vertical_travel_method/proc/progress()
	return ((world.time - start_time) / duration)

/*****************************
	Ticking
******************************/
//Just a simple loop that sleeps and ticks until the animating var is set false, indicating it should stop
/datum/vertical_travel_method/proc/handle_ticking()
	while(animating)
		tick()
		sleep(1)


/datum/vertical_travel_method/proc/tick()
	return