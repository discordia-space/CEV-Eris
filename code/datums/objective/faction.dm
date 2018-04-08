/datum/objective/faction
	var/datum/faction/faction = null

/datum/objective/faction/New(var/datum/faction/F, var/datum/mind/target, var/add_to_list = TRUE)
	faction = F
	if(add_to_list)
		faction.objectives |= src
	if(!target)
		find_target()


	update_explanation()
	all_objectives.Add(src)

/datum/objective/faction/get_targets_list()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in ticker.minds)
		if(!(possible_target in faction.members) && ishuman(possible_target.current) && (possible_target.current.stat != 2))
			possible_targets.Add(possible_target)
	return possible_targets