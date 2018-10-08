/datum/storyevent/grid_check
	cost = 20


	event_type = /datum/event/grid_check
	event_pools = list(EVENT_LEVEL_MUNDANE,EVENT_LEVEL_MODERATE)
	tags = list(TAG_SCARY, TAG_COMMUNAL, TAG_NEGATIVE)


/datum/storyevent/grid_check/get_cost(var/severity)
	return cost*severity

///////////////////////////////////////////////////////////////////////

/datum/event/grid_check	//NOTE: Times are measured in master controller ticks!
	announceWhen		= 5

/datum/event/grid_check/start()
	power_failure(0, severity, maps_data.contact_levels)

/datum/event/grid_check/announce()
	command_announcement.Announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the ship's power will be shut off for an indeterminate duration.", "Automated Grid Check", new_sound = 'sound/AI/poweroff.ogg')



/proc/power_failure(var/announce = 1, var/severity = 2, var/list/affected_z_levels)
	if(announce)
		command_announcement.Announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the ship's power will be shut off for an indeterminate duration.", "Critical Power Failure", new_sound = 'sound/AI/poweroff.ogg')

	for(var/obj/machinery/power/smes/buildable/S in SSmachines.machinery)
		S.energy_fail(rand(10 * severity*severity,20 * severity*severity))


	for(var/obj/machinery/power/apc/C in SSmachines.machinery)
		if(!C.is_critical && (!affected_z_levels || (C.z in affected_z_levels)))
			C.energy_fail(rand(30 * severity*severity,100 * severity*severity))

/proc/power_restore(var/announce = 1)
	var/list/skipped_areas = list(/area/turret_protected/ai)

	if(announce)
		command_announcement.Announce("Power has been restored to [station_name()]. We apologize for the inconvenience.", "Power Systems Nominal", new_sound = 'sound/AI/poweron.ogg')
	for(var/obj/machinery/power/apc/C in SSmachines.machinery)
		C.failure_timer = 0
		if(C.cell)
			C.cell.charge = C.cell.maxcharge
	for(var/obj/machinery/power/smes/S in SSmachines.machinery)
		var/area/current_area = get_area(S)
		if(current_area.type in skipped_areas)
			continue
		S.failure_timer = 0
		S.charge = S.capacity
		S.update_icon()
		S.power_change()

/proc/power_restore_quick(var/announce = 1)

	if(announce)
		command_announcement.Announce("All SMESs on [station_name()] have been recharged. We apologize for the inconvenience.", "Power Systems Nominal", new_sound = 'sound/AI/poweron.ogg')
	for(var/obj/machinery/power/smes/S in SSmachines.machinery)
		S.failure_timer = 0
		S.charge = S.capacity
		S.output_level = S.output_level_max
		S.output_attempt = 1
		S.input_attempt = 1
		S.update_icon()
		S.power_change()
