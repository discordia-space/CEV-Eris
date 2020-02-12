#define MUZZLE_EFFECT_PIXEL_INCREMENT 16	//How many pixels to move the muzzle flash up so your character doesn't look like they're shitting out lasers.

/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = TRUE
	unacidable = TRUE
	anchored = TRUE				//There's a reason this is here, Mport. God fucking damn it -Agouri. Find&Fix by Pete. The reason this is here is to stop the curving of emitter shots.
	pass_flags = PASSTABLE
	mouse_opacity = 0
	animate_movement = 0	//Use SLIDE_STEPS in conjunction with legacy
	var/projectile_type = /obj/item/projectile

	var/list/mob_hit_sound = list('sound/effects/gore/bullethit2.ogg', 'sound/effects/gore/bullethit3.ogg') //Sound it makes when it hits a mob. It's a list so you can put multiple hit sounds there.
	var/hitsound_wall = "ricochet"
	var/proj_color //If defined, is used to change the muzzle, tracer, and impact icon colors through Blend()
	var/def_zone = ""	//Aiming at
	var/mob/firer = null//Who shot it
	var/silenced = FALSE	//Attack message
	var/bumped

	var/shot_from = "" // name of the object which shot us

	var/accuracy = 0
	var/dispersion = 0.0

	//used for shooting at blank range, you shouldn't be able to miss
	var/can_miss = 0

	var/taser_effect = 0 //If set then the projectile will apply it's agony damage using stun_effect_act() to mobs it hits, and other damage will be ignored

	//Effects
	var/damage = 10
	var/damage_type = BRUTE		//BRUTE, BURN, TOX, OXY, CLONE, HALLOSS are the only things that should be in here
	var/nodamage = FALSE		//Determines if the projectile will skip any damage inflictions
	var/check_armour = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb	//Cael - bio and rad are also valid

	var/stun = 0
	var/weaken = 0
	var/paralyze = 0
	var/irradiate = 0
	var/stutter = 0
	var/eyeblur = 0
	var/drowsy = 0
	var/agony = 0
	var/knockback = 0

	var/incinerate = 0
	var/embed = 0 // whether or not the projectile can embed itself in the mob
	var/shrapnel_type //type of shrapnel the projectile leaves in its target.

	var/p_x = 16
	var/p_y = 16 // the pixel location of the tile that the player clicked. Default is the center

	var/can_ricochet = FALSE // defines if projectile can or cannot ricochet.
	var/ricochet_id = 0 // if the projectile ricochets, it gets its unique id in order to process iteractions with adjacent walls correctly.

	//Movement parameters
	var/speed = 0.2			//Amount of deciseconds it takes for projectile to travel
	var/pixel_speed = 33	//pixels per move - DO NOT FUCK WITH THIS UNLESS YOU ABSOLUTELY KNOW WHAT YOU ARE DOING OR UNEXPECTED THINGS /WILL/ HAPPEN!
	var/Angle = 0
	var/original_angle = 0		//Angle at firing
	var/nondirectional_sprite = FALSE //Set TRUE to prevent projectiles from having their sprites rotated based on firing angle
	var/yo = null
	var/xo = null
	var/atom/original			// the target clicked (not necessarily where the projectile is headed). Should probably be renamed to 'target' or something.
	var/turf/starting			// the projectile's starting turf
	var/list/permutated			// we've passed through these atoms, don't try to hit them again
	var/penetrating = 0			//If greater than zero, the projectile will pass through dense objects as specified by on_penetrate()
	var/penetration_modifier = 0.2 //How much internal damage this projectile can deal, as a multiplier.
	var/forcedodge = FALSE		//to pass through everything
	var/ignore_source_check = FALSE

	//Fired processing vars
	var/fired = FALSE	//Have we been fired yet
	var/paused = FALSE	//for suspending the projectile midair
	var/last_projectile_move = 0
	var/last_process = 0
	var/time_offset = 0
	var/datum/point/vector/trajectory
	var/trajectory_ignore_forcemove = FALSE	//instructs forceMove to NOT reset our trajectory to the new location!
	var/range = 50 //This will de-increment every step. When 0, it will deletze the projectile.
	var/aoe = 0 //For KAs, really

	//Hitscan
	var/hitscan = FALSE		//Whether this is hitscan. If it is, speed is basically ignored.
	var/list/beam_segments	//assoc list of datum/point or datum/point/vector, start = end. Used for hitscan effect generation.
	var/datum/point/beam_index
	var/turf/hitscan_last	//last turf touched during hitscanning.
	var/tracer_type
	var/muzzle_type
	var/impact_type
	var/hit_effect
	var/matrix/effect_transform			// matrix to rotate and scale projectile effects - putting it here so it doesn't
										//  have to be recreated multiple times

/obj/item/projectile/CanPass()
	return TRUE

