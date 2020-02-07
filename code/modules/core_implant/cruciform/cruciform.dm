var/list/disciples = list()

/obj/item/weapon/implant/core_implant/cruciform
	name = "cruciform"
	icon_state = "cruciform_green"
	desc = "Soul holder for every disciple. With the proper rituals, this can be implanted to induct a new believer into NeoTheology."
	allowed_organs = list(BP_CHEST)
	implant_type = /obj/item/weapon/implant/core_implant/cruciform
	layer = ABOVE_MOB_LAYER
	access = list(access_nt_disciple)
	power = 50
	max_power = 50
	power_regen = 0.5
	price_tag = 500

/obj/item/weapon/implant/core_implant/cruciform/get_mob_overlay(gender)
	gender = (gender == MALE) ? "m" : "f"
	return image('icons/mob/human_races/cyberlimbs/neotheology.dmi', "[icon_state]_[gender]")

/obj/item/weapon/implant/core_implant/cruciform/hard_eject()
	if(!ishuman(wearer))
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

/obj/item/weapon/implant/core_implant/cruciform/activate()
	if(!wearer || active)
		return

	if(wearer.mind && wearer.mind.changeling)
		playsound(wearer.loc, 'sound/hallucinations/wail.ogg', 55, 1)
		wearer.gib()
		return
	..()
	add_module(new CRUCIFORM_COMMON)
	update_data()
	disciples |= wearer
	return TRUE


/obj/item/weapon/implant/core_implant/cruciform/deactivate()
	if(!active || !wearer)
		return
	disciples.Remove(wearer)
	..()

/obj/item/weapon/implant/core_implant/cruciform/Process()
	..()
	if(active && round(world.time) % 5 == 0)
		remove_cyber()
	if(wearer && wearer.stat == DEAD)
		deactivate()


/obj/item/weapon/implant/core_implant/cruciform/proc/transfer_soul()
	if(!wearer || !activated)
		return FALSE
	var/datum/core_module/cruciform/cloning/data = get_module(CRUCIFORM_CLONING)
	if(wearer.dna.unique_enzymes == data.dna.unique_enzymes)
		for(var/mob/M in GLOB.player_list)
			if(M.ckey == data.ckey)
				if(M.stat != DEAD)
					return FALSE
		var/datum/mind/MN = data.mind
		if(!istype(MN, /datum/mind))
			return
		MN.transfer_to(wearer)
		wearer.ckey = data.ckey
		for(var/datum/language/L in data.languages)
			wearer.add_language(L.name)
		update_data()
		if (activate())
			return TRUE

/obj/item/weapon/implant/core_implant/cruciform/proc/remove_cyber()
	if(!wearer)
		return
	for(var/obj/O in wearer)
		if(istype(O, /obj/item/organ/external))
			var/obj/item/organ/external/R = O
			if(!BP_IS_ROBOTIC(R))
				continue

			if(R.owner != wearer)
				continue
			wearer.visible_message(SPAN_DANGER("[wearer]'s [R.name] tears off."),
			SPAN_DANGER("Your [R.name] tears off."))
			R.droplimb()
		if(istype(O, /obj/item/weapon/implant))
			if(O == src)
				continue
			var/obj/item/weapon/implant/R = O
			if(R.wearer != wearer)
				continue
			if(R.cruciform_resist)
				continue
			wearer.visible_message(SPAN_DANGER("[R.name] rips through [wearer]'s [R.part]."),\
			SPAN_DANGER("[R.name] rips through your [R.part]."))
			R.part.take_damage(rand(20,40))
			R.uninstall()
			R.malfunction = MALFUNCTION_PERMANENT
	if(ishuman(wearer))
		var/mob/living/carbon/human/H = wearer
		H.update_implants()

/obj/item/weapon/implant/core_implant/cruciform/proc/update_data()
	if(!wearer)
		return

	add_module(new CRUCIFORM_CLONING)


//////////////////////////
//////////////////////////

/obj/item/weapon/implant/core_implant/cruciform/proc/make_common()
	remove_modules(CRUCIFORM_PRIEST)
	remove_modules(CRUCIFORM_INQUISITOR)
	remove_modules(/datum/core_module/cruciform/red_light)

/obj/item/weapon/implant/core_implant/cruciform/proc/make_priest()
	add_module(new CRUCIFORM_PRIEST)
	add_module(new CRUCIFORM_REDLIGHT)

/obj/item/weapon/implant/core_implant/cruciform/proc/make_inquisitor()
	add_module(new CRUCIFORM_PRIEST)
	add_module(new CRUCIFORM_INQUISITOR)
	add_module(new /datum/core_module/cruciform/uplink())
	remove_modules(/datum/core_module/cruciform/red_light)
