/*
	Cameras in a radius will break. This provides plausible deniability to contractors and saboteurs, as
	as well as possibly raising a false alarm and the AI mobilising ironhammer to investigate nothing.

	Mainly it hurts the AI, and provides work for engineers
*/
/datum/storyevent/camera_damage
	id = "camera_damage"
	name = "camera damage"

	event_type = /datum/event/camera_damage
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE)
	tags = list(TAG_TARGETED, TAG_DESTRUCTIVE, TAG_NEGATIVE)

/////////.//////////////////////////////////////
/datum/event/camera_damage/start()
	var/obj/machinery/camera/C = acquire_random_camera()
	if(!C)
		return

	var/severity_range = 15
	log_and_message_admins("Camera damage event triggered at [jumplink(C)],")
	for(var/obj/machinery/camera/cam in range(severity_range,C))
		if(is_valid_camera(cam))
			if(prob(2))
				cam.destroy()
			else
				cam.wires.UpdateCut(CAMERA_WIRE_POWER, 0)
				if(prob(5))
					cam.wires.UpdateCut(CAMERA_WIRE_ALARM, 0)

/datum/event/camera_damage/proc/acquire_random_camera(var/remaining_attempts = 5)
	if(!cameranet.cameras.len)
		return
	if(!remaining_attempts)
		return

	var/obj/machinery/camera/C = pick(cameranet.cameras)
	if(is_valid_camera(C))
		return C
	return acquire_random_camera(remaining_attempts-1)

/datum/event/camera_damage/proc/is_valid_camera(var/obj/machinery/camera/C)
	// Only return a functional camera, not installed in a silicon, and that exists somewhere players have access
	return isOnPlayerLevel(C) && C.can_use() && !issilicon(C.loc)
