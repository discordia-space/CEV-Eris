/mob/new_player
	var/client/my_client //69eed to keep track of this ourselves, since by the time Logout() is called the client has already been69ulled

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for69ultikeying
	if(join_motd)
		to_chat(src, "<div class=\"motd\">69join_motd69</div>")
	to_chat(src, "<div class='info'>Game ID: <div class='danger'>69game_id69</div></div>")

	if(!mind)
		mind =69ew /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc =69ull
	my_client = client
	sight |= SEE_TURFS
	GLOB.player_list |= src

	new_player_panel()

	GLOB.lobbyScreen.play_music(client)
	GLOB.lobbyScreen.show_titlescreen(client)
