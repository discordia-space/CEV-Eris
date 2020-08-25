var/global/list/all_objectives = list()
var/global/list/all_objectives_types = null

/hook/startup/proc/init_objectives()
	all_objectives_types = list()
	var/indent = length("[/datum/objective]/")
	for(var/path in subtypesof(/datum/objective))
		var/id = copytext("[path]", indent+1)
		all_objectives_types[id] = path
	return TRUE

/datum/objective
	var/datum/antagonist/antag = null
	var/datum/mind/owner = null			//Who owns the objective.
	var/datum/faction/owner_faction = null
	var/explanation_text = "Nothing"	//What that person is supposed to do.
	var/datum/mind/target = null		//If they are focused on a particular person.
	var/target_amount = 0				//If they are focused on a particular number. Steal objectives have their own counter.
	var/completed = FALSE				//currently only used for custom objectives.
	var/failed = FALSE 					//If true, this objective has reached a state where it can never be completed
	var/human_target = TRUE				//If true, only select human targets
	var/unique = FALSE					//If true, each antag/faction can have only one instance of this objective

/datum/objective/New(datum/antagonist/new_owner, datum/mind/_target)
	if (istype(new_owner))
		antag = new_owner
		antag.objectives += src
		if(antag.owner)
			owner = antag.owner
	else if (istype(new_owner, /datum/faction))
		owner_faction = new_owner
		owner_faction.objectives += src
	if(!_target)
		find_target()
	else if (_target != ANTAG_SKIP_TARGET)
		target = _target
	update_explanation()
	all_objectives.Add(src)
	..()

/datum/objective/Destroy()
	if(antag)
		antag.objectives -= src
		antag = null
	if (owner_faction)
		owner_faction.objectives -= src
		owner_faction = null
	if(owner)
		owner = null
	if(target)
		target = null
	all_objectives.Remove(src)
	. = ..()

/datum/objective/proc/update_completion()	//This is for objectives requiring mid-round check, like harm or baptize
	return

/datum/objective/proc/check_completion()
	if (failed)
		return FALSE
	return completed

/datum/objective/proc/get_targets_list()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in SSticker.minds)
		if(is_valid_target(possible_target))
			possible_targets |= possible_target
	return possible_targets

//Checks if a given mind is a valid target to perform objectives on
/datum/objective/proc/is_valid_target(datum/mind/M)
	if (!M.current)
		return FALSE //No mob

	if (M == owner) //No targeting ourselves
		return FALSE

	if (!ishuman(M.current) && human_target)
		return FALSE

	if (M.current.stat == DEAD)
		//Don't target the dead
		return FALSE

	//Special handling for targeting other antags
	if (M.antagonist.len)
		for (var/datum/antagonist/A in M.antagonist)
			//Make sure we don't target our own faction
			if (owner_faction && (owner_faction == A.faction))
				return FALSE

	return TRUE


/datum/objective/proc/find_target()
	var/list/possible_targets = get_targets_list()

	var/list/existing_targets = get_owner_targets()
	possible_targets -= existing_targets
	if(possible_targets.len > 0)
		set_target(pick(possible_targets))
		return TRUE
	return FALSE

/datum/objective/proc/set_target(datum/mind/new_target)
	if(new_target)
		target = new_target
		update_explanation()

/datum/objective/proc/select_human_target(mob/user)
	var/list/possible_targets = get_targets_list()
	if(!possible_targets || !possible_targets.len)
		to_chat(user, SPAN_WARNING("Sorry! No possible targets found!"))
		return
	var/datum/mind/M = input(user, "New target") as null|anything in possible_targets
	if(M)
		target = M
		update_explanation()

/datum/objective/proc/update_explanation()

/datum/objective/proc/get_panel_entry()
	return explanation_text

/datum/objective/proc/get_info()	//Text returned by this proc will be displayed at the end of the round
	return ""

/datum/objective/Topic(href, href_list)
	if(!check_rights(R_DEBUG))
		return TRUE

	if(href_list["switch_target"])
		select_human_target(usr)
		antag.antagonist_panel()


//Used for steal objectives. Returns a list of the owner's contents, if the owner is a single player
//If the owner is a faction, then asks that faction to return its inventory
/datum/objective/proc/get_owner_inventory()
	var/list/contents = list()
	if (owner && owner.current)
		contents.Add(owner.current.get_contents())

	if (owner_faction)
		contents.Add(owner_faction.get_inventory())

	return contents

//Returns whatever this objective is targeting.
//Could be a datum, a mind, a typepath, a name, a role, or even a list of the above.
/datum/objective/proc/get_target()
	return target


//Gets the list of targets from our owner
/datum/objective/proc/get_owner_targets()
	if (owner_faction)
		return owner_faction.get_targets()
	else if (antag)
		return antag.get_targets()
	else
		return list()