/mob/living/silicon/decoy/death(gibbed)
	if(stat == DEAD)	return
	icon_state = "ai-crash"
	spawn(10)
		explosion(get_turf(src), 1500, 100)
	for(var/obj/machinery/ai_status_display/O in GLOB.ai_status_display_list) //change status
		O.mode = 2
	return ..(gibbed)
