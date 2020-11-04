/proc/draft_ghost(role_text, ban_check, pref_check)
	var/list/candidates = list()
	var/agree_time_out = FALSE
	var/any_candidates = FALSE

	for(var/mob/observer/ghost/O in GLOB.player_list)
		if(!O.client)
			continue
		if(ban_check && jobban_isbanned(O, ban_check))
			continue
		if(pref_check && !(pref_check in O.client.prefs.be_special_role))
			continue

		any_candidates = TRUE

		if(role_text)
			spawn()
				O << 'sound/effects/magic/blind.ogg' //Play this sound to a player whenever when he's chosen to decide.
				if(alert(O,"Do you want to become the [role_text]? Hurry up, you have 60 seconds to make choice!","Antag lottery","OH YES","No, I'm autist") == "OH YES")
					if(!agree_time_out)
						candidates.Add(O)
		else
			candidates.Add(O)

	if(any_candidates) //we don't need to wait if there's no candidates
		sleep(60 SECONDS)
		agree_time_out = TRUE

	while(candidates.len)
		var/mob/observer/ghost/O = pick(candidates)
		if(!O.client)
			continue
		return O
