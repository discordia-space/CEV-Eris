/mob/new_player
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/new_player/Login()
	if(!client)
		return

	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = TRUE
		mind.current = src

	// . = ..()
	// if(!. || !client)
	// 	return FALSE

	if(join_motd)
		to_chat(src, "<div class=\"motd\">[join_motd]</div>")
	to_chat(src, "<div class='info'>Game ID: <div class='danger'>[game_id]</div></div>")

	loc = null
	my_client = client
	sight |= SEE_TURFS
	GLOB.player_list |= src

	new_player_panel()

	GLOB.lobbyScreen.play_music(client)
	GLOB.lobbyScreen.show_titlescreen(client)
