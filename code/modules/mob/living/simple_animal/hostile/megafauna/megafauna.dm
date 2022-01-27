#define69OB_SIZE_LARGE 3
#define LARGE_MOB_LAYER 4.4

/mob/living/simple_animal/hostile/megafauna
	name = "boss of this gym"
	desc = "Attack the weak point for69assive damage."
	health = 1000
	maxHealth = 1000
	a_intent = I_HURT
	environment_smash = ENVIRONMENT_SMASH_WALLS
	light_range = 3
	faction = list("mining", "boss")
	var/atom/target
	minbodytemp = 0
	maxbodytemp = INFINITY
	mob_size =69OB_SIZE_LARGE
	status_flags = 0 //No pushing,69o stunning,69o paralyze and69o weaken.
	layer = LARGE_MOB_LAYER //Looks weird with them slipping under69ineral walls and cameras and shit otherwise
	mouse_opacity =69OUSE_OPACITY_OPAQUE // Easier to click on in69elee, they're giant targets anyway
	var/anger_modifier = 0
	var/recovery_time = 0
	var/chosen_attack = 1 // chosen attack69um
	var/list/attack_action_types = list()
	var/megafauna_min_cooldown = 10
	var/megafauna_max_cooldown = 20
	sanity_damage = 0.5

/mob/living/simple_animal/hostile/megafauna/Initialize(mapload)
	. = ..()
	for(var/action_type in attack_action_types)
		var/datum/action/innate/megafauna_attack/attack_action =69ew action_type()
		attack_action.Grant(src)

/mob/living/simple_animal/hostile/megafauna/proc/prevent_content_explosion()
	return TRUE

/mob/living/simple_animal/hostile/megafauna/death(gibbed,69ar/list/force_grant)
	..()
	qdel(src)

/mob/living/simple_animal/hostile/megafauna/gib()
	qdel(src)

/mob/living/simple_animal/hostile/megafauna/dust(just_ash, drop_items, force)
	qdel(src)

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
		SPAN_DANGER("69src69 devours 69L69!</span>"),
		SPAN_DANGER("You feast on 69L69, restoring your health!"))
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
	if(health <69axHealth/3)
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

/mob/living/simple_animal/hostile/megafauna/proc/spiral_shoot(negative = pick(TRUE, FALSE), rounds = 20)
	set waitfor = 0
	var/turf/start_turf = get_step(src, pick(GLOB.alldirs))
	var/incvar =69egative ? -1 : 1
	var/dirpoint = 1
	var/list/alldirs = GLOB.alldirs.Copy()
	var/firedir = alldirs69dirpoint69
	for(var/i = 0 to rounds)
		shoot_projectile(start_turf, firedir)
		dirpoint += incvar
		if(dirpoint < 1)
			dirpoint = alldirs.len
		else if(dirpoint > alldirs.len)
			dirpoint = 1
		firedir = alldirs69dirpoint69
		sleep(rand(1,3))

/mob/living/simple_animal/hostile/megafauna/proc/shoot_projectile(turf/marker,69ar/dir)
	if(!marker ||69arker == loc)
		return
	var/turf/startloc = get_turf(src)
	var/obj/item/projectile/P =69ew projectiletype(startloc)
	P.firer = src
	if(target)
		P.original = target
	P.launch(get_step(marker, dir))

/mob/living/simple_animal/hostile/megafauna/proc/random_shots()
	ranged_cooldown = world.time + 30
	var/turf/U = get_turf(src)
	for(var/T in RANGE_TURFS(12, U) - U)
		if(prob(6))
			sleep(rand(0,1))
			shoot_projectile(T, pick(GLOB.alldirs))

/mob/living/simple_animal/hostile/megafauna/proc/wave_shots()
	ranged_cooldown = world.time + 30
	var/turf/U = get_turf(src)
	for(var/T in RANGE_TURFS(12, U) - U)
		set_dir(get_dir(T, target_mob))
		if(get_dir(T, U) == get_dir(T, target_mob))
			if(prob(15))
				sleep(rand(0,1))
				shoot_projectile(T)