//TODO: make it so this is called more reliably, instead of sometimes by bullet_act() and sometimes not
/obj/item/projectile/proc/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(blocked >= 100)	//Full block
		return FALSE
	if(!isliving(target))
		return FALSE
	if(isanimal(target))
		return FALSE
	var/mob/living/L = target
	if(damage && damage_type == BRUTE)
		var/turf/target_loca = get_turf(target)
		var/splatter_dir = dir
		if(starting)
			splatter_dir = get_dir(starting, target_loca)
			target_loca = get_step(target_loca, splatter_dir)
		if(isalien(L))
			new /obj/effect/overlay/temp/dir_setting/bloodsplatter/xenosplatter(target_loca, splatter_dir)
		else
			var/blood_color = "#C80000"
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				blood_color = H.species.blood_color
			new /obj/effect/overlay/temp/dir_setting/bloodsplatter(target_loca, splatter_dir, blood_color)
		if(prob(50))
			target_loca.add_blood(L)

	L.apply_effects(stun, weaken, paralyze, 0, stutter, eyeblur, drowsy, agony, incinerate, blocked)
	L.apply_effect(irradiate, IRRADIATE, L.getarmor(null, "rad")) //radiation protection is handled separately from other armour types.
	return 1

//called when the projectile stops flying because it collided with something
/obj/item/projectile/proc/on_impact(var/atom/A)
	return

//Checks if the projectile is eligible for embedding. Not that it necessarily will.
/obj/item/projectile/proc/can_embed()
	//embed must be enabled and damage type must be brute
	if(!embed || damage_type != BRUTE)
		return FALSE
	return TRUE

/obj/item/projectile/proc/get_structure_damage()
	if(damage_type == BRUTE || damage_type == BURN)
		return damage
	return FALSE

//return TRUE if the projectile should be allowed to pass through after all, FALSE if not.
/obj/item/projectile/proc/check_penetrate(atom/A)
	return TRUE


//sets the click point of the projectile using mouse input params
/obj/item/projectile/proc/set_clickpoint(params)
	var/list/mouse_control = params2list(params)
	if(mouse_control["icon-x"])
		p_x = text2num(mouse_control["icon-x"])
	if(mouse_control["icon-y"])
		p_y = text2num(mouse_control["icon-y"])


/obj/item/projectile/proc/launch(atom/target, target_zone, mob/user, params, angle_override, forced_spread = 0)
	original = target
	def_zone = check_zone(target_zone)
	firer = user
	var/direct_target
	if(get_turf(target) == get_turf(src))
		direct_target = target

	preparePixelProjectile(target, user? user : get_turf(src), params, forced_spread)
	return fire(angle_override, direct_target)

//called to launch a projectile from a gun
/obj/item/projectile/proc/launch_from_gun(atom/target, target_zone, mob/user, params, angle_override, forced_spread, var/obj/item/weapon/gun/launcher)

	shot_from = launcher.name
	silenced = launcher.silenced

	return launch(target, target_zone, user, params, angle_override, forced_spread)


//Used to change the direction of the projectile in flight.
/obj/item/projectile/proc/redirect(new_x, new_y, atom/starting_loc, mob/new_firer=null)
	var/turf/new_target = locate(new_x, new_y, src.z)

	original = new_target
	if(new_firer)
		firer = src

	preparePixelProjectile(starting_loc, new_target)

/obj/item/projectile/proc/istargetloc(mob/living/target_mob)
	if(target_mob && original)
		var/turf/originalloc
		if(!istype(original, /turf))
			originalloc = original.loc
		else
			originalloc = original
		if(originalloc == target_mob.loc)
			return 1
		else
			return 0
	else
		return 0


