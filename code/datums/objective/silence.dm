/datum/objective/silence
	explanation_text = "Do not allow anyone to escape the station.  Only allow the shuttle to be called when everyone is dead and your story is the only one left."

/datum/objective/silence/check_completion()
	if (failed)
		return FALSE
	if(!evacuation_controller.has_evacuated())
		return FALSE

	for(var/mob/living/player in GLOB.player_list)
		if(player == owner.current)
			continue
		if(player.mind)
			if(player.stat != DEAD)
				var/turf/T = get_turf(player)
				if(!T)
					continue
				switch(T.loc.type)
					if(/area/shuttle/escape_pod1/centcom, /area/shuttle/escape_pod2/centcom)
						return FALSE
	return TRUE
