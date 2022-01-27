/mob/Logout()
	SSnano.user_logout(src) // this is used to clean up (remove) this user's69ano UIs
	GLOB.player_list -= src
	log_access("Logout: 69key_name(src)69")
	if(admin_datums69src.ckey69)
		if (SSticker.current_state == GAME_STATE_PLAYING) //Only report this stuff if we are currently playing.


			message_admins("Admin logout: 69key_name(src)69")

	if(client && client.UI)
		client.UI.hide()
	..()
	return 1