//Called when the projectile intercepts a mob. Returns 1 if the projectile hit the mob, 0 if it missed and should keep flying.
/obj/item/projectile/proc/attack_mob(mob/living/target_mob, distance, miss_modifier=0)
	if(!istype(target_mob))
		return

	//roll to-hit
	miss_modifier = 0
	var/hit_zone = check_zone(def_zone)

	var/result = PROJECTILE_FORCE_MISS
	if(hit_zone)
		def_zone = hit_zone //set def_zone, so if the projectile ends up hitting someone else later (to be implemented), it is more likely to hit the same part
		if(def_zone)
			switch(target_mob.dir)
				if(2)
					if(p_y <= 10) //legs level
						if(p_x  >= 17)
							if(def_zone == BP_L_LEG || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_L_ARM \
							|| def_zone == BP_CHEST)
								def_zone = BP_L_LEG
							if(def_zone == BP_HEAD || def_zone == BP_R_ARM)
								def_zone = BP_CHEST
							//lleg
						else
							if(def_zone == BP_L_LEG || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST)
								def_zone = BP_R_LEG
							if(def_zone == BP_HEAD || def_zone == BP_L_ARM)
								def_zone = BP_CHEST
							//rleg
						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_L_LEG, BP_R_LEG)

					if(p_y > 10 && p_y <= 13) //groin level
						if(p_x <= 12)
							if(def_zone == BP_L_ARM || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_HEAD)
								def_zone = BP_R_ARM
							if(def_zone == BP_HEAD || def_zone == BP_L_LEG)
								def_zone = BP_CHEST
							//rarm
						if(p_x > 12 && p_x < 21)
							if(def_zone == BP_L_ARM || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_L_LEG)
								def_zone = BP_GROIN
							if(def_zone == BP_HEAD)
								def_zone = BP_CHEST
							//groin
						if(p_x >= 21 && p_x < 24)
							//larm
							if(def_zone == BP_L_ARM || def_zone == BP_L_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_HEAD)
								def_zone = BP_L_ARM
							if(def_zone == BP_HEAD || def_zone == BP_R_LEG)
								def_zone = BP_CHEST

						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_ARM, BP_L_ARM, BP_CHEST, BP_GROIN)

					if(p_y > 13 && p_y <= 22)
						if(p_x <= 12)
							if(def_zone == BP_L_ARM || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_HEAD)
								def_zone = BP_R_ARM
							if(def_zone == BP_HEAD || def_zone == BP_L_LEG)
								def_zone = BP_CHEST
							//rarm
						if(p_x > 12 && p_x < 21)
							if(def_zone == BP_L_ARM || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_L_LEG \
							|| def_zone == BP_HEAD)
								def_zone = BP_CHEST
							//chest

						if(p_x >= 21 && p_x < 24)
							if(def_zone == BP_L_ARM || def_zone == BP_HEAD\
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_L_LEG)
								def_zone = BP_L_ARM
							//larm
							if(def_zone == BP_HEAD || def_zone == BP_R_LEG)
								def_zone = BP_CHEST

						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_ARM, BP_L_ARM, BP_CHEST)

					if(p_y > 22 && p_y <= 32)
						if(def_zone == BP_L_ARM \
						|| def_zone == BP_R_ARM \
						|| def_zone == BP_CHEST)
							def_zone = BP_HEAD
						//head
						if(def_zone == BP_GROIN || def_zone == BP_R_LEG || \
						def_zone == BP_L_LEG)
							def_zone = BP_CHEST

						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_HEAD, BP_CHEST)
				if(1)
					if(p_y <= 10) //legs level
						if(p_x  >= 17)
							if(def_zone == BP_L_LEG || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST)
								def_zone = BP_R_LEG
							if(def_zone == BP_HEAD || def_zone == BP_L_ARM)
								def_zone = BP_CHEST
							//rleg

						else
							if(def_zone == BP_L_LEG || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_L_ARM \
							|| def_zone == BP_CHEST)
								def_zone = BP_L_LEG
							if(def_zone == BP_HEAD || def_zone == BP_L_ARM)
								def_zone = BP_CHEST
							//lleg
						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_LEG, BP_L_LEG, BP_CHEST)

					if(p_y > 10 && p_y <= 13) //groin level
						if(p_x <= 12)
							if(def_zone == BP_L_ARM || def_zone == BP_L_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_HEAD)
								def_zone = BP_L_ARM
							if(def_zone == BP_HEAD || def_zone == BP_R_LEG)
								def_zone = BP_CHEST
							//larm
						if(p_x > 12 && p_x < 21)
							if(def_zone == BP_L_ARM || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_L_LEG)
								def_zone = BP_GROIN
							if(def_zone == BP_HEAD)
								def_zone = BP_CHEST
							//groin
						if(p_x >= 21 && p_x < 24)
							if(def_zone == BP_L_ARM || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_HEAD)
								def_zone = BP_R_ARM
							if(def_zone == BP_HEAD || def_zone == BP_L_LEG)
								def_zone = BP_CHEST
							//rarm
						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_ARM, BP_L_ARM, BP_CHEST, BP_GROIN)
					if(p_y > 13 && p_y <= 22)
						if(p_x <= 12)
							if(def_zone == BP_L_ARM || def_zone == BP_L_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_HEAD)
								def_zone = BP_L_ARM
							if(def_zone == BP_HEAD || def_zone == BP_R_LEG)
								def_zone = BP_CHEST
							//larm
						if(p_x > 12 && p_x < 21)
							if(def_zone == BP_L_ARM || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_L_LEG \
							|| def_zone == BP_HEAD)
								def_zone = BP_CHEST
							if(def_zone == BP_HEAD || def_zone == BP_R_LEG)
								def_zone = BP_CHEST
							//chest
						if(p_x >= 21 && p_x < 24)
							if(def_zone == BP_L_ARM || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_HEAD)
								def_zone = BP_R_ARM
							if(def_zone == BP_HEAD || def_zone == BP_L_LEG)
								def_zone = BP_CHEST
							//rarm
						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_ARM, BP_L_ARM, BP_CHEST)

					if(p_y > 22 && p_y <= 32)
						if(def_zone == BP_L_ARM \
						|| def_zone == BP_R_ARM \
						|| def_zone == BP_CHEST)
							def_zone = BP_HEAD
						if(def_zone == BP_GROIN || def_zone == BP_L_LEG || \
						def_zone == BP_R_LEG)
							def_zone = BP_CHEST
						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_ARM, BP_L_ARM, BP_CHEST, BP_HEAD)
						//head
				if(4)
					if(p_y <= 10) //legs level
						if(def_zone == BP_R_LEG \
						|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
						|| def_zone == BP_CHEST)
							def_zone = BP_R_LEG
						if(def_zone == BP_HEAD || def_zone == BP_R_ARM)
							def_zone = BP_CHEST
						if(def_zone == BP_L_LEG)
							def_zone = BP_L_LEG
						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_LEG, BP_L_LEG, BP_CHEST)
						//rleg

					if(p_y > 10 && p_y <= 13) //groin level
						if(p_x < 16)
							if(def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_HEAD)
								def_zone = BP_R_ARM
							if(def_zone == HEAD || def_zone == BP_L_LEG)
								def_zone = BP_CHEST
							if(def_zone == BP_L_ARM)
								def_zone = BP_L_ARM
							//rarm
						if(p_x >= 16)
							if(def_zone == BP_L_ARM || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_L_LEG)
								def_zone = BP_GROIN
							if(def_zone == BP_HEAD)
								def_zone = BP_CHEST

						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_ARM, BP_L_ARM, BP_CHEST, BP_GROIN)
							//groin

					if(p_y > 13 && p_y <= 22)
						if(p_x >= 16)
							if(def_zone == BP_L_ARM || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_L_LEG \
							|| def_zone == HEAD)
								def_zone = BP_CHEST
							//chest
						if(p_x < 16)
							if(def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_HEAD)
								def_zone = BP_R_ARM
							//rarm
							if(def_zone == BP_HEAD || def_zone == BP_L_LEG)
								def_zone = BP_CHEST
							if(def_zone == BP_L_ARM)
								def_zone = BP_L_ARM
						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_ARM, BP_L_ARM, BP_CHEST)

					if(p_y > 22 && p_y <= 32)
						if(def_zone == BP_L_ARM \
						|| def_zone == BP_R_ARM \
						|| def_zone == BP_CHEST)
							def_zone = BP_HEAD
						if(def_zone ==  BP_GROIN || def_zone == BP_L_LEG || def_zone == BP_R_LEG)
							def_zone = BP_CHEST
						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_ARM, BP_L_ARM, BP_CHEST, BP_HEAD)
						//head

				if(8)
					if(p_y <= 10) //legs level
						//lleg
						if(def_zone == BP_L_LEG \
						|| def_zone == BP_GROIN || def_zone == BP_L_ARM \
						|| def_zone == BP_CHEST)
							def_zone = BP_L_LEG

						if(def_zone == BP_HEAD || def_zone == BP_R_ARM)
							def_zone = BP_CHEST

						if(def_zone == BP_R_LEG)
							def_zone = BP_R_LEG
						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_LEG, BP_L_LEG, BP_CHEST)

					if(p_y > 10 && p_y <= 13) //groin level
						if(p_x < 16)
							if(def_zone == BP_L_ARM || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_L_LEG)
								def_zone = BP_GROIN
							if(def_zone == BP_HEAD)
								def_zone = BP_CHEST
							//groin
						if(p_x >= 16)
							if(def_zone == BP_L_ARM || def_zone == BP_L_LEG \
							|| def_zone == BP_GROIN \
							|| def_zone == BP_CHEST || def_zone == BP_HEAD)
								def_zone = BP_L_ARM
							if(def_zone == BP_HEAD || def_zone == BP_R_LEG)
								def_zone = BP_CHEST
							if(def_zone == BP_R_ARM)
								def_zone = BP_R_ARM
						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_ARM, BP_L_ARM, BP_CHEST, BP_GROIN)
							//left_arm

					if(p_y > 13 && p_y <= 22)
						if(p_x < 16)
							if(def_zone == BP_L_ARM || def_zone == BP_R_LEG \
							|| def_zone == BP_GROIN || def_zone == BP_R_ARM \
							|| def_zone == BP_CHEST || def_zone == BP_L_LEG \
							|| def_zone == BP_HEAD)
								def_zone = BP_CHEST
							//chest
						if(p_x >= 16)
							if(def_zone == BP_L_ARM || def_zone == BP_L_LEG \
							|| def_zone == BP_GROIN \
							|| def_zone == BP_CHEST || def_zone == BP_HEAD)
								def_zone = BP_L_ARM
							if(def_zone == BP_R_LEG || def_zone == BP_HEAD)
								def_zone = BP_CHEST
							if(def_zone == BP_R_ARM)
								def_zone = BP_R_ARM
							//larm
						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_ARM, BP_L_ARM, BP_CHEST)

					if(p_y > 22 && p_y <= 32)
						if(def_zone == BP_L_ARM \
						|| def_zone == BP_R_ARM \
						|| def_zone == BP_CHEST)
							def_zone = BP_HEAD
						if(def_zone ==  BP_GROIN || def_zone == BP_L_LEG || def_zone == BP_R_LEG)
							def_zone = BP_CHEST
						if(istargetloc(target_mob) == 0)
							def_zone = pick(BP_R_ARM, BP_L_ARM, BP_CHEST, BP_HEAD)
						//head



			result = target_mob.bullet_act(src, def_zone)//this returns mob's armor_check and another - see modules/mob/living/living_defense.dm


	if(result == PROJECTILE_FORCE_MISS)
		if(!silenced)
			visible_message(SPAN_NOTICE("\The [src] misses [target_mob] narrowly!"))
		return FALSE

	//hit messages
	if(silenced)
		to_chat(target_mob, SPAN_DANGER("You've been hit in the [parse_zone(def_zone)] by \the [src]!"))
	else
		visible_message(SPAN_DANGER("\The [target_mob] is hit by \the [src] in the [parse_zone(def_zone)]!"))//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter

	playsound(target_mob, pick(mob_hit_sound), 40, 1)

	//admin logs
	if(!no_attack_log)
		if(ismob(firer))

			var/attacker_message = "shot with \a [src.type]"
			var/victim_message = "shot with \a [src.type]"
			var/admin_message = "shot (\a [src.type])"

			admin_attack_log(firer, target_mob, attacker_message, victim_message, admin_message)
		else
			target_mob.attack_log += "\[[time_stamp()]\] <b>UNKNOWN SUBJECT (No longer exists)</b> shot <b>[target_mob]/[target_mob.ckey]</b> with <b>\a [src]</b>"
			msg_admin_attack("UNKNOWN shot [target_mob] ([target_mob.ckey]) with \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target_mob.x];Y=[target_mob.y];Z=[target_mob.z]'>JMP</a>)")

	//sometimes bullet_act() will want the projectile to continue flying
	if (result == PROJECTILE_CONTINUE)
		return FALSE

	if(target_mob.mob_classification & CLASSIFICATION_ORGANIC)
		var/turf/target_loca = get_turf(target_mob)
		var/mob/living/L = target_mob
		if(damage > 10 && damage_type == BRUTE)
			var/splatter_dir = dir
			if(starting)
				splatter_dir = get_dir(starting, target_loca)
				target_loca = get_step(target_loca, splatter_dir)
			var/blood_color = "#C80000"
			if(ishuman(target_mob))
				var/mob/living/carbon/human/H = target_mob
				blood_color = H.species.blood_color
			new /obj/effect/overlay/temp/dir_setting/bloodsplatter(target_mob.loc, splatter_dir, blood_color)
			if(prob(50))
				target_loca.add_blood(L)

	return TRUE

