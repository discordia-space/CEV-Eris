//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff)
//		- MC done
//		- lighting done


/*
ADMIN_VERB_ADD(/client/proc/debug_antagonist_template, R_DEBUG, null)
/client/proc/debug_antagonist_template(antag_type in all_antag_types)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")
*/


ADMIN_VERB_ADD(/client/proc/debug_controller, R_DEBUG, null)
/client/proc/debug_controller(controller in list(
		"Master", "Air", "Jobs", "Sun", "Radio",
		"Shuttles", "Evacuation", "Configuration", "pAI", "Cameras", "Transfer Controller",
		"Gas Data", "Plants", "Observation")
	)
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	switch(controller)
		if("Master")
			debug_variables(master_controller)

		if("Air")
			debug_variables(SSair)

		if("Jobs")
			debug_variables(job_master)

		if("Sun")
			debug_variables(sun)

		if("Radio")
			debug_variables(radio_controller)

		if("Shuttles")
			debug_variables(shuttle_controller)

		if("Evacuation")
			debug_variables(evacuation_controller)

		if("Configuration")
			debug_variables(config)

		if("pAI")
			debug_variables(paiController)

		if("Cameras")
			debug_variables(cameranet)

		if("Gas Data")
			debug_variables(gas_data)

		if("Plants")
			debug_variables(plant_controller)

		if("Observation")
			debug_variables(all_observable_events)

	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
