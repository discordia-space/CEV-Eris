


var/global/list/current_antags = list()
var/global/list/current_factions = list()

/datum/storyteller
	//Strings
	var/config_tag = ""
	var/name = "Storyteller"
	var/welcome = "Welcome"
	var/description = "You shouldn't see this"

	var/one_role_per_player = TRUE

	var/calculate_weights = TRUE
	//Debug and logs

	var/debug_mode = FALSE	//Setting this to TRUE prevents normal storyteller functioning. Use it for testing on local server

	//Misc
	var/force_spawn_now = FALSE
	var/list/processing_events = list()
	var/last_tick = 0
	var/next_tick = 0
	var/tick_interval = 60 SECONDS

	var/crew = 11
	var/heads = 2
	var/sec = 4
	var/eng = 3
	var/med = 4
	var/sci = 5

	var/event_spawn_timer = 0
	var/event_spawn_stage = 0

	//Set values here for starting points
	var/list/points = (
	0, //Mundane
	0, //Moderate
	0, //Major
	110 //Roleset
	)

	//Lists of events. These are built dynamically at runtime
	var/list/event_pool_mundane = list()
	var/list/event_pool_moderate = list()
	var/list/event_pool_major = list()
	var/list/event_pool_roleset = list()

	//Configuration:
	//Things you can set to make a new storyteller
	var/gain_mult_mundane = 1.0
	var/gain_mult_moderate = 1.0
	var/gain_mult_major = 1.0
	var/gain_mult_roleset = 1.0

	var/variance = 0.15 //15% How much point gains are allowed to vary up or down per tick. This helps to keep event triggering times unpredictable
	var/repetition_multiplier = 0.85 //Weights of events are multiplied by this value after they happen, to reduce the chance of multiple instances in short time

	var/event_schedule_delay = 5 MINUTES
	//Once selected, events are not fired immediately, but are scheduled for some random time in the near future
	//This mostly helps to prevent them syncing up and announcements overlapping each other
	//The maximum time between scheduling and firing an event
	//Time is random between 1 decisecond to this

/datum/storyteller/proc/can_start(var/announce = FALSE)	//when TRUE, proc should output reason, by which it can't start, to world
	if(debug_mode)
		return TRUE

	var/engineer = FALSE
	var/captain = FALSE
	for(var/mob/new_player/player in player_list)
		if(player.ready && player.mind)
			if(player.mind.assigned_role == "Captain")
				captain = TRUE
			if(player.mind.assigned_role in list("Technomancer Exultant","Technomancer"))
				engineer = TRUE
			if(captain && engineer)
				return TRUE

	var/tcol = "red"
	if(player_list.len <= 10)
		tcol = "black"

	if(announce)
		if(!engineer && !captain)
			world << "<b><font color='[tcol]'>Captain and technomancer are required to start round.</font></b>"
		else if(!engineer)
			world << "<b><font color='[tcol]'>Technomancer is required to start round.</font></b>"
		else if(!captain)
			world << "<b><font color='[tcol]'>Captain is required to start round.</font></b>"

	if(player_list.len <= 10)
		world << "<i>But there's less than 10 players, so this requirement will be ignored.</i>"
		return TRUE

	return FALSE

/datum/storyteller/proc/announce()
	world << "<b><font size=3>Storyteller is [src.name].</font> <br>[welcome]</b>"

/datum/storyteller/proc/set_up()
	build_event_pools()
	set_timer()
	set_up_events()

/datum/storyteller/proc/set_up_events()
	return

/datum/storyteller/proc/can_tick()
	if (world.time > next_tick)
		return TRUE

/datum/storyteller/proc/set_timer(var/time)
	last_tick = world.time
	next_tick = last_tick + tick_interval

/datum/storyteller/Process()
	if(can_tick())
		update_crew_count()
		update_event_weights()
		trigger_event()
		force_spawn_now = FALSE

/datum/storyteller/proc/add_processing(var/datum/storyevent/S)
	ASSERT(istype(S))
	processing_events.Add(S)

/datum/storyteller/proc/remove_processing(var/datum/storyevent/S)
	processing_events.Remove(S)

/datum/storyteller/proc/process_events()	//Called in ticker
	for(var/datum/storyevent/S in processing_events)
		if(S.processing)
			S.Process()
			if(S.is_ended())
				S.stop_processing(TRUE)

/datum/storyteller/proc/update_objectives()
	for(var/datum/antagonist/A in current_antags)
		if(!A.faction)
			for(var/datum/objective/O in A.objectives)
				O.update_completion()

	for(var/datum/faction/F in current_factions)
		for(var/datum/objective/O in F.objectives)
			O.update_completion()

/datum/storyteller/proc/update_event_weight(var/datum/storyevent/R)
	ASSERT(istype(R))

	R.weight_cache = calculate_event_weight(R)
	//R.weight_cache *= 1-rand()*weight_randomizer
	return R.weight_cache

/datum/storyteller/proc/trigger_event()
	story_debug("Called trigger_event() of base type. Fix this shit!")


/proc/storyteller_button()
	if(SSticker.storyteller)
		return "<a href='?src=\ref[SSticker.storyteller];panel=1'>\[STORY\]</a>"
	else
		return "<s>\[STORY\]</s>"


/*******************
*  Points Handling
********************/