/obj/item/projectile/Bump(atom/A as mob|obj|turf|area, forced=0)
	. = ..()
	if(A == src)
		return FALSE	//no.

	if((bumped && !forced) || (A in permutated))
		return FALSE

	if(firer && !ignore_source_check)
		if(A == firer || (A == firer.loc)) //cannot shoot yourself or your mech
			trajectory_ignore_forcemove = TRUE
			forceMove(get_turf(A))
			trajectory_ignore_forcemove = FALSE
			return FALSE


	var/distance = get_dist(get_turf(A), starting) // Get the distance between the turf shot from and the mob we hit and use that for the calculations.
	var/passthrough = FALSE //if the projectile should continue flying
	bumped = 1
	if(ismob(A))
		var/mob/M = A
		if(isliving(A))
			//if they have a neck grab on someone, that person gets hit instead
			var/obj/item/weapon/grab/G = locate() in M
			if(G && G.state >= GRAB_NECK)
				visible_message(SPAN_DANGER("\The [M] uses [G.affecting] as a shield!"))
				if(Bump(G.affecting, forced=1))
					return //If Bump() returns 0 (keep going) then we continue on to attack M.

			passthrough = !attack_mob(M, distance)
		else
			passthrough = TRUE	//so ghosts don't stop bullets
	else
		playsound(loc, hitsound_wall, 50)
		passthrough = (A.bullet_act(src, def_zone) == PROJECTILE_CONTINUE) //backwards compatibility
		if(isturf(A))
			for(var/obj/O in A)
				O.bullet_act(src)
			for(var/mob/living/M in A)
				attack_mob(M, distance)

	//penetrating projectiles can pass through things that otherwise would not let them
	if(!passthrough && penetrating > 0)
		if(check_penetrate(A))
			passthrough = TRUE
		penetrating--

	//the bullet passes through a dense object!
	if(passthrough || forcedodge)
		//move ourselves onto A so we can continue on our way.
		if(A)
			trajectory_ignore_forcemove = TRUE
			if(istype(A, /turf))
				forceMove(A)
			else
				forceMove(get_turf(A))
			trajectory_ignore_forcemove = FALSE
			permutated.Add(A)
		return FALSE

	//stop flying
	on_impact(A)

	qdel(src)
	return TRUE

