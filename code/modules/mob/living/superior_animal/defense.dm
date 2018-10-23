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

/mob/living/carbon/superior_animal/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj || Proj.nodamage)
		return

	adjustBruteLoss(Proj.damage)
	return 0

/mob/living/carbon/superior_animal/attack_hand(mob/living/carbon/M as mob)
	..()
	switch(M.a_intent)
		if (I_HELP)
			help_shake_act(M)
			//M.visible_message("\blue [M] [response_help] \the [src]")

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
			if(!G)	//the grab will delete itself in New if affecting is anchored
				return
			M.put_in_active_hand(G)
			G.synch()
			LAssailant = M

			M.do_attack_animation(src)
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message(SPAN_WARNING("[M] has grabbed [src] passively!"))

			return 1

		if (I_DISARM)
			M.visible_message("\blue [M] [response_disarm] \the [src]")
			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			M.do_attack_animation(src)

		if (I_HURT)
			var/damage = 3
			if (prob(90))
				if (HULK in M.mutations)
					damage *= 2

				playsound(loc, "punch", 25, 1, -1)
				M.visible_message("\red [M] has punched \the [src]")

				adjustBruteLoss(damage)
				updatehealth()
				M.do_attack_animation(src)
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				M.visible_message("\red [M] missed \the [src]")

/mob/living/carbon/superior_animal/attackby(var/obj/item/O, var/mob/user)
	if (meat_type && (stat == DEAD))
		if (QUALITY_CUTTING in O.tool_qualities)
			if (O.use_tool(user, src, WORKTIME_NORMAL, QUALITY_CUTTING, FAILCHANCE_NORMAL, required_stat = STAT_BIO))
				harvest(user)
	else
		O.attack(src, user, user.targeted_organ)

/mob/living/carbon/alien/ex_act(severity)
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
		return

	updatehealth()

/mob/living/carbon/superior_animal/updatehealth()
	. = ..()
	if (health <= 0)
		death()

/mob/living/carbon/superior_animal/adjustBruteLoss(var/amount)
	. = ..(amount)
	updatehealth()

/mob/living/carbon/superior_animal/gib()
	..(icon_gib,1)

/mob/living/carbon/superior_animal/death(gibbed)
	if(!gibbed && icon_dead)
		icon_state = icon_dead
	density = 0
	walk(src, 0)
	return ..(gibbed,deathmessage)