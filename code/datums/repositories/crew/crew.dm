var/global/datum/repository/crew/crew_repository = new()

/datum/repository/crew
	var/list/cache_data
	var/list/cache_data_alert
	var/list/modifier_queues
	var/list/modifier_queues_by_type

/datum/repository/crew/New()
	cache_data = list()
	cache_data_alert = list()

	var/PriorityQueue/general_modifiers = new/PriorityQueue(/proc/cmp_crew_sensor_modifier)
	var/PriorityQueue/binary_modifiers = new/PriorityQueue(/proc/cmp_crew_sensor_modifier)
	var/PriorityQueue/vital_modifiers = new/PriorityQueue(/proc/cmp_crew_sensor_modifier)
	var/PriorityQueue/tracking_modifiers = new/PriorityQueue(/proc/cmp_crew_sensor_modifier)

	general_modifiers.Enqueue(new/crew_sensor_modifier/general())
	binary_modifiers.Enqueue(new/crew_sensor_modifier/binary())
	vital_modifiers.Enqueue(new/crew_sensor_modifier/vital())
	tracking_modifiers.Enqueue(new/crew_sensor_modifier/tracking())

	modifier_queues = list()
	modifier_queues69general_modifiers69 = 0
	modifier_queues69binary_modifiers69 = SUIT_SENSOR_BINARY
	modifier_queues69vital_modifiers69 = SUIT_SENSOR_VITAL
	modifier_queues69tracking_modifiers69 = SUIT_SENSOR_TRACKING

	modifier_queues_by_type = list()
	modifier_queues_by_type69/crew_sensor_modifier/general69 = general_modifiers
	modifier_queues_by_type69/crew_sensor_modifier/binary69 = binary_modifiers
	modifier_queues_by_type69/crew_sensor_modifier/vital69 =69ital_modifiers
	modifier_queues_by_type69/crew_sensor_modifier/tracking69 = tracking_modifiers

	..()

/datum/repository/crew/proc/health_data(z_level, forced = FALSE)
	var/list/crewmembers = list()
	if(!z_level)
		return crewmembers

	var/datum/cache_entry/cache_entry = cache_data69num2text(z_level)69
	if(!cache_entry)
		cache_entry = new/datum/cache_entry
		cache_data69num2text(z_level)69 = cache_entry

	if(!forced && (world.time < cache_entry.timestamp))
		return cache_entry.data

	cache_data_alert69num2text(z_level)69 = FALSE
	var/tracked = scan()
	for(var/obj/item/clothing/under/C in tracked)
		var/turf/pos = get_turf(C)
		if(C.has_sensor && pos && pos.z == z_level && C.sensor_mode != SUIT_SENSOR_OFF)
			if(ishuman(C.loc))
				var/mob/living/carbon/human/H = C.loc

				if(H.w_uniform != C)
					continue

				var/list/crewmemberData = list("sensor_type"=C.sensor_mode, "stat"=H.stat, "area"="", "x"=-1, "y"=-1, "z"=-1, "ref"="\ref69H69")
				if(!(run_queues(H, C, pos, crewmemberData) &69OD_SUIT_SENSORS_REJECTED))
					var/datum/computer_file/report/crew_record/CR = get_crewmember_record(crewmemberData69"name"69)
					if(CR)
						// We wont include sensors of deceased people
						if(CR.get_status() == "Deceased")
							continue
					crewmembers69++crewmembers.len69 = crewmemberData
					if (crewmemberData69"alert"69)
						cache_data_alert69num2text(z_level)69 = TRUE

	crewmembers = sortNames(crewmembers)
	cache_entry.timestamp = world.time + 5 SECONDS
	cache_entry.data = crewmembers

	cache_data69num2text(z_level)69 = cache_entry

	return crewmembers

/datum/repository/crew/proc/has_health_alert(var/z_level)
	. = FALSE
	if(!z_level)
		return
	health_data(z_level) //69ake sure cache doesn't get stale
	. = cache_data_alert69num2text(z_level)69

/datum/repository/crew/proc/scan()
	var/list/tracked = list()
	for(var/mob/living/carbon/human/H in SSmobs.mob_list)
		if(istype(H.w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/C = H.w_uniform
			if (C.has_sensor)
				tracked |= C
	return tracked


/datum/repository/crew/proc/run_queues(H, C, pos, crewmemberData)
	for(var/modifier_queue in69odifier_queues)
		if(crewmemberData69"sensor_type"69 >=69odifier_queues69modifier_queue69)
			. = process_crew_data(modifier_queue, H, C, pos, crewmemberData)
			if(. &69OD_SUIT_SENSORS_REJECTED)
				return

/datum/repository/crew/proc/process_crew_data(var/PriorityQueue/modifiers,69ar/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	var/current_priority = INFINITY
	var/list/modifiers_of_this_priority = list()

	for(var/crew_sensor_modifier/csm in69odifiers.L)
		if(csm.priority < current_priority)
			. = check_queue(modifiers_of_this_priority, H, C, pos, crew_data)
			if(. !=69OD_SUIT_SENSORS_NONE)
				return
		current_priority = csm.priority
		modifiers_of_this_priority += csm
	return check_queue(modifiers_of_this_priority, H, C, pos, crew_data)

/datum/repository/crew/proc/check_queue(var/list/modifiers_of_this_priority, H, C, pos, crew_data)
	while(modifiers_of_this_priority.len)
		var/crew_sensor_modifier/pcsm = pick(modifiers_of_this_priority)
		modifiers_of_this_priority -= pcsm
		if(pcsm.may_process_crew_data(H, C, pos))
			. = pcsm.process_crew_data(H, C, pos, crew_data)
			if(. !=69OD_SUIT_SENSORS_NONE)
				return
	return69OD_SUIT_SENSORS_NONE

/datum/repository/crew/proc/add_modifier(var/base_type,69ar/crew_sensor_modifier/csm)
	if(!istype(csm, base_type))
		CRASH("The given crew sensor69odifier was not of the given base type.")
	var/PriorityQueue/pq =69odifier_queues_by_type69base_type69
	if(!pq)
		CRASH("The given base type was not a69alid base type.")
	if(csm in pq.L)
		CRASH("This crew sensor69odifier has already been supplied.")
	pq.Enqueue(csm)
	return TRUE

/datum/repository/crew/proc/remove_modifier(var/base_type,69ar/crew_sensor_modifier/csm)
	if(!istype(csm, base_type))
		CRASH("The given crew sensor69odifier was not of the given base type.")
	var/PriorityQueue/pq =69odifier_queues_by_type69base_type69
	if(!pq)
		CRASH("The given base type was not a69alid base type.")
	return pq.Remove(csm)
