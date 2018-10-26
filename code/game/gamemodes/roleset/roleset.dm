/datum/storyevent/roleset
	id = "roleset"
	event_pools = list(EVENT_LEVEL_ROLESET = POOL_THRESHOLD_ROLESET)
	var/role_id = null
	parallel = FALSE //Most roleset storyevents take time to choose antags. no multiqueueing

	//Spawning vars
	var/base_quantity = 1//How many of this antag we will attempt to at least spawn

	var/scaling_threshold = 15
	//For every [scaling_threshold] non-antag players in the crew, we will spawn one extra antag
	//Set to 0 to disable this feature

	//Transient vars, these are specific to one triggering of the event
	var/tmp/target_quantity = 0 //How many copies of this antag we are currently attempting to spawn, based on the above
	var/tmp/success_quantity = 0 //How many copies we have successfully spawned so far
	var/severity = EVENT_LEVEL_MUNDANE //The severity we're trying to trigger with

/datum/storyevent/roleset/proc/antagonist_suitable(var/datum/mind/player, var/datum/antagonist/antag)
	return TRUE

/datum/storyevent/roleset/proc/get_candidates_count(var/a_type)	//For internal using
	var/list/L = candidates_list(a_type)
	return L.len

/datum/storyevent/roleset/proc/candidates_list(var/antag, var/oneantag = TRUE)
	var/datum/antagonist/temp
	if(ispath(antag_types[antag]))
		var/t = antag_types[antag]
		temp = new t
	if(!istype(temp))
		return list()
	var/list/candidates = list()
	for(var/datum/mind/candidate in SSticker.minds)
		if(!candidate.current)
			continue
		if(!temp.can_become_antag(candidate))
			continue
		if(!antagonist_suitable(candidate,temp))
			continue
		if(!(temp.role_type in candidate.current.client.prefs.be_special_role))
			continue
		if(storyteller && storyteller.one_role_per_player && candidate.antagonist.len)
			continue
		if(player_is_antag_id(candidate,antag))
			continue

		candidates.Add(candidate)

	qdel(temp)
	return shuffle(candidates)

/datum/storyevent/roleset/proc/ghost_candidates_list(var/antag, var/act_test = TRUE)

	var/datum/antagonist/temp

	if(ispath(antag_types[antag]))
		var/t = antag_types[antag]
		temp = new t
	if(!istype(temp))
		return list()

	var/list/candidates = list()
	var/agree_time_out = FALSE
	var/any_candidates = FALSE

	if(temp.outer)
		for(var/mob/observer/candidate in player_list)
			if(!candidate.client)
				continue
			if(!temp.can_become_antag_ghost(candidate))
				continue
			if(!(temp.role_type in candidate.client.prefs.be_special_role))
				continue

			any_candidates = TRUE

			//Activity test
			if(act_test)
				spawn()
					usr = candidate
					if(alert("Do you want to become the [temp.role_text]? Hurry up, you have 20 seconds to make choice!","Antag lottery","OH YES","No, I'm autist") == "OH YES")
						if(!agree_time_out)
							candidates.Add(candidate)
			else
				candidates.Add(candidate)

		if(any_candidates && act_test)	//we don't need to wait if there's no candidates
			sleep(20 SECONDS)
			agree_time_out = TRUE

	qdel(temp)
	return shuffle(candidates)


//We will first calculate how many antags to spawn, and then attempt to make that many
/datum/storyevent/roleset/trigger_event(var/severity = EVENT_LEVEL_ROLESET)

	calc_target_quantity()
	if (!target_quantity || target_quantity <= 0)
		//Something is completely wrong, abort!
		cancel(severity, 0.0)

	var/antag = antag_types[role_id]
	/*
		We will try to spawn up to [target_quantity] antags
		If the attempt fails at any point, we will abort
	*/

	var/outer = (role_id in outer_antag_types)
	var/list/candidates = list()
	if (outer)
		candidates = ghost_candidates_list(role_id)
	else
		candidates = candidates_list(role_id)

	if (candidates.len)
		for (var/i = 1; i <= target_quantity;i++)
			if (!candidates.len)
				break

			var/datum/antagonist/A = new antag

			var/mob/M = pick_n_take(candidates)
			if(!M)
				//No candidates, abort
				break

			var/success = FALSE
			if (outer)
				success = A.create_from_ghost(M, announce = FALSE)
			else
				success = A.create_antagonist(M, announce = FALSE)

			if (success)
				success_quantity++
				create_objectives(A)
			else
				//If we found a viable candidate but failed to turn them into an antag, we'll skip over them
				i-- //Decrement i so we can try again
				//That candidate is still removed from the list by pick_n_take


	/*
		Once we get here, we're done assigning antags, for better or worse. Lets see how we did
	*/
	if (success_quantity >= target_quantity)
		//Yay, all antags successfully spawned
		return TRUE
	else
		//Welp, we didn't manage to spawn as many as desired
		log_and_message_admins("Storyteller Warning: Antagonist Spawning unsuccessful for antagonist [role_id], [antag] \n \
		We only managed to spawn [success_quantity] out of a desired [target_quantity].\n \
		Roleset pool points will be refunded pro-rata for the failures")

		//We will now refund part of the cost
		var/success_percent = 0.0
		if (success_quantity > 1)
			success_percent = success_quantity / target_quantity
		cancel(severity, success_percent)


//Tests if its possible for us to trigger, by compiling candidate lists but doing nothing with them
/datum/storyevent/roleset/can_trigger()
	var/list/possible_candidates = list()
	if(role_id in outer_antag_types)
		possible_candidates = ghost_candidates_list(role_id, FALSE) //We set act check to false so it doesn't ask ghosts
	else
		possible_candidates = candidates_list(role_id)

	if (possible_candidates.len > 0)
		return TRUE
	return FALSE


/datum/storyevent/roleset/proc/create_objectives(var/datum/antagonist/A)
	A.objectives.Cut()
	A.create_objectives(survive = TRUE)
	A.greet()

/datum/storyevent/roleset/announce()
	return

/datum/storyevent/roleset/announce_end()
	return


//Figure out how many of this antag we're going to spawn
/datum/storyevent/roleset/proc/calc_target_quantity()
	//Start by zeroing these to cancel any leftover values from last run
	target_quantity = 0
	success_quantity = 0

	var/datum/storyteller/S = get_storyteller()
	if (!S)
		//Something is horribly wrong
		return


	//Storyteller crew var contains the number of non-antag crewmembers
	var/num_crew = S.crew
	target_quantity = base_quantity
	//We add extra antags based on crew numbers
	if (scaling_threshold && num_crew >= scaling_threshold)
		target_quantity += round(num_crew / scaling_threshold)