/*
	Disabled for now.
	These events are meaningless unless there's someone inside those areas to set free.

	In order to work properly, we will need map markers or seperate areas set on brig cells, virology rooms, etc
	These will allow a can_trigger proc to intelligently decide if the event is viable
*/
/datum/event/prison_break
	startWhen		= 5
	announceWhen	= 75

	var/releaseWhen = 60
	var/list/area/areas = list()		//List of areas to affect. Filled by start()

	var/eventDept = "Security"			//Department name in announcement
	var/list/areaName = list("Brig")	//Names of areas mentioned in AI and Engineering announcements
	var/list/areaType = list(/area/eris/security/prison, /area/eris/security/brig)	//Area types to include.
	var/list/areaNotType = list()		//Area types to specifically exclude.

/datum/event/prison_break/virology
	eventDept = "Medical"
	areaName = list("Virology")
	areaType = list(/area/eris/medical/virology, /area/eris/medical/virologyaccess)

/datum/event/prison_break/xenobiology
	eventDept = "Science"
	areaName = list("Xenobiology")
	areaType = list(/area/eris/rnd/xenobiology)
	areaNotType = list(/area/eris/rnd/xenobiology/xenoflora, /area/eris/rnd/xenobiology/xenoflora_storage)

/datum/event/prison_break/station
	eventDept = "Station"
	areaName = list("Brig","Virology","Xenobiology")
	areaType = list(/area/eris/security/prison, /area/eris/security/brig, /area/eris/medical/virology, /area/eris/medical/virologyaccess, /area/eris/rnd/xenobiology)
	areaNotType = list(/area/eris/rnd/xenobiology/xenoflora, /area/eris/rnd/xenobiology/xenoflora_storage)


/datum/event/prison_break/setup()
	announceWhen = rand(75, 105)
	releaseWhen = rand(60, 90)

	src.endWhen = src.releaseWhen+2



/datum/event/prison_break/announce()
	if(areas && areas.len > 0)
		command_announcement.Announce("[pick("Gr3y.T1d3 virus","Malignant trojan")] detected in [station_name] [(eventDept == "Security")? "imprisonment":"containment"] subroutines. Secure any compromised areas immediately. Station AI involvement is recommended.", "[eventDept] Alert")


/datum/event/prison_break/start()
	for(var/area/A in GLOB.map_areas)
		if(is_type_in_list(A,areaType) && !is_type_in_list(A,areaNotType))
			areas += A

	if(areas && areas.len > 0)
		var/my_department = "[station_name] firewall subroutines"
		var/rc_message = "An unknown malicious program has been detected in the [english_list(areaName)] lighting and airlock control systems at [stationtime2text()]. Systems will be fully compromised within approximately three minutes. Direct intervention is required immediately.<br>"
		for(var/obj/machinery/message_server/MS in world)
			MS.send_rc_message("Engineering", my_department, rc_message, "", "", 2)
		for(var/mob/living/silicon/ai/A in GLOB.player_list)
			to_chat(A, SPAN_DANGER("Malicious program detected in the [english_list(areaName)] lighting and airlock control systems by [my_department]."))

	else
		log_world("ERROR: Could not initate grey-tide. Unable to find suitable containment area.")
		kill()


/datum/event/prison_break/tick()
	if(activeFor == releaseWhen)
		if(areas && areas.len > 0)
			var/obj/machinery/power/apc/theAPC = null
			for(var/area/A in areas)
				theAPC = A.get_apc()
				if(theAPC.operating)	//If the apc's off, it's a little hard to overload the lights.
					for(var/obj/machinery/light/L in A)
						L.flick_light(10)


/datum/event/prison_break/end()
	for(var/area/A in shuffle(areas))
		A.prison_break()
