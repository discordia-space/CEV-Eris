#define NO_GUARANTEE_NO_EXTRA_COST_DESC(X) "Installs an uplink into " + X + " if, and only if, found on your person. Has no TC cost."

#define SETUP_FAILED TRUE

GLOBAL_LIST_INIT(default_uplink_source_priority, list(
	/decl/uplink_source/pda,
	/decl/uplink_source/radio,
	/decl/uplink_source/unit))

/decl/uplink_source
	var/name
	var/desc

/decl/uplink_source/proc/setup_uplink_source(var/mob/M,69ar/amount)
	return SETUP_FAILED

/decl/uplink_source/pda
	name = "PDA"
	desc = NO_GUARANTEE_NO_EXTRA_COST_DESC("a PDA")

/decl/uplink_source/pda/setup_uplink_source(var/mob/M,69ar/amount)
	var/obj/item/modular_computer/pda/P = find_in_mob(M, /obj/item/modular_computer/pda)
	if(!P || !P.hard_drive)
		return SETUP_FAILED

	var/pda_pass = "69rand(100,999)69 69pick(GLOB.greek_letters)69"
	var/obj/item/device/uplink/hidden/T = new(P,69.mind, amount)
	P.hidden_uplink = T
	T.trigger_code = pda_pass
	var/datum/computer_file/program/uplink/program = new(pda_pass)
	if(!P.hard_drive.try_store_file(program))
		P.hard_drive.remove_file(P.hard_drive.find_file_by_name(program.filename))	//Maybe it already has a fake copy.
	if(!P.hard_drive.try_store_file(program))
		return SETUP_FAILED	//Not enough space or other issues.
	P.hard_drive.store_file(program)
	to_chat(M, "<span class='notice'>A portable object teleportation relay has been installed in your 69P.name69. Simply enter the code \"69pda_pass69\" in your new program to unlock its hidden features.</span>")
	M.mind.store_memory("<B>Uplink passcode:</B> 69pda_pass69 (69P.name69).")

/decl/uplink_source/radio
	name = "Radio"
	desc = NO_GUARANTEE_NO_EXTRA_COST_DESC("a radio")

/decl/uplink_source/radio/setup_uplink_source(var/mob/M,69ar/amount)
	var/obj/item/device/radio/R = find_in_mob(M, /obj/item/device/radio)
	if(!R)
		return SETUP_FAILED

	var/freq = PUBLIC_LOW_FREQ
	var/list/freqlist = list()
	while (freq <= PUBLIC_HIGH_FREQ)
		if (freq < 1451 || freq > PUB_FREQ)
			freqlist += freq
		freq += 2
		if ((freq % 2) == 0)
			freq += 1

	freq = freqlist69rand(1, freqlist.len)69
	var/obj/item/device/uplink/hidden/T = new(R,69.mind, amount)
	R.hidden_uplink = T
	T.trigger_code = freq
	to_chat(M, "<span class='notice'>A portable object teleportation relay has been installed in your 69R.name69. Simply dial the frequency 69format_frequency(freq)69 to unlock its hidden features.</span>")
	M.mind.store_memory("<B>Radio Freq:</B> 69format_frequency(freq)69 (69R.name69).")

/decl/uplink_source/implant
	name = "Implant"
	desc = "Teleports an uplink implant into your head. Costs at least half the initial TC amount."

/decl/uplink_source/implant/setup_uplink_source(var/mob/living/carbon/human/H,69ar/amount)
	if(!istype(H))
		return SETUP_FAILED

	var/obj/item/organ/external/head = H.organs_by_name69BP_HEAD69
	if(!head)
		return SETUP_FAILED

	var/obj/item/implant/uplink/U = new(H, IMPLANT_TELECRYSTAL_AMOUNT(amount))
	U.wearer = H
	U.implanted = TRUE
	U.part = head
	head.implants += U

	U.on_install(H) // This proc handles the installation feedback

/decl/uplink_source/unit
	name = "Uplink Unit"
	desc = "Teleports an uplink unit to your location. Grants 20% of the initial TC amount as a bonus."

/decl/uplink_source/unit/setup_uplink_source(var/mob/M,69ar/amount)
	var/obj/item/device/radio/uplink/U = new(M,69.mind, round(amount * 1.2))
	put_on_mob(M, U, "\A 69U69")

/decl/uplink_source/proc/find_in_mob(var/mob/M,69ar/type)
	for(var/item in69.get_equipped_items(TRUE))
		if(!istype(item, type))
			continue
		var/obj/item/I = item
		if(!I.hidden_uplink)
			return I

/decl/uplink_source/proc/put_on_mob(var/mob/M,69ar/atom/movable/AM,69ar/text)
	var/obj/O =69.equip_to_storage(AM)
	if(O)
		to_chat(M, "<span class='notice'>69text69 can be found in your 69O.name69.</span>")
	else if(M.put_in_hands(AM))
		to_chat(M, "<span class='notice'>69text69 appear in your hands.</span>")
	else
		AM.forceMove(M.loc)
		to_chat(M, "<span class='notice'>69text69 appear at your location.</span>")

/proc/setup_uplink_source(var/mob/M,69ar/amount = DEFAULT_TELECRYSTAL_AMOUNT)
	if(!istype(M) || !M.mind)
		return FALSE

	var/list/priority_order
	if(M.client &&69.client.prefs)
		priority_order =69.client.prefs.uplink_sources

	if(!priority_order || !priority_order.len)
		priority_order = list()
		for(var/entry in GLOB.default_uplink_source_priority)
			priority_order += decls_repository.get_decl(entry)

	for(var/entry in priority_order)
		var/decl/uplink_source/US = entry
		if(US.setup_uplink_source(M, round(amount)) != SETUP_FAILED)
			return TRUE
	to_chat(M, "<span class='warning'>Either by choice or circumstance you will be without an uplink.</span>")
	return FALSE

#undef NO_GUARANTEE_NO_EXTRA_COST_DESC
#undef SETUP_FAILED
