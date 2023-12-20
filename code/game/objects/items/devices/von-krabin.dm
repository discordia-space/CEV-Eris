/obj/item/device/von_krabin
	name = "Von-Krabin Stimulator"
	desc = "Psionic stimulator that make your brain work better."
	description_info = "This is a powerful stimulator that links the brain of multiple people together, the more people are connected, the better its buffs are. \n Can be empowered even further by breaking the cruciforms of NT followers."
	description_antag = "Can be destroyed with the NT sword, causes brain damage to everyone that is linked and reduces their base stats by 30, whilst buffing the EOTP's capabilities."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "von-krabin"
	item_state = "von-krabin"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 1
	throw_range = 5
	price_tag = 20000
	volumeClass = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_BIO = 9, TECH_MAGNET = 9, TECH_BLUESPACE = 4)
	spawn_frequency = 0
	spawn_blacklisted = TRUE

	var/active = FALSE
	var/area_radius = 7
	var/list/mob/living/carbon/human/the_hiveminded = list()
	var/list/mob/living/carbon/human/the_broken = list()
	var/list/mob/was_notified = list()

	var/buff_power = 10

	var/list/stats_buff = list(STAT_BIO, STAT_COG, STAT_MEC)
	var/list/acquired_buffs = list()

/obj/item/device/von_krabin/New()
	..()
	GLOB.all_faction_items[src] = GLOB.department_moebius

/obj/item/device/von_krabin/Destroy()
	GLOB.all_faction_items -= src
	GLOB.moebius_faction_item_loss++
	for(var/mob/living/carbon/human/broken_minded in the_broken)
		to_chat(broken_minded, SPAN_NOTICE("Your connection to the faith seems to have been restored to full power."))
		var/obj/item/implant/core_implant/cruciform/C = broken_minded.get_core_implant(/obj/item/implant/core_implant/cruciform)
		C.power_regen *= 2
		C.righteous_life = 50
		C.max_righteous_life = initial(C.max_righteous_life)
		C.power = 100
		if(eotp)
			eotp.power += 10
	the_broken = null
	for(var/mob/living/carbon/human/hive_minded in the_hiveminded)
		to_chat(hive_minded, SPAN_DANGER("Your connection with the [src] is cut off. The knowledge is painfully removed from you!"))
		krabin_linked -= hive_minded
		hive_minded.adjustBrainLoss(25)
		hive_minded.Weaken(5, TRUE)
		for(var/stat in stats_buff)
			hive_minded.stats.removeTempStat(stat, "von-crabbin")
			hive_minded.stats.changeStat(stat, -30)  // hard to adapt back to normality
	the_hiveminded = null
	was_notified = null
	..()

/obj/item/device/von_krabin/nt_sword_handle()
	if(eotp)
		// no more NT link obstructions
		eotp.max_power -= 20 // reduces how much is needed for things to happen
		eotp.armaments_rate += 10
		eotp.max_armaments_points += 50
	for(var/mob/living/carbon/human/hive_minded in the_hiveminded)
		if(eotp)
			eotp.power += 10
			eotp.armaments_rate += 5
			eotp.max_armaments_points += 5

/obj/item/device/von_krabin/attackby(obj/item/I, mob/user, params)
	if(nt_sword_attack(I, user))
		return FALSE
	if(I in GLOB.all_faction_items)
		if(GLOB.all_faction_items[I] == GLOB.department_security)
			if(acquired_buffs.len)
				to_chat(user, "The [src] already has combat knowledge.")
				return FALSE
			user.remove_from_mob(I)
			qdel(I)
			acquired_buffs = list(STAT_ROB, STAT_TGH, STAT_VIG)
			for(var/stat in acquired_buffs)
				stats_buff.Add(stat)
		/* for when we add felinids (if ever) SPCR-2022
		if(GLOB.all_faction_items[I] == GLOB.department_guild)
			if(istype(I,/obj/item/maneki_neko))
				for(var/mob/living/carbon/human/new_felinid in the_hiveminded)
					new_felinid.changeSpecies("felinid")
		*/
	..()

