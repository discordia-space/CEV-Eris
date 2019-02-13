/mob/Logout()
	SSnano.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	GLOB.player_list -= src
	log_access("Logout: [key_name(src)]")
	if(admin_datums[src.ckey])
		if (SSticker.current_state == GAME_STATE_PLAYING) //Only report this stuff if we are currently playing.


			message_admins("Admin logout: [key_name(src)]")

	if(client && client.UI)
		client.UI.hide()
	..()
	return 1
