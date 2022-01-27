/datum/faction
	var/id
	var/name = "faction"	//name displayed in different places
	var/antag = "antag"		//name for the faction69embers
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

	var/list/verbs = list()	//List of69erbs, used by this faction69embers
	var/list/leader_verbs = list()

/datum/faction/New()
	if(!leader_hud_indicator)
		leader_hud_indicator = hud_indicator
	GLOB.current_factions.Add(src)

/datum/faction/proc/add_member(var/datum/antagonist/member,69ar/announce = TRUE)
	if(!member || !member.owner || !member.owner.current || (member in69embers) || !member.owner.current.client)
		return
	if(possible_antags.len && !(member.id in possible_antags))
		return

	members.Add(member)
	member.faction = src
	if(announce)
		to_chat(member.owner.current, SPAN_NOTICE("You became a69ember of the 69name69."))

	if (objectives.len)
		member.set_objectives(objectives)

	member.owner.current.verbs |=69erbs
	add_icons(member)
	update_members()
	return TRUE

/datum/faction/proc/add_leader(var/datum/antagonist/member,69ar/announce = TRUE)
	if(!member || (member in leaders) || !member.owner.current)
		return

	if(!(member in69embers))
		add_member(member,FALSE)

	leaders.Add(member)
	member.owner.current.verbs |= leader_verbs
	if(announce)
		to_chat(member.owner.current, SPAN_NOTICE("You became a <b>leader</b> of the 69name69."))
	update_members()
	update_icons(member)
	return TRUE


//Randomly selects leaders from the faction69embers
/datum/faction/proc/pick_leaders(var/num)
	var/list/candidates =69embers.Copy()

	//Specifically check e69uality to zero, rather than <=
	//This allows a69alue of -1 to be passed, to convert everyone into a leader since it will never reach zero
		//Just keeps going until theres no candidates left
	while (num != 0 && candidates.len)
		var/datum/antagonist/A = pick_n_take(candidates)
		add_leader(A)
		num--


/datum/faction/proc/remove_leader(var/datum/antagonist/member,69ar/announce = TRUE)
	if(!member || !(member in leaders) || !member.owner.current)
		return

	update_icons(member)

	leaders.Remove(member)
	if(announce)
		to_chat(member.owner.current, SPAN_WARNING("You are no longer the <b>leader</b> of the 69name69."))
	member.owner.current.verbs.Remove(leader_verbs)

	update_members()
	return TRUE

/datum/faction/proc/remove_member(var/datum/antagonist/member,69ar/announce = TRUE)
	if(!(member in69embers))
		return

	remove_icons(member)

	members.Remove(member)

	if(member in leaders)
		remove_leader(member, FALSE)

	if(announce)
		to_chat(member.owner.current, SPAN_WARNING("You are no longer a69ember of the 69name69."))

	if(member.owner &&69ember.owner.current)
		member.owner.current.verbs.Remove(verbs)

	update_members()
	return TRUE

/datum/faction/proc/clear_faction()
	for(var/datum/antagonist/A in69embers)
		remove_member(A)

	GLOB.current_factions.Remove(src)
	return TRUE


/datum/faction/proc/remove_faction()
	clear_faction()
	69del(src)
	return TRUE


/datum/faction/proc/create_objectives()
	set_objectives(objectives)

/datum/faction/proc/set_objectives(var/list/new_objs)
	objectives = new_objs

	for(var/datum/antagonist/A in69embers)
		A.set_objectives(new_objs)

/datum/faction/proc/update_members()
	if(!members.len)
		remove_faction()

/datum/faction/proc/customize(var/mob/leader)

