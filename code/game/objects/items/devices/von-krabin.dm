/obj/item/device/von_krabin
	name = "Von-Krabin Stimulator"
	desc = "Psionic stimulator that make your brain work better."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "von-krabin"
	item_state = "von-krabin"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 1
	throw_range = 5
	price_tag = 20000
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_BIO = 9, TECH_MAGNET = 9)
	spawn_frequency = 0
	spawn_blacklisted = TRUE

	var/active = FALSE
	var/area_radius = 7

	var/buff_power = 5

	var/stats_buff = list(STAT_BIO, STAT_COG, STAT_MEC)
	var/list/mob/living/carbon/human/currently_affected = list()

/obj/item/von_krabin/New()
	..()
	GLOB.all_faction_items[src] = GLOB.department_moebius

/obj/item/device/von_krabin/Destroy()
	STOP_PROCESSING(SSobj, src)
	check_for_faithful(list())
	for(var/mob/living/carbon/human/H in range(8, src))
		SEND_SIGNAL(H, COMSIG_OBJ_FACTION_ITEM_DESTROY, src)
	GLOB.all_faction_items -= src
	..()

/obj/item/device/von_krabin/attackby(obj/item/I, mob/user, params)
	if(nt_sword_attack(I, user))
		return FALSE
	..()

/obj/item/device/von_krabin/attack_self()
	if(active)
		STOP_PROCESSING(SSobj, src)
		check_for_faithful(list())
	else
		START_PROCESSING(SSobj, src)
	active = !active
	return

/obj/item/device/von_krabin/Process()
	..()
	if(!active)
		return
	var/list/mob/living/carbon/human/affected = range(area_radius, src)
	check_for_faithful(affected)
	update_icon()

/obj/item/device/von_krabin/proc/check_for_faithful(list/affected)
	var/got_follower = FALSE
	var/list/mob/living/carbon/human/no_longer_affected = currently_affected - affected
	currently_affected -= no_longer_affected
	for(var/mob/living/carbon/human/H in no_longer_affected)
		for(var/stat in stats_buff)
			H.stats.removeTempStat(stat, "von_krabin")
			to_chat(H, SPAN_NOTICE("Your knowledge of [stat] slightly decreases once you leave the von krabin's influence."))
	for(var/mob/living/carbon/human/mob in affected)
		if(stats_buff)
			var/message
			for(var/stat in stats_buff)
				var/datum/stat_mod/SM = mob.stats.getTempStat(stat, "von_krabin")
				if(!SM)
					message = "A wave of dizziness washes over you, and your mind is filled with a sudden insight into [stat]."
					mob.stats.addTempStat(stat, buff_power, 20 MINUTES, "von_krabin")
				else if(SM.time < world.time + 10 MINUTES) // less than 10 minutes of buff duration left
					message = "Your knowledge of [stat] feels renewed."
					mob.stats.removeTempStat(stat, "von_krabin")
					mob.stats.addTempStat(stat, buff_power, 20 MINUTES, "von_krabin")
				if(message)
					to_chat(mob, SPAN_NOTICE(message))
		got_follower = TRUE
	currently_affected = affected
	return got_follower
