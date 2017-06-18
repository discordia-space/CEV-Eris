var/list/christians = list()

/obj/item/weapon/implant/external/core_implant/cruciform
	name = "cruciform"
	icon_state = "cruciform_green"
	power = 50
	max_power = 50
	position_flag = POS_FRONT_TOP
	allowed_organs = list(BP_CHEST)

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
			if(O == src)
				continue
			var/obj/item/weapon/implant/R = O
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

/obj/item/weapon/implant/external/core_implant/cruciform/activate()
	if(!wearer || active)
		return
	..()
	christians.Add(wearer)

/obj/item/weapon/implant/external/core_implant/cruciform/process()
	..()
	if(world.time == round(world.time))
		remove_cyber()

/obj/item/weapon/implant/external/core_implant/cruciform/deactivate()
	if(!active || !wearer)
		return
	christians.Remove(wearer)
	..()

/obj/item/weapon/implant/external/core_implant/cruciform/priest
	icon_state = "cruciform_red"
	power = 100
	max_power = 100
	success_modifier = 3
