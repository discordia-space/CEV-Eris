//Space bears!
/mob/living/carbon/superior_animal/bear
	name = "space bear"
	desc = "RawrRawr!!"
	icon_state = "bear"
	icon_gib = "bear_gib"
	speak_emote = list("growls", "roars")
	emote_see = list("stares ferociously at", "growls at", "sizes up", "glares hungrily at")
	speak_chance = 5
	turns_per_move = 4
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/bearmeat
	stop_automated_movement_when_pulled = 0
	maxHealth = 250
	melee_damage_lower = 20
	melee_damage_upper = 35
	randpixel = 8
	can_burrow = FALSE
	breath_required_type = 0 //Does not breathe
	attacktext = "mauled"

	var/quiet_sounds = list('sound/effects/creatures/bear_quiet_1.ogg',
	'sound/effects/creatures/bear_quiet_2.ogg',
	'sound/effects/creatures/bear_quiet_3.ogg',
	'sound/effects/creatures/bear_quiet_4.ogg',
	'sound/effects/creatures/bear_quiet_5.ogg',
	'sound/effects/creatures/bear_quiet_6.ogg')
	var/loud_sounds = list('sound/effects/creatures/bear_loud_1.ogg',
	'sound/effects/creatures/bear_loud_2.ogg',
	'sound/effects/creatures/bear_loud_3.ogg',
	'sound/effects/creatures/bear_loud_4.ogg')

	//Space bears aren't affected by atmos.


	min_air_pressure = 0 //Exists happily in a vacuum
	max_air_pressure = 120 //poor tolerance for high pressure
	min_bodytemperature = 0
	max_bodytemperature = 320 //Vulnerable to fire

	faction = "russian"

	//Anger management!
	//Bears are territorial, they gradually become more angry whenever they see a nearby target
	//They will not attack until anger reaches the attack threshold
	var/anger = 0
	var/anger_attack_threshold = 20


//Staring is rude
//Bears are quick to recognise rudeness
/mob/living/carbon/superior_animal/bear/examine(var/mob/user)
	if (isliving(user))
		anger++
	.=..()


/mob/living/carbon/superior_animal/bear/harvest()
	new /obj/item/clothing/head/bearpelt(get_turf(src))
	..()


/mob/living/carbon/superior_animal/bear/proc/angry()
	if (anger < anger_attack_threshold)
		return FALSE
	return TRUE

/mob/living/carbon/superior_animal/bear/speak_audio()
	if (anger > 10)
		growl_loud()
	else
		growl_soft()


//Plays a random selection of six sounds, at a low volume
//This is triggered randomly periodically by the bear
/mob/living/carbon/superior_animal/bear/proc/growl_soft()
	var/sound = pick(quiet_sounds)
	playsound(src, sound, 70, 1,3, use_pressure = 0)


//Plays a loud sound from a selection of four
//Played when bear is attacking or dies
/mob/living/carbon/superior_animal/bear/proc/growl_loud()
	var/sound = pick(loud_sounds)
	playsound(src, sound, 100, 1, 5, use_pressure = 0)
	for (var/mob/living/L in view(2, src))
		if (L.client)
			shake_camera(L, 3, 0.5)

/*
//SPACE BEARS! SQUEEEEEEEE~     OW! FUCK! IT BIT MY HAND OFF!!
/mob/living/simple_animal/hostile/bear/Hudson
	name = "Hudson"
	desc = ""
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"

/mob/living/simple_animal/hostile/bear/Life()
	. =..()
	if(!.)
		return

	if(loc && istype(loc,/turf/space))
		icon_state = "bear"
	else
		icon_state = "bearfloor"

	switch(stance)

		if(HOSTILE_STANCE_TIRED)
			stop_automated_movement = 1
			stance_step++
			if(stance_step >= 10) //rests for 10 ticks
				if(target_mob && target_mob in ListTargets(10))
					stance = HOSTILE_STANCE_ATTACK //If the mob he was chasing is still nearby, resume the attack, otherwise go idle.
				else
					stance = HOSTILE_STANCE_IDLE

		if(HOSTILE_STANCE_ALERT)
			stop_automated_movement = 1
			var/found_mob = 0
			if(target_mob && target_mob in ListTargets(10))
				if(!(SA_attackable(target_mob)))
					stance_step = max(0, stance_step) //If we have not seen a mob in a while, the stance_step will be negative, we need to reset it to 0 as soon as we see a mob again.
					stance_step++
					found_mob = 1
					src.set_dir(get_dir(src,target_mob))	//Keep staring at the mob

					if(stance_step in list(1,4,7)) //every 3 ticks
						var/action = pick( list( "growls at [target_mob].", "stares angrily at [target_mob].", "prepares to attack [target_mob]!", "closely watches [target_mob]." ) )
						if(action)
							visible_emote(action)
			if(!found_mob)
				stance_step--

			if(stance_step <= -20) //If we have not found a mob for 20-ish ticks, revert to idle mode
				stance = HOSTILE_STANCE_IDLE
			if(stance_step >= 7)   //If we have been staring at a mob for 7 ticks,
				stance = HOSTILE_STANCE_ATTACK

		if(HOSTILE_STANCE_ATTACKING)
			if(stance_step >= 20)	//attacks for 20 ticks, then it gets tired and needs to rest
				visible_emote("is worn out and needs to rest.")
				stance = HOSTILE_STANCE_TIRED
				stance_step = 0
				walk(src, 0) //This stops the bear's walking
				return



/mob/living/simple_animal/hostile/bear/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(stance != HOSTILE_STANCE_ATTACK && stance != HOSTILE_STANCE_ATTACKING)
		stance = HOSTILE_STANCE_ALERT
		stance_step = 6
		target_mob = user
	..()

/mob/living/simple_animal/hostile/bear/attack_hand(mob/living/carbon/human/M as mob)
	if(stance != HOSTILE_STANCE_ATTACK && stance != HOSTILE_STANCE_ATTACKING)
		stance = HOSTILE_STANCE_ALERT
		stance_step = 6
		target_mob = M
	..()

/mob/living/simple_animal/hostile/bear/Allow_Spacemove(var/check_drift = 0)
	return	//No drifting in space for space bears!

/mob/living/simple_animal/hostile/bear/FindTarget()
	. = ..()
	if(.)
		visible_emote("stares alertly at [.].")
		stance = HOSTILE_STANCE_ALERT

/mob/living/simple_animal/hostile/bear/LoseTarget()
	..(5)

/mob/living/simple_animal/hostile/bear/AttackingTarget()
	if(!Adjacent(target_mob))
		return
	visible_emote(list("slashes at [target_mob]!", "bites [target_mob]!"))

	var/damage = rand(20,30)

	if(ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		var/dam_zone = pick(BP_CHEST, BP_L_ARM, BP_R_ARM, BP_L_LEG , BP_R_LEG)
		var/obj/item/organ/external/affecting = H.get_organ(ran_zone(dam_zone))
		H.apply_damage(damage, BRUTE, affecting, H.run_armor_check(affecting, "melee"), sharp=1, edge=1)
		return H
	else if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.adjustBruteLoss(damage)
		return L
	//else if(istype(target_mob,/obj/mecha))
		//var/obj/mecha/M = target_mob
		//M.attack_animal(src)
		//return M

*/