/obj/item/projectile/ex_act(var/severity = 2.0)
	return //explosions probably shouldn't delete projectiles

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/item/projectile/proc/old_style_target(atom/target, atom/source)
	if(!source)
		source = get_turf(src)
	setAngle(Get_Angle(source, target))

/obj/item/projectile/proc/fire(angle, atom/direct_target)
	//If no angle needs to resolve it from xo/yo!
	if(direct_target)
		direct_target.bullet_act(src, def_zone)
		on_impact(direct_target)
		qdel(src)
		return
	if(isnum(angle))
		setAngle(angle)
	// trajectory dispersion
	var/turf/starting = get_turf(src)
	if(!starting)
		return
	if(isnull(Angle))	//Try to resolve through offsets if there's no angle set.
		if(isnull(xo) || isnull(yo))
			crash_with("WARNING: Projectile [type] deleted due to being unable to resolve a target after angle was null!")
			qdel(src)
			return
		var/turf/target = locate(CLAMP(starting + xo, 1, world.maxx), CLAMP(starting + yo, 1, world.maxy), starting.z)
		setAngle(Get_Angle(src, target))
	if(dispersion)
		setAngle(Angle + rand(-dispersion, dispersion))
	original_angle = Angle
	if(!nondirectional_sprite)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	if(muzzle_type && !silenced)
		if(ispath(muzzle_type))
			if(firer)
				var/obj/effect/projectile/thing = 	new muzzle_type(get_turf(src))
				if(thing.directional)
					thing.dir = firer.dir
					if(firer.dir == NORTH)
						thing.pixel_y = 16
						thing.layer = BELOW_MOB_LAYER // So it looks right.
					else if(firer.dir == SOUTH)
						thing.pixel_y = -16
					else if(firer.dir == EAST)
						thing.pixel_x = 16
					else if(firer.dir == WEST)
						thing.pixel_x = -16
					spawn(3)
						qdel(thing)
				else
					qdel(thing)
	forceMove(starting)
	trajectory = new(starting.x, starting.y, starting.z, 0, 0, Angle, pixel_speed)
	last_projectile_move = world.time
	fired = TRUE
	if(hitscan)
		return process_hitscan()
	else
		if(!is_processing)
			START_PROCESSING(SSprojectiles, src)
		pixel_move(1)	//move it now!

