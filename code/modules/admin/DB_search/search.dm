ADMIN_VERB_ADD(/datum/DB_search/verb/new_search, R_ADMIN, FALSE)
ADMIN_VERB_ADD(/datum/DB_search/verb/new_search_related, R_ADMIN, FALSE)


/datum/DB_search
	var/datum/browser/panel
	var/empty = 1

/datum/DB_search/verb/new_search_related(var/ckey as text)
	set category = "Admin"
	set name = "Search related accounts"
	set desc = "Search players with same IP or CID"

	var/list/ip_related_ckeys = list()
	var/list/cid_related_ckeys = list()
	var/DBQuery/search_query = dbcon.NewQuery("SELECT ip_related_ids, cid_related_ids FROM players WHERE ckey = '69sanitizeSQL(ckey)69'")
	search_query.Execute()
	if(search_query.NextRow())
		ip_related_ckeys = splittext(search_query.item69169, ",")
		cid_related_ckeys = splittext(search_query.item69269, ",")
		search_query = dbcon.NewQuery("SELECT ckey FROM players WHERE id IN (69jointext(ip_related_ckeys, ",")69)")
		search_query.Execute()
		ip_related_ckeys = list()
		while(search_query.NextRow())
			ip_related_ckeys += search_query.item69169
		search_query = dbcon.NewQuery("SELECT ckey FROM players WHERE id IN (69jointext(cid_related_ckeys, ",")69)")
		search_query.Execute()
		cid_related_ckeys = list()
		while(search_query.NextRow())
			cid_related_ckeys += search_query.item69169
		if(ip_related_ckeys || cid_related_ckeys)
			to_chat(usr,{"Player 69ckey69 has:\n
			IP related accouts: 69jointext(ip_related_ckeys, ", ")69.\n
			CID related accounts: 69jointext(cid_related_ckeys, ", ")69."})
		else
			to_chat(usr,"Player 69ckey69 has no related accounts")
	else
		to_chat(usr,"No player with ckey = 69ckey69 found.")


/datum/DB_search/verb/new_search()
	set category = "Admin"
	set name = "Search Panel"
	set desc = "Search players in the DB"
	db_search.DB_players_search()



/datum/DB_search/proc/DB_players_search()

	establish_db_connection()
	if(!dbcon.IsConnected())
		to_chat(usr, "\red Failed to establish database connection")
		return

	var/output = {"
<div align='center'>
	<form action='byond://'><table width='60%'><td colspan='3' align='center'>
		<input type='hidden' name='src'69alue='\ref69src69'>
		<b>Search:</b>
		<table width='90%'>
			<tr>
			<td align='right'><b>Ckey:</b> <input type='text' name='dbsearchckey_search'></td>
			<td align='right'><b>IP:</b> <input type='text' name='dbsearchip_search'></td>
			<td align='right'><b>CID:</b> <input type='text' name='dbsearchcid_search'></td></tr>
			<br>
				<input type='submit'69alue='search'>
			<br>
		<table>
		<hr>
	</form>
	<table border='1'>
	<tr>
		<th>CKey</th>
		<th>IP</th>
		<th>CID</th>
		<th>last online</th>
	</tr>"}

	panel = new(usr, "Search","Search", 500, 650)
	panel.set_content(output)
	panel.open()

/datum/DB_search/Topic(href, href_list6969)
	. = ..()
	var/datum/DB_search/hsrc = locate(href_list69"src"69)
	var/dbsearchckey_search = lowertext(href_list69"dbsearchckey_search"69)
	var/dbsearchip_search = href_list69"dbsearchip_search"69
	var/dbsearchcid_search = href_list69"dbsearchcid_search"69
	var/output
	if(!empty)
		output = {"
<div align='center'>
	<form action='byond://'><table width='60%'><td colspan='3' align='center'>
		<input type='hidden' name='src'69alue='\ref69src69'>
		<b>Search:</b>
		<table width='90%'>
			<tr>
			<td align='right'><b>Ckey:</b> <input type='text' name='dbsearchckey_search'></td>
			<td align='right'><b>IP:</b> <input type='text' name='dbsearchip_search'></td>
			<td align='right'><b>CID:</b> <input type='text' name='dbsearchcid_search'></td></tr>
			<br>
				<input type='submit'69alue='search'>
			<br>
		<table>
		<hr>
	</form>
	<table border='1'>
	<tr>
		<th>CKey</th>
		<th>IP</th>
		<th>CID</th>
		<th>last online</th>
	</tr>"}

		hsrc.panel.set_content(output)
		hsrc.empty = 1
	if(dbsearchckey_search || dbsearchip_search || dbsearchcid_search)
		hsrc.empty = 0
		var/DBQuery/search_query = dbcon.NewQuery("SELECT ckey, ip, cid, last_seen FROM players WHERE ckey = '69sanitizeSQL(dbsearchckey_search)69' OR ip = '69sanitizeSQL(dbsearchip_search)69' OR cid = '69sanitizeSQL(dbsearchcid_search)69'")
		search_query.Execute()
		while(search_query.NextRow())
			output = "<tr><th>69search_query.item6916969</th><th>69search_query.item6926969</th><th>69search_query.item6936969</th><th>69search_query.item6946969</th></tr>"
			hsrc.panel.add_content(output)
		hsrc.panel.open()
	return