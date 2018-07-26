/mob/living/roach/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj || Proj.nodamage)
		return

	adjustBruteLoss(Proj.damage)
	return 0


/mob/living/roach/attack_hand(mob/living/carbon/human/M as mob)
	..()

	switch(M.a_intent)

		if(I_HELP)
			if (health > 0)
				M.visible_message("\blue [M] [response_help] \the [src]")

		if(I_DISARM)
			M.visible_message("\blue [M] [response_disarm] \the [src]")
			M.do_attack_animation(src)
			//TODO: Push the mob away or something

		if(I_GRAB)
			if (M == src)
				return
			if (!(status_flags & CANPUSH))
				return

			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src)

			M.put_in_active_hand(G)

			G.synch()
			G.affecting = src
			LAssailant = M

			M.visible_message("\red [M] has grabbed [src] passively!")
			M.do_attack_animation(src)

		if(I_HURT)
			adjustBruteLoss(harm_intent_damage)
			M.visible_message("\red [M] [response_harm] \the [src]")
			M.do_attack_animation(src)

	return


/mob/living/roach/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/stack/medical))
		if(stat != DEAD)
			var/obj/item/stack/medical/MED = O
			if(health < maxHealth)
				if(MED.amount >= 1)
					adjustBruteLoss(-MED.heal_brute)
					MED.amount -= 1
					if(MED.amount <= 0)
						qdel(MED)
					for(var/mob/M in viewers(src, null))
						if ((M.client && !( M.blinded )))
							M.show_message(SPAN_NOTICE("[user] applies the [MED] on [src]."))
		else
			user << SPAN_NOTICE("\The [src] is dead, medical items won't bring \him back to life.")
	if(meat_type && (stat == DEAD))	//if the animal has a meat, and if it is dead.
		if(QUALITY_CUTTING in O.tool_qualities)
			if(O.use_tool(user, src, WORKTIME_NORMAL, QUALITY_CUTTING, FAILCHANCE_NORMAL, required_stat = STAT_BIO))
				harvest(user)
	else
		if(!O.force)
			visible_message(SPAN_NOTICE("[user] gently taps [src] with \the [O]."))
		else
			O.attack(src, user, user.targeted_organ)


/mob/living/roach/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)

	visible_message(SPAN_DANGER("\The [src] has been attacked with \the [O] by [user]."))

	if(O.force <= resistance)
		user << SPAN_DANGER("This weapon is ineffective, it does no damage.")
		return 2

	var/damage = O.force
	if (O.damtype == HALLOSS)
		damage = 0
	adjustBruteLoss(damage)

	return 0


/mob/living/roach/ex_act(severity)
	if(!blinded)
		if(HUDtech.Find("flash"))
			flick("flash", HUDtech["flash"])
	switch (severity)
		if(1.0)
			adjustBruteLoss(500)
			gib()
		if(2.0)
			adjustBruteLoss(60)
		if(3.0)
			adjustBruteLoss(30)


/mob/living/roach/adjustBruteLoss(damage)
	health = Clamp(health - damage, 0, maxHealth)


/mob/living/roach/handle_fire()
	return
/mob/living/roach/update_fire()
	return
/mob/living/roach/IgniteMob()
	return
/mob/living/roach/ExtinguishMob()
	return