/obj/item/projectile/proc/preparePixelProjectile(atom/target, atom/source, params, angle_offset = 0)
	var/turf/curloc = get_turf(source)
	var/turf/targloc = get_turf(target)
	forceMove(get_turf(source))
	starting = get_turf(source)
	original = target

	var/list/calculated = list(null,null,null)
	if(isliving(source) && params)
		calculated = calculate_projectile_angle_and_pixel_offsets(source, params)
		p_x = calculated[2]
		p_y = calculated[3]
		setAngle(calculated[1])

	else if(targloc && curloc)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		setAngle(Get_Angle(src, targloc))
	else
		crash_with("WARNING: Projectile [type] fired without either mouse parameters, or a target atom to aim at!")
		qdel(src)
	if(angle_offset)
		setAngle(Angle + angle_offset)

/obj/item/projectile/proc/before_move()
	return

/obj/item/projectile/proc/after_move()
	return

/obj/item/projectile/Crossed(atom/movable/AM) //A mob moving on a tile with a projectile is hit by it.
	..()
	if(isliving(AM) && (AM.density || AM == original))
		Bump(AM)

/obj/item/projectile/Initialize()
	. = ..()
	permutated = list()

/obj/item/projectile/proc/pixel_move(moves, trajectory_multiplier = 1, hitscanning = FALSE)
	if(!loc || !trajectory)
		if(!QDELETED(src))
			if(loc)
				on_impact(loc)
			qdel(src)
		return
	last_projectile_move = world.time
	if(!nondirectional_sprite && !hitscanning)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	trajectory.increment(trajectory_multiplier)
	var/turf/T = trajectory.return_turf()
	if(T.z != loc.z)
		before_move()
		before_z_change(loc, T)
		trajectory_ignore_forcemove = TRUE
		forceMove(T)
		trajectory_ignore_forcemove = FALSE
		after_move()
		if(!hitscanning)
			pixel_x = trajectory.return_px()
			pixel_y = trajectory.return_py()
	else
		before_move()
		step_towards(src, T)
		after_move()
		if(!hitscanning)
			pixel_x = trajectory.return_px() - trajectory.mpx * trajectory_multiplier
			pixel_y = trajectory.return_py() - trajectory.mpy * trajectory_multiplier
	if(!hitscanning)
		animate(src, pixel_x = trajectory.return_px(), pixel_y = trajectory.return_py(), time = 1, flags = ANIMATION_END_NOW)
	if(isturf(loc))
		hitscan_last = loc
	if(can_hit_target(original, permutated))
		Bump(original, TRUE)
	Range()

