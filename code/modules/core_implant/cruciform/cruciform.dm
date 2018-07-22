var/list/christians = list()

/obj/item/weapon/implant/core_implant/cruciform
	name = "cruciform"
	icon_state = "cruciform_green"
	desc = "Soul holder for every christian."
	allowed_organs = list(BP_CHEST)
	implant_type = /obj/item/weapon/implant/core_implant/cruciform

/obj/item/weapon/implant/core_implant/cruciform/New()
	..()
	add_module(new CRUCIFORM_COMMON)

/obj/item/weapon/implant/core_implant/cruciform/get_mob_overlay(gender, body_build)
	gender = (gender == MALE) ? "m" : "f"
	return image('icons/mob/human_races/cyberlimbs/neotheology.dmi', "[icon_state]_[gender][body_build]")

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
	..()
	update_data()
	christians |= wearer

/obj/item/weapon/implant/core_implant/cruciform/deactivate()
	if(!active || !wearer)
		return
	christians.Remove(wearer)
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
		for(var/mob/M in player_list)
			if(M.ckey == data.ckey)
				if(!isghost(M) && !isangel(M))
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

/obj/item/weapon/implant/core_implant/cruciform/proc/remove_cyber()
	if(!wearer)
		return
	for(var/obj/O in wearer)
		if(istype(O, /obj/item/organ/external/robotic))
			var/obj/item/organ/external/robotic/R = O
			if(R.owner != wearer)
				continue
			wearer.visible_message(SPAN_DANGER("[wearer]'s [R.name] tears off."),\
			SPAN_DANGER("Your [R.name] tears off."))
			R.droplimb()
		if(istype(O, /obj/item/weapon/implant))
			if(O == src)
				continue
			var/obj/item/weapon/implant/R = O
			if(R.wearer != wearer)
				continue
			wearer.visible_message(SPAN_DANGER("[R.name] rips through [wearer]'s [R.part]."),\
			SPAN_DANGER("[R.name] rips through your [R.part]."))
			R.part.take_damage(rand(40)+20)
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
	add_module(new CRUCIFORM_COMMON)

/obj/item/weapon/implant/core_implant/cruciform/proc/make_priest()
	add_module(new CRUCIFORM_PRIEST)

/obj/item/weapon/implant/core_implant/cruciform/proc/make_inquisitor()
	add_module(new CRUCIFORM_INQUISITOR)



/mob/proc/get_cruciform()
	var/obj/item/weapon/implant/core_implant/C = locate(/obj/item/weapon/implant/core_implant/cruciform, src)
	return C
