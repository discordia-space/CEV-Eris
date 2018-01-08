var/global/list/rolesets = list()

/proc/fill_rolesets_list()
	for(var/type in typesof(/datum/roleset)-/datum/roleset)
		rolesets.Add(new type)

/datum/roleset
	var/id = "roleset"
	var/role_id = null

	var/weight_cache = 0
	var/spawn_times = 0

	//Weight calculation settings. Set to negative to disable check
	var/req_crew = -1
	var/req_heads = -1
	var/req_sec = -1
	var/req_eng = -1
	var/req_med = -1
	var/req_sci = -1

	var/req_stage = -1

	var/max_crew_diff = 10	//Maximum difference between above values and real crew distribution. If difference is greater, weight will be 0
	var/max_stage_diff = 2

/datum/roleset/proc/get_special_weight(var/weight)
	return weight

/datum/roleset/proc/can_spawn()
	return TRUE

/datum/roleset/proc/antagonist_suitable(var/datum/mind/player, var/datum/antagonist/antag)
	return TRUE

/datum/roleset/proc/get_candidates_count(var/a_type)	//For internal using
	var/list/L = candidates_list(a_type)
	return L.len

/datum/roleset/proc/candidates_list(var/antag, var/oneantag = TRUE)
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
			if(!(temp.id in candidate.current.client.prefs.be_special_role))
				continue
			if(ticker.storyteller && ticker.storyteller.one_role_per_player && candidate.antagonist.len)
				continue
			if(player_is_antag_id(candidate,antag))
				continue

			candidates.Add(candidate)

	qdel(temp)
	return candidates

/datum/roleset/proc/ghost_candidates_list(var/antag, var/act_test = TRUE)
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
			if(!(temp.id in candidate.client.prefs.be_special_role))
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
	return candidates

/datum/roleset/proc/create()
	var/succ = spawn_roleset()
	if(succ)
		spawn_times++
		log_admin("STORYTELLER: [id] roleset has been spawned! [storyteller_button()]")
	return succ

/datum/roleset/proc/spawn_roleset()
	var/antag = antag_types[role_id]
	var/datum/antagonist/A = new antag

	if(role_id in outer_antag_types)
		var/mob/M = safepick(ghost_candidates_list(role_id))
		if(!M)
			return FALSE
		return A.create_from_ghost(M)

	else
		var/datum/mind/M = safepick(candidates_list(role_id))
		if(!M)
			return FALSE
		return A.create_antagonist(M)

	create_objectives(A)


/datum/roleset/proc/create_objectives(var/datum/antagonist/A)
	A.objectives.Cut()
	A.create_objectives()
	A.create_survive_objective()

