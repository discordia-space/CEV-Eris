//Roleset events for team antags
/datum/storyevent/roleset/faction
	var/leaders = 0
	//Set to 0 to disable leaders, or set to -1 to make everyone initially spawned into a leader

	//The id of the faction to get
	var/faction_id = null

	//The type of the faction we'll create if we can't find one
	var/faction_type = null

//This is a copypaste of roleset/trigger_event, with some new features added
/datum/storyevent/roleset/faction/trigger_event()
	calc_target_quantity()
	var/datum/antagonist/antag = GLOB.all_antag_types[role_id]
	//Find the faction first, create it if it doesnt exist
	if (!faction_id)
		return
	var/datum/faction/F = get_faction_by_id(faction_id)

	if (!F)
		F = new faction_type()



	var/list/candidates = get_candidates_list(role_id)
	if(candidates.len < min_quantity)
		// Refund roleset points since no antags were spawned
		log_and_message_admins("Storyteller Warning: Antagonist Spawning unsuccessful for antagonist [role_id], [antag] \n \
		The candidate pool ([candidates.len]) was smaller than the minimum required to spawn ([min_quantity]).\n \
		Roleset pool points will be refunded.")

		cancel(severity)
		return FALSE



	for (var/i = 1; i <= target_quantity;i++)
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
			success_quantity++
		else
			//If we found a viable candidate but failed to turn them into an antag, we'll skip over them
			i-- //Decrement i so we can try again
			//That candidate is still removed from the list by pick_n_take


	//Appoint leaders for this faction
	if (leaders)
		F.pick_leaders(leaders)


	//And pick objectives
	F.create_objectives()

	//Now that objectives are made, we can give everyone their greeting message
	F.greet()

	/*
		Once we get here, we're done assigning antags, for better or worse. Lets see how we did
	*/
	if (success_quantity >= target_quantity)
		//Yay, all antags successfully spawned
		return TRUE

	else
		//Welp, we didn't manage to spawn as many as desired
		log_and_message_admins("Storyteller Warning: Antagonist Spawning unsuccessful for antagonist [role_id], [antag] \n \
		We only managed to spawn [success_quantity] out of a desired [target_quantity].\n \
		Roleset pool points will be refunded pro-rata for the failures")

		//We will now refund part of the cost
		var/success_percent = 0
		if (success_quantity > 1)
			success_percent = success_quantity / target_quantity
		cancel(severity, success_percent)

		if ( success_quantity > 0 )
			// At least one antag has spawned
			return TRUE
		else
			return FALSE

// Code to prevent a role from being picked by the storyteller.
/datum/storyevent/roleset/faction/antagonist_suitable(var/datum/mind/player, var/datum/antagonist/antag)
	if(player.assigned_role in antag.story_ineligible)
		return FALSE
	return TRUE