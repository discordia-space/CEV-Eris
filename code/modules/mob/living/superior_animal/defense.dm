/mob/living/carbon/superior_animal/proc/harvest(var/mob/user)
	var/actual_meat_amount = max(1,(meat_amount/2))
	if(meat_type && actual_meat_amount>0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.name = "[src.name] [meat.name]"
		if(issmall(src))
			user.visible_message(SPAN_DANGER("[user] chops up \the [src]!"))
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(src)
		else
			user.visible_message(SPAN_DANGER("[user] butchers \the [src] messily!"))
			gib()

/mob/living/carbon/superior_animal/bullet_act(var/obj/item/projectile/P, var/def_zone)
	. = ..()
	updatehealth()

/mob/living/carbon/superior_animal/attackby(obj/item/I, mob/living/user, var/params)
	if (meat_type && (stat == DEAD) && (QUALITY_CUTTING in I.tool_qualities))
		if (I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_CUTTING, FAILCHANCE_NORMAL, required_stat = STAT_BIO))
			harvest(user)
	else
		. = ..()
		updatehealth()

/mob/living/carbon/superior_animal/resolve_item_attack(obj/item/I, mob/living/user, var/hit_zone)
	//mob.attackby -> item.attack -> mob.resolve_item_attack -> item.apply_hit_effect
	return 1

/mob/living/carbon/superior_animal/attack_hand(mob/living/carbon/M as mob)
	..()
	var/mob/living/carbon/human/H = M

	switch(M.a_intent)
		if (I_HELP)
			help_shake_act(M)

		if (I_GRAB)
			if(M == src || anchored)
				return 0
			for(var/obj/item/weapon/grab/G in src.grabbed_by)
				if(G.assailant == M)
					M << SPAN_NOTICE("You already grabbed [src].")
					return

			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src)
			if(buckled)
				M << SPAN_NOTICE("You cannot grab [src], \he is buckled in!")
			if(!G) //the grab will delete itself in New if affecting is anchored
				return

			M.put_in_active_hand(G)
			G.synch()
			LAssailant = M

			M.do_attack_animation(src)
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message(SPAN_WARNING("[M] has grabbed [src] passively!"))

			return 1

		if (I_DISARM)
			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			M.do_attack_animation(src)

		if (I_HURT)
			var/damage = 3
			if ((stat == CONSCIOUS) && prob(10))
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				M.visible_message("\red [M] missed \the [src]")
			else
				if (istype(H))
					damage += max(0, (H.stats.getStat(STAT_ROB) / 10))
					if (HULK in H.mutations)
						damage *= 2

				playsound(loc, "punch", 25, 1, -1)
				M.visible_message("\red [M] has punched \the [src]")

				adjustBruteLoss(damage)
				updatehealth()
				M.do_attack_animation(src)

/mob/living/carbon/superior_animal/ex_act(severity)
	..()
	if(!blinded)
		if (HUDtech.Find("flash"))
			flick("flash", HUDtech["flash"])

	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			gib()
			return

		if (2.0)
			b_loss += 60
			f_loss += 60
			ear_damage += 30
			ear_deaf += 120

		if (3.0)
			b_loss += 30
			if (prob(50))
				Paralyse(1)
			ear_damage += 15
			ear_deaf += 60

	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)

	updatehealth()

/mob/living/carbon/superior_animal/handle_regular_status_updates()
	..()
	if(status_flags & GODMODE)
		return

	if(stat == DEAD)
		blinded = 1
		silent = 0

	updatehealth()

	return 1

/mob/living/carbon/superior_animal/updatehealth()
	. = ..() //health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss
	if (health <= 0)
		death()

	if (getBruteLoss() <= -maxHealth*3)
		gib()
		return

	if (getFireLoss() <= -maxHealth*3)
		dust()
		return

/mob/living/carbon/superior_animal/gib(var/anim = icon_gib, var/do_gibs = 1)
	if (!anim)
		anim = 0

	playsound(src.loc, 'sound/effects/splat.ogg', max(10,min(50,maxHealth)), 1)
	. = ..(anim,do_gibs)

/mob/living/carbon/superior_animal/dust(var/anim = icon_dust, var/remains = dust_remains)
	if (!anim)
		anim = 0

	playsound(src.loc, 'sound/effects/Custom_flare.ogg', max(10,min(50,maxHealth)), 1)
	. = ..(anim,remains)

/mob/living/carbon/superior_animal/death(var/gibbed,var/message = deathmessage)
	if (stat != DEAD)
		visible_message("dead")

		target_mob = null
		stance = initial(stance)
		stop_automated_movement = initial(stop_automated_movement)
		walk(src, 0)

		density = 0
		layer = LYING_MOB_LAYER

	. = ..()

/mob/living/carbon/superior_animal/rejuvenate()
	density = initial(density)
	layer = initial(layer)

	. = ..()

/mob/living/carbon/superior_animal/update_icons()
	if (stat == DEAD)
		icon_state = icon_dead
	else if ((stat == UNCONSCIOUS || resting) && icon_rest)
		icon_state = icon_rest
	else if (icon_living)
		icon_state = icon_living

/mob/living/carbon/superior_animal/regenerate_icons()
	update_icons()

/mob/living/carbon/superior_animal/updateicon()
	update_icons()