/datum/storyteller/proc/modify_points(var/delta, var/type = 0)
	if (!delta || !isnum(delta))
		return
	//Adds delta points to the specified pool.
	//If type is 0, adds points to all pools
	//Pass a negative delta to subtract points
	if (type)
		points[type] += delta
	else
		for (var/a in points)
			points[a] += delta

/datum/storyteller/proc/handle_points()
	points[EVENT_LEVEL_MUNDANE] += 1 * (gain_mult_mundane) * (rand(1-variance, 1+variance))
	points[EVENT_LEVEL_MODERATE] += 1 * (gain_mult_moderate) * (rand(1-variance, 1+variance))
	points[EVENT_LEVEL_MAJOR] += 1 * (gain_mult_major) * (rand(1-variance, 1+variance))
	points[EVENT_LEVEL_ROLESET] += 1 * (gain_mult_roleset) * (rand(1-variance, 1+variance))
	check_thresholds()

/datum/storyteller/proc/check_thresholds()
	while (points[EVENT_LEVEL_MUNDANE] >= POOL_THRESHOLD_MUNDANE)
		handle_event(EVENT_LEVEL_MUNDANE)
	while (points[EVENT_LEVEL_MODERATE] >= POOL_THRESHOLD_MODERATE)
		handle_event(EVENT_LEVEL_MODERATE)
	while (points[EVENT_LEVEL_MAJOR] >= POOL_THRESHOLD_MAJOR)
		handle_event(EVENT_LEVEL_MAJOR)
	while (points[EVENT_LEVEL_ROLESET] >= POOL_THRESHOLD_ROLESET)
		handle_event(EVENT_LEVEL_ROLESET)



/*******************
*  Event Handling
********************/

//First we figure out which pool we're going to take an event from
/datum/storyteller/proc/handle_event(var/event_type)
	//This is a buffer which will hold a copy of the list we choose.
	//We will be modifying it and don't want those modifications to go back to the source
	var/list/temp_pool
	switch(event_type)
		if (EVENT_LEVEL_MUNDANE)
			temp_pool = event_pool_mundane.Copy()
		if (EVENT_LEVEL_MODERATE)
			temp_pool = event_pool_moderate.Copy()
		if (EVENT_LEVEL_MAJOR)
			temp_pool = event_pool_major.Copy()
		if (EVENT_LEVEL_ROLESET)
			temp_pool = event_pool_roleset.Copy()

	if (!temp_pool || !temp_pool.len)
		world << "ERROR: No events in pool [event_type]"
		return

	var/datum/storyevent/choice = null
	//We pick an event from the pool at random, and check if it's allowed to run
	while (choice == null)
		choice = pickweight(temp_pool)
		if (!choice.can_trigger(event_type))
			//If its not, we'll remove it from the temp pool and then pick another
			temp_pool -= choice
			choice = null

		if (!temp_pool.len)
			world << "ERROR: No useable events in pool [event_type]"
			return
			//Repeat until we find one which is allowed, or the pool is empty

	if (!choice)
		world << "ERROR: Somehow failed to find an event [event_type]"
		return

	//Once we get here, we've found an event which can run!


	//If it is allowed to run, we'll deduct its cost from our appropriate point score, and schedule it for triggering
	points[event_type] -= choice.get_cost(event_type)
	schedule_event(choice, event_type)

	//When its trigger time comes, the event will once again check if it can run
	//If it can't it will cancel itself and refund the points it cost

/datum/storyteller/proc/schedule_event(var/datum/storyevent/C, var/type)
	var/handle = addtimer(CALLBACK(GLOBAL_PROC, .proc/fire_event, C, event_type), rand(1, event_schedule_delay), TIMER_STOPPABLE)
	scheduled_events.Add(list(C), type, handle)


/****************************
*  Pool and Weight handling
*****************************/
//Builds up this storyteller's local event pools.
//This should be called only once for each new storyteller
/datum/storyteller/proc/build_event_pools()
	event_pool_mundane.Cut()
	event_pool_moderate.Cut()
	event_pool_major.Cut()
	event_pool_roleset.Cut()
	for (var/datum/storyevent/a in storyevents)
		if (!a.enabled)
			continue

		var/new_weight = calculate_event_weight(a)
		//Reduce the weight based on number of ocurrences.
		//This is mostly for the sake of midround handovers
		if (a.ocurrences >= 1)
			new_weight *= repetition_multiplier ** a.ocurrences

		//We setup the event pools as an associative list in preparation for a pickweight call
		if (EVENT_LEVEL_MUNDANE in a.event_pools)
			event_pool_mundane[a] = new_weight
		if (EVENT_LEVEL_MODERATE in a.event_pools)
			event_pool_moderate[a] = new_weight
		if (EVENT_LEVEL_MAJOR in a.event_pools)
			event_pool_major[a] = new_weight
		if (EVENT_LEVEL_ROLESET in a.event_pools)
			event_pool_roleset[a] = new_weight


/datum/storyteller/proc/update_event_weights()
	event_pool_mundane = update_pool_weights(event_pool_mundane)
	event_pool_moderate = update_pool_weights(event_pool_moderate)
	event_pool_major = update_pool_weights(event_pool_major)
	event_pool_roleset = update_pool_weights(event_pool_roleset)

/datum/storyteller/proc/update_pool_weights(var/list/pool)
	for(var/datum/storyevent/a in pool)
		var/new_weight = calculate_event_weight(a)
		if (a.ocurrences >= 1)
			new_weight *= repetition_multiplier ** a.ocurrences

		pool[a] = new_weight
	return pool