/datum/antagonist/proc/equip()

	if(owner && !ishuman(owner.current))
		return FALSE

	return TRUE

/datum/antagonist/proc/unequip()
	if(owner && !ishuman(owner.current))
		return FALSE
	return TRUE

/datum/antagonist/proc/clear_equipment()
	if(!ishuman(owner.current))
		return FALSE

	var/mob/living/carbon/human/player = owner.current

	for(var/obj/item/thing in player.contents)
		player.drop_from_inventory(thing)
		if(thing.loc != player)
			qdel(thing)

	return TRUE

/datum/antagonist/proc/create_id(var/assignment, var/equip = 1)
	if(!owner || !owner.current || !ishuman(owner.current))
		return

	var/mob/living/carbon/human/player = owner.current

	var/obj/item/weapon/card/id/W = new id_type(player)
	if(!W) return
	W.access |= default_access
	W.assignment = "[assignment]"
	player.set_id_info(W)
	if(equip) player.equip_to_slot_or_del(W, slot_wear_id)
	return W

/datum/antagonist/proc/create_radio(var/freq)
	if(!owner || !owner.current || !ishuman(owner.current))
		return

	var/mob/living/carbon/human/H = owner.current

	var/obj/item/device/radio/R

	if(freq == SYND_FREQ)
		R = new/obj/item/device/radio/headset/syndicate(H)
	else
		R = new/obj/item/device/radio/headset(H)

	R.set_frequency(freq)
	H.equip_to_slot_or_del(R, slot_l_ear)
	return R

/datum/antagonist/proc/spawn_uplink()
	if(!ishuman(owner.current))
		return
	var/mob/living/carbon/human/traitor_mob = owner.current
	var/loc = ""
	var/obj/item/R = locate() //Hide the uplink in a PDA if available, otherwise radio

	if(traitor_mob.client.prefs.uplinklocation == "Headset")
		R = locate(/obj/item/device/radio) in traitor_mob.contents
		if(!R)
			R = locate(/obj/item/modular_computer/pda) in traitor_mob.contents
			traitor_mob << "Could not locate a Radio, installing in PDA instead!"
		if (!R)
			traitor_mob << "Unfortunately, neither a radio or a PDA relay could be installed."
	else if(traitor_mob.client.prefs.uplinklocation == "PDA")
		R = locate(/obj/item/modular_computer/pda) in traitor_mob.contents
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
		R = locate(/obj/item/modular_computer/pda) in traitor_mob.contents
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

	else if (istype(R, /obj/item/modular_computer/pda))
		var/obj/item/modular_computer/pda/P = locate(/obj/item/modular_computer/pda) in traitor_mob.contents
		if(!P || !P.hard_drive)
			log_debug("TRAIOR [owner.name] couldn't recive uplink in PDA: Ether it not exist or no hardrive installed).")
			return FALSE

		var/pda_pass = "[rand(100,999)] [pick("Alpha","Bravo","Delta","Omega")]"
		var/obj/item/device/uplink/hidden/T = new(P, traitor_mob.mind)
		P.hidden_uplink = T
		var/datum/computer_file/program/uplink/program = new(pda_pass)
		if(!P.hard_drive.try_store_file(program))
			P.hard_drive.remove_file(P.hard_drive.find_file_by_name(program.filename))	//Maybe it already has a fake copy.
		if(!P.hard_drive.try_store_file(program))
			log_debug("TRAIOR [owner.name] couldn't recive uplink program in PDA: Not enough space or other issues.")
			return FALSE	//Not enough space or other issues.
		P.hard_drive.store_file(program)
		to_chat(traitor_mob, "<span class='notice'>A portable object teleportation relay has been installed in your [P.name]. Simply enter the code \"[pda_pass]\" in your new program to unlock its hidden features.</span>")
		traitor_mob.mind.store_memory("<B>Uplink passcode:</B> [pda_pass] ([P.name]).")