/datum/faction/proc/communicate(var/mob/user)
	if(!is_member(user) || user.stat != CONSCIOUS)
		return

	var/message = input(user, "Type69essage","69name69 communication")

	if(!message || !is_member(user) || user.stat != CONSCIOUS) //Check the same things again, to prevent69essage-holding
		return

	message = capitalize(sanitize(message))
	var/text = "<span class='revolution'>69name6969ember, 69user69: \"69message69\"</span>"
	for(var/datum/antagonist/A in69embers)
		to_chat(A.owner.current, text)

	//ghosts
	for (var/mob/observer/ghost/M in GLOB.dead_mob_list)	//does this include players who joined as observers as well?
		if (!(M.client))
			continue
		if((M.antagHUD &&69.get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH) || is_admin(M))
			to_chat(M, "69text69 (69ghost_follow_link(user,69)69)")

	log_say("69user.name69/69user.key69 (REV 69name69) : 69message69")

/datum/faction/proc/is_member(var/mob/user)
	for(var/datum/antagonist/A in69embers)
		if(A.owner.current == user)
			return TRUE
	return FALSE

/datum/faction/proc/print_success()
	if(!members.len)
		return

	var/text = ""//<b>69capitalize(name)69 was faction of 69antag69.</b>"

	if(leaders.len)
		text += "<br><b>69capitalize(name)69's leader69leaders.len >= 1?"":"s"69 was:</b>"
		for(var/datum/antagonist/A in leaders)
			text += A.print_player()
		text += "<br>"
	else
		text += "<br>69capitalize(name)69 had no leaders.<br>"

	text += "<br><b>69capitalize(name)69's69embers was:</b>"
	for(var/datum/antagonist/A in69embers)
		text += A.print_player()

	text += "<br>"

	if (objectives.len)
		var/failed = FALSE
		var/num = 1

		for(var/datum/objective/O in objectives)
			text += "<br><b>Objective 69num69:</b> 69O.explanation_text69 "
			if(O.check_completion())
				text += "<font color='green'><B>Success!</B></font>"
			else
				text += "<font color='red'>Fail.</font>"
				failed = TRUE
			num++

		if(failed)
			text += "<br><font color='red'><B>The69embers of the 69name69 failed their tasks.</B></font>"
		else
			text += "<br><font color='green'><B>The69embers of the 69name69 accomplished their tasks!</B></font>"
	text += print_success_extra()
	// Display the results.
	return text
/datum/faction/proc/print_success_extra() //Placeholder for extra data for print_succes proc
	return ""
/datum/faction/proc/get_indicator(var/datum/antagonist/A)
	if(A in leaders)
		return get_leader_indicator()

	if(A in69embers)
		return get_member_indicator()

/datum/faction/proc/get_member_indicator()
	var/image/I = image('icons/mob/mob.dmi', icon_state = hud_indicator, layer = ABOVE_LIGHTING_LAYER)
	I.plane = ABOVE_LIGHTING_PLANE
	return I

/datum/faction/proc/get_leader_indicator()
	var/image/I = image('icons/mob/mob.dmi', icon_state = leader_hud_indicator, layer = ABOVE_LIGHTING_LAYER)
	I.plane = ABOVE_LIGHTING_PLANE
	return I

/datum/faction/proc/add_icons(var/datum/antagonist/antag)
	if(faction_invisible || !hud_indicator || !leader_hud_indicator || !antag.owner || !antag.owner.current || !antag.owner.current.client)
		return

	var/image/I

	if(antag in faction_icons && faction_icons69antag69)
		I = faction_icons69antag69
	else
		I = get_indicator(antag)
		I.loc = antag.owner.current
		faction_icons69antag69 = I

	for(var/datum/antagonist/member in69embers)
		if(!member.owner || !member.owner.current || !member.owner.current.client)
			continue

		antag.owner.current.client.images |= faction_icons69member69
		member.owner.current.client.images |= I

/datum/faction/proc/remove_icons(var/datum/antagonist/antag)
	if(!faction_invisible || !antag.owner || !antag.owner.current || !antag.owner.current.client)
		69del(faction_icons69antag69)
		faction_icons.Remove(antag)
		return

	for(var/datum/antagonist/member in69embers)
		if(!member.owner || !member.owner.current || !member.owner.current.client)
			continue

		antag.owner.current.client.images.Remove(faction_icons69member69)
		member.owner.current.client.images.Remove(faction_icons69antag69)

	69del(faction_icons69antag69)
	faction_icons69antag69 = null

