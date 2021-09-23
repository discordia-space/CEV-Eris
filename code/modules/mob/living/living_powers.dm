/mob/living
	var/hiding

/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(incapacitated())
		return

	hiding = !hiding
	if(hiding)
		to_chat(src, SPAN_NOTICE("You are now hiding."))
	else
		to_chat(src, SPAN_NOTICE("You have stopped hiding."))
	reset_layer()


/mob/living/proc/activate_ai()
	AI_inactive = FALSE
	life_cycles_before_sleep = initial(life_cycles_before_sleep)

/mob/living/proc/try_activate_ai()
	if(AI_inactive)
		activate_ai()


/mob/living/proc/check_surrounding_area(var/dist = 7)

	if(faction == "neutral")
		return TRUE
	for (var/mob/living/exosuit/M in GLOB.mechas_list)
		if (M.z == src.z && get_dist(src, M) <= dist)
			return TRUE

	for(var/mob/living/M in SSmobs.mob_living_by_zlevel[(get_turf(src)).z])
		if(!(M.stat < DEAD))
			continue
		if(M.faction != faction)
			if(get_dist(src, M) <= dist)
				return TRUE

	return FALSE
