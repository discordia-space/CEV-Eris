#define OS_BOSS_SHOTGUN		1
#define OS_BOSS_SNIPER		2
#define OS_BOSS_CROCKET		3

/mob/living/simple_animal/hostile/megafauna/one_star
	name = "Type - 0315"
	desc = "Love and concrete."

	faction = "onestar"
	mob_size = MOB_GIGANTIC
	icon = 'icons/mob/64x64.dmi'
	icon_state = "onestar_boss_unpowered"
	icon_living = "onestar_boss_unpowered"
	icon_dead = "onestar_boss_wrecked"
	pixel_x = -16
	default_pixel_x = -16 // this shit is for make_jittery proc
	ranged = TRUE
	var/is_jittery = 0
	var/jitteriness

	//health = 1700
	health = 100 // DEBUG
	maxHealth = 100
	break_stuff_probability = 95
	stop_automated_movement = 1

	melee_damage_lower = 10
	melee_damage_upper = 20
	megafauna_min_cooldown = 30
	megafauna_max_cooldown = 60
	var/combat_state //shotgun, sniper, rockets, you get the drill.
	var/fuckingreal = FALSE

	mob_classification = CLASSIFICATION_SYNTHETIC

	wander = FALSE //No more sleepwalking


/mob/living/simple_animal/hostile/megafauna/one_star/Move()
	..()
	if(!isinspace())
		playsound(src, 'sound/mechs/mechstep.ogg', 100)

	projectiletype = /obj/item/projectile/bullet/srifle/nomuzzle // DEAL LOOK

/mob/living/simple_animal/hostile/megafauna/one_star/Bump(var/mob/target)
	if(ishuman(target))
		var/kick_dir = get_dir(src, target)
		target.throw_at(get_edge_target_turf(target, kick_dir), 3, 1)

///////////////////////////////////////////////////////////////////////////
/////////////////////////CROCKET!!!/////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/megafauna/one_star/proc/shoot_rocket(turf/marker)
	if(!marker || marker == loc)
		return
	var/turf/startloc = get_turf(src)
	var/obj/item/projectile/P = new /obj/item/projectile/bullet/rocket/one_star(startloc)
	playsound(src, 'sound/effects/bang.ogg', 100, 1)
	P.firer = src
	if(target)
		P.original = target
	P.launch(get_step(marker, get_dir(src, get_turf(marker))), x_offset = 0, y_offset = 0, angle_offset = 0, user_recoil = 0)

/obj/item/projectile/bullet/rocket/one_star // this rocket is unchanged, balance it as you want 
	name = "one star torpedo"
	icon_state = "rocket"
	damage_types = list(BRUTE = 80)
	armor_divisor = 3
	check_armour = ARMOR_BOMB
	penetrating = -5
	recoil = 0
	can_ricochet = FALSE
	var/explosion_power = 350
	var/explosion_falloff = 75
	sharp = FALSE
	edge = FALSE
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 3, MATERIAL_PLASMA = 2)

/obj/item/mech_aiming/
	..()
	//mouse_opacity = 0
	anchored = 1
	alpha = 200
	pixel_y = -16
	pixel_x = -16
	layer = 5
	unacidable = 1

/obj/item/mech_aiming/Crossed(O as obj)
	if(istype(O, /obj/item/projectile/bullet/rocket/one_star))
		var/obj/item/projectile/bullet/rocket/one_star/M = O
		M.detonate(src)
		
		qdel(src)
		qdel(M)

///obj/item/mech_aiming/Initialize() // DEAL LOOK
	//src.transform *= 0.8

/obj/item/mech_aiming/New()
	..()
	icon = 'icons/effects/alerts64x64.dmi'
	//icon_state = "aiming_flick"
	//flick("mech_aiming", src)
	icon_state = "aiming_flick"
	flick("mech_aiming", src)

////////////////////////////////////////////////////////

/obj/effect/effect/crosshair
	icon = 'icons/effects/alerts.dmi'
	icon_state = "aiming_crosshair"
	var/atom/target = null
	anchored = 1
	alpha = 200
	layer = 5
	unacidable = 1

/obj/effect/effect/crosshair/New()
	..(loc)
	loc = target.loc
	anchored = TRUE
	//spawn(50) qdel(src)
	while(target)
		loc = target.loc
		//qdel(src)


	
