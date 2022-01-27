//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP69aster controller stuff)
//		-69C done
//		- lighting done


ADMIN_VERB_ADD(/client/proc/debug_antagonist_template, R_DEBUG, null)
/client/proc/debug_antagonist_template(antag_type in GLOB.all_antag_types)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = GLOB.all_antag_types69antag_type69
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin 69key_name_admin(usr)69 is debugging the 69antag.role_text69 template.")


ADMIN_VERB_ADD(/client/proc/debug_controller, R_DEBUG, null)
/client/proc/debug_controller(controller in list(
		"Evacuation", "Configuration",
		"Cameras", "Gas Data", "Plants", "Observation")
	)
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the69arious periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	switch(controller)
		if("Evacuation")
			debug_variables(evacuation_controller)

		if("Configuration")
			debug_variables(config)

		if("Cameras")
			debug_variables(cameranet)

		if("Gas Data")
			debug_variables(gas_data)

		if("Plants")
			debug_variables(plant_controller)

		if("Observation")
			debug_variables(GLOB.all_observable_events)

	message_admins("Admin 69key_name_admin(usr)69 is debugging the 69controller69 controller.")
	return
