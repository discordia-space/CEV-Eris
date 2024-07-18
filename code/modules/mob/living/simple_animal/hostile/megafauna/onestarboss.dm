/* DEAL notes:
If you want to figure out this shitcode and actually add this in for some reason, I will leave this here before I leave. If I won't finish it, here you go:

AttackingTarget() has nothing except OpenFire() cuz otherwise Mech would melee target_mob standing nearby, and I wanted to make a attack-pattern-based mob
Minigun Behaviors: 1 is one target, that means mech can't choose two targets and shoot in completely different directions with its 2 miniguns, trying to get both mobs.

Behavior one was supposed to be like closing scissors, coming together on a target, cutting (get it?) away ways to dodge with bullets.
Behavior two - shoot two completely different targets, locking on with precision.

Effects demand parent code, so ..()

*/
#define OS_BOSS_SHOTGUN		1
#define OS_BOSS_SNIPER		2
#define OS_BOSS_ROCKET		3
#define OS_BOSS_MINIGUN		4
#define OS_BOSS_SPAWN_BOTS	5
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
	var/move_lock = FALSE
	var/first_activation = 0
	var/is_jittery = 0
	var/jitteriness
	var/doing_something = FALSE // mech should not multitask like I do
	var/mobstospawn = list(
		/mob/living/simple_animal/hostile/onestar_custodian/engineer,
		/mob/living/simple_animal/hostile/onestar_custodian,
		/mob/living/simple_animal/hostile/roomba/gun_ba,
		/mob/living/simple_animal/hostile/roomba,
		/mob/living/simple_animal/hostile/roomba/slayer,
		/mob/living/simple_animal/hostile/roomba/boomba,
		/mob/living/carbon/superior_animal/stalker/dual,
		/mob/living/carbon/superior_animal/stalker/,
		)
	var/static/list/move_list = list(OS_BOSS_SHOTGUN, OS_BOSS_SNIPER, OS_BOSS_ROCKET, OS_BOSS_MINIGUN, OS_BOSS_SPAWN_BOTS) // Shotgun, sniper, rockets, you get the drill
	var/action = OS_BOSS_SHOTGUN //action has to be some kind of default before it will be changed at the start of first attack

	health = 1700
	maxHealth = 1700
	break_stuff_probability = 95
	stop_automated_movement = 1
	attacktext = "kicked"

	melee_damage_lower = 10
	melee_damage_upper = 100
	//megafauna_min_cooldown = 30
	//megafauna_max_cooldown = 60
	mob_classification = CLASSIFICATION_SYNTHETIC

	wander = FALSE //No more sleepwalking

/*/particles/mecha_smoke/
	icon = 'icons/effects/smoke.dmi'
	icon_state = list("smoke_1" = 1, "smoke_2" = 1, "smoke_3" = 2)
	width = 100
	height = 200
	count = 1000
	spawning = 3
	lifespan = 1.5 SECONDS
	fade = 1 SECONDS
	velocity = list(0, 0.3, 0)
	position = list(5, 32, 0)
	drift = generator("sphere", 0, 1, NORMAL_RAND)
	friction = 0.2
	gravity = list(0, 0.95)
	grow = 0.05

/mob/living/simple_animal/hostile/megafauna/one_star/Initialize()
	//holder_left = new(src, /particles/mecha_smoke)
	//holder_left.layer = layer+0.001
	var/particles/mecha_smoke/smok = new /particles/mecha_smoke(src)
	. = ..()
	!!!!!!!!!!!!!!FUCKING PAIN IN THE ASS!!!!!!!!!!!!!!!!! WILL SURELY DO LATER - Deal
*/
/mob/living/simple_animal/hostile/megafauna/one_star/Move()
	..()
	if(!isinspace())
		playsound(src, 'sound/mechs/mechstep.ogg', 100)

/mob/living/simple_animal/hostile/megafauna/one_star/Bump(mob/target)

	if(ismob(target))
		var/kick_dir = get_dir(src, target)
		UnarmedAttack(target, rand(50,100)) // DEAL LOOK
		target.throw_at(get_edge_target_turf(target, kick_dir), 3, 1)

