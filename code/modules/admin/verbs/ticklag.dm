//replaces the old Ticklag69erb, fps is easier to understand
/client/proc/set_server_fps()
	set category = "Debug"
	set name = "Set Server FPS"
	set desc = "Sets game speed in frames-per-second. Can potentially break the game"

	if(!check_rights(R_DEBUG))
		return
	var/new_fps = round(input("Sets game frames-per-second. Can potentially break the game (default: 20)","FPS", world.fps) as num|null)

	if(new_fps <= 0)
		to_chat(src, SPAN_WARNING("Error: set_server_fps(): Invalid world.fps69alue. No changes69ade."))
		return


	var/msg = "69key_name(src)69 has69odified world.fps to 69new_fps69"
	log_admin(msg, 0)
	message_admins(msg, 0)
	world.change_fps(new_fps)
