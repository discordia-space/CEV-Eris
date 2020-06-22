ADMIN_VERB_ADD(/datum/DB_search/proc/DB_players_search, R_ADMIN, FALSE)


/datum/DB_search/proc/DB_players_search()

	establish_db_connection()
	if(!dbcon.IsConnected())
		to_chat(usr, "\red Failed to establish database connection")
		return

	var/output = {"
<div align='center'>
	<form action='byond:/'><table width='60%'><td colspan='3' align='center'>
		<input type='hidden' name='src' value='\ref[src]'>
		<b>Search:</b>
		<table width='90%'>
			<tr>
			<td align='right'><b>Ckey:</b> <input type='text' name='dbsearchckey_search'></td>
			<td align='right'><b>IP:</b> <input type='text' name='dbsearchip_search'></td>
			<td align='right'><b>CID:</b> <input type='text' name='dbsearchcid_search'></td></tr>
			<br>
				<input type='submit' value='search'>
				<a href='?src=\ref[src];action=startgame'>here</a>
			<br>
		<table>
	</form>"}

	var/datum/browser/panel = new(usr, "Search","Search", 500, 650)
	panel.set_content(output)
	panel.open()

/datum/DB_search/Topic(href, href_list[])
	. = ..()
	to_world("HERE")
	var/dbsearchckey_search = href_list["dbsearchckey_search"]
	var/dbsearchip_search = href_list["dbsearchip_search"]
	var/dbsearchcid_search = href_list["dbsearchcid_search"]
	to_world(href_list["dbsearchckey_search"])
	if(dbsearchckey_search || dbsearchip_search || dbsearchcid_search)
		to_world("HERE")
	return