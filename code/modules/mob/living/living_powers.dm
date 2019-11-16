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


/mob/living/proc/check_surrounding_area(var/dist = 7)
	var/list/L = hearers(src, dist)

	if(faction == "neutral")
		return 1

	if(faction == "station")
		return 1

	for (var/obj/mecha/M in mechas_list)
		if (M.z == src.z && get_dist(src, M) <= dist)
			return 1

	for(var/mob/living/M in L)
		if (M.faction != faction)
			return 1

	return 0
