/proc/lightsout(isEvent = 0, lightsoutAmount = 1,lightsoutRange = 25) //leave lightsoutAmount as 0 to break ALL lights
	if(isEvent)
		command_announcement.Announce("An Electrical storm has been detected in your area, please repair potential electronic overloads.","Electrical Storm Alert")

	if(lightsoutAmount)
		var/list/possibleEpicentres = list()
		for(var/obj/landmark/event/lightsout/newEpicentre in landmarks_list)
			possibleEpicentres += newEpicentre

		var/list/epicentreList = list()
		for(var/i=1,i<=lightsoutAmount,i++)
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

	else
		for(var/obj/machinery/power/apc/apc in SSmachines.machinery)
			apc.overload_lighting()

	return

