/datum/storyteller/erida
	config_tag = "erida"
	name = "Erida"
	welcome = "Welcome to CEV Eris!"
	description = "Experimental storyteller based on card deck system"

	var/deck_size = 0

	var/calculate_deck = TRUE	//If FALSE, erida won't calculate deck_size, keeping value

	var/mad = FALSE

/datum/storyteller/erida/set_up_events()
	for(var/datum/storyevent/S in storyevents)
		S.cost = rand(S.min_cost,S.max_cost)

/datum/storyteller/erida/proc/calculate_deck_size()
	if(!calculate_deck)
		return

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

	if(!L.len)
		return null

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
		mad = rand(1,3)

	calculate_deck_size()
	if(mad)
		deck_size *= 2

	var/list/sorted = list()
	for(var/datum/storyevent/S in storyevents)
		if(S.can_spawn() && S.weight_cache > 0)
			sorted.Add(S)


	story_debug("Stage=[event_spawn_stage]; Deck size=[deck_size]; mad=[mad]; variants available=[sorted.len]")
	var/currdeck = 0
	var/list/spawned = list()
	while(currdeck < deck_size)
		var/datum/storyevent/S = pick_storyevent(sorted)
		if(!S)
			story_debug("Storyteller is out of storyevents. [spawned.len] events spawned")
			break

		if(S.cost + currdeck > deck_size)
			sorted.Remove(S)

		if(debug_mode)
			story_debug("Debug-spawning [S.id] with weight [S.weight_cache]; Currdeck: [currdeck]([currdeck+S.cost])/[deck_size]")

		if(S.create())
			story_debug("Spawned [S.id] with weight [S.weight_cache]; Currdeck: [currdeck]([currdeck+S.cost])/[deck_size]")
			currdeck += S.cost
			spawned.Add(S.id)
			if(!S.multispawn)
				sorted.Remove(S)
		else
			if(debug_mode)
				story_debug("[S.id] fake-created")
				currdeck += S.cost
				spawned.Add(S.id)
				S.spawn_times++
				if(!S.multispawn)
					sorted.Remove(S)
			else
				sorted.Remove(S)

		update_event_weight(S)
		if(S.weight_cache <= 0)
			sorted.Remove(S)

	sorted.Cut()

	if(mad)
		mad--

	if(!currdeck)
		set_timer(rand(1,3) MINUTES)
	else
		if(mad)
			set_timer(rand(7,10) MINUTES)

		else
			set_timer(rand(20,35) MINUTES)

	return TRUE


/datum/storyteller/erida/storyteller_panel_extra()
	var/data = ""
	var/ehref = "<a href='?src=\ref[src]:edit_deck=1'>\[SET\]</a>"
	data += "<br>Deck size: <b>[deck_size]</b>[calculate_deck?"":" [ehref]"] <b><a href='?src=\ref[src];toggle_deck=1'>[calculate_deck?"\[AUTO\]":"\[MANUAL\]"]</a></b>"
	data +=	"<br>Mad mode: [mad?"[mad] stages":"no"] <b><a href='?src=\ref[src];edit_mad=1'>\[SET\]</a></b>"

	return data

/datum/storyteller/erida/topic_extra(href, href_list)
	if(href_list["edit_deck"])
		deck_size = input("Enter new deck size.","Deck edit",deck_size) as num

	if(href_list["toggle_deck"])
		calculate_deck = !calculate_deck

	if(href_list["edit_mad"])
		mad = input("Enter new mad length (0 to disable)","Mad mode",mad) as num
		if(mad < 0)
			mad = 0
