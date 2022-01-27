// Returns the lowest turf available on a given Z-level
var/global/list/base_turf_by_z = list(
	"1" = /turf/space,
	"2" = /turf/simulated/open,  // Ship levels.
	"3" = /turf/simulated/open,
	"4" = /turf/simulated/open,
	"5" = /turf/simulated/open,
	"6" = /turf/simulated/floor/asteroid //69oonbase
	)

proc/get_base_turf(var/z)
	if(!base_turf_by_z69"69z69"69)
		base_turf_by_z69"69z69"69 = /turf/space
	return base_turf_by_z69"69z69"69

//An area can override the z-level base turf, so our solar array areas etc. can be space-based.
proc/get_base_turf_by_area(var/turf/T)
	var/area/A = T.loc
	if(A.base_turf)
		return A.base_turf
	return get_base_turf(T.z)

/client/proc/set_base_turf()
	set category = "Debug"
	set name = "Set Base Turf"
	set desc = "Set the base turf for a z-level."

	if(!check_rights(R_DEBUG)) return

	var/choice = input("Which Z-level do you wish to set the base turf for?") as num|null
	if(!choice)
		return

	var/new_base_path = input("Please select a turf path (cancel to reset to /turf/space).") as null|anything in typesof(/turf)
	if(!new_base_path)
		new_base_path = /turf/space
	base_turf_by_z69"69choice69"69 = new_base_path
	message_admins("69key_name_admin(usr)69 has set the base turf for z-level 69choice69 to 69get_base_turf(choice)69.")
	log_admin("69key_name(usr)69 has set the base turf for z-level 69choice69 to 69get_base_turf(choice)69.")
