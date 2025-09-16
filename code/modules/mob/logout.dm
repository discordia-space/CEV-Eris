/mob/Logout()
	// SEND_SIGNAL_OLD(src, COMSIG_MOB_LOGOUT)
	// GLOB.logged_out_event.raise_event(src, my_client)
	log_access("Logout: [key_name(src)]")
	SSnano.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	SStgui.on_logout(src)
	GLOB.player_list -= src

	if(client && client.UI)
		client.UI.hide()

	..()

	return TRUE
