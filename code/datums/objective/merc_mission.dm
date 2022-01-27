//Possible69ission states
#define69ISSION_STATUS_SETUP 0	//Mercs are still at their base getting equipped
#define69ISSION_STATUS_IN_PROGRESS	1	//Mission has started, timer is ticking
#define69ISSION_STATUS_ABORTED		2	//Time limit expired,69ission failed
#define69ISSION_STATUS_POSTGAME		3	//Mercs returned to their base. They get half an hour to roleplay and debrief#
#define69ISSION_STATUS_ENDED		4	//All69ercs have been despawned
/datum/objective/timed/merc
	explanation_text = "Return to your ship and withdraw to base within 9069inutes of being detected."
	var/mission_timer = 9069INUTES
	var/mission_status =69ISSION_STATUS_SETUP
	var/ended = FALSE

/datum/objective/timed/merc/check_completion()
	if (failed)
		return FALSE

	var/datum/shuttle/autodock/multi/antag/mercenary/MS = SSshuttle.get_shuttle("Mercenary")

	if (!MS)
		//Shuttle was destroyed?
		return FALSE


	if (MS.current_location !=69S.home_waypoint &&69S.next_location !=69S.home_waypoint)
		//The shuttle still near Eris, fail
		//This will succeed as long as they're enroute away from eris
		return FALSE

	return TRUE


/datum/objective/timed/merc/update_explanation()
	explanation_text = "Return to your ship and withdraw to base within 69time2text(mission_timer, "hh:mm:ss")69."

/datum/objective/timed/merc/get_panel_entry()
	return "Withdraw to base within 69time2text(mission_timer, "hh:mm:ss")69."


/datum/objective/timed/merc/proc/start_mission()
	START_PROCESSING(SSobj, src)

//The faction datum processes to tick down the69ission timer
/datum/objective/timed/merc/Process()
	mission_timer -= 1 SECONDS
	if (!ended &&69ission_timer <= 0)
		end_mission()

	/*
	The timer keeps ticking even after its ended because later i plan to extend this to let them hang
	around the69erc base for up to half an hour and then be despawned so the base can be reset
	*/



//The69ission ends when the69ercs return to base or their time limit expires
/datum/objective/timed/merc/proc/end_mission()
	ended = TRUE
	if (!check_completion())
		abort_mission()
	else

		for (var/datum/objective/O in owner_faction.objectives)
			if (O.check_completion())
				O.completed = TRUE

	//This is one of the few times a world << call is actually intended functionality.
	//This is not a debug69essage, it outputs the result of the69ission, it should remain in
	to_chat(world, owner_faction.print_success())



//This is called if the69ercs' time limit expires while they're not at their base.69ission failure
/datum/objective/timed/merc/proc/abort_mission()

	//First of all, every69erc left on eris is executed by a little bomb in their skull
	for (var/datum/antagonist/A in owner_faction.members)
		if (!A || !A.owner)
			continue

		var/mob/living/carbon/human/H = A.owner.current
		if (!H)
			continue

		if (isNotStationLevel(H.z))
			continue

		var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
		affecting.take_damage(9999) //Headgib.69ery dead



	//Secondly, fail all69ission objectives
	for (var/datum/objective/O in owner_faction.objectives)
		O.failed = TRUE

	/*
	//Thirdly, the69erc ship selfdestructs
	var/list/atoms = get_area_contents(/area/shuttle/mercenary)
	for (var/a in atoms)
		qdel(a)
	*/