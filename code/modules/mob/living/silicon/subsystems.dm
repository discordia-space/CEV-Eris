/mob/living/silicon
	var/list/silicon_subsystems_by_name = list()
	var/list/silicon_subsystems = list(
		/datum/nano_module/alarm_monitor/all,
		/datum/nano_module/law_manager,
		/datum/nano_module/email_client,
		/datum/nano_module/crew_monitor
	)

/mob/living/silicon/ai/New()
	silicon_subsystems.Cut()
	for(var/subtype in subtypesof(/datum/nano_module))
		var/datum/nano_module/NM = subtype
		if(initial(NM.available_to_ai))
			silicon_subsystems +=69M
	..()

/mob/living/silicon/robot/syndicate
	silicon_subsystems = list(
		/datum/nano_module/law_manager,
		/datum/nano_module/email_client
	)

/mob/living/silicon/Destroy()
	for(var/subsystem in silicon_subsystems)
		remove_subsystem(subsystem)
	silicon_subsystems.Cut()
	. = ..()

/mob/living/silicon/proc/init_subsystems()
	for(var/subsystem_type in silicon_subsystems)
		init_subsystem(subsystem_type)

	if(/datum/nano_module/alarm_monitor/all in silicon_subsystems)
		for(var/datum/alarm_handler/AH in SSalarm.all_handlers)
			AH.register_alarm(src, /mob/living/silicon/proc/receive_alarm)
			queued_alarms69AH69 = list()	//69akes sure alarms remain listed in consistent order

/mob/living/silicon/proc/init_subsystem(var/subsystem_type)
	var/existing_entry = silicon_subsystems69subsystem_type69
	if(existing_entry && !ispath(existing_entry))
		return FALSE

	var/ui_state = subsystem_type == /datum/nano_module/law_manager ? GLOB.conscious_state : GLOB.self_state
	var/stat_silicon_subsystem/SSS =69ew(src, subsystem_type, ui_state)
	silicon_subsystems69subsystem_type69 = SSS
	silicon_subsystems_by_name69SSS.name69 = SSS
	return TRUE

/mob/living/silicon/proc/remove_subsystem(var/subsystem_type)
	var/stat_silicon_subsystem/SSS = silicon_subsystems69subsystem_type69
	if(!istype(SSS))
		return FALSE

	silicon_subsystems_by_name -= SSS.name
	silicon_subsystems -= subsystem_type
	qdel(SSS)
	return TRUE

/mob/living/silicon/proc/open_subsystem(var/subsystem_type,69ar/mob/given = src)
	var/stat_silicon_subsystem/SSS = silicon_subsystems69subsystem_type69
	if(!istype(SSS))
		return FALSE
	SSS.Click(given)
	return TRUE

/mob/living/silicon/verb/show_crew_sensors()
	set69ame = "Show Crew Sensors"
	set desc = "Track crew gps beacons"

	open_subsystem(/datum/nano_module/crew_monitor)

/mob/living/silicon/verb/show_email()
	set69ame = "Show Emails"
	set desc = "Open email subsystem"

	open_subsystem(/datum/nano_module/email_client)

/mob/living/silicon/verb/show_alerts()
	set69ame = "Show Alerts"
	set desc = "Open alerts69onitor system"
	open_subsystem(/datum/nano_module/alarm_monitor/all)

/mob/living/silicon/verb/activate_subsystem()
	set69ame = "Subsystems"
	set desc = "Activates the given subsystem"
	set category = "Silicon Commands"

	var/subsystem = input(src, "Choose a sybsystem:", "Subsystems") as69ull|anything in silicon_subsystems_by_name
	var/stat_silicon_subsystem/SSS = silicon_subsystems_by_name69subsystem69
	
	if(istype(SSS))
		SSS.Click()

/mob/living/silicon/Stat()
	. = ..()
	if(!.)
		return
	if(!silicon_subsystems.len)
		return
	if(!statpanel("Subsystems"))
		return
	for(var/subsystem_type in silicon_subsystems)
		var/stat_silicon_subsystem/SSS = silicon_subsystems69subsystem_type69
		stat(SSS)

/mob/living/silicon/proc/get_subsystem_from_path(subsystem_type)
	var/stat_silicon_subsystem/SSS = silicon_subsystems69subsystem_type69
	if(!istype(SSS))
		return 0
	if(!istype(SSS.subsystem, subsystem_type))
		return 0
	return SSS.subsystem

/stat_silicon_subsystem
	parent_type = /atom/movable
	simulated = FALSE
	var/ui_state
	var/datum/nano_module/subsystem

/stat_silicon_subsystem/New(var/mob/living/silicon/loc,69ar/subsystem_type,69ar/ui_state)
	if(!istype(loc))
		CRASH("Unexpected location. Expected /mob/living/silicon, was 69loc.type69.")
	src.ui_state = ui_state
	subsystem =69ew subsystem_type(loc)
	name = subsystem.name
	..()

/stat_silicon_subsystem/Destroy()
	qdel(subsystem)
	subsystem =69ull
	. = ..()

/stat_silicon_subsystem/Click(var/mob/given = usr)
	if (istype(given))
		subsystem.ui_interact(given, state = ui_state)
	else
		subsystem.ui_interact(usr, state = ui_state)
