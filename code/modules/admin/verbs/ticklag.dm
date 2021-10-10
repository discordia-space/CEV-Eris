//replaces the old Ticklag verb, fps is easier to understand
/client/proc/set_server_fps()
	set category = "Debug"
	set name = "Set Server FPS"
	set desc = "Sets game speed in frames-per-second. Can potentially break the game"

	if(!check_rights(R_DEBUG))
		return
	var/new_fps = round(input("Sets game frames-per-second. Can potentially break the game (default: 20)","FPS", world.fps) as num|null)

	var/newtick = input("Sets a new tick lag. Please don't mess with this too much! The stable, time-tested ticklag value is 0.33","Lag of Tick", world.tick_lag) as num|null
	//I've used ticks of 2 before to help with serious singulo lags
	if(newtick && newtick <= 2 && newtick > 0)
		log_admin("[key_name(src)] has modified world.tick_lag to [newtick]", 0)
		message_admins("[key_name(src)] has modified world.tick_lag to [newtick]", 0)
		world.tick_lag = newtick
		// No, extools CANNOT change defines, but they can change globals/runtime values.
		GLOB.internal_tick_usage = world.tick_lag * MAPTICK_MC_MIN_RESERVE * 0.01
	else
		to_chat(src, SPAN_WARNING("Error: ticklag(): Invalid world.ticklag value. No changes made."))


	var/msg = "[key_name(src)] has modified world.fps to [new_fps]"
	log_admin(msg, 0)
	message_admins(msg, 0)
	world.change_fps(new_fps)
