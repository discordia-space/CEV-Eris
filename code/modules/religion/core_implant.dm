/obj/item/core_implant
	name = "core implant"
	icon = 'icons/obj/device.dmi'
	w_class = 2
	origin_tech = list(TECH_MATERIAL=2, TECH_BIO=7, TECH_DATA=5)
	var/mob/living/carbon/human/wearer = null
	var/power = 0
	var/max_power = 0
	var/datum/dna2/record/data = null
	var/success_modifier = 1
	var/active = FALSE
	var/activated = FALSE			//true, if cruciform was activated once
	var/list/allowed_rituals = list()
	var/install_zone = "chest"

/obj/item/core_implant/Destroy()
	processing_objects.Remove(src)
	remove_hearing()
	..()

/obj/item/core_implant/proc/install(mob/living/carbon/human/M)
	forceMove(M)
	wearer = M
	wearer.update_implants()

/obj/item/core_implant/proc/deactivate()
	if(!active)
		return
	kill_wearer()
	disable()

/obj/item/core_implant/proc/uninstall()
	deactivate()
	drop()

/obj/item/core_implant/proc/kill_wearer()
	if(!wearer || wearer.stat == DEAD)
		return
	wearer.adjustBrainLoss(55+rand(5))
	wearer.adjustOxyLoss(100+rand(50))
	var/obj/item/organ/external/install = wearer.get_organ(install_zone)
	if(install)
		wearer.apply_damage(100+rand(75), BURN, install)
	wearer.apply_effect(40+rand(20), IRRADIATE, check_protection = 0)
	var/datum/effect/effect/system/spark_spread/s = new
	s.set_up(3, 1, src)
	s.start()

/obj/item/core_implant/proc/drop()
	if(!wearer)
		return
	var/turf/T = get_turf(wearer)
	forceMove(T)
	wearer.update_implants()
	wearer = null
	disable()

/obj/item/core_implant/proc/can_install(mob/living/carbon/human/M)
	return TRUE

/obj/item/core_implant/proc/can_activate()
	return TRUE

/obj/item/core_implant/proc/activate()
	if(!wearer || activated)
		return FALSE
	enable()
	return TRUE

/obj/item/core_implant/proc/transfer_soul()
	if(!wearer || !activated || !data)
		return FALSE

	if(wearer.dna.unique_enzymes == data.dna.unique_enzymes)
		var/datum/mind/MN = data.mind
		if(!istype(MN, /datum/mind))
			return
		MN.transfer_to(wearer)
		wearer.ckey = data.ckey
		for(var/datum/language/L in data.languages)
			wearer.add_language(L.name)
		update_data()
		return TRUE

/obj/item/core_implant/proc/enable()
	if(!wearer)
		return

	active = TRUE
	activated = TRUE
	update_data()
	processing_objects |= src
	add_hearing()

/obj/item/core_implant/proc/disable()
	active = FALSE
	processing_objects.Remove(src)
	remove_hearing()

/obj/item/core_implant/proc/update_data()
	if(!wearer)
		return

	data = new /datum/dna2/record()
	data.dna = wearer.dna
	data.ckey = wearer.ckey
	data.mind = wearer.mind
	data.id = copytext(md5(wearer.real_name), 2, 6)
	data.name = data.dna.real_name
	data.types = DNA2_BUF_UI | DNA2_BUF_UE | DNA2_BUF_SE
	data.languages = wearer.languages
	data.flavor = wearer.flavor_text

/obj/item/core_implant/hear_talk(mob/living/carbon/human/H, message)
	if(wearer != H)
		return

	message = replace_characters(message, list("." = ""))
	for(var/RT in allowed_rituals)
		var/datum/ritual/R = new RT
		if(R.phrase == message)
			if(R.power > src.power)
				H << "<span class='danger'>Not enough energy for the [R.name].</span>"
				return
			R.activate(H, src)
			return

/obj/item/core_implant/attack(mob/living/M, mob/living/user, var/target_zone)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(can_install(H))
			user.drop_item()
			user.visible_message("<span class='notice'>[user] installs \the [src] on [M].</span>",\
			"<span class='notice'>You install \the [src] on [M]</span>")
			install(H)
		else
			user << "<span class='warning'>You fail to install \the [src] on [M]</span>"

/obj/item/core_implant/proc/use_power(var/value)
	power = max(0, power - value)

/obj/item/core_implant/proc/restore_power(var/value)
	power = min(max_power, power + value)

/obj/item/core_implant/process()
	if(!active)
		return
	if((!wearer || loc != wearer) && active)
		disable()
	restore_power(0.5)


/obj/item/core_implant/verb/detach()
	set name = "Detach implant"
	set category = "Object"
	set src in usr

	if(!istype(usr, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/user = usr

	if(!user.stat && !user.handcuffed && !active && wearer == user)
		uninstall()
		user.put_in_active_hand(src)
		user.visible_message("<span class='notice'>[user] detach \his \the [src].</span>",\
			"<span class='notice'>You detach your \the [src].</span>")
