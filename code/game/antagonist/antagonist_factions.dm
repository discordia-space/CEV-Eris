/datum/faction
	var/id = "faction"
	var/name = "faction"	//name displayed in many places
	var/antag = "antag"		//name for the faction members
	var/antag_plural = "antags"
	var/welcome_text = "Hello, antagonist!"

	var/hud_indicator = null
	var/faction_invisible = TRUE

	var/list/faction_icons = list()

	var/list/possible_antags = list()	//List of antag ids, that can join this faction. If empty, anybody can join

	var/list/objectives = list()
	var/list/members = list()
	var/list/leaders = list()

	var/list/verbs = list()	//List of verbs, used by this faction members
	var/list/leader_verbs = list()

/datum/faction/New()
	current_factions.Add(src)
	create_objectives()

/datum/faction/proc/add_member(var/datum/antagonist/member, var/announce = TRUE)
	if(!member || !member.owner || !member.owner.current || member in members || !member.owner.current.client)
		return
	if(possible_antags.len && !(member.id in possible_antags))
		return

	members.Add(member)
	member.faction = src
	if(announce)
		member.owner.current << SPAN_NOTICE("You became a member of the [name].")
	member.set_objectives(objectives)

	member.owner.current.verbs |= verbs
	add_icons()
	update_members()
	return TRUE

/datum/faction/proc/add_leader(var/datum/antagonist/member, var/announce = TRUE)
	if(!member || member in leaders || !member.owner.current)
		return

	if(!(member in members))
		add_member(member,FALSE)

	leaders.Add(member)
	member.owner.current.verbs |= leader_verbs
	if(announce)
		member.owner.current << SPAN_NOTICE("You became a <b>leader</b> of the [name].")
	update_members()
	return TRUE

/datum/faction/proc/remove_leader(var/datum/antagonist/member, var/announce = TRUE)
	if(!member || !(member in leaders) || !member.owner.current)
		return

	leaders.Remove(member)
	if(announce)
		member.owner.current << SPAN_WARNING("You are no longer the <b>leader</b> of the [name].")
	member.owner.current.verbs.Remove(leader_verbs)

	update_members()
	return TRUE

/datum/faction/proc/remove_member(var/datum/antagonist/member, var/announce = TRUE)
	if(!(member in members))
		return

	remove_icons()

	members.Remove(member)

	if(member in leaders)
		remove_leader(member, FALSE)

	if(announce)
		member.owner.current << SPAN_WARNING("You are no longer a member of the [name].")

	if(member.owner && member.owner.current)
		member.owner.current.verbs.Remove(verbs)

	update_members()
	return TRUE

/datum/faction/proc/remove_faction()
	for(var/datum/antagonist/A in members)
		remove_member(A)

	current_factions.Remove(src)
	qdel(src)
	return TRUE


/datum/faction/proc/create_objectives()

/datum/faction/proc/set_objectives(var/list/new_objs)
	objectives = new_objs

	for(var/datum/antagonist/A in members)
		A.set_objectives(new_objs)

/datum/faction/proc/update_members()
	var/leaders_alive = FALSE
	for(var/datum/antagonist/A in leaders)
		if(A.is_active())
			leaders_alive = TRUE

	if(!members.len || !leaders_alive)
		remove_faction()

/datum/faction/proc/customize(var/mob/leader)

/datum/faction/proc/print_success()
	if(!members.len)
		return

	var/text = "<b>[capitalize(name)] was faction of [antag].</b>"

	if(leaders.len)
		text += "<br><b>[capitalize(name)]'s leader[leaders.len >= 1?"":"s"] was:</b>"
		for(var/datum/antagonist/A in leaders)
			text += A.print_player()
		text += "<br>"
	else
		text += "<br>[capitalize(name)] had no leaders.<br>"

	text += "<br><b>[capitalize(name)]'s members was:</b>"
	for(var/datum/antagonist/A in members)
		text += A.print_player()

	text += "<br>"
	var/failed = FALSE
	var/num = 1

	for(var/datum/objective/O in objectives)
		text += "<br><b>Objective [num]:</b> [O.explanation_text] "
		if(O.check_completion())
			text += "<font color='green'><B>Success!</B></font>"
		else
			text += "<font color='red'>Fail.</font>"
			failed = TRUE
		num++

	if(failed)
		text += "<br><font color='red'><B>The members of the [name] failed their tasks.</B></font>"
	else
		text += "<br><font color='green'><B>The members of the [name] accomplished their tasks!</B></font>"

	// Display the results.
	return text

