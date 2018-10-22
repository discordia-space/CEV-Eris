/mob/living/superior_animal/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj || Proj.nodamage)
		return

	adjustBruteLoss(Proj.damage)
	return 0


/mob/living/superior_animal/attack_hand(mob/living/carbon/human/M as mob)
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


/mob/living/superior_animal/attackby(var/obj/item/O, var/mob/user)
	if(meat_type && (stat == DEAD))	//if the animal has a meat, and if it is dead.
		if(QUALITY_CUTTING in O.tool_qualities)
			if(O.use_tool(user, src, WORKTIME_NORMAL, QUALITY_CUTTING, FAILCHANCE_NORMAL, required_stat = STAT_BIO))
				harvest(user)
	else
		O.attack(src, user, user.targeted_organ)


/mob/living/superior_animal/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)

	visible_message(SPAN_DANGER("\The [src] has been attacked with \the [O] by [user]."))

	if(O.force <= resistance)
		user << SPAN_DANGER("This weapon is ineffective, it does no damage.")
		return 2

	var/damage = O.force
	if (O.damtype == HALLOSS)
		damage = 0
	adjustBruteLoss(damage)

	return 0


/mob/living/superior_animal/ex_act(severity)
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


/mob/living/superior_animal/adjustBruteLoss(damage)
	health = Clamp(health - damage, 0, maxHealth)


/mob/living/superior_animal/handle_fire()
	return
/mob/living/superior_animal/update_fire()
	return
/mob/living/superior_animal/IgniteMob()
	return
/mob/living/superior_animal/ExtinguishMob()
	return
