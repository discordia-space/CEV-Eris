/datum/admins/proc/set_admin_notice()
	set category = "Server"
	set name = "Set Admin Notice"
	set desc ="Set an announcement that appears to everyone who joins the server. Only lasts this round"
	if(!check_rights(0))
		return

	var/new_admin_notice = input(src,"Set a public notice for this round. Everyone who joins the server will see it.\n(Leaving it blank will delete the current notice):","Set Notice",GLOB.admin_notice) as message|null
	if(new_admin_notice == null)
		return
	if(new_admin_notice == GLOB.admin_notice)
		return
	if(new_admin_notice == "")
		message_admins("[key_name(usr)] removed the admin notice.")
		log_admin("[key_name(usr)] removed the admin notice:\n[GLOB.admin_notice]")
	else
		message_admins("[key_name(usr)] set the admin notice.")
		log_admin("[key_name(usr)] set the admin notice:\n[new_admin_notice]")
		to_chat(world, span_adminnotice("<b>Admin Notice:</b>\n \t [new_admin_notice]"))
	// SSblackbox.record_feedback("tally", "admin_verb", 1, "Set Admin Notice") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	GLOB.admin_notice = new_admin_notice
	return

/client/proc/toggle_hub()
	set category = "Server"
	set name = "Toggle Hub"

	world.update_hub_visibility(!GLOB.hub_visibility)

	log_admin("[key_name(usr)] has toggled the server's hub status for the round, it is now [(GLOB.hub_visibility?"on":"off")] the hub.")
	message_admins("[key_name_admin(usr)] has toggled the server's hub status for the round, it is now [(GLOB.hub_visibility?"on":"off")] the hub.")
	if (GLOB.hub_visibility && !world.reachable)
		message_admins("WARNING: The server will not show up on the hub because byond is detecting that a filewall is blocking incoming connections.")

	// SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggled Hub Visibility", "[GLOB.hub_visibility ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
