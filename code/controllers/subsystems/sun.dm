SUBSYSTEM_DEF(sun)
	name = "Sun"
	wait = 1 MINUTES

	var/angle
	var/dx
	var/dy
	var/rate
	var/list/solars = list()

/datum/controller/subsystem/sun/Initialize(start_timeofday)
	angle = rand(0, 359) // angle = azimuth
	rate = round(rand(50, 200)/100, 0.01) // 50% - 200% of standard rotation. Rate = azimuth_mod
	if(prob(50))
		rate *= -1
	return ..()

/datum/controller/subsystem/sun/stat_entry(msg)
	msg = "P:[solars.len], A:[angle]"
	return ..()

/datum/controller/subsystem/sun/fire(resumed = FALSE)
	angle += rate * 6
	angle = round(angle, 0.01)
	if(angle >= 360)
		angle -= 360
	if(angle < 0)
		angle += 360

	var/s = sin(angle)
	var/c = cos(angle)

	// Either "abs(s) < abs(c)" or "abs(s) >= abs(c)"
	// In both cases, the greater is greater than 0, so, no "if 0" check is needed for the divisions
	if( abs(s) < abs(c))
		dx = s / abs(c)
		dy = c / abs(c)
	else
		dx = s/abs(s)
		dy = c / abs(s)

	complete_movement()

/datum/controller/subsystem/sun/proc/complete_movement()
	// SEND_SIGNAL(src, COMSIG_SUN_MOVED, azimuth)
	for(var/obj/machinery/power/solar_control/SC in solars)
		if(!SC.powernet)
			solars.Remove(SC)
			continue
		SC.update()

/datum/controller/subsystem/sun/vv_edit_var(var_name, var_value)
	. = ..()
	if(var_name == NAMEOF(src, angle))
		complete_movement()
