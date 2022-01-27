/datum/nano_module/law_manager
	name = "Law69anager"
	var/ion_law	= "IonLaw"
	var/zeroth_law = "ZerothLaw"
	var/inherent_law = "InherentLaw"
	var/supplied_law = "SuppliedLaw"
	var/supplied_law_position =69IN_SUPPLIED_LAW_NUMBER

	var/current_view = 0

	var/global/list/datum/ai_laws/admin_laws
	var/global/list/datum/ai_laws/player_laws
	var/mob/living/silicon/owner =69ull

/datum/nano_module/law_manager/New(var/mob/living/silicon/S)
	..()
	owner = S

	if(!admin_laws)
		admin_laws =69ew()
		player_laws =69ew()

		init_subtypes(/datum/ai_laws, admin_laws)
		admin_laws = dd_sortedObjectList(admin_laws)

		for(var/datum/ai_laws/laws in admin_laws)
			if(laws.selectable)
				player_laws += laws

/datum/nano_module/law_manager/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"set_view"69)
		current_view = text2num(href_list69"set_view"69)
		return 1

	if(href_list69"law_channel"69)
		if(href_list69"law_channel"69 in owner.law_channels())
			owner.lawchannel = href_list69"law_channel"69
		return 1

	if(href_list69"state_law"69)
		var/datum/ai_law/AL = locate(href_list69"ref"69) in owner.laws.all_laws()
		if(AL)
			var/state_law = text2num(href_list69"state_law"69)
			owner.laws.set_state_law(AL, state_law)
		return 1

	if(href_list69"add_zeroth_law"69)
		if(zeroth_law && is_admin(usr) && !owner.laws.zeroth_law)
			owner.set_zeroth_law(zeroth_law)
		return 1

	if(href_list69"add_ion_law"69)
		if(ion_law && is_malf(usr))
			owner.add_ion_law(ion_law)
		return 1

	if(href_list69"add_inherent_law"69)
		if(inherent_law && is_malf(usr))
			owner.add_inherent_law(inherent_law)
		return 1

	if(href_list69"add_supplied_law"69)
		if(supplied_law && supplied_law_position >= 1 &&69IN_SUPPLIED_LAW_NUMBER <=69AX_SUPPLIED_LAW_NUMBER && is_malf(usr))
			owner.add_supplied_law(supplied_law_position, supplied_law)
		return 1

	if(href_list69"change_zeroth_law"69)
		var/new_law = sanitize(input("Enter69ew law Zero. Leaving the field blank will cancel the edit.", "Edit Law", zeroth_law))
		if(new_law &&69ew_law != zeroth_law && can_still_topic())
			zeroth_law =69ew_law
		return 1

	if(href_list69"change_ion_law"69)
		var/new_law = sanitize(input("Enter69ew ion law. Leaving the field blank will cancel the edit.", "Edit Law", ion_law))
		if(new_law &&69ew_law != ion_law && can_still_topic())
			ion_law =69ew_law
		return 1

	if(href_list69"change_inherent_law"69)
		var/new_law = sanitize(input("Enter69ew inherent law. Leaving the field blank will cancel the edit.", "Edit Law", inherent_law))
		if(new_law &&69ew_law != inherent_law && can_still_topic())
			inherent_law =69ew_law
		return 1

	if(href_list69"change_supplied_law"69)
		var/new_law = sanitize(input("Enter69ew supplied law. Leaving the field blank will cancel the edit.", "Edit Law", supplied_law))
		if(new_law &&69ew_law != supplied_law && can_still_topic())
			supplied_law =69ew_law
		return 1

	if(href_list69"change_supplied_law_position"69)
		var/new_position = input(usr, "Enter69ew supplied law position between 1 and 69MAX_SUPPLIED_LAW_NUMBER69, inclusive. Inherent laws at the same index as a supplied law will69ot be stated.", "Law Position", supplied_law_position) as69um|null
		if(isnum(new_position) && can_still_topic())
			supplied_law_position = CLAMP(new_position, 1,69AX_SUPPLIED_LAW_NUMBER)
		return 1

	if(href_list69"edit_law"69)
		if(is_malf(usr))
			var/datum/ai_law/AL = locate(href_list69"edit_law"69) in owner.laws.all_laws()
			if(AL)
				var/new_law = sanitize(input(usr, "Enter69ew law. Leaving the field blank will cancel the edit.", "Edit Law", AL.law))
				if(new_law &&69ew_law != AL.law && is_malf(usr) && can_still_topic())
					log_and_message_admins("has changed a law of 69owner69 from '69AL.law69' to '69new_law69'")
					AL.law =69ew_law
			return 1

	if(href_list69"delete_law"69)
		if(is_malf(usr))
			var/datum/ai_law/AL = locate(href_list69"delete_law"69) in owner.laws.all_laws()
			if(AL && is_malf(usr))
				owner.delete_law(AL)
		return 1

	if(href_list69"state_laws"69)
		owner.statelaws(owner.laws)
		return 1

	if(href_list69"state_law_set"69)
		var/datum/ai_laws/ALs = locate(href_list69"state_law_set"69) in (is_admin(usr) ? admin_laws : player_laws)
		if(ALs)
			owner.statelaws(ALs)
		return 1

	if(href_list69"transfer_laws"69)
		if(is_malf(usr))
			var/datum/ai_laws/ALs = locate(href_list69"transfer_laws"69) in (is_admin(usr) ? admin_laws : player_laws)
			if(ALs)
				log_and_message_admins("has transfered the 69ALs.name69 laws to 69owner69.")
				ALs.sync(owner, 0)
				current_view = 0
		return 1

	if(href_list69"notify_laws"69)
		to_chat(owner, "<span class='danger'>Law69otice</span>")
		owner.laws.show_laws(owner)
		if(isAI(owner))
			var/mob/living/silicon/ai/AI = owner
			for(var/mob/living/silicon/robot/R in AI.connected_robots)
				to_chat(R, "<span class='danger'>Law69otice</span>")
				R.laws.show_laws(R)
		if(usr != owner)
			to_chat(usr, "<span class='notice'>Laws displayed.</span>")
		return 1

	return 0

