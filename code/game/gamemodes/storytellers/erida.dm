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

	if(debug_mode)
		deck_size += heads*4
		deck_size += sec*3
		deck_size += eng*2
		deck_size += med+sci
		return

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


/datum/storyteller/erida/proc/pick_storyevent(var/list/L)
	var/max = 0
	var/target = 0
	for(var/datum/storyevent/S in L)
		max += S.weight_cache

	target = rand()*max
	max = 0

	for(var/datum/storyevent/S in L)
		max += S.weight_cache
		if(max > target)
			return S

/datum/storyteller/erida/trigger_event()
	if(!mad && prob(10))
		mad = TRUE
		mad_stages = rand(1,3)

	calculate_deck_size()
	if(mad)
		deck_size *= 2

	var/list/sorted = list()
	for(var/datum/storyevent/S in storyevents)
		if(S.can_spawn() && S.weight_cache > 0)
			sorted.Add(S)


	debugmode("Deck size=[deck_size]; mad=[mad]; variants available=[sorted.len]")
	var/currdeck = 0
	var/list/spawned = list()
	spawnparams["deck_full"] = TRUE
	while(currdeck < deck_size)
		var/datum/storyevent/S = pick_storyevent(sorted)
		if(!S)
			debug("Storyteller is out of storyevents. [spawned.len] events spawned")
			spawnparams["deck_full"] = FALSE
			break

		if(S.cost + currdeck > deck_size)
			sorted.Remove(S)

		debugmode("Debug-spawning [S.id] with weight [S.weight_cache]; Currdeck: [currdeck]([currdeck+S.cost])/[deck_size]")

		if(S.create())
			currdeck += S.cost
			spawned.Add(S.id)
			if(!S.multispawn)
				sorted.Remove(S)
		else if(debug_mode)
			debugmode("[S.id] fake-created")
			currdeck += S.cost
			S.spawn_times++

	sorted.Cut()

	spawnparams["mad"] = mad
	if(mad)
		spawnparams["mad_stage"] = mad_stages
	spawnparams["deck_size"] = deck_size
	spawnparams["deck_used"] = currdeck

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

	log_spawn(spawned)

	return TRUE
