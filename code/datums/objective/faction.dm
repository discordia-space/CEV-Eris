/datum/objective/faction
	var/datum/faction/faction = null

/datum/objective/faction/New(var/datum/faction/F, var/datum/mind/target)
	faction = F
	faction.objectives |= src
	if(!target)
		find_target()


	update_explanation()
	all_objectives.Add(src)

/datum/objective/faction/Destroy()
	if(faction)
		faction.objectives -= src
		faction = null
	return ..()

/datum/objective/faction/get_targets_list()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in SSticker.minds)
		if(!(possible_target in faction.members) && ishuman(possible_target.current) && (possible_target.current.stat != 2))
			possible_targets.Add(possible_target)
	return possible_targets
