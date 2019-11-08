/obj/machinery/power/nt_obelisk
	name = "NeoTheology's obelisk"
	desc = "The obelisk."
	icon = 'icons/obj/neotheology_machinery.dmi'
	icon_state = "nt_obelisk"
	//TODO:
	//circuit = /obj/item/weapon/circuitboard/nt_obelisk

	density = TRUE
	anchored = TRUE
	layer = 2.8

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500

	var/active = FALSE
	var/area_radius = 7
	var/damage = 20
	var/max_targets = 5

	var/nt_buff_power = 5
	var/nt_buff_cd = 3

	var/static/stat_buff

/obj/machinery/power/nt_obelisk/New()
	..()

/obj/machinery/attack_hand(mob/user as mob)
	return

/obj/machinery/power/nt_obelisk/Process()
	..()
	if(stat)
		return
	active = check_for_faithful()
	update_icon()
	if(!active)
		use_power = 1
		for(var/obj/structure/burrow/burrow in range(area_radius, src))
			if(burrow.obelisk_around == any2ref(src))
				burrow.obelisk_around = null
	else
		use_power = 2

		for(var/obj/structure/burrow/burrow in range(area_radius, src))
			if(!burrow.obelisk_around)
				burrow.obelisk_around = any2ref(src)

		var/to_fire = max_targets
		for(var/mob/living/carbon/superior_animal/animal in range(area_radius, src))
			if(animal.stat != DEAD) //got roach, spider, maybe bear
				animal.take_overall_damage(damage)
				to_fire--
				if(!to_fire) return
		for(var/mob/living/simple_animal/hostile/animal in range(area_radius, src))
			if(animal.stat != DEAD) //got bear or something
				animal.take_overall_damage(damage)
				to_fire--
				if(!to_fire) return
		for(var/obj/effect/plant/shroom in range(area_radius, src))
			if(shroom.seed.type == /datum/seed/mushroom/maintshroom)
				qdel(shroom)
				to_fire--
				if(!to_fire) return

/obj/machinery/power/nt_obelisk/proc/check_for_faithful()
	var/got_neoteo = FALSE
	for(var/mob/living/carbon/human/mob in range(area_radius, src))
		if(mob)
			var/obj/item/weapon/implant/core_implant/I = mob.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform)
			if(I && I.active && I.wearer)
				if(I.power < I.max_power)	I.power += nt_buff_power
				for(var/r_tag in mob.personal_ritual_cooldowns)
					mob.personal_ritual_cooldowns[r_tag] -= nt_buff_cd

				if(stat_buff)
					var/buff_power = disciples.len
					var/message
					var/prev_stat
					for(var/stat in ALL_STATS)
						var/datum/stat_mod/SM = mob.stats.getTempStat(stat, "nt_obelisk")
						if(stat == stat_buff)
							if(!SM)
								message = "A wave of dizziness washes over you, and your mind is filled with a sudden insight into [stat]."
							else if(SM.value != buff_power) // buff power was changed
								message = "Your knowledge of [stat] feels slightly [SM.value > buff_power ? "lessened" : "broadened"]."
							else if(SM.time < world.time + 10 MINUTES) // less than 10 minutes of buff duration left
								message = "Your knowledge of [stat] feels renewed."
							mob.stats.addTempStat(stat, buff_power, 20 MINUTES, "nt_obelisk")
						else if(SM)
							prev_stat = stat
							mob.stats.removeTempStat(stat, "nt_obelisk")

					if(prev_stat) // buff stat was replaced
						message = "A wave of dizziness washes over you, and your mind is filled with a sudden insight into [stat_buff] as your knowledge of [prev_stat] feels lessened."
					if(message)
						to_chat(mob, SPAN_NOTICE(message))

				got_neoteo = TRUE
	return got_neoteo


/obj/machinery/power/nt_obelisk/update_icon()
	icon_state = "nt_obelisk[active?"_on":""]"
