var/list/christians = list()

/obj/item/weapon/implant/external/core_implant/cruciform
	name = "cruciform"
	icon_state = "cruciform_red"
	power = 50
	max_power = 50
	allowed_rituals = list(/datum/ritual/cruciform/relief, /datum/ritual/cruciform/soul_hunger, /datum/ritual/cruciform/entreaty)
	position_flag = POS_FRONT_TOP

/obj/item/weapon/implant/external/core_implant/cruciform/get_mob_overlay(gender, body_build)
	gender = (gender == MALE) ? "m" : "f"
	return image('icons/mob/human_races/cyberlimbs/neotheology.dmi', "[icon_state]_[gender][body_build]")

/obj/item/weapon/implant/external/core_implant/cruciform/proc/remove_cyber()
	if(!wearer)
		return
	for(var/obj/O in wearer)
		if(istype(O, /obj/item/organ/external/robotic))
			var/obj/item/organ/external/robotic/R = O
			wearer.visible_message("<span class='danger'>[wearer]'s [R.name] tears off.</span>",\
			"<span class='danger'>Your [R.name] tears off.</span>")
			R.droplimb()
		if(istype(O, /obj/item/weapon/implant))
			if(istype(O, /obj/item/weapon/implant/external/core_implant/cruciform))
				continue
			var/obj/item/weapon/implant/R = O
			wearer.visible_message("<span class='danger'>[R.name] rips through [wearer]'s [R.part].</span>",\
			"<span class='danger'>[R.name] rips through your [R.part].</span>")
			R.part.take_damage(rand(20)+10)
			R.forceMove(get_turf(wearer))
			R.wearer = null
			R.part.implants.Remove(R)
			R.malfunction = MALFUNCTION_PERMANENT
	if(istype(wearer, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = wearer
		H.update_implants()

/obj/item/weapon/implant/external/core_implant/cruciform/activate()
	if(!wearer || active)
		return
	..()
	christians.Add(wearer)

/obj/item/weapon/implant/external/core_implant/cruciform/can_activate()
	if(!wearer || activated || data)
		return FALSE

	if(!can_operate(wearer))
		return FALSE

	for(var/obj/item/clothing/C in wearer)
		if(wearer.l_hand == C || wearer.r_hand == C)
			continue
		return FALSE
	return TRUE

/obj/item/weapon/implant/external/core_implant/cruciform/priest
	icon_state = "cruciform_green"
	power = 100
	max_power = 100
	success_modifier = 3
	allowed_rituals = list(/datum/ritual/cruciform/relief, /datum/ritual/cruciform/soul_hunger, /datum/ritual/cruciform/entreaty,
					/datum/ritual/cruciform/epiphany, /datum/ritual/cruciform/resurrection, /datum/ritual/cruciform/reincarnation)