//Returns true if the target atom is on our current turf and above the right layer
/obj/item/projectile/proc/can_hit_target(atom/target, var/list/passthrough)
	return (target && ((target.layer >= TURF_LAYER + 0.3) || ismob(target)) && (loc == get_turf(target)) && (!(target in passthrough)))

/proc/calculate_projectile_angle_and_pixel_offsets(mob/user, params)
	var/list/mouse_control = params2list(params)
	var/p_x = 0
	var/p_y = 0
	var/angle = 0
	if(mouse_control["icon-x"])
		p_x = text2num(mouse_control["icon-x"])
	if(mouse_control["icon-y"])
		p_y = text2num(mouse_control["icon-y"])
	if(mouse_control["screen-loc"])
		//Split screen-loc up into X+Pixel_X and Y+Pixel_Y
		var/list/screen_loc_params = splittext(mouse_control["screen-loc"], ",")

		//Split X+Pixel_X up into list(X, Pixel_X)
		var/list/screen_loc_X = splittext(screen_loc_params[1],":")

		//Split Y+Pixel_Y up into list(Y, Pixel_Y)
		var/list/screen_loc_Y = splittext(screen_loc_params[2],":")
		var/x = text2num(screen_loc_X[1]) * 32 + text2num(screen_loc_X[2]) - 32
		var/y = text2num(screen_loc_Y[1]) * 32 + text2num(screen_loc_Y[2]) - 32

		//Calculate the "resolution" of screen based on client's view and world's icon size. This will work if the user can view more tiles than average.
		var/list/screenview = getviewsize(user.client.view)
		var/screenviewX = screenview[1] * world.icon_size
		var/screenviewY = screenview[2] * world.icon_size

		var/ox = round(screenviewX/2) - user.client.pixel_x //"origin" x
		var/oy = round(screenviewY/2) - user.client.pixel_y //"origin" y
		angle = ATAN2(y - oy, x - ox)
	return list(angle, p_x, p_y)

/obj/item/projectile/proc/Range()
	range--
	if(range <= 0 && loc)
		on_range()

/obj/item/projectile/proc/on_range() //if we want there to be effects when they reach the end of their range
	on_impact(loc)
	qdel(src)

/obj/item/projectile/proc/store_hitscan_collision(datum/point/pcache)
	beam_segments[beam_index] = pcache
	beam_index = pcache
	beam_segments[beam_index] = null

/obj/item/projectile/proc/return_predicted_turf_after_moves(moves, forced_angle)		//I say predicted because there's no telling that the projectile won't change direction/location in flight.
	if(!trajectory && isnull(forced_angle) && isnull(Angle))
		return FALSE
	var/datum/point/vector/current = trajectory
	if(!current)
		var/turf/T = get_turf(src)
		current = new(T.x, T.y, T.z, pixel_x, pixel_y, isnull(forced_angle)? Angle : forced_angle, pixel_speed)
	var/datum/point/vector/v = current.return_vector_after_increments(moves)
	return v.return_turf()

/obj/item/projectile/proc/return_pathing_turfs_in_moves(moves, forced_angle)
	var/turf/current = get_turf(src)
	var/turf/ending = return_predicted_turf_after_moves(moves, forced_angle)
	return getline(current, ending)

/obj/item/projectile/proc/process_hitscan()
	var/safety = range * 3
	var/return_vector = RETURN_POINT_VECTOR_INCREMENT(src, Angle, MUZZLE_EFFECT_PIXEL_INCREMENT, 1)
	record_hitscan_start(return_vector)
	while(loc && !QDELETED(src))
		if(paused)
			stoplag(1)
			continue
		if(safety-- <= 0)
			qdel(src)
			crash_with("WARNING: [type] projectile encountered infinite recursion during hitscanning in [__FILE__]/[__LINE__]!")
			return	//Kill!
		pixel_move(1, 1, TRUE)

/obj/item/projectile/proc/record_hitscan_start(datum/point/pcache)
	beam_segments = list()	//initialize segment list with the list for the first segment
	beam_index = pcache
	beam_segments[beam_index] = null	//record start.

/obj/item/projectile/proc/vol_by_damage()
	if(src.damage)
		return CLAMP((src.damage) * 0.67, 30, 100)// Multiply projectile damage by 0.67, then CLAMP the value between 30 and 100
	else
		return 50 //if the projectile doesn't do damage, play its hitsound at 50% volume.

/obj/item/projectile/proc/before_z_change(turf/oldloc, turf/newloc)
	var/datum/point/pcache = trajectory.copy_to()
	if(hitscan)
		store_hitscan_collision(pcache)

