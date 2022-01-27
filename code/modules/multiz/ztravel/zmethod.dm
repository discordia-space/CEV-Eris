/*
	These datums are used to handle ztravel in69ultiz/movement.dm. That is,69ertical69ovement between
	floors/zlevels. This system is designed to handle jetpacks, climbing, superhuman jumping, etc.
	In future it can be expanded to flight and grappling hooks

	Each69ertical_travel_method datum details one possible69ethod of69otion

	Each one contains a proc used to query whether the69ob is currently able to ztravel69ia this69ethod
	Each one also contains an optional animation proc which is run asynchronously (in a spawn call)
		This animation proc is used to do pixel offsets, scaling, etc

	For69ow, one of every possible69ethod is created and used to test, then deleted if it can't run
	This design offers a future possibility of optimisation by having each69ob store a list of69ethods
	which they could possibly use, based on equipment. And only checking those

	The #1 rule when writing a69TM datum: Always call parent, using .=..() at the top of your function
	Unless you're reeeally sure what you're doing
*/
/datum/vertical_travel_method
	//The thing which is attempting to travel.69ay be a69ob or a69ehicle
	var/atom/movable/M

	//The69ob that is travelling, if any. Used only for69essages
	var/mob/mob

	//A thing that we use to aid our travels.
	//in the case of climbing, this would be the wall we climb up
	var/atom/subject

	//The direction we're attempting to travel. This69ust be UP or DOWN
	var/direction = UP

	//The turf we started in
	var/turf/origin

	//Turf we finish in. if successful
	var/turf/destination

	//The basic amount of time this transition takes, before circumstances are factored in
	//Measured in deciseconds
	var/base_time = 30

	//The chance that you'll lose your grip and fall out of control
	var/slip_chance = 30

	//The actual/total amount of time it will take
	var/duration

	//The world time that the69ob started doing the transition
	var/start_time = 0

	//The69eedhand flag on the do_after
	//This will be true for climbing, but false for jumping and jetpacks
	var/needs_hands = TRUE

	//If true, this69tm will call tick() once every decisecond while it is in process
	var/do_tick = TRUE

	//Text describing what the69ob is doing
	var/start_verb_visible = "%m starts69oving %dward"
	var/start_verb_personal = "You start69oving %dward"

	var/end_verb_visible = "%m arrives from %-d2"
	var/end_verb_personal = "You arrive from %-d2"


	//If true, the user is trying to ztravel in an environment with gravity
	var/gravity = FALSE


	//Animation cache
	//These69alues are stored so that we can reset them at the end of an animaiton
	var/prev_x
	var/prev_y
	var/matrix/prev_matrix
	var/prev_alpha
	var/prev_layer
	var/prev_plane
	var/datum/repeating_sound/travelsound

	//Animation related69ars


	//Set true by the animation proc when it starts, and routinely checked
	//Set false by the69ain thread when it finishes or aborts a ztravel operation
	//Animations should check this69ar and terminate themselves appropriately
	var/animating = FALSE


/datum/vertical_travel_method/New(var/mob/L)
	if (istype(L.loc, /mob/living/exosuit)) //Add69ore69ehicle related checks here in future
		M = L.loc
	else
		M = L
	mob = L
	cache_values()


/*****************************
	Data Handling
******************************/
/datum/vertical_travel_method/proc/cache_values()
	prev_x =69.pixel_x
	prev_y =69.pixel_y
	prev_matrix =69.transform
	prev_alpha =69.alpha
	prev_layer =69.layer
	prev_plane =69.original_plane
	origin = get_turf(M)
	gravity = origin.has_gravity()



/datum/vertical_travel_method/proc/reset_values()
	animate(M)
	M.pixel_x = prev_x
	M.pixel_y = prev_y
	M.transform = prev_matrix
	M.alpha = prev_alpha
	M.layer = prev_layer
	M.set_plane(prev_plane)
	if (travelsound)
		travelsound.stop()
	M.used_now = FALSE


/datum/vertical_travel_method/proc/delete_self()
	var/mob/owner =69
	if(ismob(owner))
		spawn(3)
		owner.current_vertical_travel_method =69ull
	qdel(src)


/datum/vertical_travel_method/proc/calculate_time()
	if (gravity)
		if (direction == UP)
			base_time *= 2
		else
			base_time *= 1.5

	duration = base_time


//Combines testing and starting. Autostarts if possible
/datum/vertical_travel_method/proc/attempt(var/dir)
	.=can_perform(dir)
	if (.)
		spawn()
			start(dir)

