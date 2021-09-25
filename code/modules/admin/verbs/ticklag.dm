//replaces the old Ticklag verb, fps is easier to understand
/client/proc/set_server_fps()
	set category = "Debug"
	set name = "Set Server FPS"
	set desc = "Sets game speed in frames-per-second. Can potentially break the game"

	if(!check_rights(R_DEBUG))
		return
	var/new_fps = round(input("Sets game frames-per-second. Can potentially break the game (default: 20)","FPS", world.fps) as num|null)

	if(new_fps <= 0)
		to_chat(src, SPAN_WARNING("Error: set_server_fps(): Invalid world.fps value. No changes made."), confidential = TRUE)
		return


	var/msg = "[key_name(src)] has modified world.fps to [new_fps]"
	log_admin(msg, 0)
	message_admins(msg, 0)
	world.change_fps(new_fps)
