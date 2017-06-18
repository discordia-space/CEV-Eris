/obj/item/weapon/implant/external/core_implant
	name = "core implant"
	icon = 'icons/obj/device.dmi'
	w_class = 2
	origin_tech = list(TECH_MATERIAL=2, TECH_BIO=7, TECH_DATA=5)
	var/power = 0
	var/max_power = 0
	var/datum/coreimplant_record/data = null
	var/success_modifier = 1
	var/active = FALSE
	var/activated = FALSE			//true, if cruciform was activated once
	var/address = null				//string, used as id for targeted rituals

/obj/item/weapon/implant/external/core_implant/Destroy()
	processing_objects.Remove(src)
	deactivate()
	..()

/obj/item/weapon/implant/external/core_implant/proc/kill_wearer()
	if(!istype(wearer, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = wearer
	if(H.stat == DEAD)
		return
	H.adjustBrainLoss(55+rand(5))
	H.adjustOxyLoss(100+rand(50))
	if(part)
		H.apply_damage(100+rand(75), BURN, part)
	H.apply_effect(40+rand(20), IRRADIATE, check_protection = 0)
	var/datum/effect/effect/system/spark_spread/s = new
	s.set_up(3, 1, src)
	s.start()

/obj/item/weapon/implant/external/core_implant/malfunction()
	kill_wearer()

/obj/item/weapon/implant/external/core_implant/install(var/mob/M)
	if(ishuman(M))
		..(M)

/obj/item/weapon/implant/external/core_implant/uninstall()
	deactivate()
	..()

/obj/item/weapon/implant/external/core_implant/activate()
	if(!wearer || active)
		return
	active = TRUE
	activated = TRUE
	update_data()
	processing_objects |= src
	add_hearing()

/obj/item/weapon/implant/external/core_implant/deactivate()
	if(!active)
		return
	kill_wearer()
	remove_hearing()
	active = FALSE
	processing_objects.Remove(src)

/obj/item/weapon/implant/external/core_implant/proc/transfer_soul()
	if(!wearer || !activated || !data)
		return FALSE

	if(wearer.dna.unique_enzymes == data.dna.unique_enzymes)
		for(var/mob/M in player_list)
			if(M.ckey == data.ckey)
				if(1)	//angel check here
					return FALSE
		var/datum/mind/MN = data.mind
		if(!istype(MN, /datum/mind))
			return
		MN.transfer_to(wearer)
		wearer.ckey = data.ckey
		for(var/datum/language/L in data.languages)
			wearer.add_language(L.name)
		update_data()
		return TRUE

/obj/item/weapon/implant/external/core_implant/proc/update_data()
	if(!wearer)
		return

	data = new /datum/coreimplant_record()
	data.dna = wearer.dna
	data.ckey = wearer.ckey
	data.mind = wearer.mind
	data.languages = wearer.languages
	data.flavor = wearer.flavor_text

	if(ishuman(wearer))
		var/mob/living/carbon/human/H = wearer
		data.age = H.age

/obj/item/weapon/implant/external/core_implant/proc/update_address()
	if(!loc)
		address = null
		return

	if(wearer)
		address = wearer.real_name
		return

	var/area/A = get_area(src)
	if(istype(loc, /obj/machinery/neotheology))
		address = "[loc.name] in [strip_improper(A.name)]"
		return

	address = null

/obj/item/weapon/implant/external/core_implant/hear_talk(mob/living/carbon/human/H, message)
	if(wearer != H)
		return

//	message = replace_characters(message, list("." = ""))
	for(var/RT in cruciform_rituals)
		var/datum/ritual/R = new RT
		if(R.compare(message))
			if(R.power > src.power)
				H << "<span class='danger'>Not enough energy for the [R.name].</span>"
				return
			if(!R.is_allowed(src))
				H << "<span class='danger'>You are not allowed to perform [R.name].</span>"
				return
			R.activate(H, src, R.get_targets(message))
			return

/obj/item/weapon/implant/external/core_implant/proc/use_power(var/value)
	power = max(0, power - value)

/obj/item/weapon/implant/external/core_implant/proc/restore_power(var/value)
	power = min(max_power, power + value)

/obj/item/weapon/implant/external/core_implant/process()
	if(!active)
		return
	if((!wearer || loc != wearer) && active)
		remove_hearing()
		active = FALSE
		processing_objects.Remove(src)
	restore_power(0.5)

//////////////////////////
//////////////////////////

/datum/coreimplant_record
	var/datum/dna/dna = null

	var/age = 30
	var/ckey = ""
	var/mind = null
	var/languages = list()
	var/flavor = ""