/obj/item/device/von_krabin/attack(mob/living/M, mob/living/user, target_zone)
	if(!ishuman(M) || M.isMonkey())
		return ..()
	if(user.a_intent == I_HELP && !is_neotheology_disciple(M))
		if(M in the_hiveminded)
			user.visible_message(SPAN_NOTICE("[user] begins unlinking [M]'s mind from the [src]"))
			if(do_after(user, 5 SECONDS, M, TRUE))
				user.visible_message(SPAN_NOTICE("[user] unlinks [M] from the [src]"))
				remove_from_the_hivemind(M)
		user.visible_message(SPAN_NOTICE("[user] begins linking [M]'s mind to the [src]"))
		if(do_after(user, 5 SECONDS, M, TRUE))
			user.visible_message(SPAN_NOTICE("[user] links [M] to the [src]"))
			add_to_the_hivemind(M)
	else if(user.a_intent == I_HURT && is_neotheology_disciple(M))
		// no tormenting the SSD or disconnected
		if(!M.client)
			return ..()
		if(M in the_broken)
			// already broken
			return ..()
		// mental tormentation
		user.visible_message(SPAN_DANGER("[user] begins breaking [M]'s link to the Eye of the protector using the [src]"))
		if(do_after(user, 20 SECONDS, M, TRUE))
			user.visible_message(SPAN_DANGER("[user] breaks [M]'s link to the Eye of the protector, reducing their cruciform's capabilities!"))
			the_broken.Add(M)
			M.Weaken(10)
			M.adjustHalLoss(50)
			to_chat(M, "As your link to the Eye of the protector is broken, your soul is exposed, you feel the pain of the blue depths.")
			var/obj/item/implant/core_implant/cruciform/C = M.get_core_implant(/obj/item/implant/core_implant/cruciform)
			C.power_regen *= 0.5
			C.righteous_life = 0
			C.max_righteous_life *= 0.75
			C.power = 0
			if(eotp)
				eotp.power = 0 // reset power

/obj/item/device/von_krabin/proc/add_to_the_hivemind(mob/living/carbon/human/target)
	if(is_neotheology_disciple(target))
		to_chat(target, "Your cruciform prevents a link between the [src] and you to form.")
		return FALSE
	if(target in the_hiveminded)
		return FALSE
	to_chat(target, SPAN_NOTICE("You link yourself with the [src], you feel the knowledge of countless minds flood you!"))
	LAZYADD(the_hiveminded, target)
	LAZYADD(krabin_linked, target)
	recalculate_buffs(FALSE)

/obj/item/device/von_krabin/proc/remove_from_the_hivemind(mob/living/carbon/human/target)
	if(!(target in the_hiveminded))
		return FALSE
	to_chat(target,  SPAN_NOTICE("You unlink yourself from the [src], you feel the valuable knowledge seep away"))
	the_hiveminded -= target
	krabin_linked -= target
	for(var/stat in stats_buff)
		target.stats.removeTempStat(stat, "von-crabbin")
	recalculate_buffs(TRUE)

/obj/item/device/von_krabin/proc/notify(mob/user)
	if(user in was_notified)
		return FALSE
	to_chat(user , SPAN_DANGER("Being near a obelisk reduces your connection with the [src]"))
	LAZYADD(was_notified, user)

/obj/item/device/von_krabin/proc/recalculate_buffs(lost_follower = FALSE)
	buff_power = initial(buff_power) + round(the_hiveminded.len/2) * 5 + the_broken.len * 5 // for every 2 followers, gain 5 more buff, for every broken NT mind add 5 more
	for(var/mob/living/carbon/human/affected in the_hiveminded)
		for(var/stat in stats_buff)
			affected.stats.removeTempStat(stat, "von-crabbin")
			if(stat in acquired_buffs)
				affected.stats.addTempStat(stat, round(buff_power / 2), INFINITY, "von-crabbin")
			else
				affected.stats.addTempStat(stat, buff_power, INFINITY, "von-crabbin")
		if(lost_follower)
			to_chat(affected, SPAN_NOTICE("You feel the knowledge from the [src] lessen as a linked mind is lost!"))
		else
			to_chat(affected, SPAN_NOTICE("You feel the knowledge from the [src] increase as another mind links itself!"))



/obj/item/device/von_krabin/proc/recalculate_buff(near_crystal, mob/living/carbon/human/affected)
	if(!(affected in the_hiveminded))
		for(var/stat in stats_buff)
			affected.stats.removeTempStat(stat, "von-crabbin")
		return FALSE
	if(near_crystal)
		for(var/stat in stats_buff)
			affected.stats.removeTempStat(stat, "von-crabbin")
			if(stat in acquired_buffs)
				affected.stats.addTempStat(stat, round(buff_power / 4), INFINITY, "von-crabbin")
			else
				affected.stats.addTempStat(stat, round(buff_power / 2), INFINITY, "von-crabbin")
	else
		for(var/stat in stats_buff)
			affected.stats.removeTempStat(stat, "von-crabbin")
			if(stat in acquired_buffs)
				affected.stats.addTempStat(stat, round(buff_power / 2), INFINITY, "von-crabbin")
			else
				affected.stats.addTempStat(stat, buff_power, INFINITY, "von-crabbin")
		to_chat(affected, SPAN_DANGER("Leaving the obelisks range strengthens your connection with the [src]"))


/obj/item/device/von_krabin/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/target = user
		if(target in the_hiveminded)
			remove_from_the_hivemind(target)
		else if(!is_neotheology_disciple(target))
			add_to_the_hivemind(target)
