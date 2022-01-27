/proc/draft_69host(role_text, ban_check, pref_check)
	var/list/candidates = list()
	var/a69ree_time_out = FALSE
	var/any_candidates = FALSE

	for(var/mob/observer/69host/O in 69LOB.player_list)
		if(!O.client)
			continue
		if(ban_check && jobban_isbanned(O, ban_check))
			continue
		if(pref_check && !(pref_check in O.client.prefs.be_special_role))
			continue

		any_candidates = TRUE

		if(role_text)
			spawn()
				O << 'sound/effects/ma69ic/blind.o6969' //Play this sound to a player whenever when he's chosen to decide.
				if(alert(O,"Do you want to become the 69role_text69? Hurry up, you have 60 seconds to69ake choice!","Anta69 lottery","OH YES","No, I'm autist") == "OH YES")
					if(!a69ree_time_out)
						candidates.Add(O)
		else
			candidates.Add(O)

	if(any_candidates) //we don't69eed to wait if there's69o candidates
		sleep(60 SECONDS)
		a69ree_time_out = TRUE

	while(candidates.len)
		var/mob/observer/69host/O = pick(candidates)
		if(!O.client)
			continue
		return O
