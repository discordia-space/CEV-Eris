/datum/storyevent/roleset
	id = "roleset"
	event_pools = list(EVENT_LEVEL_ROLESET = POOL_THRESHOLD_ROLESET)
	var/role_id = null
	parallel = FALSE //Most roleset storyevents take time to choose antags. no69ulti69ueueing

	//Spawning69ars
	var/min_69uantity = 1 //A hard69inimum. If we can't spawn at least this69any, we spawn none at all.

	var/base_69uantity = 1//How69any of this antag we will attempt to at least spawn.
	//If we can't spawn them all though its  okay

	var/scaling_threshold = 15
	//For every 69scaling_threshold69 non-antag players in the crew, we will spawn one extra antag
	//Set to 0 to disable this feature

	var/max_69uantity = 6 //Never spawn69ore than this69any


	//Whenever we ask a player to become this antag but they decline, they will be recorded here.
	//They will not be asked again until a certain time has passed
	var/list/re69uest_log = list()
	var/re69uest_timeout = 6069INUTES

	//Transient69ars, these are specific to one triggering of the event
	var/tmp/target_69uantity = 0 //How69any copies of this antag we are currently attempting to spawn, based on the above
	var/tmp/success_69uantity = 0 //How69any copies we have successfully spawned so far
	var/severity = EVENT_LEVEL_MUNDANE //The severity we're trying to trigger with


/datum/storyevent/roleset/proc/antagonist_suitable(var/datum/mind/player,69ar/datum/antagonist/antag)
	return TRUE

/datum/storyevent/roleset/proc/get_candidates_count(var/a_type)	//For internal using
	var/list/L = get_candidates_list(a_type)
	return L.len

/datum/storyevent/roleset/proc/get_candidates_list(var/antag,69ar/report)
	var/datum/antagonist/A = GLOB.all_antag_types69role_id69

	if (A.outer)
		return ghost_candidates_list(role_id)
	else
		return candidates_list(role_id)

/datum/storyevent/roleset/proc/candidates_list(var/antag,69ar/report)
	var/datum/antagonist/temp = GLOB.all_antag_types69antag69
	if(!istype(temp))
		if (report) to_chat(report, SPAN_NOTICE("Failure: Unable to locate antag datum: -69temp69-69temp.type69- for antag 69antag69"))
		return list()
	var/list/candidates = list()
	for(var/datum/mind/candidate in SSticker.minds)
		if(!candidate.current)
			if (report) to_chat(report, SPAN_NOTICE("Failure: 69candidate69 has no69ob"))
			continue
		if(!temp.can_become_antag(candidate, report))
			if (report) to_chat(report, SPAN_NOTICE("Failure: 69candidate69 can't become this antag"))
			continue
		if(!antagonist_suitable(candidate, temp))
			if (report) to_chat(report, SPAN_NOTICE("Failure: 69candidate69 is not antagonist suitable"))
			continue
		if(!(temp.bantype in candidate.current.client.prefs.be_special_role))
			if (report) to_chat(report, SPAN_NOTICE("Failure: 69candidate69 has special role 69temp.bantype69 disabled"))
			continue
		if(GLOB.storyteller && GLOB.storyteller.one_role_per_player && candidate.antagonist.len)
			if (report) to_chat(report, SPAN_NOTICE("Failure: 69candidate69 is already a 69candidate.antagonist6916969 and can't be two antags"))
			continue
		if(player_is_antag_id(candidate,antag))
			if (report) to_chat(report, SPAN_NOTICE("Failure: 69candidate69 is already a 69antag69"))
			continue
		candidates.Add(candidate)
	return shuffle(candidates)

