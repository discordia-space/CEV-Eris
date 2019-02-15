/var/obj/effect/lobby_image = new/obj/effect/lobby_image()

/obj/effect/lobby_image
	name = "Baystation12"
	desc = "This shouldn't be read"
	icon = 'icons/misc/title.dmi'
	screen_loc = "WEST,SOUTH"

/obj/effect/lobby_image/Initialize()
	var/list/known_icon_states = icon_states(icon)
	for(var/lobby_screen in config.lobby_screens)
		if(!(lobby_screen in known_icon_states))
			error("Lobby screen '[lobby_screen]' did not exist in the icon set [icon].")
			config.lobby_screens -= lobby_screen

	if(config.lobby_screens.len)
		icon_state = pick(config.lobby_screens)
	else
		icon_state = known_icon_states[1]

/mob/new_player
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	if(join_motd)
		src << "<div class=\"motd\">[join_motd]</div>"
	src << "<div class='info'>Game ID: <div class='danger'>[game_id]</div></div>"

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	my_client = client
	sight |= SEE_TURFS
	GLOB.player_list |= src

	new_player_panel()
	if(client)
		client.playtitlemusic()

	if(!istype(lobby_image, /obj/effect/lobby_image))
		var/the_type
		if(isnull(lobby_image))
			the_type = "(null)"
		else if(isicon(lobby_image))		//All of these should be impossible, just catching possibilities.
			the_type = "/icon"
		else if(istext(lobby_image))
			the_type = "(text)"
		else if(isnum(lobby_image))
			the_type = "(num)"
		else if(istype(lobby_image, /datum))	//Already casted
			the_type = "[lobby_image.type]"
		else
			the_type = "(UNKNOWN)"
		crash_with("WARNING: lobby_image global variable was the wrong type \[[the_type]\] instead of the proper /obj/effect/lobby_image!")
		lobby_image = new /obj/effect/lobby_image			//Ensures it's the right type.
	client.screen += lobby_image