/////////////////////////////////////////////////////////////
///////////////////HOLOGRAM DASH TELEGRAPH///////////////////
//////////////////////////////////////////////////////////////

/obj/effect/effect/telegraph/
	..()
	mouse_opacity = 0

/obj/effect/effect/telegraph/New()
	sleep(10)


/*
New AI 5 year plan:
Initially dormant, activates as a reaction to recieving damage or specific tile (entrance to the boss room) being triggered


Make jump sequience and call related proc "great_leap_forward"
*/

/mob/living/simple_animal/hostile/megafauna/one_star/death()
	..()
	icon = 'icons/effects/alerts.dmi'
	icon_state = "telegraph"
	flick("telegraph_flick", src)

/obj/effect/effect/telegraph/Crossed(BB as mob)
	if(istype(BB, /mob/living/simple_animal/hostile/megafauna/one_star))
		var/mob/living/simple_animal/hostile/megafauna/one_star/boss = BB
		boss.shoot_projectile(boss.target_mob, rand(0,90))
		boss.shoot_projectile(boss.target_mob, rand(0,90))
		boss.shoot_projectile(boss.target_mob, rand(0,90))
		qdel(src)

	
	
	
/////////////////////////////////////////////////////////////////////////////
///////////////////////////////THROW IT BACK/////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
// /mob/living/simple_animal/hostile/hivemind/proc/anim_shake(atom/target)
	//var/init_px = target.pixel_x
//	animate(target, pixel_x=init_px + 10*pick(-1, 1), time=1)
//	animate(pixel_x=init_px, time=8, easing=BOUNCE_EASING)


/mob/living/simple_animal/hostile/megafauna/one_star/make_jittery(var/amount)
	jitteriness = min(1000, jitteriness + amount)	// store what will be new value
													// clamped to max 1000
	if(jitteriness > 100 && !is_jittery)
		spawn(0)
			jittery_process()

/mob/living/simple_animal/hostile/megafauna/one_star/proc/jittery_process()
	is_jittery = 1
	while(jitteriness > 100)
		var/amplitude = min(4, jitteriness / 100)
		pixel_x = default_pixel_x + rand(-amplitude, amplitude)
		pixel_y = default_pixel_y + rand(-amplitude/3, amplitude/3)

		sleep(1)
	//endwhile - reset the pixel offsets to zero
	is_jittery = 0
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y
	////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/megafauna/one_star/Life()
	if(!stasis && !AI_inactive)
		switch(stance)
			if(HOSTILE_STANCE_IDLE)
				target_mob = FindTarget()

			if(HOSTILE_STANCE_ATTACK)
				if(destroy_surroundings)
					DestroySurroundings()
				MoveToTarget()
				

			if(HOSTILE_STANCE_ATTACKING)
				if(destroy_surroundings)
					DestroySurroundings()
				AttackTarget()

/////////////////////////////////////////////////////////////////////
/////////////////////LE EPIC DEATH CUTSCENE//////////////////////////
/////////////////////////////////////////////////////////////////////
/mob/living/simple_animal/hostile/megafauna/one_star/death() // part 1
	..()
	
	stop_automated_movement = 1
	walk(src, 0)
	LoseTarget()
	stance = initial(stance) // he is standing
	icon_state = initial(icon_state)
	target_mob = null
	make_jittery(500)
	playsound(src, "sound/mechs/BOSS/Boss_Death.ogg", 100) // "YOU THINK YOU CAN KILL ME?"
	spawn(60) dying()

/mob/living/simple_animal/hostile/megafauna/one_star/proc/dying() // part 2
	icon_state = icon_dead // he falls with epic sounds
	playsound(src, "sound/effects/Explosion1.ogg", 100, 1) // OHHH FUCK YOU CAN *dead*
	explosion(src, 350, 75, 0)
	stasis = TRUE
	layer = LYING_MOB_LAYER
	density = TRUE
	spawn(10) 
		is_jittery = 0
		jitteriness = 0

/mob/living/simple_animal/hostile/megafauna/one_star/MoveToTarget()
	if(!target_mob || SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob in ListTargets(10))
		OpenFire(target_mob)
