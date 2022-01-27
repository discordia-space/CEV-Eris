/datum/admin_secret_item/admin_secret/jump_shuttle
	name = "Jump a Shuttle"

/datum/admin_secret_item/admin_secret/jump_shuttle/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/shuttle_tag = input(user, "Which shuttle do you want to jump?") as null|anything in SSshuttle.shuttles
	if (!shuttle_tag) return

	var/datum/shuttle/S = SSshuttle.shuttles69shuttle_tag69

	var/origin_area = input(user, "Which area is the shuttle at now? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)") as null|area in world
	if (!origin_area) return

	var/destination_area = input(user, "Which area is the shuttle at now? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)") as null|area in world
	if (!destination_area) return

	var/long_jump = alert(user, "Is there a transition area for this jump?","", "Yes", "No")
	if (long_jump == "Yes")
		var/transition_area = input(user, "Which area is the transition area? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)") as null|area in world
		if (!transition_area) return

		var/move_duration = input(user, "How69any seconds will this jump take?") as num

		S.long_jump(origin_area, destination_area, transition_area,69ove_duration)
		message_admins(SPAN_NOTICE("69key_name_admin(user)69 has initiated a jump from 69origin_area69 to 69destination_area69 lasting 69move_duration69 seconds for the 69shuttle_tag69 shuttle"), 1)
		log_admin("69key_name_admin(user)69 has initiated a jump from 69origin_area69 to 69destination_area69 lasting 69move_duration69 seconds for the 69shuttle_tag69 shuttle")
	else
		S.short_jump(origin_area, destination_area)
		message_admins(SPAN_NOTICE("69key_name_admin(user)69 has initiated a jump from 69origin_area69 to 69destination_area69 for the 69shuttle_tag69 shuttle"), 1)
		log_admin("69key_name_admin(user)69 has initiated a jump from 69origin_area69 to 69destination_area69 for the 69shuttle_tag69 shuttle")
