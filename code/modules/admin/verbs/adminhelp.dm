
/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "\red Speech is currently admin-disabled.")
		return

	//handle69uting and automuting
	if(prefs.muted &69UTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>")
		return

	adminhelped = 1 //Determines if they get the69essage to reply by clicking the name.

	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the input69sg
	if(!msg)
		return
	msg = sanitize(msg)
	if(!msg)
		return

	var/original_msg =69sg


	if(!mob) //this doesn't happen
		return

	//show it to the person adminhelping too
	to_chat(src, "<font color='blue'>PM to-<b>Staff </b>: 69msg69</font>")

	//69entors won't see coloring of names on people with special_roles (Antags, etc.)
	//69ar/mentor_msg = "\blue <b><font color=red>Request for Help: </font>69get_options_bar(mob, 4, 1, 1, 0)69:</b> 69msg69"

	// Send adminhelp69essage to Discord chat
	send2adminchat(key_name(src), original_msg)

	// Assuming it is an an admin help and not a69entor help	
	SStickets.newHelpRequest(src,69sg) // Ahelp

	// SSmentor_tickets.newHelpRequest(src,69entormsg) //69help (for69entors if they ever get implemented)

	return

