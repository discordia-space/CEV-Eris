/datum/faction
	var/name = "faction"
	var/welcome_text = ""
	var/hud_indicator = null

	var/antag_type

	var/list/objectives = list()
	var/list/members = list()
	var/list/leaders = list()

	var/list/verbs = list()

/datum/faction/New()
	create_objectives()

/datum/faction/proc/add_member(var/datum/antagonist/member)
	if(!member || !member.owner || !member.owner.current || member in members)
		return

	members.Add(member)
	member.faction = src

	member.objectives = objectives

	member.owner.current.verbs |= verbs

	update_members()

/datum/faction/proc/add_leader(var/datum/antagonist/member)
	if(!member || member in leaders)
		return

	if(!(member in members))
		add_member(member)

	leaders.Add(member)

	update_members()

/datum/faction/proc/remove_member(var/datum/antagonist/member)
	if(!(member in members))
		return

	members.Remove(member)
	leaders.Remove(member)

	if(member.owner && member.owner.current)
		member.owner.current.verbs.Remove(verbs)

	update_members()

/datum/faction/proc/remove_faction()
	for(var/datum/antagonist/A in members)
		remove_member(A)

	current_factions.Remove(src)
	qdel(src)


/datum/faction/proc/create_objectives()

/datum/faction/proc/update_members()
	if(!members.len)
		remove_faction()
		return

/datum/faction/proc/customize(var/mob/leader)


