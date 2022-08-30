/mob/Logout()
	// SEND_SIGNAL(src, COMSIG_MOB_LOGOUT)
	// GLOB.logged_out_event.raise_event(src, my_client)
	log_access("Logout: [key_name(src)]")
	SSnano.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	GLOB.player_list -= src

	if(admin_datums[src.ckey])
		if (SSticker.current_state == GAME_STATE_PLAYING) //Only report this stuff if we are currently playing.
			message_admins("Admin logout: [key_name(src)]")

	if(client && client.UI)
		client.UI.hide()

	..()

	return TRUE
