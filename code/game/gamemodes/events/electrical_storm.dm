/datum/event/electrical_storm
	var/lightsoutAmount	= 1
	var/lightsoutRange	= 25


/datum/event/electrical_storm/announce()
	command_announcement.Announce("An electrical storm has been detected in your area, please repair potential electronic overloads.", "Electrical Storm Alert")


/datum/event/electrical_storm/start()
	var/list/epicentreList = list()

	var/list/possibleEpicentres = list()
	for(var/obj/landmark/event/lightsout/newEpicentre in landmarks_list)
		if(!newEpicentre in epicentreList)
			possibleEpicentres += newEpicentre

	for(var/i=1, i <= lightsoutAmount, i++)
		if(possibleEpicentres.len)
			var/picked = pick(possibleEpicentres)
			epicentreList += picked
			possibleEpicentres -= picked
		else
			break

	if(!epicentreList.len)
		return

	for(var/obj/landmark/epicentre in epicentreList)
		for(var/obj/machinery/power/apc/apc in range(epicentre,lightsoutRange))
			apc.overload_lighting()
