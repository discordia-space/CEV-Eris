/datum/faction
	var/id
	var/name = "faction"	//name displayed in different places
	var/antag = "antag"		//name for the faction members
	var/antag_plural = "antags"
	var/welcome_text = "Hello, antagonist!"

	var/hud_indicator
	var/leader_hud_indicator
	var/faction_invisible = TRUE

	var/list/faction_icons = list()

	var/list/possible_antags = list()	//List of antag ids, that can join this faction. If empty, anybody can join

	var/list/objectives = list()
	var/list/members = list()
	var/list/leaders = list()

	var/list/faction_datum_verbs = list()	//List of verbs, used by this faction members
	var/list/leader_verbs = list()

/datum/faction/New()
	if(!leader_hud_indicator)
		leader_hud_indicator = hud_indicator
	GLOB.current_factions.Add(src)

/datum/faction/proc/add_member(datum/antagonist/member, announce = TRUE)
	if(!member || !member.owner || !member.owner.current || (member in members) || !member.owner.current.client)
		return
	if(possible_antags.len && !(member.id in possible_antags))
		return

	members.Add(member)
	member.faction = src
	if(announce)
		to_chat(member.owner.current, SPAN_NOTICE("You became a member of the [name]."))

	if(objectives.len)
		member.set_objectives(objectives)

	add_verb(member.owner.current, faction_datum_verbs)
	add_icons(member)
	update_members()
	return TRUE

/datum/faction/proc/add_leader(datum/antagonist/member, announce = TRUE)
	if(!member || (member in leaders) || !member.owner.current)
		return

	if(!(member in members))
		add_member(member,FALSE)

	leaders.Add(member)
	add_verb(member.owner.current, leader_verbs)
	if(announce)
		to_chat(member.owner.current, SPAN_NOTICE("You became a <b>leader</b> of the [name]."))
	update_members()
	update_icons(member)
	return TRUE


//Randomly selects leaders from the faction members
/datum/faction/proc/pick_leaders(num)
	var/list/candidates = members.Copy()

	//Specifically check equality to zero, rather than <=
	//This allows a value of -1 to be passed, to convert everyone into a leader since it will never reach zero
		//Just keeps going until theres no candidates left
	while (num != 0 && candidates.len)
		var/datum/antagonist/A = pick_n_take(candidates)
		add_leader(A)
		num--


/datum/faction/proc/remove_leader(datum/antagonist/member, announce = TRUE)
	if(!member || !(member in leaders) || !member.owner.current)
		return

	update_icons(member)

	leaders.Remove(member)
	if(announce)
		to_chat(member.owner.current, SPAN_WARNING("You are no longer the <b>leader</b> of the [name]."))
	member.owner.current.verbs.Remove(leader_verbs)

	update_members()
	return TRUE

/datum/faction/proc/remove_member(datum/antagonist/member, announce = TRUE)
	if(!(member in members))
		return

	remove_icons(member)

	members.Remove(member)

	if(member in leaders)
		remove_leader(member, FALSE)

	if(announce)
		to_chat(member.owner.current, SPAN_WARNING("You are no longer a member of the [name]."))

	if(member.owner && member.owner.current)
		member.owner.current.verbs.Remove(faction_datum_verbs)

	update_members()
	return TRUE

/datum/faction/proc/clear_faction()
	for(var/datum/antagonist/A in members)
		remove_member(A)

	GLOB.current_factions.Remove(src)
	return TRUE


/datum/faction/proc/remove_faction()
	clear_faction()
	qdel(src)
	return TRUE


/datum/faction/proc/create_objectives()
	set_objectives(objectives)

/datum/faction/proc/set_objectives(list/new_objs)
	objectives = new_objs

	for(var/datum/antagonist/A in members)
		A.set_objectives(new_objs)

/datum/faction/proc/update_members()
	if(!members.len)
		remove_faction()

/datum/faction/proc/customize(mob/leader)

/datum/faction/proc/communicate(mob/user)
	var/message = input(user, "Type message","[name] communication")

	if(!message || user.stat != CONSCIOUS)
		return

	message = capitalize(sanitize(message))
	var/text = "<span class='revolution'>[name] member, [user.real_name]: \"[message]\"</span>"
	for(var/i in SShumans.mob_list)
		if(is_excelsior(i))
			to_chat(i, text)

	//ghosts
	for(var/mob/observer/ghost/M in GLOB.dead_mob_list)	//does this include players who joined as observers as well?
		if(!M.client)
			continue
		if((M.antagHUD && M.get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH) || is_admin(M))
			to_chat(M, "[text] ([ghost_follow_link(user, M)])")

	log_say("[user.name]/[user.key] (REV [name]) : [message]")

/datum/faction/proc/is_member(mob/user)
	for(var/datum/antagonist/A in members)
		if(A.owner.current == user)
			return TRUE
	return FALSE

/datum/faction/proc/print_success()
	if(!members.len)
		return

	var/text = ""//<b>[capitalize(name)] was faction of [antag].</b>"

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

	if(objectives.len)
		var/failed = FALSE
		var/num = 1

		for(var/datum/objective/O in objectives)
			text += "<br><b>Objective [num]:</b> [O.explanation_text] "
			text += "[O.get_info()] "
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
	text += print_success_extra()
	// Display the results.
	return text
