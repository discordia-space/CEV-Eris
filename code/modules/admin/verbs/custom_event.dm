ADMIN_VERB_ADD(/client/proc/cmd_admin_change_custom_event, R_ADMIN, FALSE)
//69erb for admins to set custom event
/client/proc/cmd_admin_change_custom_event()
	set category = "Fun"
	set name = "Custom Admin Notice"

	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return

	var/input = sanitize(input(usr, "Enter the description of the custom notice. Be descriptive. To cancel the notice,69ake this blank or hit cancel.", "Custom Event", custom_event_msg) as69essage|null,69AX_BOOK_MESSAGE_LEN, extra = 0)
	if(!input || input == "")
		custom_event_msg = null
		log_admin("69usr.key69 has cleared the custom notice text.")
		message_admins("69key_name_admin(usr)69 has cleared the custom notice text.")
		return

	log_admin("69usr.key69 has changed the custom notice text.")
	message_admins("69key_name_admin(usr)69 has changed the custom notice text.")

	custom_event_msg = input

	to_chat(world, "<h1 class='alert'>Custom Notice</h1>")
	to_chat(world, "<h2 class='alert'>A custom notice is starting. OOC Info:</h2>")
	to_chat(world, "<span class='alert'>69custom_event_msg69</span>")
	to_chat(world, "<br>")

// normal69erb for players to69iew info
/client/verb/cmd_view_custom_event()
	set category = "OOC"
	set name = "Notice Info"

	if(!custom_event_msg || custom_event_msg == "")
		to_chat(src, "There currently is no known notice.")
		to_chat(src, "Keep in69ind: it is possible that an admin has not properly set this.")
		return

	to_chat(src, "<h1 class='alert'>Custom Notice</h1>")
	to_chat(src, "<h2 class='alert'>A custom notice is taking place. OOC Info:</h2>")
	to_chat(src, "<span class='alert'>69custom_event_msg69</span>")
	to_chat(src, "<br>")
