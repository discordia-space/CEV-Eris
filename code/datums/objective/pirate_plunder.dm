//Possible mission states
#define PLUNDER_STATUS_SETUP 0	//Mercs are still at their base getting equipped
#define PLUNDER_STATUS_IN_PROGRESS	1	//Mission has started, timer is ticking
#define PLUNDER_STATUS_ABORTED		2	//Time limit expired, mission failed
#define PLUNDER_STATUS_POSTGAME		3	//Mercs returned to their base. They get half an hour to roleplay and debrief#
#define PLUNDER_STATUS_ENDED		4	//All pirates have been despawned

/datum/objective/timed/pirate
	explanation_text = "Return to your ship and withdraw to base within X minutes."
	var/mission_timer = 45 MINUTES
	var/mission_status = PLUNDER_STATUS_SETUP
	var/ended = FALSE

/datum/objective/timed/pirate/check_completion()
	if(failed)
		return FALSE

	var/datum/shuttle/autodock/multi/antag/pirate/MS = SSshuttle.get_shuttle("Pirate")

	if(!MS)
		//Shuttle was destroyed?
		return FALSE


	if(MS.current_location != MS.home_waypoint && MS.next_location != MS.home_waypoint)
		//The shuttle still near Eris, fail
		//This will succeed as long as they're enroute away from eris
		return FALSE

	return TRUE


/datum/objective/timed/pirate/update_explanation()
	explanation_text = "Return to your ship and withdraw to base within [round(mission_timer / (1 MINUTE), 1)] minutes."

/datum/objective/timed/pirate/get_panel_entry()
	return "Withdraw to base within [round(mission_timer / (1 MINUTE), 1)] minutes. Time remaining: [time2text(mission_timer, "mm:ss")]."

/datum/objective/timed/pirate/get_info()
	return "Time remaining at arrival: [time2text(mission_timer, "mm:ss")]."

/datum/objective/timed/pirate/proc/start_mission()
	START_PROCESSING(SSobj, src)
	mission_status = PLUNDER_STATUS_IN_PROGRESS

//The faction datum processes to tick down the mission timer
/datum/objective/timed/pirate/Process()
	mission_timer -= 1 SECONDS
	if(!ended && mission_timer <= 0)
		end_mission()

	/*
	The timer keeps ticking even after its ended because later i plan to extend this to let them hang
	around the pirate base for up to half an hour and then be despawned so the base can be reset
	*/



//The mission ends when the pirates return to base or their time limit expires
/datum/objective/timed/pirate/proc/end_mission()
	ended = TRUE
	if(!check_completion())
		abort_mission()
		mission_status = PLUNDER_STATUS_ABORTED
	else
		for(var/datum/objective/O in owner_faction.objectives)
			if(O.check_completion())
				O.completed = TRUE
		mission_status = PLUNDER_STATUS_POSTGAME

	// Not going back to Eris once mission is over
	var/datum/shuttle/autodock/multi/antag/pirate/MS = SSshuttle.get_shuttle("Pirate")
	if(MS)
		MS.lock_shuttle()

	//This is one of the few times a world << call is actually intended functionality.
	//This is not a debug message, it outputs the result of the mission, it should remain in
	to_chat(world, owner_faction.print_success())



//This is called if the pirates' time limit expires while they're not at their base. Mission failure
/datum/objective/timed/pirate/proc/abort_mission()

	//First of all, every pirate left on eris is executed by a little bomb in their skull
	for(var/datum/antagonist/A in owner_faction.members)
		if(!A || !A.owner)
			continue

		var/mob/living/carbon/human/H = A.owner.current
		if(!H)
			continue

		if(!IS_SHIP_LEVEL(H.z))
			continue

		var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
		affecting.take_damage(9999) //Headgib. Very dead



	//Secondly, fail all mission objectives
	for(var/datum/objective/O in owner_faction.objectives)
		O.failed = TRUE

	/*
	// Thirdly, the pirate ship selfdestructs
	var/list/atoms = get_area_contents(/area/shuttle/pirate)
	for(var/a in atoms)
		qdel(a)
	*/