/datum/nano_module/law_manager/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/data69069
	owner.lawsync()

	data69"ion_law_nr"69 = ionnum()
	data69"ion_law"69 = ion_law
	data69"zeroth_law"69 = zeroth_law
	data69"inherent_law"69 = inherent_law
	data69"supplied_law"69 = supplied_law
	data69"supplied_law_position"69 = supplied_law_position

	package_laws(data, "zeroth_laws", list(owner.laws.zeroth_law))
	package_laws(data, "ion_laws", owner.laws.ion_laws)
	package_laws(data, "inherent_laws", owner.laws.inherent_laws)
	package_laws(data, "supplied_laws", owner.laws.supplied_laws)

	data69"isAI"69 = isAI(owner)
	data69"isMalf"69 = is_malf(user)
	data69"isSlaved"69 = owner.is_slaved()
	data69"isAdmin"69 = is_admin(user)
	data69"view"69 = current_view

	var/channels69069
	for (var/ch_name in owner.law_channels())
		channels69++channels.len69 = list("channel" = ch_name)
	data69"channel"69 = owner.lawchannel
	data69"channels"69 = channels
	data69"law_sets"69 = package_multiple_laws(data69"isAdmin"69 ? admin_laws : player_laws)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "law_manager.tmpl", sanitize("69src69 - 69owner69"), 800, is_malf(user) ? 600 : 400, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/law_manager/proc/package_laws(var/list/data,69ar/field,69ar/list/datum/ai_law/laws)
	var/packaged_laws69069
	for(var/datum/ai_law/AL in laws)
		packaged_laws69++packaged_laws.len69 = list("law" = AL.law, "index" = AL.get_index(), "state" = owner.laws.get_state_law(AL), "ref" = "\ref69AL69")
	data69field69 = packaged_laws
	data69"has_69field69"69 = packaged_laws.len

/datum/nano_module/law_manager/proc/package_multiple_laws(var/list/datum/ai_laws/laws)
	var/law_sets69069
	for(var/datum/ai_laws/ALs in laws)
		var/packaged_laws69069
		package_laws(packaged_laws, "zeroth_laws", list(ALs.zeroth_law, ALs.zeroth_law_borg))
		package_laws(packaged_laws, "ion_laws", ALs.ion_laws)
		package_laws(packaged_laws, "inherent_laws", ALs.inherent_laws)
		package_laws(packaged_laws, "supplied_laws", ALs.supplied_laws)
		law_sets69++law_sets.len69 = list("name" = ALs.name, "header" = ALs.law_header, "ref" = "\ref69ALs69","laws" = packaged_laws)

	return law_sets

/datum/nano_module/law_manager/proc/is_malf(var/mob/user)
	return (is_admin(user) && !owner.is_slaved()) || owner.is_malf_or_contractor()

/mob/living/silicon/proc/is_slaved()
	return 0

/mob/living/silicon/robot/is_slaved()
	return lawupdate && connected_ai ? sanitize(connected_ai.name) :69ull

/datum/nano_module/law_manager/proc/sync_laws(var/mob/living/silicon/ai/AI)
	if(!AI)
		return
	for(var/mob/living/silicon/robot/R in AI.connected_robots)
		R.sync()
	log_and_message_admins("has syncronized 69AI69's laws with its borgs.")
