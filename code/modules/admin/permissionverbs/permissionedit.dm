ADMIN_VERB_ADD(/client/proc/edit_admin_permissions, R_PERMISSIONS, FALSE)
/client/proc/edit_admin_permissions()
	set category = "Admin"
	set name = "Permissions Panel"
	set desc = "Edit admin permissions"

	if(!check_rights(R_PERMISSIONS))
		return
	usr.client.holder.edit_admin_permissions()


/datum/admins/proc/edit_admin_permissions()
	if(!check_rights(R_PERMISSIONS))
		return

	var/output = {"<!DOCTYPE html>
		<html>
		<head>
		<title>Permissions Panel</title>
		<script type='text/javascript' src='search.js'></script>
		<link rel='stylesheet' type='text/css' href='panels.css'>
		</head>
		<body onload='selectTextField();updateSearch();'>
		<div id='main'><table id='searchable' cellspacing='0'>
		<tr class='title'>
		<th style='width:125px;text-align:right;'>CKEY <a class='small' href='?src=\ref69src69;editrights=add'>\69+\69</a></th>
		<th style='width:125px;'>RANK</th><th style='width:100%;'>PERMISSIONS</th>
		</tr>
		"}

	for(var/admin_ckey in admin_datums)
		var/datum/admins/D = admin_datums69admin_ckey69
		if(!D)
			continue
		var/rank = D.rank ? D.rank : "*none*"
		var/rights = rights2text(D.rights," ")
		if(!rights)
			rights = "*none*"

		output += "<tr>"
		output += "<td style='text-align:right;'>69admin_ckey69 <a class='small' href='?src=\ref69src69;editrights=remove;ckey=69admin_ckey69'>\69-\69</a></td>"
		output += "<td><a href='?src=\ref69src69;editrights=rank;ckey=69admin_ckey69'>69rank69</a></td>"
		output += "<td><a class='small' href='?src=\ref69src69;editrights=permissions;ckey=69admin_ckey69'>69rights69</a></td>"
		output += "</tr>"

	output += {"
		</table></div>
		<div id='top'><b>Search:</b> <input type='text' id='filter'69alue='' style='width:70%;' onkeyup='updateSearch();'></div>
		</body>
		</html>"}

	usr << browse(output,"window=editrights;size=600x500")

/datum/admins/proc/log_admin_rank_modification(var/admin_ckey,69ar/new_rank)
	if(config.admin_legacy_system)
		return

	if(!usr.client)
		return

	if(!usr.client.holder || !(usr.client.holder.rights & R_PERMISSIONS))
		to_chat(usr, SPAN_WARNING("You do not have permission to do this!"))
		return

	establish_db_connection()

	if(!dbcon.IsConnected())
		to_chat(usr, SPAN_WARNING("Failed to establish database connection."))
		return

	if(!admin_ckey || !new_rank)
		return

	admin_ckey = ckey(admin_ckey)

	if(!admin_ckey)
		return

	if(!istext(admin_ckey) || !istext(new_rank))
		return

	var/DBQuery/select_query = dbcon.NewQuery("SELECT ckey FROM players WHERE ckey = '69admin_ckey69' AND rank != 'player'")
	select_query.Execute()

	var/new_admin = TRUE
	if(select_query.NextRow())
		new_admin = FALSE

	if(new_admin)
		var/DBQuery/insert_query = dbcon.NewQuery("UPDATE players SET rank = '69new_rank69' WHERE ckey = '69admin_ckey69'")
		insert_query.Execute()
		message_admins("69key_name_admin(usr)6969ade 69key_name_admin(admin_ckey)69 an admin with the rank 69new_rank69")
		log_admin("69key_name(usr)6969ade 69key_name(admin_ckey)69 an admin with the rank 69new_rank69")
		to_chat(usr, SPAN_NOTICE("New admin added."))
	else
		var/DBQuery/insert_query = dbcon.NewQuery("UPDATE players SET rank = '69new_rank69' WHERE ckey = '69admin_ckey69'")
		insert_query.Execute()
		message_admins("69key_name_admin(usr)69 changed 69key_name_admin(admin_ckey)69 admin rank to 69new_rank69")
		log_admin("69key_name(usr)69 changed 69key_name(admin_ckey)69 admin rank to 69new_rank69")
		to_chat(usr, SPAN_NOTICE("Admin rank changed."))

/datum/admins/proc/log_admin_permission_modification(var/admin_ckey,69ar/new_permission,69ar/nominal)
	if(config.admin_legacy_system)
		return

	if(!usr.client)
		return

	if(!usr.client.holder || !(usr.client.holder.rights & R_PERMISSIONS))
		to_chat(usr, SPAN_WARNING("You do not have permission to do this!"))
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		to_chat(usr, SPAN_WARNING("Failed to establish database connection."))
		return

	if(!admin_ckey || !new_permission)
		return

	admin_ckey = ckey(admin_ckey)

	if(!admin_ckey)
		return

	if(istext(new_permission))
		new_permission = text2num(new_permission)

	if(!istext(admin_ckey) || !isnum(new_permission))
		return

	var/DBQuery/select_query = dbcon.NewQuery("SELECT ckey, flags FROM players WHERE ckey = '69admin_ckey69'")
	select_query.Execute()
	if(!select_query.NextRow())
		to_chat(usr, SPAN_WARNING("Permissions edit for 69admin_ckey69 failed on retrieving related database record."))
		return

	var/admin_rights = text2num(select_query.item69269)

	if(admin_rights & new_permission) //This admin already has this permission, so we are removing it.
		var/DBQuery/insert_query = dbcon.NewQuery("UPDATE players SET flags = 69admin_rights & ~new_permission69 WHERE ckey = '69admin_ckey69'")
		insert_query.Execute()
		message_admins("69key_name_admin(usr)69 removed the 69nominal69 permission of 69admin_ckey69")
		log_admin("69key_name(usr)69 removed the 69nominal69 permission of 69admin_ckey69")
		to_chat(usr, SPAN_NOTICE("Permission removed."))
	else //This admin doesn't have this permission, so we are adding it.
		var/DBQuery/insert_query = dbcon.NewQuery("UPDATE players SET flags = '69admin_rights | new_permission69' WHERE ckey = '69admin_ckey69'")
		insert_query.Execute()
		message_admins("69key_name_admin(usr)69 added the 69nominal69 permission of 69admin_ckey69")
		log_admin("69key_name(usr)69 added the 69nominal69 permission of 69admin_ckey69")
		to_chat(usr, SPAN_NOTICE("Permission added."))
