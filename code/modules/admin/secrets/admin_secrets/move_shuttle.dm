/datum/admin_secret_item/admin_secret/move_shuttle
	name = "Move a Shuttle"

/datum/admin_secret_item/admin_secret/move_shuttle/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/confirm = alert(user, "This command directly moves a shuttle from one area to another. DO NOT USE THIS UNLESS YOU ARE DEBUGGING A SHUTTLE AND YOU KNOW WHAT YOU ARE DOING.", "Are you sure?", "Ok", "Cancel")
	if (confirm == "Cancel")
		return

	var/shuttle_tag = input(user, "Shuttle:", "Which shuttle do you want to move?") as null|anything in SSshuttle.shuttles
	if (!shuttle_tag) return

	var/datum/shuttle/S = SSshuttle.shuttles[shuttle_tag]

	var/list/possible_d = list()
	for(var/obj/effect/shuttle_landmark/WP in world)
		possible_d["[WP.name]"] = WP

	var/D = input(user, "Destination:", "Select the destination.") as null|anything in possible_d
	var/obj/effect/shuttle_landmark/destination = possible_d[D]
	if (!destination || !istype(destination)) return

	S.attempt_move(destination)
	log_and_message_admins("moved the [shuttle_tag] shuttle to [destination] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[destination.x];Y=[destination.y];Z=[destination.z]'>JMP</a>)", user)
