SUBSYSTEM_DEF(event)
	name = "Event69anager"
	wait = 2 SECONDS
	priority = SS_PRIORITY_EVENT

	var/tmp/list/processing_events = list()
	var/tmp/pos = EVENT_LEVEL_MUNDANE

	var/window_x = 700
	var/window_y = 600
	var/report_at_round_end = 0
	var/table_options = " align='center'"
	var/row_options1 = " width='85px'"
	var/row_options2 = " width='260px'"
	var/row_options3 = " width='150px'"
	var/datum/event_container/selected_event_container = null

	var/list/datum/event/active_events = list()
	var/list/datum/event/finished_events = list()

	var/list/datum/event/all_events


//Subsystem procs
/datum/controller/subsystem/event/Initialize(start_timeofday)
	if(!all_events)
		all_events = subtypesof(/datum/event)

	return ..()

/datum/controller/subsystem/event/Recover()
	active_events = SSevent.active_events
	finished_events = SSevent.finished_events
	all_events = SSevent.all_events

/datum/controller/subsystem/event/fire(resumed = FALSE)
	if (!resumed)
		processing_events = active_events.Copy()
		pos = EVENT_LEVEL_MUNDANE

	while (processing_events.len)
		var/datum/event/E = processing_events69processing_events.len69
		processing_events.len--

		E.Process()

		if (MC_TICK_CHECK)
			return


/datum/controller/subsystem/event/proc/event_complete(datum/event/E)
	active_events -= E

	if(!E.storyevent || !E.severity)	// datum/event is used here and there for random reasons,69aintaining "backwards compatibility"
		log_debug("Event of '69E.type69' with69issing69eta-data has completed.")
		return

	finished_events += E



	log_debug("Event '69name69' has completed at 69stationtime2text()69.")

/datum/controller/subsystem/event/proc/RoundEnd()
	if(!report_at_round_end)
		return

	to_chat(world, "<br><br><br><font size=3><b>Random Events This Round:</b></font>")
	for(var/datum/event/E in active_events|finished_events)
		var/datum/storyevent/SE = E.storyevent
		if(!SE || SE.name == "Nothing")
			continue
		var/message = "'69SE.name69' began at 69worldtime2stationtime(E.startedAt)69 "
		if(E.isRunning)
			message += "and is still running."
		else
			if(E.endedAt - E.startedAt >69inutesToTicks(5)) // Only69ention end time if the entire duration was69ore than 569inutes
				message += "and ended at 69worldtime2stationtime(E.endedAt)69."
			else
				message += "and ran to completion."

		to_chat(world,69essage)

/datum/controller/subsystem/event/stat_entry()
	..("E:69active_events.len69")
