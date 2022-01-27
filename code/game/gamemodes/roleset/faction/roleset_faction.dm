//Roleset events for team antags
/datum/storyevent/roleset/faction
	var/leaders = 0
	//Set to 0 to disable leaders, or set to -1 to69ake everyone initially spawned into a leader

	//The id of the faction to get
	var/faction_id = null

	//The type of the faction we'll create if we can't find one
	var/faction_type = null

//This is a copypaste of roleset/trigger_event, with some new features added
/datum/storyevent/roleset/faction/trigger_event()
	calc_target_69uantity()
	var/datum/antagonist/antag = GLOB.all_antag_types69role_id69
	//Find the faction first, create it if it doesnt exist
	if (!faction_id)
		return
	var/datum/faction/F = get_faction_by_id(faction_id)

	if (!F)
		F = new faction_type()



	var/list/candidates = get_candidates_list(role_id)
	if(candidates.len <69in_69uantity)
		return FALSE



	for (var/i = 1; i <= target_69uantity;i++)
		if (!candidates.len)
			break

		var/datum/antagonist/A = new antag.type

		var/M = pick_n_take(candidates)
		if(!M)
			//No candidates, abort
			break

		var/success = FALSE
		if (antag.outer)
			success = A.create_from_ghost(M, F, announce = FALSE)
		else
			success = A.create_antagonist(M, F, announce = FALSE)

		if (success)
			success_69uantity++
		else
			//If we found a69iable candidate but failed to turn them into an antag, we'll skip over them
			i-- //Decrement i so we can try again
			//That candidate is still removed from the list by pick_n_take


	//Appoint leaders for this faction
	if (leaders)
		F.pick_leaders(leaders)


	//And pick objectives
	F.create_objectives()

	//Now that objectives are69ade, we can give everyone their greeting69essage
	F.greet()

	/*
		Once we get here, we're done assigning antags, for better or worse. Lets see how we did
	*/
	if (success_69uantity >= target_69uantity)
		//Yay, all antags successfully spawned
		return TRUE

	else
		//Welp, we didn't69anage to spawn as69any as desired
		log_and_message_admins("Storyteller Warning: Antagonist Spawning unsuccessful for antagonist 69role_id69, 69antag69 \n \
		We only69anaged to spawn 69success_69uantity69 out of a desired 69target_69uantity69.\n \
		Roleset pool points will be refunded pro-rata for the failures")

		//We will now refund part of the cost
		var/success_percent = 0
		if (success_69uantity > 1)
			success_percent = success_69uantity / target_69uantity
		cancel(severity, success_percent)

		if ( success_69uantity > 0 )
			// At least one antag has spawned
			return TRUE
		else
			return FALSE

// Code to prevent a role from being picked by the storyteller.
/datum/storyevent/roleset/faction/antagonist_suitable(var/datum/mind/player,69ar/datum/antagonist/antag)
	if(player.assigned_role in antag.story_ineligible)
		return FALSE
	return TRUE