/datum/storyevent/roleset/proc/ghost_candidates_list(var/antag,69ar/act_test = TRUE,69ar/report)

	var/datum/antagonist/temp = GLOB.all_antag_types69antag69
	if(!istype(temp))
		return list()

	var/list/candidates = list()
	var/agree_time_out = FALSE
	var/any_candidates = FALSE

	if(temp.outer)
		for(var/mob/observer/candidate in GLOB.player_list)
			if(!candidate.client)
				if (report) to_chat(report, SPAN_NOTICE("Failure: 69candidate69 is disconnected"))
				continue

			//Lets check if we asked them recently to prevent spam
			if ((candidate.key in re69uest_log))
				var/last_re69uest = re69uest_log69candidate.key69
				if ((world.time - last_re69uest) < re69uest_timeout)
					if (report) to_chat(report, SPAN_NOTICE("Failure: 69candidate69 was already asked too recently"))
					continue
			if(!temp.can_become_antag_ghost(candidate))
				if (report) to_chat(report, SPAN_NOTICE("Failure: 69candidate69 can't become this antag from ghost"))
				continue
			if(!(temp.bantype in candidate.client.prefs.be_special_role))
				if (report) to_chat(report, SPAN_NOTICE("Failure: 69candidate69 has special role 69temp.bantype69 disabled"))
				continue

			any_candidates = TRUE

			//Activity test
			if(act_test)
				spawn()
					re69uest_log69candidate.key69 = world.time //Record this re69uest so we don't spam them repeatedly
					usr = candidate
					usr << 'sound/effects/magic/blind.ogg' //Play this sound to a player whenever when he's chosen to decide.
					if(alert("Do you want to become the 69temp.role_text69? Hurry up, you have 60 seconds to69ake choice!","Antag lottery","OH YES","No, I'm autist") == "OH YES")
						if(!agree_time_out)
							candidates.Add(candidate)
			else
				candidates.Add(candidate)

		if(any_candidates && act_test)	//we don't need to wait if there's no candidates
			sleep(60 SECONDS)
			agree_time_out = TRUE

	return shuffle(candidates)


//We will first calculate how69any antags to spawn, and then attempt to69ake that69any
/datum/storyevent/roleset/trigger_event(var/severity = EVENT_LEVEL_ROLESET)

	calc_target_69uantity()
	if (!target_69uantity || target_69uantity <= 0)
		//Something is completely wrong, abort!
		cancel(severity, 0)

	var/datum/antagonist/antag = GLOB.all_antag_types69role_id69



	/*
		We will try to spawn up to 69target_69uantity69 antags
		If the attempt fails at any point, we will abort
	*/

	var/list/candidates = get_candidates_list(role_id)


	if (candidates.len)
		for (var/i = 1; i <= target_69uantity;i++)
			if (!candidates.len)
				break

			var/datum/antagonist/A = new antag.type

			var/mob/M = pick_n_take(candidates)
			if(!M)
				//No candidates, abort
				break

			var/success = FALSE
			if (antag.outer)
				success = A.create_from_ghost(M, announce = FALSE)
			else
				success = A.create_antagonist(M, announce = FALSE)

			if (success)
				success_69uantity++
				create_objectives(A)
			else
				//If we found a69iable candidate but failed to turn them into an antag, we'll skip over them
				i-- //Decrement i so we can try again
				//That candidate is still removed from the list by pick_n_take


	/*
		Once we get here, we're done assigning antags, for better or worse. Lets see how we did
	*/
	if (success_69uantity >= target_69uantity)
		//Yay, all antags successfully spawned
		log_and_message_admins("Antagonist Spawning successful for antagonist 69role_id69, 69antag69, 69uantity 69success_69uantity69")
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

//Tests if its possible for us to trigger, by compiling candidate lists but doing nothing with them
/datum/storyevent/roleset/can_trigger(var/severity = EVENT_LEVEL_ROLESET,69ar/report)
	var/list/possible_candidates = list()
	if(GLOB.outer_antag_types69role_id69)
		possible_candidates = ghost_candidates_list(role_id, FALSE, report) //We set act check to false so it doesn't ask ghosts
	else
		possible_candidates = candidates_list(role_id, report)

	if (possible_candidates.len > 0)
		return TRUE
	if (report) to_chat(report, SPAN_NOTICE("Failure: No candidates found"))
	return FALSE


/datum/storyevent/roleset/proc/create_objectives(datum/antagonist/A)
	A.objectives.Cut()
	A.create_objectives(survive = TRUE)
	A.greet()

/datum/storyevent/roleset/announce()
	return

/datum/storyevent/roleset/announce_end()
	return


//Figure out how69any of this antag we're going to spawn
/datum/storyevent/roleset/proc/calc_target_69uantity()
	//Start by zeroing these to cancel any leftover69alues from last run
	target_69uantity = 0
	success_69uantity = 0

	var/datum/storyteller/S = get_storyteller()
	if (!S)
		//Something is horribly wrong
		return


	//Storyteller crew69ar contains the number of non-antag crewmembers
	var/num_crew = S.crew
	target_69uantity = base_69uantity
	//We add extra antags based on crew numbers
	if (scaling_threshold && num_crew >= scaling_threshold)
		target_69uantity += round(num_crew / scaling_threshold)

	target_69uantity =69in(target_69uantity,69ax_69uantity)