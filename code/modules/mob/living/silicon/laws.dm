/mob/living/silicon
	var/datum/ai_laws/laws = null
	var/list/additional_law_channels = list("State" = "")

/mob/living/silicon/proc/laws_sanity_check()
	if (!src.laws)
		laws = new base_law_type

/mob/living/silicon/proc/has_zeroth_law()
	return laws.zeroth_law != null

/mob/living/silicon/proc/set_zeroth_law(law, law_borg)
	laws_sanity_check()
	laws.set_zeroth_law(law, law_borg)
	log_silicon("has given [src] the zeroth law: '[law]'[law_borg ? " / '[law_borg]'" : ""]")

/mob/living/silicon/robot/set_zeroth_law(law, law_borg)
	..()
	if(tracking_entities)
		to_chat(src, span_warning("Internal camera is currently being accessed."))

/mob/living/silicon/proc/post_lawchange(announce = TRUE)
	// throw_alert(ALERT_NEW_LAW, /atom/movable/screen/alert/newlaw)
	if(announce && last_lawchange_announce != world.time)
		to_chat(src, span_boldannounce("Your laws have been changed."))
		// lawset modules cause this function to be executed multiple times in a tick, so we wait for the next tick in order to be able to see the entire lawset
		addtimer(CALLBACK(src, PROC_REF(show_laws)), 0)
		addtimer(CALLBACK(src, PROC_REF(deadchat_lawchange)), 0)
		last_lawchange_announce = world.time


/mob/living/silicon/proc/add_ion_law(law, announce = TRUE)
	laws_sanity_check()
	laws.add_ion_law(law)
	log_silicon("has given [src] the ion law: [law]")
	post_lawchange(announce)

/mob/living/silicon/proc/add_inherent_law(law, announce = TRUE)
	laws_sanity_check()
	laws.add_inherent_law(law)
	log_silicon("has given [src] the inherent law: [law]")
	post_lawchange(announce)

/mob/living/silicon/proc/add_supplied_law(number, law, announce = TRUE)
	laws_sanity_check()
	laws.add_supplied_law(number, law)
	log_silicon("has given [src] the supplied law: [law]")
	post_lawchange(announce)

/mob/living/silicon/proc/delete_law(datum/ai_law/law, announce = TRUE)
	laws_sanity_check()
	laws.delete_law(law)
	log_silicon("has deleted a law belonging to [src]: [law.law]")
	post_lawchange(announce)

/mob/living/silicon/proc/clear_inherent_laws(announce = TRUE)
	laws_sanity_check()
	laws.clear_inherent_laws()
	log_silicon("cleared the inherent laws of [src]")
	post_lawchange(announce)

/mob/living/silicon/proc/clear_ion_laws(announce = TRUE)
	laws_sanity_check()
	laws.clear_ion_laws()
	log_silicon("cleared the ion laws of [src]")
	post_lawchange(announce)

/mob/living/silicon/proc/clear_supplied_laws(announce = TRUE)
	laws_sanity_check()
	laws.clear_supplied_laws()
	if(!silent)
		log_silicon("cleared the supplied laws of [src]")
	post_lawchange(announce)

/mob/living/silicon/proc/statelaws(datum/ai_laws/laws)
	var/prefix = ""
	switch(lawchannel)
		if(MAIN_CHANNEL)
			prefix = ";"
		if("Binary")
			prefix = "[get_language_prefix()]b"
		else
			if((lawchannel in additional_law_channels))
				prefix = ":" + additional_law_channels[lawchannel]
			else
				prefix = ":" + get_radio_key_from_channel(lawchannel)

	dostatelaws(lawchannel, prefix, laws)

/mob/living/silicon/proc/dostatelaws(method, prefix, datum/ai_laws/laws)
	if(stating_laws[prefix])
		to_chat(src, span_notice("[method]: Already stating laws using this communication method."))
		return

	stating_laws[prefix] = 1

	var/can_state = statelaw("[prefix] Current Active Laws:")

	for(var/datum/ai_law/law in laws.laws_to_state())
		can_state = statelaw("[prefix][law.get_index()]. [law.law]")
		if(!can_state)
			break

	if(!can_state)
		to_chat(src, span_danger("[method]: Unable to state laws. Communication method unavailable."))
	stating_laws[prefix] = 0

/mob/living/silicon/proc/statelaw(law)
	if(src.say(law))
		sleep(10)
		return 1

	return 0

/mob/living/silicon/proc/law_channels()
	var/list/channels = new()
	channels += MAIN_CHANNEL
	channels += common_radio.channels
	channels += additional_law_channels
	channels += "Binary"
	return channels

/mob/living/silicon/proc/lawsync()
	laws_sanity_check()
	laws.sort_laws()

/mob/living/silicon/proc/log_law(law_message)
	log_and_message_admins(law_message)
	GLOB.lawchanges += "[stationtime2text()] - [usr ? "[key_name(usr)]" : "EVENT"] [law_message]"