/mob/living/simple_animal/hostile/megafauna/one_star/UnarmedAttack(atom/A, proximity)
	attack_sound = pick("sound/weapons/punch1.ogg", "sound/weapons/punch2.ogg", "sound/weapons/punch3.ogg")
	..()



////////////////////////////////////////////////////////////////////////////
///////////////////////////////////MINIGUN//////////////////////////////////
////////////////////////////////////////////////////////////////////////////
/mob/living/simple_animal/hostile/megafauna/one_star/proc/shoot_minigun(target)
	var/def_zone = pick(
		organ_rel_size[BP_HEAD]; BP_HEAD,
		organ_rel_size[BP_CHEST]; BP_CHEST,
		organ_rel_size[BP_GROIN]; BP_GROIN,
		organ_rel_size[BP_L_ARM]; BP_L_ARM,
		organ_rel_size[BP_R_ARM]; BP_R_ARM,
		organ_rel_size[BP_L_LEG]; BP_L_LEG,
		organ_rel_size[BP_R_LEG]; BP_R_LEG,
		)

	set_dir(get_dir(src, target))
	var/obj/item/projectile/P = new /obj/item/projectile/bullet/lrifle(loc)
	P.launch(get_turf(target), def_zone)
	playsound(src, 'sound/weapons/guns/fire/lmg_fire.ogg', 60, 1)


/obj/effect/effect/minigun_aim
	icon = 'icons/effects/alerts.dmi'
	icon_state = "spin"
	//flick("stupid_circle.dmi", src)
	//mouse_opacity = 0
	anchored = TRUE
	alpha = 200
	layer = FLY_LAYER
	unacidable = TRUE

/obj/effect/effect/minigun_aim/New()
	..()
	flick("wind_up", src)

/obj/effect/effect/minigun_aim/proc/StayOn(mob/living/target)
	loc = target.loc
	var/prev_position = get_turf(target)
	var/timer = 50
	var/walk_direction
	while(walk_direction == null && timer != 0)
		sleep(1 SECOND)
		walk_direction = get_dir(prev_position, get_turf(target))
		timer--
	walk(src, walk_direction, target.move_to_delay * 0.8, target.move_to_delay)



///////////////////////////////////////////////////////////////////////////
/////////////////////////CROCKET!!!/////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/megafauna/one_star/proc/shoot_rocket(turf/marker)
	if(!marker || marker == loc)
		return
	var/turf/startloc = get_turf(src)
	var/obj/item/projectile/P = new /obj/item/projectile/bullet/rocket/one_star(startloc)
	playsound(src, 'sound/effects/bang.ogg', 100, 1) // this is a fucking tile fall sound
	P.firer = src
	if(target)
		P.original = target
	P.launch(get_step(marker, get_dir(src, get_turf(marker))))

/obj/item/projectile/bullet/rocket/one_star // this rocket is unchanged from parent, balance it as you want
	name = "one star torpedo"
	icon_state = "rocket"
	//damage_types = list(BRUTE = 80)
	//armor_divisor = 3
	//check_armour = ARMOR_BOMB
	//penetrating = -5
	//recoil = 0
	//can_ricochet = FALSE
	//var/explosion_power = 350
	//var/explosion_falloff = 75
	//sharp = FALSE
	//edge = FALSE
	//matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 3, MATERIAL_PLASMA = 2)

/obj/effect/effect/mech_aiming
	anchored = TRUE
	alpha = 200
	pixel_y = -16
	pixel_x = -16
	layer = FLY_LAYER
	unacidable = TRUE

/obj/effect/effect/mech_aiming/Crossed(obj/item/projectile/bullet/rocket/one_star/rocket)
	if(istype(rocket))
		rocket.detonate(src)
		qdel(src)
		qdel(rocket)
