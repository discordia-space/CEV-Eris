var/global/list/rolesets = list()

/proc/fill_rolesets_list()
	for(var/type in typesof(/datum/roleset)-/datum/roleset)
		rolesets.Add(new type)

/datum/roleset
	var/id = "roleset"
	var/list/roles = list()

/datum/roleset/proc/get_roles_weight()
	var/W = 0
	for(var/role in roles)
		W += antag_weights[role] * roles[role]
	return W

/datum/roleset/proc/get_special_weight()
	return 0

/datum/roleset/proc/get_weight()
	return get_roles_weight() + get_special_weight()

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

			//Activity test)))
			if(act_test)
				spawn()
					usr = candidate
					if(alert("Do you want to become the [temp.role_text]? Hurry up, you have 20 seconds to make choice!","Antag lottery","OH YES","No, I'm autist") == "OH YES")
						if(!agree_time_out)
							candidates.Add(candidate)

		if(any_candidates && act_test)	//we won't need to wait, if there's no candidates
			sleep(20 SECONDS)
			agree_time_out = TRUE

	return candidates

/datum/roleset/proc/spawn_roleset()
	return


/datum/roleset/proc/log_roleset(var/text)
	log_admin("ROLESET: [text] <a href='?src=\ref[ticker.storyteller];panel=1'>\[STRT\]</a>")
