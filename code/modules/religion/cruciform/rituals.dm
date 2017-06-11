var/list/cruciform_rituals = typesof(/datum/ritual/cruciform)-/datum/ritual/cruciform

/datum/ritual/cruciform
	name = "cruciform"
	phrase = null

/datum/ritual/cruciform/relief
	name = "relief"
	phrase = "Et si ambulavero in medio umbrae mortis non timebo mala"
	desc = "Short litany to relieve a pain of afflicted."
	power = 50
	chance = 33

/datum/ritual/cruciform/relief/perform(mob/living/carbon/human/H, obj/item/weapon/implant/external/core_implant/C)
	H.add_chemical_effect(CE_PAINKILLER, 10)


/datum/ritual/cruciform/soul_hunger
	name = "soul hunger"
	phrase = "Panem nostrum cotidianum da nobis hodie"
	desc = "Litany of piligrims, helps better withstand hunger."
	power = 50
	chance = 33

/datum/ritual/cruciform/soul_hunger/perform(mob/living/carbon/human/H, obj/item/weapon/implant/external/core_implant/C)
	H.nutrition += 100
	H.adjustToxLoss(5)


/datum/ritual/cruciform/entreaty
	name = "entreaty"
	phrase = "Deus meus ut quid dereliquisti me"
	desc = "Litany of piligrims, helps better withstand hunger."
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
	desc = "Cyberchristianity's principal sacrament is a ritual of baptism and merging with cruciform. A body, relieved of clothes should be placed on NeoTheology corporation's  special altar."


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
		fail(user, C, "There's no souls for epiphany here.")
		return FALSE

	if(!CI.can_activate())
		return FALSE
	else
		CI.activate()

	return TRUE

/* - This will be used later, when new cult arrive.
/datum/ritual/cruciform/banish
	name = "banish"
	phrase = "Et ne inducas nos in tentationem, sed libera nos a malo"
*/

/datum/ritual/cruciform/resurrection
	name = "resurrection"
	phrase = "Target human fuit, et crediderunt in me non morietur in aeternum"
	desc = "A ritual of formation of a new body in a speclially designed machine.  Deceased person's cruciform has to be placed on the scanner then a prayer is to be uttered over the apparatus."

/datum/ritual/cruciform/resurrection/perform(mob/living/carbon/human/H, obj/item/weapon/implant/external/core_implant/C)
	var/obj/machinery/neotheology/cloner/pod = null
	var/last_dist = 128
	for(var/obj/machinery/neotheology/cloner/CL in view(world.view, C.wearer))
		if(!CL.cloning)
			if(get_dist(CL,C.wearer) <= last_dist)
				last_dist = get_dist(CL,C.wearer)
				pod = CL
	if(pod)
		pod.start()
		return TRUE
	else
		fail(H, C, "There are no pods ready for resurrection.")


/datum/ritual/cruciform/reincarnation
	name = "reincarnation"
	phrase = "Vas autem Target human senex moritur, et onus hoc levaverit"
	desc = "A reunion of a spirit with it's new body, ritual of activation of a crucifrom, lying on the body. The process requires NeoTheology's special altar on which a body stripped of clothes is to be placed."


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
		fail(user, C, "There's no souls for reincarnation here.")
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

	return CI.transfer_soul()
