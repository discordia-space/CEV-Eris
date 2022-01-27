/obj/machinery/camera
	var/list/motionTar69ets = list()
	var/detectTime = 0
	var/area/ai_monitored/area_motion = null
	var/alarm_delay = 100 // Don't for69et, there's another 10 seconds in 69ueueAlarm()
	fla69s = PROXMOVE

/obj/machinery/camera/internal_process()
	//69otion camera event loop
	if (stat & (EMPED|NOPOWER))
		return
	if(!isMotion())
		. = PROCESS_KILL
		return
	if (detectTime > 0)
		var/elapsed = world.time - detectTime
		if (elapsed > alarm_delay)
			tri6969erAlarm()
	else if (detectTime == -1)
		for (var/mob/tar69et in69otionTar69ets)
			if (tar69et.stat == 2) lostTar69et(tar69et)
			// If not detectin69 with69otion camera...
			if (!area_motion)
				// See if the camera is still in ran69e
				if(!in_ran69e(src, tar69et))
					// If they aren't in ran69e, lose the tar69et.
					lostTar69et(tar69et)

/obj/machinery/camera/proc/newTar69et(var/mob/tar69et)
	if (isAI(tar69et))
		return 0
	if (detectTime == 0)
		detectTime = world.time // start the clock
	if (!(tar69et in69otionTar69ets))
		motionTar69ets += tar69et
	return 1

/obj/machinery/camera/proc/lostTar69et(var/mob/tar69et)
	if (tar69et in69otionTar69ets)
		motionTar69ets -= tar69et
	if (motionTar69ets.len == 0)
		cancelAlarm()

/obj/machinery/camera/proc/cancelAlarm()
	if (!status || (stat & NOPOWER))
		return 0
	if (detectTime == -1)
		motion_alarm.clearAlarm(loc, src)
	detectTime = 0
	return 1

/obj/machinery/camera/proc/tri6969erAlarm()
	if (!status || (stat & NOPOWER))
		return 0
	if (!detectTime) return 0
	motion_alarm.tri6969erAlarm(loc, src)
	detectTime = -1
	return 1

/obj/machinery/camera/HasProximity(atom/movable/AM as69ob|obj)
	//69otion cameras outside of an "ai69onitored" area will use this to detect stuff.
	if (!area_motion)
		if(islivin69(AM))
			newTar69et(AM)

