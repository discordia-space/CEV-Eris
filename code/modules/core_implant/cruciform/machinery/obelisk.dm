GLOBAL_LIST_EMPTY(all_obelisk)

/obj/machinery/power/nt_obelisk
	name = "NeoTheology's obelisk"
	desc = "The obelisk."
	icon = 'icons/obj/neotheology_machinery.dmi'
	icon_state = "nt_obelisk"
	//TODO:
	//circuit = /obj/item/electronics/circuitboard/nt_obelisk

	density = TRUE
	anchored = TRUE
	layer = 2.8

	use_power = IDLE_POWER_USE
	idle_power_usage = 30
	active_power_usage = 2500

	var/active = FALSE
	var/area_radius = 7
	var/damage = 45
	var/max_targets = 7

	var/nt_buff_cd = 3

	var/list/currently_affected = list()
	var/force_active = 0

	var/ticks_to_next_process = 3

/obj/machinery/power/nt_obelisk/New()
	..()
	GLOB.all_obelisk |= src

/obj/machinery/power/nt_obelisk/Destroy()
	for(var/i in currently_affected)
		var/mob/living/carbon/human/H = i
		H.stats.removePerk(/datum/perk/active_sanityboost)
	currently_affected = null
	return ..()

/obj/machinery/power/nt_obelisk/attack_hand(mob/user)
	return

/obj/machinery/power/nt_obelisk/Process()
	..()
	if(stat)
		return
	var/list/affected = list()
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if (H.z == src.z && get_dist(src, H) <= area_radius)
			affected.Add(H)
	var/list/currently_copied = currently_affected.Copy()
	for(var/mob/living/carbon/human/H in affected)
		if(H in krabin_linked)
			var/obj/item/device/von_krabin/von_crabbin = locate(/obj/item/device/von_krabin) in GLOB.all_faction_items
			if(von_crabbin)
				currently_affected.Add(H)
				von_crabbin.recalculate_buff(TRUE, H)
				von_crabbin.notify(H)
	currently_copied -= affected
	for(var/mob/living/carbon/human/H in currently_copied)
		if(H in krabin_linked)
			var/obj/item/device/von_krabin/von_crabbin = locate(/obj/item/device/von_krabin) in GLOB.all_faction_items
			if(von_crabbin)
				currently_affected.Remove(H)
				von_crabbin.recalculate_buff(FALSE, H)
				von_crabbin.was_notified -= H


	active = check_for_faithful(affected)

	if(force_active > 0)
		active = TRUE
	force_active--
	update_icon()

	if(!active)
		use_power = IDLE_POWER_USE
	else
		use_power = ACTIVE_POWER_USE

	if(ticks_to_next_process > 0)
		ticks_to_next_process--
		return
	else
		ticks_to_next_process = 3

	for(var/obj/structure/burrow/burrow in GLOB.all_burrows)
		if(get_dist(src, burrow) <= area_radius)
			if(!active)
				if(burrow.obelisk_around == any2ref(src))
					burrow.obelisk_around = null
			else
				if(!burrow.obelisk_around)
					burrow.obelisk_around = any2ref(src)

	var/list/affected_mobs = SSmobs.mob_living_by_zlevel[(get_turf(src)).z]

	var/to_fire = max_targets
	for(var/mob/living/A in affected_mobs)
		if(!(get_dist(src, A) <= area_radius))
			continue
		if(istype(A, /mob/living/carbon/superior_animal))
			var/mob/living/carbon/superior_animal/animal = A
			if(animal.stat != DEAD) //got roach, spider, maybe bear
				animal.take_overall_damage(damage)
				if(animal.stat == DEAD)
					eotp.addObservation(5)
				if(!--to_fire)
					return
		else if(istype(A, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/animal = A
			if(animal.stat != DEAD) //got bear or something
				animal.take_overall_damage(damage)
				if(animal.stat == DEAD)
					eotp.addObservation(1)
				if(!--to_fire)
					return

	if(to_fire)//If there is anything else left, fuck up the plants
		for(var/obj/effect/plant/shroom in GLOB.all_maintshrooms)
			if(shroom.z == src.z && get_dist(src, shroom) <= area_radius)
				qdel(shroom)
				if(!--to_fire)
					return

/obj/machinery/power/nt_obelisk/proc/check_for_faithful(list/affected)
	var/got_neoteo = FALSE
	var/list/no_longer_affected = currently_affected - affected
	for(var/i in no_longer_affected)
		var/mob/living/carbon/human/H = i
		H.stats.removePerk(/datum/perk/active_sanityboost)


	currently_affected -= no_longer_affected
	for(var/mob/living/carbon/human/mob in affected)
		var/obj/item/implant/core_implant/I = mob.get_core_implant(/obj/item/implant/core_implant/cruciform)
		if(!(mob in eotp.scanned))
			eotp.scanned |= mob
			if(I && I.active && I.wearer)
				eotp.addObservation(20)
			else if(mob.mutation_index > 2 && !get_active_mutation(mob, MUTATION_ATHEIST) && !get_active_mutation(mob, MUTATION_GODBLOOD))
				mob.adjustFireLoss(mob.mutation_index)
				eotp.removeObservation(15)
				if(mob.mutation_index > 5)
					mob.adjustFireLoss(mob.mutation_index * 2)
					mob.sanity.changeLevel(-1)
				if(prob(10))
					to_chat(mob, SPAN_WARNING("You feel uncomfortable being around [src]."))
			else if(is_carrion(mob))
				eotp.removeObservation(20)
			else
				eotp.addObservation(10)
		if(I && I.active && I.wearer)
			if(!(mob in currently_affected)) // the mob just entered the range of the obelisk
				mob.stats.addPerk(/datum/perk/active_sanityboost)
				currently_affected += mob
			I.restore_power(I.power_regen*2)
			for(var/r_tag in mob.personal_ritual_cooldowns)
				mob.personal_ritual_cooldowns[r_tag] -= nt_buff_cd

			got_neoteo = TRUE
	return got_neoteo


/obj/machinery/power/nt_obelisk/update_icon()
	icon_state = "nt_obelisk[active?"_on":""]"
