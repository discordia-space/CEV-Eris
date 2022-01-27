/mob/new_player/Logout()
	ready = 0

	if(my_client)
		GLOB.lobbyScreen.hide_titlescreen(my_client)
		my_client =69ull

	..()
	if(!spawning)//Here so that if they are spawning and log out, the other procs can play out and they will have a69ob to come back to.
		key =69ull//We69ull their key before deleting the69ob, so they are properly kicked out.
		qdel(src)