/datum/faction/proc/get_indicator()
	return image('icons/mob/mob.dmi', icon_state = hud_indicator, layer = LIGHTING_LAYER+0.1)

/datum/faction/proc/add_icons(var/datum/antagonist/antag)
	if(faction_invisible || !hud_indicator || !antag.owner || !antag.owner.current || !antag.owner.current.client)
		return

	var/image/I

	if(faction_icons[antag])
		I = faction_icons[antag]
	else
		I = get_indicator()
		I.loc = antag.owner.current.loc
		faction_icons[antag] = I

	for(var/datum/antagonist/member in members)
		if(!member.owner || !member.owner.current || !member.owner.current.client)
			continue

		antag.owner.current.client.images |= faction_icons[member]
		member.owner.current.client.images |= I

/datum/faction/proc/remove_icons(var/datum/antagonist/antag)
	if(!hud_indicator || !antag.owner || !antag.owner.current || !antag.owner.current.client)
		qdel(faction_icons[antag])
		faction_icons[antag] = null
		return

	for(var/datum/antagonist/member in members)
		if(!member.owner || !member.owner.current || !member.owner.current.client)
			continue

		antag.owner.current.client.images.Remove(faction_icons[member])
		member.owner.current.client.images.Remove(faction_icons[antag])

	qdel(faction_icons[antag])
	faction_icons[antag] = null

/datum/faction/proc/clear_icons()
	for(var/datum/antagonist/antag in members)
		remove_icons(antag)

	for(var/icon in faction_icons)	//Some members of faction may be offline, but we need to remove all icons
		qdel(faction_icons[icon])

	faction_icons = list()

/datum/faction/proc/reset_icons()
	clear_icons()
	for(var/datum/antagonist/antag in members)
		add_icons(antag)

/datum/faction/proc/faction_panel()
	var/data = "FACTION PANEL"
	data += "<br>[name] - faction of [antag] ([id])"
	data += "<br>Welcome: [welcome_text]"
	data += {"<br><a href='?src=\ref[src];rename=1'>\[NAME\]</a>
	<a href='?src=\ref[src];rewelcome=1'>\[WLCM\]</a><a href='?src=\ref[src];remove=1'>\[REMOVE\]</a>"}
	data += "<br>Hud: \"<a href='?src=\ref[src];seticon=1'>[hud_indicator ? hud_indicator : "null"]</a>\""
	data += "<br><a href='?src=\ref[src];toggleinv=1'>\[MAKE [faction_invisible ? "VISIBLE" : "INVISIBLE"]\]</a>"


	data += "<br><br><b>Members:</b>"
	for(var/i=1;i<=members.len)
		var/datum/antagonist/member = members[i]
		if(!istype(member))
			data += "<br>Invalid element on index [i]: [member ? member : "NULL"]"
		else
			if(member in leaders)
				data += "<br>[member.owner ? member.owner.name : "no owner"] <a href='?src=\ref[src];remleader=[i]'>\[REMLEADER\]</a><a href='?src=\ref[src];remmember=[i]'>\[REM\]</a>"
			else
				data += "<br>[member.owner ? member.owner.name : "no owner"] <a href='?src=\ref[src];makeleader=[i]'>\[LEADER\]</a><a href='?src=\ref[src];remmember=[i]'>\[REMOVE\]</a>"

	usr << browse(data,"window=[id]faction")

/datum/faction/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return

	faction_panel()

