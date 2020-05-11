/datum/perk/combat
	var/streak = ""
	var/max_streak_length = 6
	var/current_target
	active = FALSE
	toggleable = TRUE

/datum/perk/combat/activate()
	. = ..()
	if(!.)
		return
	if(holder.combat_style)
		holder.combat_style.deactivate(holder)
	holder.combat_style = src

/datum/perk/combat/deactivate()
	. = ..()
	if(!.)
		return
	holder.combat_style = null

/datum/perk/combat/is_active()
	return holder.combat_style == src

/datum/perk/combat/proc/disarm_act(mob/living/A, mob/living/D)
	return 0

/datum/perk/combat/proc/harm_act(mob/living/A, mob/living/D)
	return 0

/datum/perk/combat/proc/grab_act(mob/living/A, mob/living/D)
	return 0

/datum/perk/combat/proc/add_to_streak(element,mob/living/D)
	if(D != current_target)
		reset_streak(D)
	streak = streak+element
	if(length(streak) > max_streak_length)
		streak = copytext(streak,2)
	return

/datum/perk/combat/proc/reset_streak(mob/living/new_target)
	current_target = new_target
	streak = ""
