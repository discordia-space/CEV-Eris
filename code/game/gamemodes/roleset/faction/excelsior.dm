/datum/storyevent/roleset/faction/excelsior
	id = "excelsior"
	name = "excelsior"
	role_id = ROLE_EXCELSIOR_REV
	faction_id = FACTION_EXCELSIOR
	faction_type = /datum/faction/excelsior
	//min_cost = 10
	//max_cost = 20

	base_quantity = 2 //They're a group antag, we want a few of em
	scaling_threshold = 8

	req_crew = 6
	leaders = -1 //Every excelsior spawned directly is a leader. Non leaders are those recruited during gameplay

	story_ineligible = list(JOBS_SECURITY, JOBS_COMMAND)

// Code to prevent a role from being picked by the storyteller.
/datum/storyevent/roleset/faction/excelsior/antagonist_suitable(var/datum/mind/player, var/datum/antagonist/antag)
	if(player.assigned_role in story_ineligible)
		return FALSE
	return TRUE