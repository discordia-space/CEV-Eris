var/list/christians = list()

/obj/item/core_implant/cruciform
	name = "cruciform"
	icon_state = "cruciform_red"
	power = 50
	max_power = 50
	allowed_rituals = list(/datum/ritual/relief, /datum/ritual/soul_hunger, /datum/ritual/entreaty)

/obj/item/core_implant/cruciform/get_mob_overlay(gender, body_build)
	gender = (gender == MALE) ? "m" : "f"
	return image('icons/mob/human_races/cyberlimbs/neotheology.dmi', "[icon_state]_[gender][body_build]")

/obj/item/core_implant/cruciform/proc/remove_cyber()
	if(!wearer)
		return
	for(var/obj/O in wearer)
		if(istype(O, /obj/item/organ/external/robotic))
			var/obj/item/organ/external/robotic/R = O
			wearer.visible_message("<span class='danger'>[wearer]'s [R.name] tears off.</span>",\
			"<span class='danger'>Your [R.name] tears off.</span>")
			R.droplimb()
		if(istype(O, /obj/item/weapon/implant))
			var/obj/item/weapon/implant/R = O
			wearer.visible_message("<span class='danger'>[R.name] rips through [wearer]'s [R.part].</span>",\
			"<span class='danger'>[R.name] rips through your [R.part].</span>")
			R.part.take_damage(rand(20)+10)
			R.forceMove(get_turf(wearer))
			R.wearer = null
			R.part.implants.Remove(R)
			R.malfunction = MALFUNCTION_PERMANENT

/obj/item/core_implant/cruciform/activate()
	if(!wearer)
		return FALSE

	remove_cyber()
	enable()
	return TRUE

/obj/item/core_implant/cruciform/enable()
	if(..())
		christians.Add(wearer)

/obj/item/core_implant/cruciform/can_activate()
	if(!wearer || activated || data)
		return FALSE

	if(!can_operate(wearer))
		return FALSE

	for(var/obj/item/clothing/C in wearer)
		if(wearer.l_hand == C || wearer.r_hand == C)
			continue
		return FALSE
	return TRUE

/obj/item/core_implant/cruciform/can_install(mob/living/carbon/human/M)
	if(locate(/obj/item/core_implant) in M)
		return FALSE

	if(!can_operate(M))
		return FALSE

	for(var/obj/item/clothing/C in M)
		if(M.l_hand == C || M.r_hand == C)
			continue
		return FALSE

	return TRUE

/obj/item/core_implant/cruciform/priest
	icon_state = "cruciform_green"
	power = 100
	max_power = 100
	success_modifier = 3
	allowed_rituals = list(/datum/ritual/relief, /datum/ritual/soul_hunger, /datum/ritual/entreaty,
					/datum/ritual/epiphany, /datum/ritual/resurrection, /datum/ritual/reincarnation)
