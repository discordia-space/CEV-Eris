#define MOB_SIZE_LARGE 3
#define LARGE_MOB_LAYER 4.4

/mob/living/simple_animal/hostile/megafauna
	name = "boss of this gym"
	desc = "Attack the weak point for massive damage."
	health = 1000
	maxHealth = 1000
	a_intent = I_HURT
	environment_smash = ENVIRONMENT_SMASH_WALLS
	light_range = 3
	faction = list("mining", "boss")
	var/robust_searching = TRUE //By default, mobs have a simple searching method, set this to 1 for the more scrutinous searching (stat_attack, stat_exclusive, etc), should be disabled on most mobs
	var/stat_attack = DEAD
	var/atom/target
	//atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = INFINITY
	mob_size = MOB_SIZE_LARGE
	layer = LARGE_MOB_LAYER //Looks weird with them slipping under mineral walls and cameras and shit otherwise
	mouse_opacity = MOUSE_OPACITY_OPAQUE // Easier to click on in melee, they're giant targets anyway
	var/list/crusher_loot
	var/elimination = 0
	var/anger_modifier = 0
	var/recovery_time = 0
	var/true_spawn = TRUE // if this is a megafauna that should grant achievements, or have a gps signal
	var/nest_range = 10
	var/chosen_attack = 1 // chosen attack num
	var/list/attack_action_types = list()
	var/small_sprite_type
	var/megafauna_min_cooldown = 10
	var/megafauna_max_cooldown = 20

/mob/living/simple_animal/hostile/megafauna/Initialize(mapload)
	. = ..()
	//apply_status_effect(STATUS_EFFECT_CRUSHERDAMAGETRACKING)
	ADD_TRAIT(src, TRAIT_NO_TELEPORT, MEGAFAUNA_TRAIT)
	for(var/action_type in attack_action_types)
		var/datum/action/innate/megafauna_attack/attack_action = new action_type()
		attack_action.Grant(src)
	//if(small_sprite_type)
	//	var/datum/action/small_sprite/small_action = new small_sprite_type()
	//	small_action.Grant(src)

/mob/living/simple_animal/hostile/megafauna/Move()
	if(nest && nest.parent && get_dist(nest.parent, src) > nest_range)
		var/turf/closest = get_turf(nest.parent)
		for(var/i = 1 to nest_range)
			closest = get_step(closest, get_dir(closest, src))
		forceMove(closest) // someone teleported out probably and the megafauna kept chasing them
		target = null
		return
	return ..()

/mob/living/simple_animal/hostile/megafauna/proc/prevent_content_explosion()
	return TRUE

/mob/living/simple_animal/hostile/megafauna/death(gibbed, var/list/force_grant)
	if(health > 0)
		return
	else
		//var/datum/status_effect/crusher_damage/C = has_status_effect(STATUS_EFFECT_CRUSHERDAMAGETRACKING)
		//var/crusher_kill = FALSE
		//if(C && crusher_loot && C.total_damage >= maxHealth * 0.6)
		//spawn_crusher_loot()
		//  crusher_kill = TRUE
		..()

//mob/living/simple_animal/hostile/megafauna/proc/spawn_crusher_loot()
//	loot = crusher_loot

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
	if(recovery_time >= world.time)
		return
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(!client && ranged && ranged_cooldown <= world.time)
				OpenFire()
		else
			devour(L)

/mob/living/simple_animal/hostile/megafauna/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	visible_message(
		"<span class='danger'>[src] devours [L]!</span>",
		"<span class='userdanger'>You feast on [L], restoring your health!</span>")
	if(client)
		adjustBruteLoss(-L.maxHealth/2)
	L.gib()
	return TRUE

/mob/living/simple_animal/hostile/megafauna/ex_act(severity, target)
	switch (severity)
		if (1)
			adjustBruteLoss(250)

		if (2)
			adjustBruteLoss(100)

		if(3)
			adjustBruteLoss(50)

/mob/living/simple_animal/hostile/megafauna/proc/SetRecoveryTime(buffer_time)
	recovery_time = world.time + buffer_time
	ranged_cooldown = world.time + buffer_time

/datum/action/innate/megafauna_attack
	name = "Megafauna Attack"
	//icon_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = ""
	var/mob/living/simple_animal/hostile/megafauna/M
	var/chosen_message
	var/chosen_attack_num = 0

/datum/action/innate/megafauna_attack/Grant(mob/living/L)
	if(istype(L, /mob/living/simple_animal/hostile/megafauna))
		M = L
		return ..()
	return FALSE

/datum/action/innate/megafauna_attack/Activate()
	M.chosen_attack = chosen_attack_num
	to_chat(M, chosen_message)


/mob/living/simple_animal/hostile/megafauna/proc/select_spiral_attack()
	if(health < maxHealth/3)
		return double_spiral()
	return spiral_shoot()

/mob/living/simple_animal/hostile/megafauna/proc/double_spiral()
	INVOKE_ASYNC(src, .proc/spiral_shoot, FALSE)
	INVOKE_ASYNC(src, .proc/spiral_shoot, TRUE)

/mob/living/simple_animal/hostile/megafauna/proc/telegraph()
	for(var/mob/M in range(10,src))
		if(M.client)
			shake_camera(M, 4, 3)
	visible_message(SPAN_DANGER(pick("Prepare to die!", "JUSTICE", "Run!")))
	sleep(rand(megafauna_min_cooldown, megafauna_max_cooldown))


/mob/living/simple_animal/hostile/megafauna/proc/spiral_shoot(negative = pick(TRUE, FALSE), counter_start = 8)
	var/turf/start_turf = get_step(src, pick(GLOB.alldirs))
	var/counter = counter_start
	for(var/i in 1 to 80)
		if(prob(35))
			sleep(rand(1,3))
		if(negative)
			counter--
		else
			counter++
		if(counter > 16)
			counter = 1
		if(counter < 1)
			counter = 16
		shoot_projectile(start_turf, counter * 22.5)

/mob/living/simple_animal/hostile/megafauna/proc/shoot_projectile(turf/marker, set_angle)
	if(!isnum(set_angle) && (!marker || marker == loc))
		return
	var/turf/startloc = get_turf(src)
	var/obj/item/projectile/P = new /obj/item/projectile/beam/heavylaser(startloc)
	P.firer = src
	if(target)
		P.original = target
	P.launch( get_step(marker, pick(SOUTH, NORTH, WEST, EAST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)) )

/mob/living/simple_animal/hostile/megafauna/proc/random_shots()
	ranged_cooldown = world.time + 30
	var/turf/U = get_turf(src)
	for(var/T in RANGE_TURFS(12, U) - U)
		if(prob(6))
			sleep(rand(0,1))
			shoot_projectile(T)

/mob/living/simple_animal/hostile/megafauna/proc/wave_shots()
	ranged_cooldown = world.time + 30
	var/turf/U = get_turf(src)
	for(var/T in RANGE_TURFS(12, U) - U)
		dir = get_dir(T, target_mob)
		if(get_dir(T, U) == get_dir(T, target_mob))
			if(prob(15))
				sleep(rand(0,1))
				shoot_projectile(T)