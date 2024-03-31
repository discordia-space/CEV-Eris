/datum/DB_search
	var/datum/browser/panel
	var/empty = 1

/datum/DB_search/verb/new_search_related(var/ckey as text)
	set category = "Admin"
	set name = "Search related accounts"
	set desc = "Search players with same IP or CID"

	var/list/ip_related_ckeys = list()
	var/list/cid_related_ckeys = list()
	var/DBQuery/search_query = dbcon.NewQuery("SELECT ip_related_ids, cid_related_ids FROM players WHERE ckey = '[sanitizeSQL(ckey)]'")
	search_query.Execute()
	if(search_query.NextRow())
		ip_related_ckeys = splittext(search_query.item[1], ",")
		cid_related_ckeys = splittext(search_query.item[2], ",")
		search_query = dbcon.NewQuery("SELECT ckey FROM players WHERE id IN ([jointext(ip_related_ckeys, ",")])")
		search_query.Execute()
		ip_related_ckeys = list()
		while(search_query.NextRow())
			ip_related_ckeys += search_query.item[1]
		search_query = dbcon.NewQuery("SELECT ckey FROM players WHERE id IN ([jointext(cid_related_ckeys, ",")])")
		search_query.Execute()
		cid_related_ckeys = list()
		while(search_query.NextRow())
			cid_related_ckeys += search_query.item[1]
		if(ip_related_ckeys || cid_related_ckeys)
			to_chat(usr,{"Player [ckey] has:\n
			IP related accouts: [jointext(ip_related_ckeys, ", ")].\n
			CID related accounts: [jointext(cid_related_ckeys, ", ")]."})
		else
			to_chat(usr,"Player [ckey] has no related accounts")
	else
		to_chat(usr,"No player with ckey = [ckey] found.")


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
		<input type='hidden' name='src' value='\ref[src]'>
		<b>Search:</b>
		<table width='90%'>
			<tr>
			<td align='right'><b>Ckey:</b> <input type='text' name='dbsearchckey_search'></td>
			<td align='right'><b>IP:</b> <input type='text' name='dbsearchip_search'></td>
			<td align='right'><b>CID:</b> <input type='text' name='dbsearchcid_search'></td></tr>
			<br>
				<input type='submit' value='search'>
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

/datum/DB_search/Topic(href, href_list[])
	. = ..()
	var/datum/DB_search/hsrc = locate(href_list["src"])
	var/dbsearchckey_search = lowertext(href_list["dbsearchckey_search"])
	var/dbsearchip_search = href_list["dbsearchip_search"]
	var/dbsearchcid_search = href_list["dbsearchcid_search"]
	var/output
	if(!empty)
		output = {"
<div align='center'>
	<form action='byond://'><table width='60%'><td colspan='3' align='center'>
		<input type='hidden' name='src' value='\ref[src]'>
		<b>Search:</b>
		<table width='90%'>
			<tr>
			<td align='right'><b>Ckey:</b> <input type='text' name='dbsearchckey_search'></td>
			<td align='right'><b>IP:</b> <input type='text' name='dbsearchip_search'></td>
			<td align='right'><b>CID:</b> <input type='text' name='dbsearchcid_search'></td></tr>
			<br>
				<input type='submit' value='search'>
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
		var/DBQuery/search_query = dbcon.NewQuery("SELECT ckey, ip, cid, last_seen FROM players WHERE ckey = '[sanitizeSQL(dbsearchckey_search)]' OR ip = '[sanitizeSQL(dbsearchip_search)]' OR cid = '[sanitizeSQL(dbsearchcid_search)]'")
		search_query.Execute()
		while(search_query.NextRow())
			output = "<tr><th>[search_query.item[1]]</th><th>[search_query.item[2]]</th><th>[search_query.item[3]]</th><th>[search_query.item[4]]</th></tr>"
			hsrc.panel.add_content(output)
		hsrc.panel.open()
	return