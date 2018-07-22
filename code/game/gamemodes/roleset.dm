/datum/storyevent/roleset
	id = "roleset"

	var/role_id = null

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
	if(!temp.outer)
		for(var/datum/mind/candidate in ticker.minds)
			if(!candidate.current)
				continue
			if(!temp.can_become_antag(candidate))
				continue
			if(!antagonist_suitable(candidate,temp))
				continue
			if(!(temp.role_type in candidate.current.client.prefs.be_special_role))
				continue
			if(ticker.storyteller && ticker.storyteller.one_role_per_player && candidate.antagonist.len)
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

		if(any_candidates && act_test)	//we don't need to wait if there's no candidates
			sleep(20 SECONDS)
			agree_time_out = TRUE

	qdel(temp)
	return shuffle(candidates)

/datum/storyevent/roleset/spawn_event()
	var/antag = antag_types[role_id]
	var/datum/antagonist/A = new antag

	if(role_id in outer_antag_types)
		var/mob/M = safepick(ghost_candidates_list(role_id))
		if(!M)
			return FALSE
		. = A.create_from_ghost(M)

	else
		var/datum/mind/M = safepick(candidates_list(role_id))
		if(!M)
			return FALSE
		. = A.create_antagonist(M)

	create_objectives(A)


/datum/storyevent/roleset/proc/create_objectives(var/datum/antagonist/A)
	A.objectives.Cut()
	A.create_objectives()
	A.create_survive_objective()
	A.greet()

/datum/storyevent/roleset/announce()
	return

/datum/storyevent/roleset/announce_end()
	return
