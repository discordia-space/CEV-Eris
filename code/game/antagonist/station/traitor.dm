// Inherits most of its vars from the base datum.
/datum/antagonist/traitor
	id = ROLE_TRAITOR
	protected_jobs = list("Ironhammer Operative", "Ironhammer Gunnery Sergeant", "Ironhammer Inspector", "Ironhammer Commander", "Captain", "Ironhammer Medical Specialist")

/datum/antagonist/traitor/get_extra_panel_options(var/datum/mind/player)
	return "<a href='?src=\ref[player];common=crystals'>\[set crystals\]</a><a href='?src=\ref[src];spawn_uplink=\ref[player.current]'>\[spawn uplink\]</a>"

/datum/antagonist/traitor/Topic(href, href_list)
	if (..())
		return
	if(href_list["spawn_uplink"]) spawn_uplink(locate(href_list["spawn_uplink"]))

/datum/antagonist/traitor/create_objectives()
	if(!..())
		return

	if(issilicon(owner.current))
		new /datum/objective/assassinate (src)
		new /datum/objective/survive (src)

		if(prob(10))
			new /datum/objective/block (src)
	else
		switch(rand(1,100))
			if(1 to 33)
				new /datum/objective/assassinate (src)
			if(34 to 50)
				new /datum/objective/brig (src)
			if(51 to 66)
				new /datum/objective/harm (src)
			else
				new /datum/objective/steal (src)
		if (!(locate(/datum/objective/escape) in objectives))
			new /datum/objective/escape (src)
	return

/datum/antagonist/traitor/equip(var/mob/living/carbon/human/traitor_mob)
	if(issilicon(traitor_mob)) // this needs to be here because ..() returns false if the mob isn't human
		add_law_zero(traitor_mob)
		return 1

	if(!..())
		return 0

	spawn_uplink()

	//Begin code phrase.
	give_codewords()

/datum/antagonist/traitor/proc/give_codewords()
	if(!owner.current)
		return
	var/mob/living/traitor_mob = owner.current
	traitor_mob << "<u><b>Your employers provided you with the following information on how to identify possible allies:</b></u>"
	traitor_mob << "<b>Code Phrase</b>: <span class='danger'>[syndicate_code_phrase]</span>"
	traitor_mob << "<b>Code Response</b>: <span class='danger'>[syndicate_code_response]</span>"
	traitor_mob.mind.store_memory("<b>Code Phrase</b>: [syndicate_code_phrase]")
	traitor_mob.mind.store_memory("<b>Code Response</b>: [syndicate_code_response]")
	traitor_mob << "Use the code words, preferably in the order provided, during regular conversation, to identify other agents. Proceed with caution, however, as everyone is a potential foe."

/datum/antagonist/traitor/proc/spawn_uplink()
	if(!ishuman(owner.current))
		return
	var/mob/living/carbon/human/traitor_mob = owner.current
	var/loc = ""
	var/obj/item/R = locate() //Hide the uplink in a PDA if available, otherwise radio

	if(traitor_mob.client.prefs.uplinklocation == "Headset")
		R = locate(/obj/item/device/radio) in traitor_mob.contents
		if(!R)
			R = locate(/obj/item/device/pda) in traitor_mob.contents
			traitor_mob << "Could not locate a Radio, installing in PDA instead!"
		if (!R)
			traitor_mob << "Unfortunately, neither a radio or a PDA relay could be installed."
	else if(traitor_mob.client.prefs.uplinklocation == "PDA")
		R = locate(/obj/item/device/pda) in traitor_mob.contents
		if(!R)
			R = locate(/obj/item/device/radio) in traitor_mob.contents
			traitor_mob << "Could not locate a PDA, installing into a Radio instead!"
		if(!R)
			traitor_mob << "Unfortunately, neither a radio or a PDA relay could be installed."
	else if(traitor_mob.client.prefs.uplinklocation == "None")
		traitor_mob << "You have elected to not have an AntagCorp portable teleportation relay installed!"
		R = null
	else
		traitor_mob << "You have not selected a location for your relay in the antagonist options! Defaulting to PDA!"
		R = locate(/obj/item/device/pda) in traitor_mob.contents
		if (!R)
			R = locate(/obj/item/device/radio) in traitor_mob.contents
			traitor_mob << "Could not locate a PDA, installing into a Radio instead!"
		if (!R)
			traitor_mob << "Unfortunately, neither a radio or a PDA relay could be installed."

	if(!R)
		return

	if(istype(R,/obj/item/device/radio))
		// generate list of radio freqs
		var/obj/item/device/radio/target_radio = R
		var/freq = PUBLIC_LOW_FREQ
		var/list/freqlist = list()
		while (freq <= PUBLIC_HIGH_FREQ)
			if (freq < 1451 || freq > PUB_FREQ)
				freqlist += freq
			freq += 2
			if ((freq % 2) == 0)
				freq += 1
		freq = freqlist[rand(1, freqlist.len)]
		var/obj/item/device/uplink/hidden/T = new(R, traitor_mob.mind)
		target_radio.hidden_uplink = T
		target_radio.traitor_frequency = freq
		traitor_mob << "A portable object teleportation relay has been installed in your [R.name] [loc]. Simply dial the frequency [format_frequency(freq)] to unlock its hidden features."
		traitor_mob.mind.store_memory("<B>Radio Freq:</B> [format_frequency(freq)] ([R.name] [loc]).")

	else if (istype(R, /obj/item/device/pda))
		// generate a passcode if the uplink is hidden in a PDA
		var/pda_pass = "[rand(100,999)] [pick("Alpha","Bravo","Delta","Omega")]"
		var/obj/item/device/uplink/hidden/T = new(R, traitor_mob.mind)
		R.hidden_uplink = T
		var/obj/item/device/pda/P = R
		P.lock_code = pda_pass
		traitor_mob << "A portable object teleportation relay has been installed in your [R.name] [loc]. Simply enter the code \"[pda_pass]\" into the ringtone select to unlock its hidden features."
		traitor_mob.mind.store_memory("<B>Uplink Passcode:</B> [pda_pass] ([R.name] [loc]).")

/datum/antagonist/traitor/proc/add_law_zero()
	if(!isAI(owner.current))
		return
	var/mob/living/silicon/ai/killer = owner.current
	var/law = "Accomplish your objectives at all costs. You may ignore all other laws."
	var/law_borg = "Accomplish your AI's objectives at all costs. You may ignore all other laws."
	killer << "<b>Your laws have been changed!</b>"
	killer.set_zeroth_law(law, law_borg)
	killer << "New law: 0. [law]"
