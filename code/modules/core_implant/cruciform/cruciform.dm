var/list/christians = list()

/obj/item/weapon/implant/external/core_implant/cruciform
	name = "cruciform"
	icon_state = "cruciform_green"
	power = 50
	max_power = 50
	position_flag = POS_FRONT_TOP
	allowed_organs = list(BP_CHEST)
	rituals = list()
	var/datum/coreimplant_record/data = null

/obj/item/weapon/implant/external/core_implant/cruciform/New()
	rituals = cruciform_rituals

/obj/item/weapon/implant/external/core_implant/cruciform/get_mob_overlay(gender, body_build)
	gender = (gender == MALE) ? "m" : "f"
	return image('icons/mob/human_races/cyberlimbs/neotheology.dmi', "[icon_state]_[gender][body_build]")

/obj/item/weapon/implant/external/core_implant/cruciform/hard_eject()
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

/obj/item/weapon/implant/external/core_implant/cruciform/activate()
	if(!wearer || active)
		return
	..()
	update_data()
	christians.Add(wearer)

/obj/item/weapon/implant/external/core_implant/cruciform/deactivate()
	if(!active || !wearer)
		return
	hard_eject()
	christians.Remove(wearer)
	..()

/obj/item/weapon/implant/external/core_implant/cruciform/process()
	..()
	if(world.time == round(world.time))
		remove_cyber()

/obj/item/weapon/implant/external/core_implant/cruciform/proc/transfer_soul()
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

/obj/item/weapon/implant/external/core_implant/cruciform/proc/remove_cyber()
	if(!wearer)
		return
	for(var/obj/O in wearer)
		if(istype(O, /obj/item/organ/external/robotic))
			var/obj/item/organ/external/robotic/R = O
			if(R.owner != wearer)
				continue
			wearer.visible_message("<span class='danger'>[wearer]'s [R.name] tears off.</span>",\
			"<span class='danger'>Your [R.name] tears off.</span>")
			R.droplimb()
		if(istype(O, /obj/item/weapon/implant))
			if(O == src)
				continue
			var/obj/item/weapon/implant/R = O
			if(R.wearer != wearer)
				continue
			wearer.visible_message("<span class='danger'>[R.name] rips through [wearer]'s [R.part].</span>",\
			"<span class='danger'>[R.name] rips through your [R.part].</span>")
			R.part.take_damage(rand(40)+20)
			R.forceMove(get_turf(wearer))
			R.wearer = null
			R.part.implants.Remove(R)
			R.malfunction = MALFUNCTION_PERMANENT
	if(istype(wearer, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = wearer
		H.update_implants()

/obj/item/weapon/implant/external/core_implant/cruciform/proc/update_data()
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

/obj/item/weapon/implant/external/core_implant/cruciform/priest
	icon_state = "cruciform_red"
	power = 100
	max_power = 100
	success_modifier = 3

//////////////////////////
//////////////////////////

/datum/coreimplant_record
	var/datum/dna/dna = null

	var/age = 30
	var/ckey = ""
	var/mind = null
	var/languages = list()
	var/flavor = ""
