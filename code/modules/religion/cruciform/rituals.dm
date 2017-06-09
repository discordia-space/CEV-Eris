/datum/ritual/cruciform
	name = "cruciform"
	phrase = null

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


/datum/ritual/cruciform/epiphany
	name = "epiphany"
	phrase = "In nomine Patris et Filii et Spiritus sancti"

/datum/ritual/cruciform/epiphany/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C)
	var/last_dist = 128
	var/obj/item/weapon/implant/external/core_implant/CI = null
	for(var/mob/living/carbon/human/CH in view(world.view, user))
		if(!CH.ckey || !CH.mind)
			continue
		var/obj/item/weapon/implant/external/core_implant/CR = locate(/obj/item/weapon/implant/external/core_implant/cruciform) in CH
		if(CR && CR.wearer == CH && !CR.active && !CR.activated)
			if(get_dist(CH,user) <= last_dist)
				last_dist = get_dist(CH,user)
				CI = CR

	if(!CI)	//No epiphany candidates
		fail(user, C, "Epiphany candidates not found")
		return FALSE

	if(!CI.can_activate())
		return FALSE
	else
		CI.activate()

	return TRUE


/datum/ritual/cruciform/banish
	name = "banish"
	phrase = "Et ne inducas nos in tentationem, sed libera nos a malo"


/datum/ritual/cruciform/resurrection
	name = "resurrection"
	phrase = "Surge stultus fragmen stercore gallus."	//WIP

/datum/ritual/cruciform/resurrection/perform(mob/living/carbon/human/H, obj/item/weapon/implant/external/core_implant/C)
	var/obj/machinery/neotheology/cloner/pod = locate(/obj/machinery/neotheology/cloner) in view(world.view, H)
	if(pod)
		if(!pod.cloning)
			pod.start()
			return TRUE
		else
			fail(H, C, "Cloner already cloning")
	else
		fail(H, C, "Cloner not found.")


/datum/ritual/cruciform/reincarnation
	name = "reincarnation"
	phrase = "Nunc omni stercore corpori inserere"		//WIP

/datum/ritual/cruciform/reincarnation/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C)
	var/last_dist = 128
	var/obj/item/weapon/implant/external/core_implant/CI = null
	for(var/mob/living/carbon/human/CH in view(world.view, user))
		if(CH.ckey || CH.mind)
			continue
		var/obj/item/weapon/implant/external/core_implant/CR = locate(/obj/item/weapon/implant/external/core_implant/cruciform) in CH
		if(CR && CR.wearer == CH && !CR.active && CR.activated)
			if(get_dist(CH,user) <= last_dist)
				last_dist = get_dist(CH,user)
				CI = CR

	if(!CI)	//No candidates
		fail(user, C, "Reincarnation candidates not found")
		return FALSE

	var/datum/mind/MN = CI.data.mind
	if(!istype(MN, /datum/mind))
		fail(user, C, "Soul inteface failure")
		return FALSE
	if(MN.active)
		if(CI.data.ckey != ckey(MN.key))
			fail(user, C, "Soul inteface failure")
			return FALSE
	if(MN.current && MN.current.stat != DEAD)
		fail(user, C, "Soul inteface failure")
		return FALSE

	return CI.transfer_soul()
