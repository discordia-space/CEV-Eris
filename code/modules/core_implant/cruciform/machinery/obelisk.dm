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
	var/damage = 20
	var/max_targets = 5

	var/nt_buff_cd = 3

	var/list/currently_affected = list()
	var/force_active = 0

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
	var/list/affected = range(area_radius, src)
	active = check_for_faithful(affected)
	if(force_active > 0)
		active = TRUE
	force_active--
	update_icon()
	if(!active)
		use_power = IDLE_POWER_USE
		for(var/obj/structure/burrow/burrow in affected)
			if(burrow.obelisk_around == any2ref(src))
				burrow.obelisk_around = null
	else
		use_power = ACTIVE_POWER_USE

		var/to_fire = max_targets
		for(var/A in affected)
			if(isburrow(A))
				var/obj/structure/burrow/burrow = A
				if(!burrow.obelisk_around)
					burrow.obelisk_around = any2ref(src)
			else if(istype(A, /mob/living/carbon/superior_animal))
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
			else if(istype(A, /obj/effect/plant))
				var/obj/effect/plant/shroom = A
				if(shroom.seed.type == /datum/seed/mushroom/maintshroom)
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


/obj/machinery/power/nt_obelisk/on_update_icon()
	icon_state = "nt_obelisk[active?"_on":""]"
