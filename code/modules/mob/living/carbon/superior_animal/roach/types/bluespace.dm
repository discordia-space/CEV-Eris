/mob/living/carbon/superior_animal/roach/bluespace
	name = "Bluespace Roach"
	desc = "A bluespace roach"
	icon_state = "bluespaceroach"
	maxHealth = 25
	health = 25

	melee_damage_lower = 3
	melee_damage_upper = 10
	sanity_damage = 1
	var/change_tele_to_mob = 25
	var/chance_tele_to_eat = 25
	var/chance_tele_to_random = 10

/mob/living/carbon/superior_animal/roach/bluespace/New()
	..()
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 0, loc)
	sparks.start()

/mob/living/carbon/superior_animal/roach/bluespace/Life()
	. = ..()
	if(stat) // if the roach is conscious
		return
	var/turf/target
	if((stance == HOSTILE_STANCE_ATTACK || stance == HOSTILE_STANCE_ATTACKING) && target_mob && !Adjacent(target_mob) && prob(change_tele_to_mob))
		target = get_turf(target_mob)
	else if(eat_target && busy == 1 && eat_target && !Adjacent(eat_target) && prob(chance_tele_to_eat))
		target = get_turf(eat_target)
	else if(stance == HOSTILE_STANCE_IDLE && !busy && prob(chance_tele_to_random))
		target = get_random_secure_turf_in_range(src, 7, 1)
	if(target)
		playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)
		do_teleport(src, target, 1)
		playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)
