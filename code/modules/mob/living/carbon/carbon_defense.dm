
//Called when the mob is hit with an item in combat.
/mob/living/carbon/resolve_item_attack(obj/item/I, mob/living/user, var/hit_zone)
	if(check_attack_throat(I, user))
		return null
	if (!hit_zone)
		hit_zone = "chest"
	return ..(I, user, hit_zone)

/mob/living/carbon/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)

	if(!effective_force)
		return 0

	//Hulk modifier
//	if(HULK in user.mutations)
//		effective_force *= 2

	//Apply weapon damage
	var/weapon_sharp = is_sharp(I)
	var/weapon_edge = has_edge(I)

	if(prob(getarmor(hit_zone, ARMOR_MELEE))) //melee armour provides a chance to turn sharp/edge weapon attacks into blunt ones
		weapon_sharp = 0
		weapon_edge = 0

	hit_impact(effective_force, get_step(user, src))
	damage_through_armor(effective_force, I.damtype, hit_zone, ARMOR_MELEE, armour_divisor = I.armor_divisor, used_weapon = I, sharp = weapon_sharp, edge = weapon_edge)

/*Its entirely possible that we were gibbed or dusted by the above. Check if we still exist before
continuing. Being gibbed or dusted has a 1.5 second delay, during which it sets the transforming var to
true, and the mob is not yet deleted, so we need to check that as well*/
	if (QDELETED(src) || transforming)
		return TRUE

	//Melee weapon embedded object code.
	if (I && I.damtype == BRUTE && !I.anchored && !is_robot_module(I))
		var/damage = effective_force

		//blunt objects should really not be embedding in things unless a huge amount of force is involved

		var/embed_threshold = weapon_sharp? 5*I.w_class : 15*I.w_class

		//The user's robustness stat adds to the threshold, allowing you to use more powerful weapons without embedding risk
		embed_threshold += user.stats.getStat(STAT_ROB)
		var/embed_chance = (damage - embed_threshold)*I.embed_mult
		if (embed_chance > 0 && prob(embed_chance))
			src.embed(I, hit_zone)

	return TRUE

// Attacking someone with a weapon while they are neck-grabbed
/mob/living/carbon/proc/check_attack_throat(obj/item/W, mob/user)
	if(user.a_intent == I_HURT)
		for(var/obj/item/grab/G in src.grabbed_by)
			if(G.assailant == user && G.state >= GRAB_NECK)
				if(attack_throat(W, G, user))
					return 1
	return 0

// Knifing
/mob/living/carbon/proc/attack_throat(obj/item/W, obj/item/grab/G, mob/user)

	if(!W.edge || !W.force || W.damtype != BRUTE)
		return 0 //unsuitable weapon

	user.visible_message(SPAN_DANGER("\The [user] begins to slit [src]'s throat with \the [W]!"))

	user.next_move = world.time + 50 //also should prevent user from triggering this repeatedly
	if(!do_mob(user, src, 50, progress = 1))
		if(!(G && G.assailant == user && G.affecting == src)) //check that we still have a grab
			return 0

		damage_through_armor(W.force, W.damtype, BP_HEAD, wounding_multiplier = 2, sharp = W.sharp, edge = W.edge, used_weapon = W)
		
		user.visible_message(SPAN_DANGER("\The [user] cuts [src]'s neck with \the [W]!"), SPAN_DANGER("You cut [src]'s neck with \the [W]!"))

		if(W.hitsound)
			playsound(loc, W.hitsound, 50, 1, -1)

		G.last_action = world.time
		flick(G.hud.icon_state, G.hud)

		user.attack_log += "\[[time_stamp()]\]<font color='red'> Knifed [name] ([ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(W.damtype)])</font>"
		src.attack_log += "\[[time_stamp()]\]<font color='orange'> Got knifed by [user.name] ([user.ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(W.damtype)])</font>"
		msg_admin_attack("[key_name(user)] knifed [key_name(src)] with [W.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(W.damtype)])" )
		return 1

	else
		return 0
