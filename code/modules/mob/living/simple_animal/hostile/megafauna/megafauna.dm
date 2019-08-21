/mob/living/simple_animal/hostile/megafauna
	name = "boss of this gym"
	desc = "Attack the weak point for massive damage."
	health = 1000
	maxHealth = 1000
	a_intent = I_HURT
	//sentience_type = SENTIENCE_BOSS
	environment_smash = ENVIRONMENT_SMASH_WALLS
	//mob_biotypes = list(MOB_ORGANIC, MOB_EPIC)
	//obj_damage = 400
	light_range = 3
	faction = list("mining", "boss")
	//weather_immunities = list("lava","ash")
	//movement_type = FLYING
	robust_searching = TRUE
	ranged_ignores_vision = TRUE
	stat_attack = DEAD
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	//damage_coeff = list(BRUTE = 1, BURN = 0.5, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	minbodytemp = 0
	maxbodytemp = INFINITY
	vision_range = 5
	aggro_vision_range = 18
	//move_force = MOVE_FORCE_OVERPOWERING
	//move_resist = MOVE_FORCE_OVERPOWERING
	//pull_force = MOVE_FORCE_OVERPOWERING
	mob_size = MOB_LARGE
	layer = ABOVE_ALL_MOB_LAYER //Looks weird with them slipping under mineral walls and cameras and shit otherwise
	mouse_opacity = MOUSE_OPACITY_OPAQUE // Easier to click on in melee, they're giant targets anyway

	var/list/boss_attack_types = list()
	var/list/boss_attacks = list()

	var/datum/boss_attack/current_attack

	var/recovery_time = 0
	var/nest_range = 10

/mob/living/simple_animal/hostile/megafauna/Initialize(mapload)
	. = ..()
	//apply_status_effect(STATUS_EFFECT_CRUSHERDAMAGETRACKING)
	//add_trait(TRAIT_NO_TELEPORT, MEGAFAUNA_TRAIT)

	for(var/attack_type in boss_attack_types)
		boss_attacks += new attack_type(src)


/*
/mob/living/simple_animal/hostile/megafauna/Moved()
	if(nest && nest.parent && get_dist(nest.parent, src) > nest_range)
		var/turf/closest = get_turf(nest.parent)
		for(var/i = 1 to nest_range)
			closest = get_step(closest, get_dir(closest, src))
		forceMove(closest) // someone teleported out probably and the megafauna kept chasing them
		target = null
		return
	return ..()
*/


/mob/living/simple_animal/hostile/megafauna/proc/pick_boss_attack()
	for(var/a in boss_attacks)
		var/datum/boss_attack/attack = a
		var/list/targets = attack.can_execute()

		if(targets)
			attack.execute(targets)
			break


/mob/living/simple_animal/hostile/megafauna/death(gibbed, var/list/force_grant)
	if(health > 0)
		return
	else
		..()

/mob/living/simple_animal/hostile/megafauna/gib()
	if(health > 0)
		return
	else
		..()

/mob/living/simple_animal/hostile/megafauna/dust(just_ash, drop_items, force)
	if(!force && health > 0)
		return
	else
		..()

/mob/living/simple_animal/hostile/megafauna/AttackingTarget()
	if(current_attack || recovery_time >= world.time)
		return
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(!client && ranged && ranged_cooldown <= world.time)
				OpenFire()

/mob/living/simple_animal/hostile/megafauna/ex_act(severity, target)
	switch (severity)
		if (1)
			adjustBruteLoss(300)

		if (2)
			adjustBruteLoss(150)

		if(3)
			adjustBruteLoss(50)

/mob/living/simple_animal/hostile/megafauna/proc/SetRecoveryTime(buffer_time)
	recovery_time = world.time + buffer_time
	ranged_cooldown = world.time + buffer_time
