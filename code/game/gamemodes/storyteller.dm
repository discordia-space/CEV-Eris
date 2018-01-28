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

	var/list/dbglist
	//Fake crew values for test
	var/debug_mode = FALSE
	var/f_crew = 11
	var/f_heads = 2
	var/f_sec = 4
	var/f_eng = 3
	var/f_med = 4
	var/f_sci = 5

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
		force_spawn_now = FALSE
		update_event_weights()
		trigger_event()

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

/datum/storyteller/proc/calculate_event_weight(var/datum/storyevent/R)
	var/weight = 1

	var/crew = 0
	var/heads = 0
	var/sec = 0
	var/eng = 0
	var/med = 0
	var/sci = 0

	for(var/mob/M in player_list)
		if(M.client && (M.mind && !M.mind.antagonist.len) && M.stat != DEAD && (ishuman(M) || isrobot(M) || isAI(M)))
			var/datum/job/job = job_master.GetJob(M.mind.assigned_role)
			if(job)
				crew++
				if(job.head_position)
					heads++
				if(job.department == "Engineering")
					eng++
				if(job.department == "Security")
					sec++
				if(job.department == "Medical")
					med++
				if(job.department == "Science")
					sci++

	//Fake crew values for tests
	if(debug_mode)
		crew = f_crew
		heads = f_heads
		sec = f_sec
		eng = f_eng
		med = f_med
		sci = f_sci


	weight *= weight_mult(crew,R.req_crew,R.max_crew_diff_lower,R.max_crew_diff_higher,TRUE)
	weight *= weight_mult(heads,R.req_heads,R.max_crew_diff_lower,R.max_crew_diff_higher,TRUE)
	weight *= weight_mult(sec,R.req_sec,R.max_crew_diff_lower,R.max_crew_diff_higher,TRUE)
	weight *= weight_mult(eng,R.req_eng,R.max_crew_diff_lower,R.max_crew_diff_higher,TRUE)
	weight *= weight_mult(med,R.req_med,R.max_crew_diff_lower,R.max_crew_diff_higher,TRUE)
	weight *= weight_mult(sci,R.req_sci,R.max_crew_diff_lower,R.max_crew_diff_higher,TRUE)

	weight *= weight_mult(event_spawn_stage,R.req_stage,R.max_stage_diff_lower,R.max_stage_diff_higher,TRUE)

	weight *= weight_mult(R.spawn_times,0,0,R.spawn_times_max)

	weight = R.get_special_weight(weight)

	return weight

/datum/storyteller/proc/weight_mult(var/val, var/req, var/min, var/max, var/atl = FALSE)
	if(req < 0)
		return 1
	if(val < min || (!atl && val > max))
		return 0
	if(atl && req < val)
		return 1
	var/mod = (min+max/2)**2
	return max(mod-(abs(val-req)**2),0)/mod

/datum/storyteller/proc/update_event_weights()
	for(var/datum/storyevent/R in storyevents)
		get_event_weight(R)

/datum/storyteller/proc/trigger_event()
	var/datum/storyevent/E
	for(var/datum/storyevent/R in storyevents)
		if(R.can_spawn())
			if(!E || R.weight_cache > E.weight_cache)
				E = R

	if(E.create())
		set_timer(min_spawn_delay, max_spawn_delay)
		event_spawn_stage++
		return TRUE
	else
		set_timer(rand(1 MINUTES,3 MINUTES))
		return FALSE


/proc/storyteller_button()
	if(ticker && ticker.storyteller)
		return "<a href='?src=\ref[ticker.storyteller];panel=1'>\[STORY\]</a>"
	else
		return "<s>\[STORY\]</s>"


