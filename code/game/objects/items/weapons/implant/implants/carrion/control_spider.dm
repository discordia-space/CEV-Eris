/obj/item/weapon/implant/carrion_spider/control
	name = "control spider"
	icon_state = "spiderling_control"
	spider_price = 40
	var/active = FALSE
	var/last_use = - 5 MINUTES
	var/mob/living/captive_brain/host_brain
	var/datum/mind/owner_mind_last
	var/mob/living/wearer_last
	var/list/start_damage = list()

/obj/item/weapon/implant/carrion_spider/control/activate()
	..()
	if(!owner_mob || !owner_mob?.mind)
		return
	if(!wearer)
		to_chat(owner_mob, SPAN_WARNING("[src] doesn't have a host"))
		return
	if(wearer.stat == DEAD)
		to_chat(owner_mob, SPAN_WARNING("[wearer] is dead"))
		return
	if(wearer == owner_mob)
		to_chat(owner_mob, SPAN_DANGER("You feel dumb"))
		return
	if(wearer.has_brain_worms() || is_carrion(wearer))
		to_chat(owner_mob, SPAN_DANGER("A parasite inside this body prevents spider influence."))
		return
	if(last_use + 5 MINUTES > world.time)
		to_chat(owner_mob, SPAN_WARNING("The mind control spider is spent, and needs 5 minutes to regenerate."))
		return
	
	var/datum/mind/owner_mind = owner_mob.mind

	to_chat(owner_mob, SPAN_NOTICE("You assume control of the host."))
	to_chat(wearer, SPAN_DANGER("You feel a strange shifting sensation as another consciousness displaces yours."))

	if(ishuman(wearer)) //Wearer base type is human, so we have to change it back to mob/living
		start_damage = list(wearer.getBruteLoss(), wearer.getOxyLoss(), wearer.getToxLoss(), wearer.getFireLoss())
	else
		var/mob/living/L = wearer
		start_damage = list(L.bruteloss, L.oxyloss, L.toxloss, L.fireloss)
	owner_mind_last = owner_mind
	wearer_last = wearer
	qdel(host_brain)
	host_brain = new(src)
	wearer.mind?.transfer_to(host_brain)
	owner_mind.transfer_to(wearer)
	active = TRUE
	last_use = world.time

	addtimer(CALLBACK(src, .proc/return_mind), 1 MINUTES)

/obj/item/weapon/implant/carrion_spider/control/on_uninstall()
	..()
	return_mind()

/obj/item/weapon/implant/carrion_spider/control/Destroy()
	. = ..()
	return_mind()

/obj/item/weapon/implant/carrion_spider/control/proc/return_mind()
	if(!active)
		return
	active = FALSE
	if(owner_mob)
		if(isghost(owner_mind_last.current))
			to_chat(owner_mind_last.current, SPAN_NOTICE("You are yanked back to your body from beyond the void."))
		owner_mind_last.transfer_to(owner_mob)
	if(wearer_last)
		if(host_brain)
			host_brain.mind?.transfer_to(wearer_last)
			qdel(host_brain)
		if(owner_mob)
			var/mob/living/carbon/human/H = wearer_last
			if(istype(H))
				owner_mob.adjustBruteLoss((H.getBruteLoss() - start_damage[1]) * 2)	//You can heal for the double ammount if you were very nice
				owner_mob.adjustOxyLoss((H.getOxyLoss() - start_damage[2]) * 2)
				owner_mob.adjustToxLoss((H.getToxLoss() - start_damage[3]) * 2)
				owner_mob.adjustFireLoss((H.getFireLoss() - start_damage[4]) * 2)
			else
				owner_mob.adjustBruteLoss((wearer_last.bruteloss - start_damage[1]) * 2)
				owner_mob.adjustOxyLoss((wearer_last.oxyloss - start_damage[2]) * 2)
				owner_mob.adjustToxLoss((wearer_last.toxloss - start_damage[3]) * 2)
				owner_mob.adjustFireLoss((wearer_last.fireloss - start_damage[4]) * 2)
	else
		owner_mob.gib()
