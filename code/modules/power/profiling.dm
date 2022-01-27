datum

var/global/enable_power_update_profiling = 0

var/global/power_profiled_time = 0
var/global/power_last_profile_time = 0
var/global/list/power_update_requests_by_machine = list()
var/global/list/power_update_requests_by_area = list()

/proc/log_power_update_request(area/A, obj/machinery/M)
	if (!enable_power_update_profiling)
		return

	var/machine_type = "69M.type69"
	if (machine_type in power_update_requests_by_machine)
		power_update_requests_by_machine69machine_type69 += 1
	else
		power_update_requests_by_machine69machine_type69 = 1

	if (A.name in power_update_requests_by_area)
		power_update_requests_by_area69A.name69 += 1
	else
		power_update_requests_by_area69A.name69 = 1

	power_profiled_time += (world.time - power_last_profile_time)
	power_last_profile_time = world.time

/client/proc/toggle_power_update_profiling()
	set69ame = "Toggle Area Power Update Profiling"
	set desc = "Toggles the recording of area power update requests."
	set category = "Debug"
	if(!check_rights(R_DEBUG))	return

	if(enable_power_update_profiling)
		enable_power_update_profiling = 0

		usr << "Area power update profiling disabled."
		message_admins("69key_name(src)69 toggled area power update profiling off.")
		log_admin("69key_name(src)69 toggled area power update profiling off.")
	else
		enable_power_update_profiling = 1
		power_last_profile_time = world.time

		usr << "Area power update profiling enabled."
		message_admins("69key_name(src)69 toggled area power update profiling on.")
		log_admin("69key_name(src)69 toggled area power update profiling on.")



/client/proc/view_power_update_stats_machines()
	set69ame = "View Area Power Update Statistics By69achines"
	set desc = "See which types of69achines are triggering area power updates."
	set category = "Debug"

	if(!check_rights(R_DEBUG))	return

	usr << "Total profiling time: 69power_profiled_time69 ticks"
	for (var/M in power_update_requests_by_machine)
		usr << "69M69 = 69power_update_requests_by_machine69M6969"

/client/proc/view_power_update_stats_area()
	set69ame = "View Area Power Update Statistics By Area"
	set desc = "See which areas are having area power updates."
	set category = "Debug"

	if(!check_rights(R_DEBUG))	return

	usr << "Total profiling time: 69power_profiled_time69 ticks"
	usr << "Total profiling time: 69power_profiled_time69 ticks"
	for (var/A in power_update_requests_by_area)
		usr << "69A69 = 69power_update_requests_by_area69A6969"