/obj/item/projectile/bullet/rocket/one_star/detonate()
	..()
	if(istype(firer, /mob/living/simple_animal/hostile/megafauna/one_star/))
		var/mob/living/simple_animal/hostile/megafauna/one_star/boss = firer
		boss.doing_something = FALSE
	

/obj/effect/effect/mech_aiming/New()
	..()
	icon = 'icons/effects/alerts64x64.dmi'
	//icon_state = "aiming_flick"
	//flick("mech_aiming", src)
	icon_state = "aiming_flick"
	flick("mech_aiming", src)

////////////////////////////////////////////////////////
/////////////////		SNIPER			////////////////
////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/megafauna/one_star/proc/shoot_sniper(atom/target, def_zone)
	if(istype(target, /mob/living/carbon/human))
		def_zone = pick(
			organ_rel_size[BP_HEAD]; BP_HEAD, // yes head too motherfuckers
			organ_rel_size[BP_CHEST]; BP_CHEST,
			organ_rel_size[BP_GROIN]; BP_GROIN,
			organ_rel_size[BP_L_ARM]; BP_L_ARM,
			organ_rel_size[BP_R_ARM]; BP_R_ARM,
			organ_rel_size[BP_L_LEG]; BP_L_LEG,
			organ_rel_size[BP_R_LEG]; BP_R_LEG,
		)

	//if(QDELETED(target))
	//	return
	set_dir(get_dir(src, target))
	var/obj/item/projectile/P = new /obj/item/projectile/beam/sniper(loc)
	P.launch(target, def_zone)
	playsound(src, 'sound/machines/onestar/boss/obliteration.ogg', 100)

/obj/effect/effect/crosshair
	icon = 'icons/effects/alerts.dmi'
	icon_state = "aiming_crosshair"
	//var/atom/target = null
	anchored = 1
	alpha = 200
	layer = 5
	unacidable = 1

///obj/effect/effect/crosshair/New(var/mob/living/M)

/obj/effect/effect/crosshair/proc/StayOn(mob/living/M)
	loc = M.loc
	anchored = TRUE
	if(M)
		walk_towards(src, M, 1, 1)
	else
		qdel(src)




//////////////////////////////////////////////////////////////
///////////////////////SHOTGUN ATTACK/////////////////////////
//////////////////////////////////////////////////////////////
/mob/living/simple_animal/hostile/megafauna/one_star/proc/shoot_shotgun(atom/target, def_zone)
	if(istype(target, /mob/living/carbon/human))
		def_zone = pick(
			organ_rel_size[BP_HEAD]; BP_HEAD,
			organ_rel_size[BP_CHEST]; BP_CHEST,
			organ_rel_size[BP_GROIN]; BP_GROIN,
			organ_rel_size[BP_L_ARM]; BP_L_ARM,
			organ_rel_size[BP_R_ARM]; BP_R_ARM,
			organ_rel_size[BP_L_LEG]; BP_L_LEG,
			organ_rel_size[BP_R_LEG]; BP_R_LEG,
		)

	//if(QDELETED(target))
	//	return
	set_dir(get_dir(src, target))
	var/pellets = 2
	for(pellets, pellets > 0, pellets--)
		var/obj/item/projectile/P = new /obj/item/projectile/bullet/pellet/shotgun(loc)
		P.launch(target, def_zone)
	playsound(src, "sound/weapons/guns/fire/shotgunp_fire.ogg", 100, 1)


/obj/effect/effect/telegraph/New()
	..()
	icon = 'icons/effects/alerts.dmi'
	icon_state = "telegraph"
	flick("telegraph_flick", src)
	spawn(100) qdel(src)

/obj/effect/effect/telegraph/Crossed(mob/living/simple_animal/hostile/megafauna/one_star/boss)
	if(istype(boss) && boss.target_mob)
		boss.shoot_shotgun(boss.target_mob)
		boss.doing_something = FALSE
		boss.move_lock = FALSE
		qdel(src)


