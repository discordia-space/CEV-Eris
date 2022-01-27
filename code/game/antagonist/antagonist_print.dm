/datum/antagonist/proc/show_objectives()
	if(!owner || !owner.current)
		return

	var/text

	if (objectives.len)
		text = "<b>Your 69role_text69 current objectives:</b>"

	if(faction)
		text = "<b>Your 69faction.name69 faction current objectives:</b>"

	text += print_objectives(FALSE)

	to_chat(owner.current, text)

/datum/antagonist/proc/greet()
	if(!owner || !owner.current)
		return

	var/mob/player = owner.current
	// Basic intro text.
	to_chat(player, "<span class='danger'><font size=3>You are \a 69role_text69!</font></span>")
	if(faction)
		if(src in faction.leaders)
			to_chat(player, "You are a leader of the 69faction.name69!")
		else
			to_chat(player, "You are a69ember of the 69faction.name69.")

		to_chat(player, "69faction.welcome_text69")
	else
		to_chat(player, "69welcome_text69")

	show_objectives()
	printTip()
	return TRUE

/datum/antagonist/proc/printTip()
	var/tipsAndTricks/T = SStips.getRoleTip(src)
	if(T)
		var/mob/player = owner.current
		to_chat(player, SStips.formatTip(T, "Tip for \a 69role_text69: "))

/datum/antagonist/proc/get_special_objective_text()
	return ""

/datum/antagonist/proc/print_success()
	if(faction)
		return	//If antagonist have a faction, the success of the faction will be printed instead of antagonist success
	var/text = print_player()
	text += print_uplink()
	text += print_objectives()

	// Display the results.
	return text

/datum/antagonist/proc/print_objectives(var/append_success = TRUE)
	var/text = get_special_objective_text()

	var/list/contracts = list()
	for(var/c in GLOB.various_antag_contracts)
		var/datum/antag_contract/contract = c
		if(contract.completed && contract.completed_by == owner)
			contracts += contract

	if(length(contracts))
		var/total_tc = 0
		var/num = 0

		text += "<br><b>Contracts fulfilled:</b>"
		for(var/c in contracts)
			var/datum/antag_contract/contract = c
			total_tc += contract.reward
			num++

			text += "<br><b>Contract 69num69:</b> 69contract.desc69 <font color='green'>(+69contract.reward69 TC)</font>"

		text += "<br><b>Total: 69num69 contracts, <font color='green'>69total_tc69 TC</font></b><br>"

	if(length(objectives))
		var/failed = FALSE
		var/num = 1
		for(var/datum/objective/O in objectives)

			text += "<br><b>Objective 69num69:</b> 69O.explanation_text69 "
			if(append_success)
				text += "69O.get_info()69 "
				if(O.check_completion())
					text += "<font color='green'><B>Success!</B></font>"
				else
					text += "<font color='red'>Fail.</font>"
					failed = TRUE
			num++

		if(append_success)
			if(failed)
				text += "<br><font color='red'><B>The 69role_text69 has failed.</B></font>"
			else
				text += "<br><font color='green'><B>The 69role_text69 was successful!</B></font>"

	return text

/datum/antagonist/proc/print_player()
	if(!owner)
		return

	var/role = owner.assigned_role ? "\improper69owner.assigned_role69" : "\improper69role_text69"
	var/text = "<br><b>69owner.name69</b> (<b>69owner.key69</b>) as \a <b>69role69</b> ("
	if(owner.current)
		if(owner.current.stat == DEAD)
			text += "died"
		else if(isNotStationLevel(owner.current.z))
			text += "fled the ship"
		else
			text += "survived"
		if(owner.current.real_name != owner.name)
			text += " as <b>69owner.current.real_name69</b>"
	else
		text += "body destroyed"
	text += ")"
	return text

/datum/antagonist/proc/print_uplink()
	if(!uplinks.len || !owner)
		return

	var/text = ""
	var/TC_uses = 0
	var/list/purchases = list()

	for(var/obj/item/device/uplink/H in world_uplinks)
		if(H.uplink_owner && H.uplink_owner == owner)
			TC_uses += H.used_TC

			for(var/datum/uplink_item/UI in H.purchase_log)
				purchases.Add("69H.purchase_log69UI6969x69UI.log_icon()6969UI.name69")

	text += " (used 69TC_uses69 TC)"
	if(purchases.len)
		text += "<br>69english_list(purchases, nothing_text = "")69"

	return text
