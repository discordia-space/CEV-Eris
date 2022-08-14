/mob/living/carbon/superior_animal/roach/bluespace
	name = "Unbekannt Roach"
	desc = "This shimmering insectoid-like creature greatly resembles a giant cockroach. It flickers in and out of reality, as if it didn't really belong here."
	icon_state = "bluespaceroach"
	maxHealth = 25
	health = 25
	meat_type = /obj/item/bluespace_crystal
	melee_damage_lower = 4
	melee_damage_upper = 11
	armor_divisor = ARMOR_PEN_MAX // Hits through armor

	sanity_damage = 1
	spawn_blacklisted = TRUE
	var/change_tele_to_mob = 25
	var/chance_tele_to_eat = 25
	var/chance_tele_to_random = 10

	// Armor related variables
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 15,
		bomb = 0,
		bio = 25,
		rad = 50
	)

/mob/living/carbon/superior_animal/roach/bluespace/Initialize(mapload)
	. = ..()
	do_sparks(3, 0, src.loc)

/mob/living/carbon/superior_animal/roach/bluespace/handle_ai()
	if(!..())
		return FALSE

	var/turf/target
	if((stance == HOSTILE_STANCE_ATTACK || stance == HOSTILE_STANCE_ATTACKING) && target_mob && !Adjacent(target_mob) && prob(change_tele_to_mob))
		target = get_turf(target_mob)
	else if(eat_target && busy == 1 && eat_target && !Adjacent(eat_target) && prob(chance_tele_to_eat))
		target = get_turf(eat_target)
	else if(stance == HOSTILE_STANCE_IDLE && !busy && prob(chance_tele_to_random))
		target = get_random_secure_turf_in_range(src, 7, 1)
	if(target)
		playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)
		do_sparks(3, 0, src.loc)
		do_teleport(src, target, 1)
		playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)

/mob/living/carbon/superior_animal/roach/bluespace/attackby(obj/item/W, mob/user, params)
	if(prob(change_tele_to_mob))
		var/source = src
		if(target_mob)
			source = target_mob
		var/turf/T = get_random_secure_turf_in_range(source, 2, 1)
		do_sparks(3, 0, src.loc)
		do_teleport(src, T)
		return FALSE
	. = ..()

/mob/living/carbon/superior_animal/roach/bluespace/attack_hand(mob/living/carbon/M)
	if(M.a_intent != I_HELP && prob(change_tele_to_mob))
		var/source = src
		if(target_mob)
			source = target_mob
		var/turf/T = get_random_secure_turf_in_range(source, 2, 1)
		do_sparks(3, 0, src.loc)
		do_teleport(src, T)
		return FALSE
	. = ..()

/mob/living/carbon/superior_animal/roach/bluespace/bullet_act(obj/item/projectile/P, def_zone)
	if(prob(change_tele_to_mob))
		var/source = src
		if(target_mob)
			source = target_mob
		var/turf/T = get_random_secure_turf_in_range(source, 2, 1)
		do_sparks(3, 0, src.loc)
		do_teleport(src, T)
		return FALSE
	. = ..()

/mob/living/carbon/superior_animal/roach/bluespace/attack_generic(mob/user, damage, attack_message)
	if(!damage || !istype(user))
		return FALSE
	if(prob(change_tele_to_mob))
		var/source = src
		if(target_mob)
			source = target_mob
		var/turf/T = get_random_secure_turf_in_range(source, 2, 1)
		do_sparks(3, 0, src.loc)
		do_teleport(src, T)
		return FALSE
	. = ..()
