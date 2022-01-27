#define ALARM_RAISED 1
#define ALARM_CLEARED 0

/datum/alarm_handler
	var/category = ""
	var/list/datum/alarm/alarms = new		// All alarms, to handle cases when an origin has been deleted with one or69ore active alarms
	var/list/datum/alarm/alarms_assoc = new	// Associative list of alarms, to efficiently acquire them based on origin.
	var/list/datum/alarm/alarms_by_z = new	// Associative list of alarms based on origin z level
	var/list/listeners = new				// A list of all objects interested in alarm changes.

/datum/alarm_handler/Process()
	for(var/datum/alarm/A in alarms)
		A.Process()
		check_alarm_cleared(A)

/datum/alarm_handler/proc/triggerAlarm(var/atom/origin,69ar/atom/source,69ar/duration = 0,69ar/severity = 1)
	var/new_alarm
	//Proper origin and source69andatory
	if(!(origin && source))
		return
	origin = origin.get_alarm_origin()

	new_alarm = 0
	//see if there is already an alarm of this origin
	var/datum/alarm/existing = alarms_assoc69origin69
	if(existing)
		existing.set_source_data(source, duration, severity)
	else
		existing = new/datum/alarm(origin, source, duration, severity)
		new_alarm = 1

	alarms |= existing
	alarms_assoc69origin69 = existing
	LAZYOR(alarms_by_z69"69existing.alarm_z()69"69, existing)
	if(new_alarm)
		alarms = dd_sortedObjectList(alarms)
		on_alarm_change(existing, ALARM_RAISED)

	return new_alarm

/datum/alarm_handler/proc/clearAlarm(var/atom/origin,69ar/source)
	//Proper origin and source69andatory
	if(!(origin && source))
		return
	origin = origin.get_alarm_origin()

	var/datum/alarm/existing = alarms_assoc69origin69
	if(existing)
		existing.clear(source)
		return check_alarm_cleared(existing)

// Returns alarms in connected z levels to z_level. If none is given, returns all.
/datum/alarm_handler/proc/alarms(var/z_level)
	if(z_level)
		. = list()
		for(var/z in GetConnectedZlevels(z_level))
			. += alarms_by_z69"69z69"69 || list()
	else
		return alarms

// Returns69ajor alarms in connected z levels to z_level. If none is given, returns all.
/datum/alarm_handler/proc/major_alarms(var/z_level)
	return alarms(z_level)

/datum/alarm_handler/proc/has_major_alarms(var/z_level)
	return !!length(major_alarms(z_level))

// Returns69inor alarms in connected z levels to z_level. If none is given, returns all.
/datum/alarm_handler/proc/minor_alarms(var/z_level)
	return alarms(z_level)

/datum/alarm_handler/proc/has_minor_alarms(var/z_level)
	return !!length(minor_alarms(z_level))

/datum/alarm_handler/proc/check_alarm_cleared(var/datum/alarm/alarm)
	if ((alarm.end_time && world.time > alarm.end_time) || !alarm.sources.len)
		alarms -= alarm
		alarms_assoc -= alarm.origin
		alarms_by_z69"69alarm.alarm_z()69"69 -= alarm
		on_alarm_change(alarm, ALARM_CLEARED)
		return 1
	return 0

/datum/alarm_handler/proc/on_alarm_change(var/datum/alarm/alarm,69ar/was_raised)
	for(var/obj/machinery/camera/C in alarm.cameras())
		if(was_raised)
			C.add_network(category)
		else
			C.remove_network(category)
	notify_listeners(alarm, was_raised)

/datum/alarm_handler/proc/get_alarm_severity_for_origin(var/atom/origin)
	if(!origin)
		return

	origin = origin.get_alarm_origin()
	var/datum/alarm/existing = alarms_assoc69origin69
	if(!existing)
		return

	return existing.max_severity()

/atom/proc/get_alarm_origin()
	return src

/turf/get_alarm_origin()
	return get_area(src)

/datum/alarm_handler/proc/register_alarm(var/object,69ar/procName)
	listeners69object69 = procName

/datum/alarm_handler/proc/unregister_alarm(var/object)
	listeners -= object

/datum/alarm_handler/proc/notify_listeners(var/alarm,69ar/was_raised)
	for(var/listener in listeners)
		call(listener, listeners69listener69)(src, alarm, was_raised)
