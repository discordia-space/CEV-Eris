/datum/storyteller/erida
	config_tag = "erida"
	name = "Erida"
	welcome = "Welcome to CEV Eris!"
	description = "Experimental storyteller based on card deck system"

	weight_randomizer = 0.15

	min_spawn_delay = 20 MINUTES
	max_spawn_delay = 30 MINUTES

	var/minimal_weight = 0.3
	var/deck_size = 0

	var/mad = FALSE
	var/mad_stages = 0

/datum/storyteller/erida/events_set_up()
	for(var/datum/storyevent/S in storyevents)
		S.cost = rand(S.min_cost,S.max_cost)

/datum/storyteller/erida/proc/calculate_deck_size()
	deck_size = 0
	for(var/mob/M in player_list)
		if(M.client && (M.mind && !M.mind.antagonist.len) && M.stat != DEAD && (ishuman(M) || isrobot(M) || isAI(M)))
			var/datum/job/job = job_master.GetJob(M.mind.assigned_role)
			if(job)
				if(job.head_position)
					deck_size += 4
				else if(job.department == "Engineering")
					deck_size += 2
				else if(job.department == "Security")
					deck_size += 3
				else
					deck_size += 1

	//Fake values for test
	if(debug_mode)
		deck_size = 0
		deck_size += f_heads*4
		deck_size += f_sec*3
		deck_size += f_eng*2
		deck_size += f_med+f_sci

/datum/storyteller/erida/trigger_event()
	if(!mad && prob(10))
		mad = TRUE
		mad_stages = rand(1,3)

	calculate_deck_size()
	if(mad)
		deck_size *= 2

	var/list/sorted = list()
	for(var/datum/storyevent/S in storyevents)
		var/min_w = minimal_weight
		if(mad)
			min_w = minimal_weight * 0.2
		if(S.can_spawn() && S.weight_cache >= min_w)
			if(!sorted.len)
				sorted.Insert(rand(1,sorted.len),S)
			else
				sorted.Add(S)


	//world << "[sorted.len] spawn variants available"
	//world << "Deck size is [deck_size]"
	var/currdeck = 0
	for(var/datum/storyevent/S in sorted)
		if(currdeck + S.cost < deck_size)
			//world << "Spawning [S.id] with weight [S.weight_cache]... Currdeck: [currdeck] ([currdeck+S.cost])"
			//currdeck += S.cost
			//S.spawn_times++
			if(S.create())
				//world << "^ Success!"
				currdeck += S.cost
	event_spawn_stage++

	sorted.Cut()

	if(mad_stages)
		mad_stages--
	else
		mad = FALSE

	if(currdeck == 0)
		set_timer(rand(1,3) MINUTES)
	else
		if(mad)
			set_timer(rand(7,15) MINUTES)

		else
			set_timer(rand(20,35) MINUTES)

	return TRUE
