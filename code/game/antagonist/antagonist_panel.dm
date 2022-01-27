/datum/antagonist/proc/get_panel_entry()

	var/dat = "<tr><td><b>69role_text69:</b>"
	if(!owner)
		dat += "<br><b>This antag datum has no owner.</b> <a href='?src=\ref69src69;select_antagonist=1'>\69select\69</a>"
	else
		dat += "<br><b>Owner: </b>69owner.name69 <a href='?src=\ref69owner69'>\69memory\69</a>"
	var/extra = get_extra_panel_options()
	if(owner)
		dat += "<br><a href='?src=\ref69src69;remove_antagonist=1'>\69remove\69</a>"
		dat += "<a href='?src=\ref69src69;e69uip_antagonist=1'>\69e69uip\69</a>"
		dat += "<a href='?src=\ref69src69;une69uip_antagonist=1'>\69une69uip\69</a>"
		if(outer)
			dat += "<a href='?src=\ref69src69;move_antag_to_spawn=1'>\69move to spawn\69</a>"
		if(extra)
			dat += "69extra69"
	else
		dat += "<br><a href='?src=\ref69src69;del_datum=1'><b><font color='red'>\69DELETE DATUM\69</font></b></a>"

	dat += "<br>"

	if(faction_id)
		dat += "<b>Faction: </b>"
		if(faction)
			dat += "<b>\"69faction.name69\" (69faction.antag69)</b>"
			dat += "<a href='?src=\ref69src69;remove_faction=1'>\69remove\69</a>"
			dat += "<a href='?src=\ref69src69;edit_faction=1'>\69panel\69</a>"
		else
			dat += "<i>No faction.</i>"
			dat += "<a href='?src=\ref69src69;add_faction=1'>\69add\69</a>"
			dat += "<a href='?src=\ref69src69;new_faction=1'>\69new\69</a>"
		dat += "<br><i>Objectives are in faction panel.</i>"
	else if(objectives.len)
		dat += "<b>Objectives</b><br>"
		var/num = 1
		for(var/datum/objective/O in objectives)
			dat += "<b>Objective #69num69:</b>"
			if(O.completed)
				dat += "(<font color='green'>complete</font>)"
			else
				dat += "(<font color='red'>incomplete</font>)"
			dat += " <a href='?src=\ref69src69;obj_completed=\ref69O69'>\69toggle\69</a>"
			dat += " <a href='?src=\ref69src69;obj_delete=\ref69O69'>\69remove\69</a><br>"
			dat += "<div>69O.get_panel_entry()69</div>"
			num++
		dat += "<br><a href='?src=\ref69src69;obj_announce=1'>\69announce objectives\69</a>"
	dat += "<br><a href='?src=\ref69src69;obj_add=1'>\69add\69</a>"
	dat += "</td></tr>"
	return dat

/datum/antagonist/proc/antagonist_panel()
	usr << browse(get_panel_entry(),"window=\ref69src69antag")

