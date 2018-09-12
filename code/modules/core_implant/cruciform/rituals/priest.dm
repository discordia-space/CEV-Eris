/datum/ritual/cruciform/priest
	name = "priest"
	phrase = null
	desc = ""
	category = "Priest"

/datum/ritual/targeted/cruciform/priest
	name = "priest targeted"
	phrase = null
	desc = ""
	category = "Priest"


/datum/ritual/cruciform/priest/epiphany
	name = "Epiphany"
	phrase = "In nomine Patris et Filii et Spiritus sancti"
	desc = "Cyberchristianity's principal sacrament is a ritual of baptism and merging with cruciform. A body, relieved of clothes should be placed on NeoTheology corporation's  special altar."

/datum/ritual/cruciform/priest/epiphany/perform(mob/living/carbon/human/user, obj/item/weapon/implant/core_implant/C)
	var/obj/item/weapon/implant/core_implant/cruciform/CI = get_grabbed(user)

	if(!CI)
		fail("There is no cruciform on this one.", user, C)
		return FALSE

	if(!CI.wearer)
		fail("Cruciform is not installed.", user, C)
		return FALSE

	if(CI.activated || CI.active)
		fail("This cruciform already has a soul inside.", user, C)
		return FALSE

	CI.activate()

	CI.wearer << "<span class='info'>Your cruciform vibrates and warms up.</span>"

	if(SSticker.storyteller)	//Call objectives update to check inquisitor objective completion
		SSticker.storyteller.update_objectives()

	return TRUE

/* - This will be used later, when new cult arrive.
/datum/ritual/cruciform/banish
	name = "banish"
	phrase = "Et ne inducas nos in tentationem, sed libera nos a malo"
*/

/datum/ritual/cruciform/priest/resurrection
	name = "Resurrection"
	phrase = "Qui fuit, et crediderunt in me non morietur in aeternum"
	desc = "A ritual of formation of a new body in a speclially designed machine.  Deceased person's cruciform has to be placed on the scanner then a prayer is to be uttered over the apparatus."

/datum/ritual/cruciform/priest/resurrection/perform(mob/living/carbon/human/user, obj/item/weapon/implant/core_implant/C)
	var/list/OBJS = get_front(user)

	var/obj/machinery/neotheology/cloner/pod = locate(/obj/machinery/neotheology/cloner) in OBJS

	if(!pod)
		fail("You fail to find any cloner here.", user, C)
		return FALSE

	if(pod.cloning)
		fail("Cloner is already cloning.", user, C)
		return FALSE

	if(pod.stat & NOPOWER)
		fail("Cloner is off.", user, C)
		return FALSE

	pod.start()
	return TRUE

/datum/ritual/cruciform/priest/reincarnation
	name = "Reincarnation"
	phrase = "Vetus moritur et onus hoc levaverit"
	desc = "A reunion of a spirit with it's new body, ritual of activation of a crucifrom, lying on the body. The process requires NeoTheology's special altar on which a body stripped of clothes is to be placed."

/datum/ritual/cruciform/priest/reincarnation/perform(mob/living/carbon/human/user, obj/item/weapon/implant/core_implant/C)
	var/obj/item/weapon/implant/core_implant/cruciform/CI = get_grabbed(user)

	if(!CI)
		fail("There is no cruciform on this one", user, C)
		return FALSE

	var/datum/core_module/cruciform/cloning/data = CI.get_module(CRUCIFORM_CLONING)

	if(!CI.wearer)
		fail("Cruciform is not installed.", user, C)
		return FALSE

	if(!CI.activated)
		fail("This cruciform doesn't have soul inside.", user, C)
		return FALSE

	if(CI.active)
		fail("This cruciform already activated.", user, C)
		return FALSE

	if(CI.wearer.stat == DEAD)
		fail("Soul cannot move to dead body.", user, C)
		return FALSE

	var/datum/mind/MN = data.mind
	if(!istype(MN, /datum/mind))
		fail("Soul is lost.", user, C)
		return FALSE
	if(MN.active)
		if(data.ckey != ckey(MN.key))
			fail("Soul is lost.", user, C)
			return FALSE
	if(MN.current && MN.current.stat != DEAD)
		fail("Soul is lost.", user, C)
		return FALSE

	var/succ = CI.transfer_soul()

	if(!succ)
		fail("Soul transfer failed.", user, C)
		return FALSE

	return TRUE


