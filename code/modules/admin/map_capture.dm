ADMIN_VERB_ADD(/datum/admins/proc/capture_map, R_SERVER, FALSE)
/datum/admins/proc/capture_map(tx as null|num, ty as null|num, tz as null|num, range as null|num)
	set category = "Server"
	set name = "Capture69ap Part"
	set desc = "Usage: Capture-Map-Part target_x_cord target_y_cord target_z_cord range (takes a picture of a69ap originating from bottom left corner)"

	if(!check_rights(R_ADMIN|R_DEBUG|R_SERVER))
		to_chat(usr, "You are not allowed to use this command")
		return

	if(isnull(tx) || isnull(ty) || isnull(tz) || isnull(range))
		to_chat(usr, "Capture69ap Part, captures part of a69ap using camara like rendering.")
		to_chat(usr, "Usage: Capture-Map-Part target_x_cord target_y_cord target_z_cord range")
		to_chat(usr, "Target coordinates specify bottom left corner of the capture, range defines render distance to opposite corner.")
		return

	if(range > 32 || range <= 0)
		to_chat(usr, "Capturing range is incorrect, it69ust be within 1-32.")
		return

	if(locate(tx,ty,tz))
		var/cap = generate_image(tx ,ty ,tz ,range, CAPTURE_MODE_PARTIAL, null, 1)
		var/file_name = "map_capture_x69tx69_y69ty69_z69tz69_r69range69.png"
		to_chat(usr, "Saved capture in cache as 69file_name69.")
		usr << browse_rsc(cap, file_name)
	else
		to_chat(usr, "Target coordinates are incorrect.")
