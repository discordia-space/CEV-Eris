/mob/living/carbon/superior_animal/roach/bluespace
	name = "Bluespace Roach"
	desc = "A bluespace roach"
	icon_state = "bluespaceroach"
	maxHealth = 25
	health = 25

	melee_damage_lower = 3
	melee_damage_upper = 10

/mob/living/carbon/superior_animal/roach/bluespace/Life()
	. = ..()
	if(stat) // if the roach is conscious
		return
	var/turf/target
	if((stance == HOSTILE_STANCE_ATTACK || stance == HOSTILE_STANCE_ATTACKING) && target_mob && !Adjacent(target_mob) && prob(25))
		target = get_turf(target_mob)
	else if(eat_target && busy == 1 && eat_target && !Adjacent(eat_target) && prob(25))
		target = get_turf(target_mob)
	else if(stance == HOSTILE_STANCE_IDLE && !busy && prob(10))
		target = get_random_secure_turf_in_range(src, 7, 1)
	if(target)
		playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)
		do_teleport(src, target, 1)
		playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)