/datum/ritual/cruciform/priest/install
	name = "Commitment"
	phrase = "Unde ipse Dominus dabit vobis signum"
	desc = "This litany will command cruciform attach to person, so you can perform Reincarnation or Epiphany. Cruciform must lay near them."

/datum/ritual/cruciform/priest/install/perform(mob/living/carbon/human/user, obj/item/weapon/implant/core_implant/C)
	var/obj/item/weapon/grab/G = locate(/obj/item/weapon/grab) in user
	var/obj/item/weapon/implant/core_implant/cruciform/CI

	if(G && G.affecting && ishuman(G.affecting))
		CI = G.affecting.get_cruciform()
	else
		fail("You must hold patient's hand.", user, C)
		return FALSE

	var/mob/living/H = G.affecting

	if(CI)
		fail("[H] already have a cruciform installed.", user, C)
		return FALSE

	var/list/L = get_front(user)

	CI = locate(/obj/item/weapon/implant/core_implant/cruciform) in L

	if(!CI)
		fail("There is no cruciform on this one", user, C)
		return FALSE

	if(!(H in L))
		fail("Cruciform is too far from [H].", user, C)
		return FALSE

	if(CI.active)
		fail("Cruciform already active.", user, C)
		return FALSE

	if(!H.lying || !locate(/obj/machinery/optable/altar) in L)
		fail("[H] must lie on the altar.", user, C)
		return FALSE

	for(var/obj/item/clothing/CL in H)
		if(H.l_hand == CL || H.r_hand == CL)
			continue
		fail("[H] must be undressed.", user, C)
		return FALSE

	CI.install(H)

	if(CI.wearer != H)
		fail("Commitment failed.", user, C)
		return FALSE

	if(ishuman(H))
		var/mob/living/carbon/human/M = H
		var/obj/item/organ/external/E = M.organs_by_name[BP_CHEST]
		E.take_damage(25)
		M.custom_pain("You feel cruciform rips into your chest!",1)
		M.update_implants()
		M.updatehealth()

	return TRUE


/datum/ritual/cruciform/priest/ejection
	name = "Deprivation"
	phrase = "Et revertatur pulvis in terram suam unde erat et spiritus redeat ad Deum qui dedit illum"
	desc = "This litany will command cruciform to detach from bearer if one bearing it is dead. You will be able to attach this cruciform later, or use it in scaner for Resurrection."

/datum/ritual/cruciform/priest/ejection/perform(mob/living/carbon/human/user, obj/item/weapon/implant/core_implant/C)
	var/obj/item/weapon/implant/core_implant/cruciform/CI = get_grabbed(user)

	if(!CI)
		fail("There is no cruciform on this one", user, C)
		return FALSE

	if(!CI.wearer)
		fail("Cruciform is not installed.", user, C)
		return FALSE

	var/mob/M = CI.wearer

	if(CI.active && M.stat != DEAD)
		fail("You cannot eject active cruciform from alive christian.", user, C)
		return FALSE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/E = H.organs_by_name[BP_CHEST]
		E.take_damage(15)
		H.custom_pain("You feel cruciform rips out of your chest!",1)

	CI.uninstall()
	return TRUE


/datum/ritual/cruciform/priest/unupgrade
	name = "Asacris"
	phrase = "A caelo usque ad centrum"
	desc = "This litany will remove any upgrade from "

/datum/ritual/cruciform/priest/unupgrade/perform(mob/living/carbon/human/user, obj/item/weapon/implant/core_implant/C)
	var/obj/item/weapon/implant/core_implant/cruciform/CI = get_grabbed(user)

	if(!CI)
		fail("There is no cruciform on this one.", user, C)
		return FALSE

	if(!CI.wearer)
		fail("Cruciform is not installed.", user, C)
		return FALSE

	if(!istype(CI.upgrades) || length(CI.upgrades) <= 0)
		fail("here is no upgrades on this one.", user, C)
		return FALSE

	for(var/obj/item/weapon/coreimplant_upgrade/CU in CI.upgrades)
		CU.remove()

	return TRUE

