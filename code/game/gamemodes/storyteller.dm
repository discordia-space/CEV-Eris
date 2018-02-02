var/global/list/current_antags = list()
var/global/list/current_factions = list()

/datum/storyteller
	var/config_tag = ""
	var/name = "Storyteller"
	var/welcome = "Welcome"
	var/description = "You shouldn't see this"

	var/event_spawn_timer = 0
	var/event_spawn_stage = 0

	var/min_spawn_delay = 20 MINUTES
	var/max_spawn_delay = 30 MINUTES

	var/min_start_spawn_delay = 10 MINUTES
	var/max_start_spawn_delay = 18 MINUTES

	var/one_role_per_player = TRUE

	var/force_spawn_now = FALSE

	var/weight_randomizer = 0.15

	var/list/processing_events = list()
	var/list/spawn_log = list()

	var/list/dbglist		//Reference to storyevents list for easy getting it by VV
	var/list/spawnparams	//Associated list of values used in log_spawn()

	var/debug_mode = FALSE	//Setting this to TRUE prevents normal storyteller functioning. Use it for testing on local server

	var/crew = 11
	var/heads = 2
	var/sec = 4
	var/eng = 3
	var/med = 4
	var/sci = 5

/datum/storyteller/proc/can_start(var/announce = FALSE)	//when TRUE, proc should output reason, by which it can't start, to world
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

	if(announce)
		if(!engineer && !captain)
			world << "<b><font color='red'>Captain and technomancer are required to start round.</font></b>"
		else if(!engineer)
			world << "<b><font color='red'>Technomancer is required to start round.</font></b>"
		else if(!captain)
			world << "<b><font color='red'>Captain is required to start round.</font></b>"

	return FALSE

/datum/storyteller/proc/announce()
	world << "<b><font size=3>Storyteller is [src.name].</font> <br>[welcome]</b>"

/datum/storyteller/proc/set_up()
	fill_storyevents_list()
	set_timer(rand(min_start_spawn_delay, max_start_spawn_delay))
	events_set_up()
	dbglist = storyevents

/datum/storyteller/proc/events_set_up()
	return

/datum/storyteller/proc/set_timer(var/time)
	event_spawn_timer = world.time + time

/datum/storyteller/proc/process()
	if(force_spawn_now || (event_spawn_timer && event_spawn_timer <= world.time))
		update_crew_count()
		update_event_weights()
		spawnparams = list()
		trigger_event()
		event_spawn_stage++
		force_spawn_now = FALSE

/datum/storyteller/proc/add_processing(var/datum/storyevent/S)
	ASSERT(istype(S))
	processing_events.Add(S)

/datum/storyteller/proc/remove_processing(var/datum/storyevent/S)
	processing_events.Remove(S)

/datum/storyteller/proc/process_events()	//Called in ticker
	for(var/datum/storyevent/S in processing_events)
		if(S.processing)
			S.process()
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

/datum/storyteller/proc/get_event_weight(var/datum/storyevent/R)
	ASSERT(istype(R))

	R.weight_cache = calculate_event_weight(R)
	R.weight_cache *= 1-rand()*weight_randomizer
	return R.weight_cache

/datum/storyteller/proc/trigger_event()
	debug("Called trigger_event() of base type. Fix this shit!")


/proc/storyteller_button()
	if(ticker && ticker.storyteller)
		return "<a href='?src=\ref[ticker.storyteller];panel=1'>\[STORY\]</a>"
	else
		return "<s>\[STORY\]</s>"