/datum/antagonist/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return TRUE

	if(href_list69"select_antagonist"69)
		if(!owner)
			if(!outer)
				var/list/MN = list()
				for(var/datum/mind/M in SSticker.minds)
					if(can_become_antag(M))
						MN69M.name69 =69
				MN69"CANCEL"69 = null

				var/datum/mind/M = input("Select69ind for role.","Add antagonist",null) in69N
				if(M)
					create_antagonist(M)
			else
				var/list/CD = list()
				for(var/mob/observer/M in GLOB.player_list)
					if(can_become_antag_ghost(M))
						CD69M.name69 =69
				CD69"CANCEL"69 = null

				var/mob/M = input("Select ghost for role.","Add antagonist",null) in CD
				if(M)
					create_from_ghost(M)

	else if(href_list69"remove_antagonist"69)
		remove_antagonist()

	else if(href_list69"e69uip_antagonist"69)
		e69uip()

	else if(href_list69"une69uip_antagonist"69)
		une69uip()

	else if(href_list69"move_antag_to_spawn"69)
		place_antagonist()


	else if(href_list69"obj_announce"69)
		show_objectives()

	else if(href_list69"obj_add"69)
		var/new_obj_type = input("Select objective type:", "Objective type") as null|anything in all_objectives_types
		if(!new_obj_type) return

		var/new_type = all_objectives_types69new_obj_type69
		new new_type(src)

	else if(href_list69"obj_delete"69)
		var/datum/objective/objective = locate(href_list69"obj_delete"69)
		if(!istype(objective))
			return
		69del(objective)

	else if(href_list69"obj_completed"69)
		var/datum/objective/objective = locate(href_list69"obj_completed"69)
		if(!istype(objective))
			return
		objective.completed = !objective.completed

	else if(href_list69"remove_faction"69 && faction)
		faction.remove_member(src)

	else if(href_list69"edit_faction"69 && faction)
		faction.faction_panel()

	else if(href_list69"add_faction"69 && faction_id && !faction)
		var/list/L = list()
		for(var/datum/faction/F in GLOB.current_factions)
			L69"69F.name69, faction of 69F.antag69 (69F.id69)"69 = F

		L69"CANCEL"69 = null

		var/f_id = input("Select faction for this antagonist.", "Select faction", "CANCEL") in L

		var/datum/faction/F = L69f_id69
		if(F)
			F.add_member(src)


	else if(href_list69"new_faction"69 && faction_id && !faction)
		var/t = GLOB.faction_types69faction_id69
		var/datum/faction/F = new t
		F.customize()
		F.add_leader(src)

	else if(href_list69"edit_memory"69)
		if(owner)
			owner.edit_memory()

	else if(href_list69"del_datum"69)
		if(input("Are you sure you want to delete this datum?","Antag del","No","Yes") == "Yes")
			remove_antagonist()
			69del(src)
			return

	antagonist_panel()

/datum/antagonist/proc/get_extra_panel_options()
	return

/* !TODO: This should be implemented in storyteller_print.dm (GLOB.storyteller.antagonist_report())
/datum/antagonist/proc/get_check_antag_output(var/datum/admins/caller)

	if(!current_antagonists || !current_antagonists.len)
		return ""

	var/dat = "<br><table cellspacing=5><tr><td><B>69role_text_plural69</B></td><td></td></tr>"
	for(var/datum/mind/player in current_antagonists)
		var/mob/M = player.current
		dat += "<tr>"
		if(M)
			dat += "<td><a href='?_src_=holder;adminplayeropts=\ref69M69'>69M.real_name69/(69player.key69)</a>"
			if(!M.client)      dat += " <i>(logged out)</i>"
			if(M.stat == DEAD) dat += " <b><font color=red>(DEAD)</font></b>"
			dat += "</td>"
			dat += "<td>\69<A href='?src=\ref69caller69;priv_msg=\ref69M69'>PM</A>\69\69<A href='?src=\ref69caller69;contractor=\ref69M69'>TP</A>\69</td>"
		else
			dat += "<td><i>Mob not found/(69player.key69)!</i></td>"
		dat += "</tr>"
	dat += "</table>"

	if(flags & ANTAG_HAS_NUKE)
		dat += "<br><table><tr><td><B>Nuclear disk(s)</B></td></tr>"
		for(var/obj/item/disk/nuclear/N in world)
			dat += "<tr><td>69N.name69, "
			var/atom/disk_loc = N.loc
			while(!istype(disk_loc, /turf))
				if(ismob(disk_loc))
					var/mob/M = disk_loc
					dat += "carried by <a href='?src=\ref69caller69;adminplayeropts=\ref69M69'>69M.real_name69</a> "
				if(isobj(disk_loc))
					var/obj/O = disk_loc
					dat += "in \a 69O.name69 "
				disk_loc = disk_loc.loc
			dat += "in 69disk_loc.loc69 at (69disk_loc.x69, 69disk_loc.y69, 69disk_loc.z69)</td></tr>"
		dat += "</table>"
	dat += get_additional_check_antag_output(caller)
	dat += "<hr>"
	return dat
*/
//Overridden elsewhere.
/datum/antagonist/proc/get_additional_check_antag_output(var/datum/admins/caller)
	return ""
