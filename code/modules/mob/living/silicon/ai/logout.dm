
/mob/living/silicon/ai/Logout()
	if(old_client)
		QDEL_NULL(old_client.CH)
	old_client = null
	..()
	for(var/obj/machinery/ai_status_display/O in world) //change status
		O.mode = 0
	if(!isturf(loc))
		if (client)
			client.eye = loc
			client.perspective = EYE_PERSPECTIVE

	view_core()
	return
