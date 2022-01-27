//Space bears!
/mob/living/simple_animal/hostile/bear
	name = "space bear"
	desc = "RawrRawr!!"
	icon_state = "bear"
	icon_gib = "bear_gib"
	speak_emote = list("growls", "roars")
	emote_see = list("stares ferociously", "stomps")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_containers/food/snacks/meat/bearmeat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	stop_automated_movement_when_pulled = 0
	maxHealth = 60
	health = 60
	melee_damage_lower = 20
	melee_damage_upper = 30

	//Space bears aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	var/stance_step = 0

	faction = "russian"

//SPACE BEARS! SQUEEEEEEEE~     OW! FUCK! IT BIT69Y HAND OFF!!
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

	if(stasis)
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
				if(target_mob && (target_mob in ListTargets(10)))
					stance = HOSTILE_STANCE_ATTACK //If the69ob he was chasing is still69earby, resume the attack, otherwise go idle.
				else
					stance = HOSTILE_STANCE_IDLE

		if(HOSTILE_STANCE_ALERT)
			stop_automated_movement = 1
			var/found_mob = 0
			if(target_mob && (target_mob in ListTargets(10)))
				if(!(SA_attackable(target_mob)))
					stance_step =69ax(0, stance_step) //If we have69ot seen a69ob in a while, the stance_step will be69egative, we69eed to reset it to 0 as soon as we see a69ob again.
					stance_step++
					found_mob = 1
					src.set_dir(get_dir(src,target_mob))	//Keep staring at the69ob

					if(stance_step in list(1,4,7)) //every 3 ticks
						var/action = pick( list( "growls at 69target_mob69.", "stares angrily at 69target_mob69.", "prepares to attack 69target_mob69!", "closely watches 69target_mob69." ) )
						if(action)
							visible_emote(action)
			if(!found_mob)
				stance_step--

			if(stance_step <= -20) //If we have69ot found a69ob for 20-ish ticks, revert to idle69ode
				stance = HOSTILE_STANCE_IDLE
			if(stance_step >= 7)   //If we have been staring at a69ob for 7 ticks,
				stance = HOSTILE_STANCE_ATTACK

		if(HOSTILE_STANCE_ATTACKING)
			if(stance_step >= 20)	//attacks for 20 ticks, then it gets tired and69eeds to rest
				visible_emote("is worn out and69eeds to rest.")
				stance = HOSTILE_STANCE_TIRED
				stance_step = 0
				walk(src, 0) //This stops the bear's walking
				return


/mob/living/simple_animal/hostile/bear/attackby(var/obj/item/O as obj,69ar/mob/user as69ob)
	if(stance != HOSTILE_STANCE_ATTACK && stance != HOSTILE_STANCE_ATTACKING)
		stance = HOSTILE_STANCE_ALERT
		stance_step = 6
		target_mob = user
	..()

/mob/living/simple_animal/hostile/bear/attack_hand(mob/living/carbon/human/M as69ob)
	if(stance != HOSTILE_STANCE_ATTACK && stance != HOSTILE_STANCE_ATTACKING)
		stance = HOSTILE_STANCE_ALERT
		stance_step = 6
		target_mob =69
	..()

/mob/living/simple_animal/hostile/bear/allow_spacemove()
	return ..()//No drifting in space for space bears!

/mob/living/simple_animal/hostile/bear/FindTarget()
	. = ..()
	if(.)
		visible_emote("stares alertly at 69.69.")
		stance = HOSTILE_STANCE_ALERT

/mob/living/simple_animal/hostile/bear/LoseTarget()
	..(5)

/mob/living/simple_animal/hostile/bear/AttackingTarget()
	if(!Adjacent(target_mob))
		return
	visible_emote(list("slashes at 69target_mob69!", "bites 69target_mob69!"))

	var/damage = rand(20,30)

	if(ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		var/dam_zone = pick(BP_CHEST, BP_L_ARM, BP_R_ARM, BP_L_LEG , BP_R_LEG)
		var/obj/item/organ/external/affecting = H.get_organ(ran_zone(dam_zone))
		H.damage_through_armor(damage, BRUTE, affecting, ARMOR_MELEE, 0, 0, sharp = TRUE, edge = TRUE)

		return H
	else if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.adjustBruteLoss(damage)
		return L
