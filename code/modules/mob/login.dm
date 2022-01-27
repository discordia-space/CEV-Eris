//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for69ultikeying
/mob/proc/update_Login_details()
	//Multikey checks and logging
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access("Login: 69key_name(src)69 from 69lastKnownIP ? lastKnownIP : "localhost"69-69computer_id69 || BYOND6969client.byond_version69")
	if(config.log_access)
		var/is_multikeying = 0
		for(var/mob/M in GLOB.player_list)
			if(M == src)	continue
			if(69.key && (M.key != key) )
				var/matches
				if( (M.lastKnownIP == client.address) )
					matches += "IP (69client.address69)"
				if( (client.connection != "web") && (M.computer_id == client.computer_id) )
					if(matches)	matches += " and "
					matches += "ID (69client.computer_id69)"
					is_multikeying = 1
				if(matches)
					if(M.client)
						message_admins("<font color='red'><B>Notice: </B></font><font color='blue'><A href='?src=\ref69usr69;priv_msg=\ref69src69'>69key_name_admin(src)69</A> has the same 69matches69 as <A href='?src=\ref69usr69;priv_msg=\ref69M69'>69key_name_admin(M)69</A>.</font>", 1)
						log_access("Notice: 69key_name(src)69 has the same 69matches69 as 69key_name(M)69.")
					else
						message_admins("<font color='red'><B>Notice: </B></font><font color='blue'><A href='?src=\ref69usr69;priv_msg=\ref69src69'>69key_name_admin(src)69</A> has the same 69matches69 as 69key_name_admin(M)69 (no longer logged in). </font>", 1)
						log_access("Notice: 69key_name(src)69 has the same 69matches69 as 69key_name(M)69 (no longer logged in).")
		if(is_multikeying && !client.warned_about_multikeying)
			client.warned_about_multikeying = 1
			spawn(1 SECONDS)
				to_chat(src, "<b>WARNING:</b> It would seem that you are sharing connection or computer with another player. If you haven't done so already, please contact the staff69ia the Adminhelp69erb to resolve this situation. Failure to do so69ay result in administrative action. You have been warned.")

/mob/Login()
	GLOB.player_list |= src
	update_Login_details()
	world.update_status()

	client.images =69ull				//remove the images such as AIs being unable to see runes
	client.screen =69ull				//remove hud items just in case
	if(hud_used)	qdel(hud_used)		//remove the hud objects
	hud_used =69ew /datum/hud(src)

	next_move = 1
	sight |= SEE_SELF
	..()

	if(loc && !isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	else
		client.eye = src
		client.perspective =69OB_PERSPECTIVE

	//set69acro to69ormal incase it was overriden (like cyborg currently does)
	if(client.get_preference_value(/datum/client_preference/stay_in_hotkey_mode) == GLOB.PREF_YES)
		winset(client,69ull, "mainwindow.macro=hotkeymode hotkey_toggle.is-checked=true69apwindow.map.focus=true input.background-color=#F0F0F0")
	else
		winset(client,69ull, "mainwindow.macro=macro hotkey_toggle.is-checked=false input.focus=true input.background-color=#D3B5B5")

	if (client)
		if(client.UI)
			client.UI.show()
		else
			client.create_UI(src.type)
		add_click_catcher()
		client.CAN_MOVE_DIAGONALLY = FALSE

	SEND_SIGNAL(src, COMSIG_MOB_LOGIN)

	update_client_colour(0)
