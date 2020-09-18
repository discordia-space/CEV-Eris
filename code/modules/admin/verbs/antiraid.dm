GLOBAL_LIST_EMPTY(PB_bypass) //Handles ckey

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

ADMIN_VERB_ADD(/client/proc/addbunkerbypass, R_ADMIN, FALSE)
/client/proc/addbunkerbypass(ckeytobypass as text)
	set category = "Server"
	set name = "Add PB Bypass"
	set desc = "Allows a given ckey to connect despite the panic bunker for a given round."
	if(!dbcon.IsConnected())
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled or not working!</span>")
		return

	GLOB.PB_bypass |= ckey(ckeytobypass)
	log_admin("[key_name(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")

ADMIN_VERB_ADD(/client/proc/revokebunkerbypass, R_ADMIN, FALSE)
/client/proc/revokebunkerbypass(ckeytobypass as text)
	set category = "Server"
	set name = "Revoke PB Bypass"
	set desc = "Revoke's a ckey's permission to bypass the panic bunker for a given round."
	if(!dbcon.IsConnected())
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled or not working!</span>")
		return

	GLOB.PB_bypass -= ckey(ckeytobypass)
	log_admin("[key_name(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")

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

ADMIN_VERB_ADD(/client/proc/toggle_vpn_white, R_ADMIN, FALSE)
/client/proc/toggle_vpn_white(var/ckey as text)
	set category = "Server"
	set name = "Whitelist ckey from VPN Checks"

	if(!check_rights(R_ADMIN))
		return

	if (!dbcon || !dbcon.IsConnected())
		to_chat(usr,"The database is not connected!")
		return

	var/DBQuery/query = dbcon.NewQuery("SELECT id FROM players WHERE ckey = '[sanitizeSQL(ckey)]'")
	query.Execute()
	if(query.NextRow())
		var/temp_id = query.item[1]
		log_and_message_admins("[key_name(usr)] has toggled VPN checks for [ckey].")
		query = dbcon.NewQuery("UPDATE players SET VPN_check_white = !VPN_check_white WHERE id = '[temp_id]'")
		query.Execute()
	else
		to_chat(usr,"Player [ckey] not found!")