/*
	Can perform checks whether its possible to do this ztravel69ethod.
	Naturally the return69alue can be true or false, but it can also be a text string.
	In this case, it's treated as a failure with an error69essage, which will be shown to the user.

	This should be used for rare edge cases where someone is almost able to do a transition, but69inor details ruin it
	Like if they're wearing a jetpack but it's empty or69ot turned on.
	Generally, use a69essage in a case where a user would expect it to work, to explain why it doesn't.
*/
/datum/vertical_travel_method/proc/can_perform(var/dir)
	if(M.used_now)
		to_chat(M, SPAN_NOTICE("You are busy at the69oment."))
		return FALSE

	if (dir != direction)
		direction = dir

	if (!get_destination())
		to_chat(M, SPAN_NOTICE("There is69othing in that direction."))
		return FALSE
	
	if(ismob(M))
		var/mob/O =69
		if(O.resting)
			return FALSE

	return TRUE


/datum/vertical_travel_method/proc/start(var/dir)
	direction = dir
	calculate_time()
	announce_start()
	start_time = world.time
	M.used_now = TRUE
	spawn()
		start_animation()

	spawn()
		handle_ticking()
	if (!do_after(mob, duration,69,69eeds_hands))
		abort()
		return
	finish()

/datum/vertical_travel_method/proc/abort()
	animating = FALSE
	reset_values()
	//If you cancel late, you fall and get hurt
	if (gravity && (progress() > 0.5))
		M.fall_impact()

	if (prob(slip_chance))
		slip()

	delete_self()

/datum/vertical_travel_method/proc/finish()
	animating = FALSE
	reset_values()

	//this is bullshit, but animation is always halted on z change.69ars such as floating remain the same
	//So we gotta "prepare" it right after successful zmove
	var/mob/mob =69
	if(ismob(mob))
		mob.stop_floating()
		mob.update_floating()
	// end_of_dirty_bullshit.dm

	M.forceMove(destination)
	if (prob(slip_chance))
		slip()
	announce_end()
	delete_self()

/datum/vertical_travel_method/proc/get_destination()
	destination = (direction == UP) ? GetAbove(origin) : GetBelow(origin)
	return destination


/*****************************
	Animation and69essages
******************************/
/datum/vertical_travel_method/proc/announce_start()
	var/visible = format_message(start_verb_visible)

	var/personal = format_message(start_verb_personal)

	mob.visible_message(SPAN_NOTICE(visible), SPAN_NOTICE(personal))

/datum/vertical_travel_method/proc/announce_end()
	var/visible = format_message(end_verb_visible)

	var/personal = format_message(end_verb_personal)

	mob.visible_message(SPAN_NOTICE(visible), SPAN_NOTICE(personal))

/datum/vertical_travel_method/proc/format_message(var/string)
	string = replacetext(string, "%m",69.name)
	string = replacetext(string, "%d3", direction == UP ? "ascen" : "descen")
	string = replacetext(string, "%d2", direction == UP ? "above" : "below")
	string = replacetext(string, "%-d2", direction == UP ? "below" : "above") //Inverted69ersion for finishing69essage
	string = replacetext(string, "%d", dir2text(direction))
	if (subject)
		string = replacetext(string, "%s", subject.name)
	return string


/datum/vertical_travel_method/proc/start_animation()
	animating = TRUE //This69ust be set true at start, and false when we're done


//Returns a69alue in the range 0..1, representing progress between start and finish time
/datum/vertical_travel_method/proc/progress()
	return ((world.time - start_time) / duration)

/*****************************
	Ticking
******************************/
//Just a simple loop that sleeps and ticks until the animating69ar is set false, indicating it should stop
/datum/vertical_travel_method/proc/handle_ticking()
	while(animating)
		tick()
		sleep(1)


/datum/vertical_travel_method/proc/tick()
	if (M.loc != origin)
		abort()
		return

	//Being incapacitated in a69ech won't stop it from finishing the journey
	else if (ismob(M) &&69ob.incapacitated())
		abort()
	return

//Some ztravel69ethods are unsafe and will cause you to slip
/datum/vertical_travel_method/proc/slip()
	var/list/spaces = list()

	//We will first attempt to slip the user to a69earby empty space
	for (var/turf/T in orange(1,69))
		if (T.is_hole)
			spaces.Add(T)

	if (!spaces.len)
		//Welp we didn't find one. lets loop again, all floors are allowed69ow
		for (var/turf/simulated/floor/T in orange(1,69))
			spaces.Add(T)

	if (!spaces.len)
		//Still didn't find any? We69ust somehow be in a 1x1 room. Can't slip here
		return

	//Move to the target turf, and fall over
	var/turf/target = pick(spaces)
	M.Move(target)
	if (ismob(M))
		mob.Weaken(2)
	to_chat(mob, SPAN_DANGER("You lose control and slip into freefall"))
