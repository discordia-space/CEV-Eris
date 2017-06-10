var/list/cruciform_rituals = (typesof(/datum/ritual/cruciform)-/datum/ritual/cruciform)+\
	(typesof(/datum/ritual/targeted/cruciform)-/datum/ritual/targeted/cruciform)

/datum/ritual/cruciform
	name = "cruciform"
	phrase = null
	implant_type = /obj/item/weapon/implant/external/core_implant/cruciform

/datum/ritual/targeted/cruciform
	name = "cruciform targeted"
	phrase = null
	implant_type = /obj/item/weapon/implant/external/core_implant/cruciform

/datum/ritual/cruciform/relief
	name = "relief"
	phrase = "Et si ambulavero in medio umbrae mortis non timebo mala"
	power = 50
	chance = 33

/datum/ritual/cruciform/relief/perform(mob/living/carbon/human/H, obj/item/weapon/implant/external/core_implant/C)
	H.add_chemical_effect(CE_PAINKILLER, 10)


/datum/ritual/cruciform/soul_hunger
	name = "soul hunger"
	phrase = "Panem nostrum cotidianum da nobis hodie"
	power = 50
	chance = 33

/datum/ritual/cruciform/soul_hunger/perform(mob/living/carbon/human/H, obj/item/weapon/implant/external/core_implant/C)
	H.nutrition += 100
	H.adjustToxLoss(5)


/datum/ritual/cruciform/entreaty
	name = "entreaty"
	phrase = "Deus meus ut quid dereliquisti me?"
	power = 50
	chance = 60

/datum/ritual/cruciform/entreaty/perform(mob/living/carbon/human/H, obj/item/weapon/implant/external/core_implant/C)
	for(var/mob/living/carbon/human/target in christians)
		if(target == H)
			continue
		if(locate(/obj/item/weapon/implant/external/core_implant/cruciform/priest, target) || prob(20))
			target << "<span class='danger'>[H], faithful cruciform follower, cries for salvation!</span>"
	return TRUE


/datum/ritual/targeted/cruciform/epiphany
	name = "epiphany"
	phrase = "In nomine Patris et Filii et Spiritus sancti \[Target human]"

/datum/ritual/targeted/cruciform/epiphany/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C, list/targets)
	if(targets.len != 1)
		fail(user, C, "Cannot find follower.")
		return FALSE

	var/obj/item/weapon/implant/external/core_implant/cruciform/CI = targets[1]

	if(!CI)
		fail(user, C, "Cruciform not found.")
		return FALSE

	if(!CI.wearer)
		fail(user, C, "Cruciform is not installed.")
		return FALSE

	if(CI.activated || CI.active)
		fail(user, C, "This cruciform already has a soul inside.")
		return FALSE

	if(!CI.can_activate())
		fail(user, C, "Epiphany failed.")
		return FALSE
	else
		CI.activate()

	return TRUE

/datum/ritual/targeted/cruciform/epiphany/is_target_valid(index, obj/item/weapon/implant/external/core_implant/target)
	if(index == 1)
		if(target.wearer && target.wearer && !target.activated && !target.active)
			return TRUE

/datum/ritual/cruciform/banish
	name = "banish"
	phrase = "Et ne inducas nos in tentationem, sed libera nos a malo"


/datum/ritual/targeted/cruciform/resurrection
	name = "resurrection"
	phrase = "Surge stultus fragmen stercore gallus \[Target cloner]"	//WIP

/datum/ritual/targeted/cruciform/resurrection/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C, list/targets)
	if(targets.len != 1)
		fail(user, C, "Cannot find cloner.")
		return FALSE

	var/obj/item/weapon/implant/external/core_implant/cruciform/CI = targets[1]

	if(!CI)
		fail(user, C, "Cloner not found.")
		return FALSE

	if(CI.wearer || !istype(CI.loc, /obj/machinery/neotheology/cloner))
		fail(user, C, "This is not cloner.")
		return FALSE

	var/obj/machinery/neotheology/cloner/pod = CI.loc

	if(pod.cloning)
		fail(user, C, "Cloner is already cloning.")
		return FALSE

	if(pod.stat & NOPOWER)
		fail(user, C, "Cloner not working.")
		return FALSE

	pod.start()
	return TRUE

/datum/ritual/targeted/cruciform/resurrection/is_target_valid(index, obj/item/weapon/implant/external/core_implant/target)
	if(index == 1)
		if(!target.wearer && istype(target.loc, /obj/machinery/neotheology/cloner))
			return TRUE

/datum/ritual/targeted/cruciform/reincarnation
	name = "reincarnation"
	phrase = "Nunc omni stercore corpori inserere \[Target dummy]"		//WIP

/datum/ritual/targeted/cruciform/reincarnation/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C, list/targets)
	if(targets.len != 1)
		fail(user, C, "Cannot find follower.")
		return FALSE

	var/obj/item/weapon/implant/external/core_implant/cruciform/CI = targets[1]

	if(!CI)
		fail(user, C, "Cruciform not found.")
		return FALSE

	if(!CI.wearer)
		fail(user, C, "Cruciform is not installed.")
		return FALSE

	if(!CI.activated)
		fail(user, C, "This cruciform doesn't have soul inside.")
		return FALSE

	if(CI.active)
		fail(user, C, "This cruciform already activated.")
		return FALSE

	if(CI.wearer.stat == DEAD)
		fail(user, C, "Soul cannot move to dead body.")
		return FALSE

	var/datum/mind/MN = CI.data.mind
	if(!istype(MN, /datum/mind))
		fail(user, C, "Soul is lost.")
		return FALSE
	if(MN.active)
		if(CI.data.ckey != ckey(MN.key))
			fail(user, C, "Soul is lost.")
			return FALSE
	if(MN.current && MN.current.stat != DEAD)
		fail(user, C, "Soul is lost.")
		return FALSE

	var/succ = CI.transfer_soul()

	if(!succ)
		fail(user, C, "Soul transfer failed.")
		return FALSE

	return TRUE

/datum/ritual/targeted/cruciform/reincarnation/is_target_valid(index, obj/item/weapon/implant/external/core_implant/target)
	if(index == 1)
		if(target.wearer && target.wearer && target.activated && !target.active)
			return TRUE


/datum/ritual/targeted/cruciform/ejection
	name = "ejection"
	phrase = "Eject cruciform implant from \[Target dead]"		//WIP

/datum/ritual/targeted/cruciform/ejection/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C, list/targets)
	if(targets.len != 1)
		fail(user, C, "Cannot find follower.")
		return FALSE

	var/obj/item/weapon/implant/external/core_implant/cruciform/CI = targets[1]

	if(!CI)
		fail(user, C, "Cruciform not found.")
		return FALSE

	if(!CI.wearer)
		fail(user, C, "Cruciform is not installed.")
		return FALSE

	var/mob/M = CI.wearer

	if(CI.active && M.stat != DEAD)
		fail(user, C, "You can't eject activated cruciform from alive christian.")
		return FALSE

	CI.uninstall()
	return TRUE

/datum/ritual/targeted/cruciform/ejection/is_target_valid(index, obj/item/weapon/implant/external/core_implant/target)
	if(index == 1)
		if(target.wearer && (!target.active || target.wearer.stat == DEAD))
			return TRUE
