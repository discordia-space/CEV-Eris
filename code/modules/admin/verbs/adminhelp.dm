
/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "\red Speech is currently admin-disabled.")
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>")
		return

	adminhelped = 1 //Determines if they get the message to reply by clicking the name.

	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the input msg
	if(!msg)
		return
	msg = sanitize(msg)
	if(!msg)
		return

	var/original_msg = msg


	if(!mob) //this doesn't happen
		return

	//show it to the person adminhelping too
	to_chat(src, "<font color='blue'>PM to-<b>Staff </b>: [msg]</font>")

	// Mentors won't see coloring of names on people with special_roles (Antags, etc.)
	// var/mentor_msg = "\blue <b><font color=red>Request for Help: </font>[get_options_bar(mob, 4, 1, 1, 0)]:</b> [msg]"

	// Send adminhelp message to Discord chat
	send2adminchat(key_name(src), original_msg)

	// Assuming it is an an admin help and not a mentor help	
	SStickets.newHelpRequest(src, msg) // Ahelp

	// SSmentor_tickets.newHelpRequest(src, mentormsg) // Mhelp (for mentors if they ever get implemented)

	return

