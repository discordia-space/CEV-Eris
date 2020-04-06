/datum/objective/block
	explanation_text = "Do not allow any organic lifeforms to escape on the shuttle alive."
	unique = TRUE

/datum/objective/block/check_completion()
	if (failed)
		return FALSE

	if(!issilicon(owner.current))
		return FALSE
	if(!evacuation_controller.has_evacuated())
		return FALSE
	if(!owner.current)
		return FALSE

	var/area/first_escape_pod = locate(/area/shuttle/escape_pod1/centcom)
	var/area/second_escape_pod = locate(/area/shuttle/escape_pod2/centcom)
	var/protected_mobs[] = list(/mob/living/silicon/ai, /mob/living/silicon/pai, /mob/living/silicon/robot)
	for(var/mob/living/player in GLOB.player_list)
		if(player.type in protected_mobs)
			continue
		if(player.mind)
			if(player.stat != 2)
				if(get_turf(player) in first_escape_pod || (get_turf(player) in second_escape_pod))
					return FALSE
	return TRUE
