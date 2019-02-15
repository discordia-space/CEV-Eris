/datum/objective/faction
	var/datum/faction/faction = null

/datum/objective/faction/New(var/datum/faction/F, var/datum/mind/_target)
	faction = F
	faction.objectives |= src
	target = _target
	if(!target)
		find_target()


	update_explanation()
	all_objectives.Add(src)

/datum/objective/faction/Destroy()
	if(faction)
		faction.objectives -= src
		faction = null
	return ..()

