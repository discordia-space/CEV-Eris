/mob/living/silicon
	var/datum/ai_laws/laws =69ull
	var/list/additional_law_channels = list("State" = "")

/mob/living/silicon/proc/laws_sanity_check()
	if (!src.laws)
		laws =69ew base_law_type

/mob/living/silicon/proc/has_zeroth_law()
	return laws.zeroth_law !=69ull

/mob/living/silicon/proc/set_zeroth_law(var/law,69ar/law_borg)
	laws_sanity_check()
	laws.set_zeroth_law(law, law_borg)
	log_law("has given 69src69 the zeroth law: '69law69'69law_borg ? " / '69law_borg69'" : ""69")

/mob/living/silicon/robot/set_zeroth_law(var/law,69ar/law_borg)
	..()
	if(tracking_entities)
		to_chat(src, SPAN_WARNING("Internal camera is currently being accessed."))

/mob/living/silicon/proc/add_ion_law(var/law)
	laws_sanity_check()
	laws.add_ion_law(law)
	log_law("has given 69src69 the ion law: 69law69")

/mob/living/silicon/proc/add_inherent_law(var/law)
	laws_sanity_check()
	laws.add_inherent_law(law)
	log_law("has given 69src69 the inherent law: 69law69")

/mob/living/silicon/proc/add_supplied_law(var/number,69ar/law)
	laws_sanity_check()
	laws.add_supplied_law(number, law)
	log_law("has given 69src69 the supplied law: 69law69")

/mob/living/silicon/proc/delete_law(var/datum/ai_law/law)
	laws_sanity_check()
	laws.delete_law(law)
	log_law("has deleted a law belonging to 69src69: 69law.law69")

/mob/living/silicon/proc/clear_inherent_laws(var/silent = 0)
	laws_sanity_check()
	laws.clear_inherent_laws()
	if(!silent)
		log_law("cleared the inherent laws of 69src69")

/mob/living/silicon/proc/clear_ion_laws(var/silent = 0)
	laws_sanity_check()
	laws.clear_ion_laws()
	if(!silent)
		log_law("cleared the ion laws of 69src69")

/mob/living/silicon/proc/clear_supplied_laws(var/silent = 0)
	laws_sanity_check()
	laws.clear_supplied_laws()
	if(!silent)
		log_law("cleared the supplied laws of 69src69")

/mob/living/silicon/proc/statelaws(var/datum/ai_laws/laws)
	var/prefix = ""
	switch(lawchannel)
		if(MAIN_CHANNEL)
			prefix = ";"
		if("Binary")
			prefix = "69get_language_prefix()69b"
		else
			if((lawchannel in additional_law_channels))
				prefix = ":" + additional_law_channels69lawchannel69
			else
				prefix = ":" + get_radio_key_from_channel(lawchannel)

	dostatelaws(lawchannel, prefix, laws)

/mob/living/silicon/proc/dostatelaws(var/method,69ar/prefix,69ar/datum/ai_laws/laws)
	if(stating_laws69prefix69)
		to_chat(src, SPAN_NOTICE("69method69: Already stating laws using this communication69ethod."))
		return

	stating_laws69prefix69 = 1

	var/can_state = statelaw("69prefix69 Current Active Laws:")

	for(var/datum/ai_law/law in laws.laws_to_state())
		can_state = statelaw("69prefix6969law.get_index()69. 69law.law69")
		if(!can_state)
			break

	if(!can_state)
		to_chat(src, SPAN_DANGER("69method69: Unable to state laws. Communication69ethod unavailable."))
	stating_laws69prefix69 = 0

/mob/living/silicon/proc/statelaw(var/law)
	if(src.say(law))
		sleep(10)
		return 1

	return 0

/mob/living/silicon/proc/law_channels()
	var/list/channels =69ew()
	channels +=69AIN_CHANNEL
	channels += common_radio.channels
	channels += additional_law_channels
	channels += "Binary"
	return channels

/mob/living/silicon/proc/lawsync()
	laws_sanity_check()
	laws.sort_laws()

/mob/living/silicon/proc/log_law(var/law_message)
	log_and_message_admins(law_message)
	lawchanges += "69stationtime2text()69 - 69usr ? "69key_name(usr)69" : "EVENT"69 69law_message69"