/datum/faction/proc/print_success_extra() //Placeholder for extra data for print_succes proc
	return ""

/datum/faction/proc/get_indicator(datum/antagonist/A)
	if(A in leaders)
		return get_leader_indicator()

	if(A in members)
		return get_member_indicator()

/datum/faction/proc/get_member_indicator()
	var/image/I = image('icons/mob/mob.dmi', icon_state = hud_indicator, layer = ABOVE_LIGHTING_LAYER)
	I.plane = ABOVE_LIGHTING_PLANE
	return I

/datum/faction/proc/get_leader_indicator()
	var/image/I = image('icons/mob/mob.dmi', icon_state = leader_hud_indicator, layer = ABOVE_LIGHTING_LAYER)
	I.plane = ABOVE_LIGHTING_PLANE
	return I

/datum/faction/proc/add_icons(datum/antagonist/antag)
	if(faction_invisible || !hud_indicator || !leader_hud_indicator || !antag.owner || !antag.owner.current || !antag.owner.current.client)
		return

	var/image/I

	if(antag in faction_icons && faction_icons[antag])
		I = faction_icons[antag]
	else
		I = get_indicator(antag)
		I.loc = antag.owner.current
		faction_icons[antag] = I

	for(var/datum/antagonist/member in members)
		if(!member.owner || !member.owner.current || !member.owner.current.client)
			continue

		antag.owner.current.client.images |= faction_icons[member]
		member.owner.current.client.images |= I

/datum/faction/proc/remove_icons(datum/antagonist/antag)
	if(!faction_invisible || !antag.owner || !antag.owner.current || !antag.owner.current.client)
		qdel(faction_icons[antag])
		faction_icons.Remove(antag)
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

/datum/faction/proc/update_icons(datum/antagonist/A)
	remove_icons(A)
	add_icons(A)

/datum/faction/proc/faction_panel()
	var/data = "<center><font size='3'><b>FACTION PANEL</b></font></center>"
	data += "<br>[name] - faction of [antag] ([id])"
	data += "<br>Welcome: [welcome_text]"
	data += {"<br><a href='?src=\ref[src];rename=1'>\[NAME\]</a>
	<a href='?src=\ref[src];rewelcome=1'>\[WLCM\]</a><a href='?src=\ref[src];remove=1'>\[REMOVE\]</a>"}
	data += "<br>Hud: \"<a href='?src=\ref[src];seticon=1'>[hud_indicator ? hud_indicator : "null"]</a>\""
	data += "<br><a href='?src=\ref[src];toggleinv=1'>\[MAKE [faction_invisible ? "VISIBLE" : "INVISIBLE"]\]</a>"


	data += "<br><br><b>Members:</b>"
	for(var/i=1;i<=members.len; i++)
		var/datum/antagonist/member = members[i]
		if(!istype(member))
			data += "<br>Invalid element on index [i]: [member ? member : "NULL"]"
		else
			if(member in leaders)
				data += "<br>[member.owner ? member.owner.name : "no owner"] <a href='?src=\ref[src];remleader=\ref[member]'>\[REMV LEADER\]</a> \[REMOVE\]"
			else
				data += "<br>[member.owner ? member.owner.name : "no owner"] <a href='?src=\ref[src];makeleader=\ref[member]'>\[MAKE LEADER\]</a> <a href='?src=\ref[src];remmember=[i]'>\[REMOVE\]</a>"
			data += "<a href='?src=[member]'>\[EDIT\]</a>"

	data += "<br><br><b>Objectives:</b><br>"
	for(var/i=1;i<=objectives.len; i++)
		var/datum/objective/O = objectives[i]
		//Make sure we show the most up-to-date info
		O.update_completion()
		O.update_explanation()
		data += "[i]. [O.get_panel_entry()]<br>"

	usr << browse(data,"window=[id]faction")

/datum/faction/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return

	if(href_list["makeleader"])
		var/datum/antagonist/A = locate(href_list["makeleader"])
		if(istype(A))
			add_leader(A)

	if(href_list["remleader"])
		var/datum/antagonist/A = locate(href_list["remleader"])
		if(istype(A) && (A in leaders))
			remove_leader(A)

	if(href_list["remmember"])
		var/datum/antagonist/A = locate(href_list["remmember"])
		if(istype(A) && !(A in leaders))
			remove_member(A)

	faction_panel()


//This returns a list of all items owned, held, worn, etc by faction members
/datum/faction/proc/get_inventory()
	var/list/contents = list()
	for(var/datum/antagonist/A in members)
		if(A.owner && A.owner.current)
			contents.Add(A.owner.current.get_contents())

	return contents


/datum/faction/proc/greet()
	for(var/datum/antagonist/A in members)
		A.greet()


//Returns a list of all minds and atoms which have been targeted by our objectives
//This is used to disqualify them from being picked by farther objectives
/datum/faction/proc/get_targets()
	var/list/targets = list()
	for(var/datum/objective/O in objectives)
		targets.Add(O.get_target())
	return targets