// Is this just a complicated fucking D6 throw? All this to get a mob to fucking shoot.
//		if(get_dist(src, target_mob) <= 6)
//			OpenFire(target_mob)
//		else
//				set_glide_size(DELAY2GLIDESIZE(move_to_delay))
//				walk_to(src, target_mob, 1, move_to_delay)
//			if(ranged)
//				if(prob(rand(15,25)))
//					stance = HOSTILE_STANCE_ATTACKING
//					set_glide_size(DELAY2GLIDESIZE(move_to_delay))
//					walk_to(src, target_mob, 1, move_to_delay)
//				else
//					OpenFire(target_mob)
//			else
//				if(prob(45))
//					stance = HOSTILE_STANCE_ATTACKING
//					set_glide_size(DELAY2GLIDESIZE(move_to_delay))
//					walk_to(src, target_mob, 1, move_to_delay)
//				else
//					OpenFire(target_mob)
//		else
//			stance = HOSTILE_STANCE_ATTACKING
//			set_glide_size(DELAY2GLIDESIZE(move_to_delay))
//			walk_to(src, target_mob, 1, move_to_delay)
//	return 0

/mob/living/simple_animal/hostile/megafauna/one_star/LoseTarget()
	..()
	icon_state = initial(icon_state)

/mob/living/simple_animal/hostile/megafauna/one_star/LostTarget()
	..()
	icon_state = initial(icon_state)

/mob/living/simple_animal/hostile/megafauna/one_star/FindTarget()
	vision_range = 10
	if(health < maxHealth) // if some cheesy boy decides to cheese it with a sniper rifle
		vision_range = 30
	. = ..()
	if(.)
		icon_state = "onestar_boss"
	else
		icon_state = initial(icon_state)

/mob/living/simple_animal/hostile/megafauna/one_star/AttackingTarget()
	OpenFire()
//	if(!Adjacent(target_mob))
	//	return
	//if(isliving(target_mob))
//		var/mob/living/L = target_mob
	//	L.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
	//	return L
	//if(istype(target_mob, /mob/living/exosuit))
	//	var/mob/living/exosuit/M = target_mob
	//	M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
	//	return M
//	if(istype(target_mob,/obj/machinery/bot))
	//	var/obj/machinery/bot/B = target_mob
//		B.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
//		return B


/mob/living/simple_animal/hostile/megafauna/one_star/OpenFire()
	if(src.stat != DEAD)
		visible_message("\red <b>[src]</b> IS NOT FUCKING STUPID!", 1) // DEAL LOOK
		combat_state = OS_BOSS_SHOTGUN
		switch(combat_state)
			if(OS_BOSS_SHOTGUN)
				var/obj/effect/effect/telegraph/F = new /obj/effect/effect/telegraph(target_mob.loc)
				for(F in orange(src, 10))
					visible_message("\red <b>[src]</b> THIS WORKS!!!", 1) // DEAL LOOK
					move_to_delay = 3
					set_glide_size(DELAY2GLIDESIZE(move_to_delay))
					walk_to(src, F.loc, 0, move_to_delay)
					playsound(src.loc, 'sound/mechs/mechstep.ogg', 100)
				if(F in orange(1, src)) // this is fucking stupid, but if you remove this and stand on the hologram it will not be able to kick you for some reason, see Bump()
					step(src, get_dir(src, F), move_to_delay)
					step_to(src, get_dir(src, F), move_to_delay)
			if(OS_BOSS_SNIPER)
				var/obj/effect/effect/crosshair/C = new /obj/effect/effect/crosshair(target_mob.loc)
				C.target = target_mob
				//insert sniper roifle sound here boy
				visible_message("\red <b>[src]</b>SNIPING IS A GOOD JOB MATE", 1) // DEAL LOOK
			if(OS_BOSS_CROCKET)
				visible_message("\red <b>[src]</b> ROCKET ATTACK", 1) // DEAL LOOK
				var/obj/item/mech_aiming/S = new /obj/item/mech_aiming(target_mob.loc)
				spawn(20) 
					shoot_rocket(get_turf(S))
					spawn(5) qdel(S)
	//		if(OS_BOSS_MELEE)
//			if(OS_BOSS_)
		//	if(OS_BOSS_)
	//			return
