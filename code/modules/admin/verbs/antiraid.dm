ADMIN_VERB_ADD(/client/proc/panicbunker, R_ADMIN, FALSE)
/client/proc/panicbunker()
	set category = "Server"
	set name = "Toggle Panic Bunker"
	
	if(!check_rights(R_ADMIN))
		return

	if (!config.sql_enabled)
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled!</span>")
		return

	config.panic_bunker = (!config.panic_bunker)

	log_and_message_admins("[key_name(usr)] has toggled the Panic Bunker, it is now [(config.panic_bunker?"on":"off")].")
	if (config.panic_bunker && (!dbcon || !dbcon.IsConnected()))
		message_admins("The database is not connected! Panic bunker will not work until the connection is reestablished.")

ADMIN_VERB_ADD(/client/proc/paranoia_logging, R_ADMIN, FALSE)
/client/proc/paranoia_logging()
	set category = "Server"
	set name = "New Player Warnings"

	if(!check_rights(R_ADMIN))
		return

	config.paranoia_logging = (!config.paranoia_logging)

	log_and_message_admins("[key_name(usr)] has toggled Paranoia Logging, it is now [(config.paranoia_logging?"on":"off")].")
	if (config.paranoia_logging && (!dbcon || !dbcon.IsConnected()))
		message_admins("The database is not connected! Paranoia logging will not be able to give 'player age' (time since first connection) warnings, only Byond account warnings.")

ADMIN_VERB_ADD(/client/proc/ip_reputation, R_ADMIN, FALSE)
/client/proc/ip_reputation()
	set category = "Server"
	set name = "Toggle IP Rep Checks"

	if(!check_rights(R_ADMIN))
		return

	config.ip_reputation = (!config.ip_reputation)

	log_and_message_admins("[key_name(usr)] has toggled IP reputation checks, it is now [(config.ip_reputation?"on":"off")].")
	if (config.ip_reputation && (!dbcon || !dbcon.IsConnected()))
		message_admins("The database is not connected! IP reputation logging will not be able to allow existing players to bypass the reputation checks (if that is enabled).")
