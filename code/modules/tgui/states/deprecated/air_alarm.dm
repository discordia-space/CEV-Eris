/datum/ui_state/air_alarm
	var/datum/nano_module/atmos_control/atmos_control = null
	var/obj/machinery/alarm/air_alarm = null

/datum/ui_state/air_alarm/can_use_topic(src_object, mob/user)
	if(has_access(user))
		return UI_INTERACTIVE
	return UI_UPDATE

/datum/ui_state/air_alarm/href_list(mob/user)
	var/list/extra_href = list()
	extra_href["remote_connection"] = 1
	extra_href["remote_access"] = has_access(user)

	return extra_href

/datum/ui_state/air_alarm/proc/has_access(mob/user)
	return user && (isAI(user) || atmos_control.access.allowed(user) || atmos_control.emagged || air_alarm.rcon_setting == RCON_YES || (air_alarm.alarm_area.atmosalm && air_alarm.rcon_setting == RCON_AUTO))
