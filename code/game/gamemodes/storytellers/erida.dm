/datum/storyteller/erida
	config_tag = "erida"
	name = "Erida"
	welcome = "Welcome to CEV Eris!"
	description = "Experimental storyteller based on card deck system"

	var/deck_size = 0

	var/calculate_deck = TRUE	//If FALSE, erida won't calculate deck_size, keeping69alue

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
		deck_size +=69ed+sci
		return

	for(var/mob/M in GLOB.player_list)
		if(M.client && (M.mind && !M.mind.antagonist.len) &&69.stat != DEAD && (ishuman(M) || isrobot(M) || isAI(M)))
			var/datum/job/job = SSjob.GetJob(M.mind.assigned_role)
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


	story_debug("Stage=69event_spawn_stage69; Deck size=69deck_size69;69ad=69mad69;69ariants available=69sorted.len69")
	var/currdeck = 0
	var/list/spawned = list()
	while(currdeck < deck_size)
		var/datum/storyevent/S = pick_storyevent(sorted)
		if(!S)
			story_debug("Storyteller is out of storyevents. 69spawned.len69 events spawned")
			break

		if(S.cost + currdeck > deck_size)
			sorted.Remove(S)

		if(debug_mode)
			story_debug("Debug-spawning 69S.id69 with weight 69S.weight_cache69; Currdeck: 69currdeck69(69currdeck+S.cost69)/69deck_size69")

		if(S.create())
			story_debug("Spawned 69S.id69 with weight 69S.weight_cache69; Currdeck: 69currdeck69(69currdeck+S.cost69)/69deck_size69")
			currdeck += S.cost
			spawned.Add(S.id)
			if(!S.multispawn)
				sorted.Remove(S)
		else
			if(debug_mode)
				story_debug("69S.id69 fake-created")
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
		set_timer(rand(1,3)69INUTES)
	else
		if(mad)
			set_timer(rand(7,10)69INUTES)

		else
			set_timer(rand(20,35)69INUTES)

	return TRUE


/datum/storyteller/erida/storyteller_panel_extra()
	var/data = ""
	var/ehref = "<a href='?src=\ref69src69:edit_deck=1'>\69SET\69</a>"
	data += "<br>Deck size: <b>69deck_size69</b>69calculate_deck?"":" 69ehref69"69 <b><a href='?src=\ref69src69;toggle_deck=1'>69calculate_deck?"\69AUTO\69":"\69MANUAL\69"69</a></b>"
	data +=	"<br>Mad69ode: 69mad?"69mad69 stages":"no"69 <b><a href='?src=\ref69src69;edit_mad=1'>\69SET\69</a></b>"

	return data

/datum/storyteller/erida/topic_extra(href, href_list)
	if(href_list69"edit_deck"69)
		deck_size = input("Enter new deck size.","Deck edit",deck_size) as num

	if(href_list69"toggle_deck"69)
		calculate_deck = !calculate_deck

	if(href_list69"edit_mad"69)
		mad = input("Enter new69ad length (0 to disable)","Mad69ode",mad) as num
		if(mad < 0)
			mad = 0