/obj/item/projectile/Process()
	last_process = world.time

	if(!loc || !fired || !trajectory)
		fired = FALSE
		return PROCESS_KILL
	if(paused || !isturf(loc))
		last_projectile_move += world.time - last_process		//Compensates for pausing, so it doesn't become a hitscan projectile when unpaused from charged up ticks.
		return
	var/elapsed_time_deciseconds = (world.time - last_projectile_move) + time_offset
	time_offset = 0
	var/required_moves = 0
	if(speed > 0)
		required_moves = FLOOR(elapsed_time_deciseconds / speed, 1)
		if(required_moves > SSprojectiles.global_max_tick_moves)
			var/overrun = required_moves - SSprojectiles.global_max_tick_moves
			required_moves = SSprojectiles.global_max_tick_moves
			time_offset += overrun * speed
		time_offset += MODULUS(elapsed_time_deciseconds, speed)
	else
		required_moves = SSprojectiles.global_max_tick_moves
	if(!required_moves)
		return
	for(var/i in 1 to required_moves)
		pixel_move(required_moves)

/obj/item/projectile/proc/setAngle(new_angle)	//wrapper for overrides.
	Angle = new_angle
	if(!nondirectional_sprite)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	if(trajectory)
		trajectory.set_angle(new_angle)
	return TRUE

/obj/item/projectile/forceMove(atom/target)
	. = ..()
	if(trajectory && !trajectory_ignore_forcemove && isturf(target))
		trajectory.initialize_location(target.x, target.y, target.z, 0, 0)

/obj/item/projectile/Destroy()
	if(hitscan)
		if(loc && trajectory)
			var/datum/point/pcache = trajectory.copy_to()
			beam_segments[beam_index] = pcache
		generate_hitscan_tracers()
	STOP_PROCESSING(SSprojectiles, src)
	return ..()

/obj/item/projectile/proc/generate_hitscan_tracers(cleanup = TRUE, duration = 10)
	if(!length(beam_segments))
		return
	if(duration <= 0)
		return
	if(tracer_type)
		for(var/datum/point/p in beam_segments)
			generate_tracer_between_points(p, beam_segments[p], tracer_type, color, duration)
	if(muzzle_type && !silenced)
		var/datum/point/p = beam_segments[1]
		var/atom/movable/thing = new muzzle_type
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(original_angle)
		thing.transform = M
		spawn(duration)
			qdel(thing)
	if(impact_type)
		var/datum/point/p = beam_segments[beam_segments[beam_segments.len]]
		var/atom/movable/thing = new impact_type
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(Angle)
		thing.transform = M
		spawn(duration)
			qdel(thing)
	if(cleanup)
		for(var/i in beam_segments)
			qdel(i)
		beam_segments = null
		QDEL_NULL(beam_index)



//"Tracing" projectile
/obj/item/projectile/test //Used to see if you can hit them.
	invisibility = 101 //Nope!  Can't see me!
	yo = null
	xo = null
	var/result = 0 //To pass the message back to the gun.

/obj/item/projectile/test/Bump(atom/A as mob|obj|turf|area)
	if(A == firer)
		loc = A.loc
		return //cannot shoot yourself
	if(istype(A, /obj/item/projectile))
		return
	if(isliving(A) || istype(A, /obj/mecha) || istype(A, /obj/vehicle))
		result = 2 //We hit someone, return 1!
		return
	result = 1
	return

/obj/item/projectile/test/launch(atom/target)
	var/turf/curloc = get_turf(src)
	var/turf/targloc = get_turf(target)
	if(!curloc || !targloc)
		return 0

	original = target

	//plot the initial trajectory
	preparePixelProjectile(curloc, targloc)
	return Process(targloc)
/*
/obj/item/projectile/test/Process(turf/targloc)
	while(src) //Loop on through!
		if(result)
			return (result - 1)
		if((!( targloc ) || loc == targloc))
			targloc = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z) //Finding the target turf at map edge

		trajectory.increment()	// increment the current location
		location = trajectory.return_position()		// update the locally stored location data

		Move(location.return_turf())

		var/mob/living/M = locate() in get_turf(src)
		if(istype(M)) //If there is someting living...
			return 1 //Return 1
		else
			M = locate() in get_step(src,targloc)
			if(istype(M))
				return 1
*/

//Helper proc to check if you can hit them or not.
/proc/check_trajectory(atom/target as mob|obj, atom/firer as mob|obj, var/pass_flags=PASSTABLE|PASSGLASS|PASSGRILLE, flags=null)
	if(!istype(target) || !istype(firer))
		return 0

	var/obj/item/projectile/test/trace = new /obj/item/projectile/test(get_turf(firer)) //Making the test....

	//Set the flags and pass flags to that of the real projectile...
	if(!isnull(flags))
		trace.flags = flags
	trace.pass_flags = pass_flags

	var/output = trace.launch(target) //Test it!
	qdel(trace) //No need for it anymore
	return output //Send it back to the gun!

/proc/get_proj_icon_by_color(var/obj/item/projectile/P, var/color)
	var/icon/I = new(P.icon, P.icon_state)
	I.Blend(color)
	return I