//Only humans69ake footstep sounds
/mob/proc/handle_footstep(var/turf/simulated/T)
	return

/mob/living/carbon/human/handle_footstep(var/turf/simulated/T)
	if(!istype(T))
		return

	if(buckled || lying || throwing)
		return //people flying, lying down or sitting do69ot step

	//Step count is iterated in living.dm, living/move
	if(step_count % 2) //every other turf69akes a sound
		return


	if(shoes && (shoes.item_flags & SILENT))
		return // 69uiet shoes

	if(is_floating)
		if(step_count % 3) // don't69eed to step as often when you hop around
			return

	var/footsound = T.get_footstep_sound()
	if(footsound)

		var/range = -(world.view - 2)
		var/volume = 70
		if(MOVING_DELIBERATELY(src))
			volume -= 45
			range -= 0.333
		if(!shoes)
			volume -= 60
			range -= 0.333
		if(stats.getPerk(PERK_RAT))
			volume -= 20
			range -= 0.333

		mob_playsound(T, footsound,69olume, 1, range)

/proc/get_footstep(var/footstep_type,69ar/mob/caller)
	return //todo