/////////////////////////////////////////////////////////////////////////////
///////////////////////////////THROW IT BACK/////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/mob/living/simple_animal/hostile/megafauna/one_star/proc/anim_shake(atom/target)
	var/init_px = target.pixel_x
	animate(target, pixel_x=init_px + 10*pick(-1, 1), time=1)
	animate(pixel_x=init_px, time=8, easing=BOUNCE_EASING)


/mob/living/simple_animal/hostile/megafauna/one_star/make_jittery(amount)
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

		sleep(100 MILLISECONDS)
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
				if(target_mob in view(30, src)) // Could you really afford distractions now?
					MoveToTarget()
				else
					stance = HOSTILE_STANCE_IDLE
					target_mob = null


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
	make_jittery(500)
	target_mob = null
	playsound(src, "sound/machines/onestar/boss/Boss_Death.ogg", 100) // "YOU THINK YOU CAN KILL ME?"
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
		if(!first_activation)
			first_activation++
			playsound(src, 'sound/machines/onestar/boss/Activation.ogg', 100, 1)
			
	else
		icon_state = initial(icon_state)

/mob/living/simple_animal/hostile/megafauna/one_star/AttackingTarget() // overwriting the thing because mech loves to bite people like roaches do. Erased for the pattern-based combat.
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
	if(!doing_something)
		if(src.stat != DEAD && target_mob)
			if(!move_lock)
				action = pick(move_list)
			switch(action)
				if(OS_BOSS_SHOTGUN)
					var/obj/effect/effect/telegraph/F = new /obj/effect/effect/telegraph(target_mob.loc)
					move_lock = TRUE
					for(F in orange(src, 30))
						if(F in orange(1, src)) // this is fucking stupid, but if you remove this and stand on the hologram it will not be able to kick you for some reason, see Bump()
							for(var/mob/living/targ in orange(1, src))
								if(F.loc == targ.loc)
									qdel(F)
									//targ.gib() // I havent come for a better solution due to laziness and inability to fix.
									targ.Weaken(3)
									//playsound(targ.loc, 'sound/mechs/obliteration.ogg', 100) DEAL LOOK
									var/kick_dir = get_dir(src, targ)
									UnarmedAttack(targ, rand(50,100))
									targ.throw_at(get_edge_target_turf(targ, kick_dir), 3, 1)
									doing_something = FALSE
									LoseTarget()
									move_lock = FALSE
									icon_state = "onestar_boss"
									break
						move_to_delay = 3
						set_glide_size(DELAY2GLIDESIZE(move_to_delay))
						if(stat != DEAD)
							walk_to(src, F.loc, 0, move_to_delay)
				if(OS_BOSS_SNIPER)
					doing_something = TRUE
					var/obj/effect/effect/crosshair/C = new /obj/effect/effect/crosshair(target_mob.loc)
					C.StayOn(target_mob)
					playsound(C.loc, 'sound/weapons/guns/interact/batrifle_cock.ogg', 100, 1)
					spawn(2 SECONDS) 
						shoot_sniper(target_mob)
						qdel(C)
						doing_something = FALSE
					//var/obj/effect/effect/crosshair/C = new /obj/effect/effect/crosshair(target_mob.loc)
					//C.target = target_mob
					//C.StayOn(target_mob)
					//for(C in orange(src, 30))
					//	spawn(20) shoot_sniper()
					//insert sniper roifle sound here boy
				if(OS_BOSS_ROCKET)
					doing_something = TRUE
					var/obj/effect/effect/mech_aiming/S = new /obj/effect/effect/mech_aiming(target_mob.loc)
					playsound(target_mob.loc, 'sound/machines/onestar/boss/rocket_lock.ogg', 50, 1)
					spawn(2 SECONDS)
						shoot_rocket(get_turf(S), src)
						spawn(10) 
							qdel(S)
							doing_something = FALSE

				if(OS_BOSS_MINIGUN)
					var/list/minigun_target
					minigun_target = new/list()
					for(var/mob/living/target in orange(7, src)) // anyone nearby?
						if(target.stat != DEAD && target.faction != "onestar")
							minigun_target.Add(target)
					doing_something = TRUE
					switch(LAZYLEN(minigun_target))
						if(0)
							sleep(500 MILLISECONDS)
							error(SPAN_DANGER("[src] is fucking up, tell c*ders!"))
							doing_something = FALSE
						if(1)
							var/mob/target1 = pick(minigun_target)
							var/obj/effect/effect/minigun_aim/B = new /obj/effect/effect/minigun_aim(target1.loc)
							var/obj/effect/effect/minigun_aim/A = new /obj/effect/effect/minigun_aim(target1.loc)
							var/target_location = get_turf(target1)
							get_cardinal_dir(src, target1)
							switch(get_cardinal_dir(src, target1)) // dont look at me, I did all I could! Reasoning behind this is so aim doesnt spawn in a wall and bumps into a wall if possible.
								if(NORTH)
									step(A, WEST)
									step(B, EAST)
									step(A, WEST)
									step(B, EAST)
									step(A, WEST)
									step(B, EAST)
								if(SOUTH)
									step(A, WEST)
									step(B, EAST)
									step(A, WEST)
									step(B, EAST)
									step(A, WEST)
									step(B, EAST)
								if(EAST)
									step(A, NORTH)
									step(B, SOUTH)
									step(A, NORTH)
									step(B, SOUTH)
									step(A, NORTH)
									step(B, SOUTH)
								if(WEST)
									step(A, NORTH)
									step(B, SOUTH)
									step(A, NORTH)
									step(B, SOUTH)
									step(A, NORTH)
									step(B, SOUTH)
							spawn(80 MILLISECONDS)
								step_towards(A, target_location)
								step_towards(B, target_location)
							spawn(120 MILLISECONDS)
								step_towards(A, target_location)
								step_towards(B, target_location)
							spawn(160 MILLISECONDS)
								step_towards(A, target_location)
								step_towards(B, target_location)
							var/i = 15
							playsound(loc, 'sound/machines/onestar/boss/minigun_windup.ogg', 75)
							sleep(500 MILLISECONDS)
							while(i != 0 && src.stat != DEAD)
								i--
								shoot_minigun(A)
								shoot_minigun(B)
								sleep(500 MILLISECONDS)
							qdel(A)
							qdel(B)
							doing_something = FALSE
						if(2 to 100)
							var/mob/target1 = pick(minigun_target)
							minigun_target -= target1 // target shouldnt be the same
							var/mob/target2 = pick(minigun_target)
							minigun_target -= target2
							var/obj/effect/effect/minigun_aim/B = new /obj/effect/effect/minigun_aim(target2.loc)
							var/obj/effect/effect/minigun_aim/A = new /obj/effect/effect/minigun_aim(target1.loc)
							A.StayOn(target1)
							B.StayOn(target2)
							var/i = 15
							playsound(src.loc, 'sound/machines/onestar/boss/minigun_windup.ogg', 75)
							sleep(500 MILLISECONDS)
							while(i != 0)
								i--
								shoot_minigun(A)
								shoot_minigun(B)
								sleep(100 MILLISECONDS)
							qdel(A)
							qdel(B)
							doing_something = FALSE
				if(OS_BOSS_SPAWN_BOTS)
					//var/allies
					//for(var/mob/goon in orange(7, src))
					//	if(istype(goon, /mob/living/simple_animal/hostile/))
					//		if(goon.faction == "onestar")
					//			allies = TRUE
					//			OpenFire()
					//if(allies == FALSE)
					var/turfs_around = list()
					for(var/turf/T in orange(1, src))
						turfs_around += T
					var/mobs_to_spawn = rand(2, 6)
					while(mobs_to_spawn)
						var/mobchoice = pick(mobstospawn)
						var/mob/living/simple_animal/newmob = new mobchoice(pick(turfs_around))
						var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
						sparks.set_up(3, 0, get_turf(newmob.loc))
						sparks.start()
						mobs_to_spawn--
			if(!move_lock && stat != DEAD) // I fucking hate what I am doing with this code
				target_mob = FindTarget()
						
