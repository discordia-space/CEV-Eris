ADMIN_VERB_ADD(/datum/admins/proc/capture_map, R_SERVER, FALSE)
/datum/admins/proc/capture_map(tx as null|num, ty as null|num, tz as null|num, range as null|num)
	set category = "Server"
	set name = "Capture Map Part"
	set desc = "Usage: Capture-Map-Part target_x_cord target_y_cord target_z_cord range (captures part of a map originating from bottom left corner)"

	if(!check_rights(R_ADMIN|R_DEBUG|R_SERVER))
		to_chat(usr, "You are not allowed to use this command")
		return

	if(isnull(tx) || isnull(ty) || isnull(tz) || isnull(range))
		to_chat(usr, "Capture Map Part, captures part of a map using camara like rendering.")
		to_chat(usr, "Usage: Capture-Map-Part target_x_cord target_y_cord target_z_cord range")
		to_chat(usr, "Target coordinates specify bottom left corner of the capture, range defines render distance to opposite corner.")
		return

	if(range > 32 || range <= 0)
		to_chat(usr, "Capturing range is incorrect, it must be within 1-32.")
		return

	if(locate(tx,ty,tz))
		var/cap = generate_image(tx ,ty ,tz ,range, CAPTURE_MODE_PARTIAL, null, 1)
		var/file_name = "map_capture_x[tx]_y[ty]_z[tz]_r[range].png"
		to_chat(usr, "Saved capture in cache as [file_name].")
		usr << browse_rsc(cap, file_name)
	else
		to_chat(usr, "Target coordinates are incorrect.")