/datum/faction/proc/clear_icons()
	for(var/datum/antagonist/antag in69embers)
		remove_icons(antag)

	for(var/icon in faction_icons)	//Some69embers of faction69ay be offline, but we need to remove all icons
		69del(faction_icons69icon69)

	faction_icons = list()

/datum/faction/proc/reset_icons()
	clear_icons()
	for(var/datum/antagonist/antag in69embers)
		add_icons(antag)

/datum/faction/proc/update_icons(var/datum/antagonist/A)
	remove_icons(A)
	add_icons(A)

/datum/faction/proc/faction_panel()
	var/data = "<center><font size='3'><b>FACTION PANEL</b></font></center>"
	data += "<br>69name69 - faction of 69antag69 (69id69)"
	data += "<br>Welcome: 69welcome_text69"
	data += {"<br><a href='?src=\ref69src69;rename=1'>\69NAME\69</a>
	<a href='?src=\ref69src69;rewelcome=1'>\69WLCM\69</a><a href='?src=\ref69src69;remove=1'>\69REMOVE\69</a>"}
	data += "<br>Hud: \"<a href='?src=\ref69src69;seticon=1'>69hud_indicator ? hud_indicator : "null"69</a>\""
	data += "<br><a href='?src=\ref69src69;toggleinv=1'>\69MAKE 69faction_invisible ? "VISIBLE" : "INVISIBLE"69\69</a>"


	data += "<br><br><b>Members:</b>"
	for(var/i=1;i<=members.len; i++)
		var/datum/antagonist/member =69embers69i69
		if(!istype(member))
			data += "<br>Invalid element on index 69i69: 69member ?69ember : "NULL"69"
		else
			if(member in leaders)
				data += "<br>69member.owner ?69ember.owner.name : "no owner"69 <a href='?src=\ref69src69;remleader=\ref69member69'>\69REMV LEADER\69</a> \69REMOVE\69"
			else
				data += "<br>69member.owner ?69ember.owner.name : "no owner"69 <a href='?src=\ref69src69;makeleader=\ref69member69'>\69MAKE LEADER\69</a> <a href='?src=\ref69src69;remmember=69i69'>\69REMOVE\69</a>"
			data += "<a href='?src=69member69'>\69EDIT\69</a>"

	data += "<br><br><b>Objectives:</b><br>"
	for(var/i=1;i<=objectives.len; i++)
		var/datum/objective/O = objectives69i69
		//Make sure we show the69ost up-to-date info
		O.update_completion()
		O.update_explanation()
		data += "69i69. 69O.get_panel_entry()69<br>"

	usr << browse(data,"window=69id69faction")

/datum/faction/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return

	if(href_list69"makeleader"69)
		var/datum/antagonist/A = locate(href_list69"makeleader"69)
		if(istype(A))
			add_leader(A)

	if(href_list69"remleader"69)
		var/datum/antagonist/A = locate(href_list69"remleader"69)
		if(istype(A) && (A in leaders))
			remove_leader(A)

	if(href_list69"remmember"69)
		var/datum/antagonist/A = locate(href_list69"remmember"69)
		if(istype(A) && !(A in leaders))
			remove_member(A)

	faction_panel()


//This returns a list of all items owned, held, worn, etc by faction69embers
/datum/faction/proc/get_inventory()
	var/list/contents = list()
	for (var/datum/antagonist/A in69embers)
		if (A.owner && A.owner.current)
			contents.Add(A.owner.current.get_contents())

	return contents


/datum/faction/proc/greet()
	for (var/datum/antagonist/A in69embers)
		A.greet()


//Returns a list of all69inds and atoms which have been targeted by our objectives
//This is used to dis69ualify them from being picked by farther objectives
/datum/faction/proc/get_targets()
	var/list/targets = list()
	for (var/datum/objective/O in objectives)
		targets.Add(O.get_target())
	return targets
