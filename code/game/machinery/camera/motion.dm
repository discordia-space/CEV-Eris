/obj/machinery/camera
	var/list/motion_targets = list()
	var/detect_time = 0
	var/area/ai_monitored/area_motion = null
	var/alarm_delay = 100 // Don't forget, there's another 10 seconds in queueAlarm()
	flags = PROXMOVE

/obj/machinery/camera/internal_process()
	// motion camera event loop
	if(stat & (EMPED|NOPOWER))
		return
	if(!isMotion())
		. = PROCESS_KILL
		return
	if(detect_time > 0)
		var/elapsed = world.time - detect_time
		if(elapsed > alarm_delay)
			triggerAlarm()
	else if(detect_time == -1)
		for(var/mob/target in motion_targets)
			if(target.stat == 2)
				lostTarget(target)
			// If not detecting with motion camera...
			if(!area_motion)
				// See if the camera is still in range
				if(!in_range(src, target))
					// If they aren't in range, lose the target.
					lostTarget(target)

/obj/machinery/camera/proc/newTarget(mob/target)
	if(isAI(target))
		return
	if(detect_time == 0)
		detect_time = world.time // start the clock
	if(!(target in motion_targets))
		RegisterSignal(target, COMSIG_NULL_TARGET, PROC_REF(lostTarget), TRUE)
		motion_targets += target
	return TRUE

/obj/machinery/camera/proc/lostTarget(mob/target)
	if(target in motion_targets)
		UnregisterSignal(target, COMSIG_NULL_TARGET)
		motion_targets -= target
	if(motion_targets.len == 0)
		cancelAlarm()

/obj/machinery/camera/proc/cancelAlarm()
	if(!status || (stat & NOPOWER))
		return
	if(detect_time == -1)
		motion_alarm.clearAlarm(loc, src)
	detect_time = 0
	return TRUE

/obj/machinery/camera/proc/triggerAlarm()
	if(!status || (stat & NOPOWER))
		return
	if(!detect_time)
		return
	motion_alarm.triggerAlarm(loc, src)
	detect_time = -1
	return TRUE

/obj/machinery/camera/HasProximity(atom/movable/AM)
	// Motion cameras outside of an "ai monitored" area will use this to detect stuff.
	if(!area_motion)
		if(isliving(AM))
			newTarget(AM)

