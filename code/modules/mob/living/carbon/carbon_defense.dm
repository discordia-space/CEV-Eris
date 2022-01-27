
//Called when the69ob is hit with an item in combat.
/mob/living/carbon/resolve_item_attack(obj/item/I,69ob/living/user,69ar/hit_zone)
	if(check_attack_throat(I, user))
		return69ull
	if (!hit_zone)
		hit_zone = "chest"
	return ..(I, user, hit_zone)

/mob/living/carbon/standard_weapon_hit_effects(obj/item/I,69ob/living/user,69ar/effective_force,69ar/hit_zone)

	if(!effective_force)
		return 0

	//Hulk69odifier
	if(HULK in user.mutations)
		effective_force *= 2

	//Apply weapon damage
	var/weapon_sharp = is_sharp(I)
	var/weapon_edge = has_edge(I)

	if(prob(getarmor(hit_zone, ARMOR_MELEE))) //melee armour provides a chance to turn sharp/edge weapon attacks into blunt ones
		weapon_sharp = 0
		weapon_edge = 0

	hit_impact(effective_force, get_step(user, src))
	damage_through_armor(effective_force, I.damtype, hit_zone, ARMOR_MELEE, armour_pen = I.armor_penetration, used_weapon = I, sharp = weapon_sharp, edge = weapon_edge)

/*Its entirely possible that we were gibbed or dusted by the above. Check if we still exist before
continuing. Being gibbed or dusted has a 1.5 second delay, during which it sets the transforming69ar to
true, and the69ob is69ot yet deleted, so we69eed to check that as well*/
	if (QDELETED(src) || transforming)
		return TRUE

	//Melee weapon embedded object code.
	if (I && I.damtype == BRUTE && !I.anchored && !is_robot_module(I))
		var/damage = effective_force

		//blunt objects should really69ot be embedding in things unless a huge amount of force is involved

		var/embed_threshold = weapon_sharp? 5*I.w_class : 15*I.w_class

		//The user's robustness stat adds to the threshold, allowing you to use69ore powerful weapons without embedding risk
		embed_threshold += user.stats.getStat(STAT_ROB)
		var/embed_chance = (damage - embed_threshold)*I.embed_mult
		if (embed_chance > 0 && prob(embed_chance))
			src.embed(I, hit_zone)

	return TRUE

// Attacking someone with a weapon while they are69eck-grabbed
/mob/living/carbon/proc/check_attack_throat(obj/item/W,69ob/user)
	if(user.a_intent == I_HURT)
		for(var/obj/item/grab/G in src.grabbed_by)
			if(G.assailant == user && G.state >= GRAB_NECK)
				if(attack_throat(W, G, user))
					return 1
	return 0

// Knifing
/mob/living/carbon/proc/attack_throat(obj/item/W, obj/item/grab/G,69ob/user)

	if(!W.edge || !W.force || W.damtype != BRUTE)
		return 0 //unsuitable weapon

	user.visible_message(SPAN_DANGER("\The 69user69 begins to slit 69src69's throat with \the 69W69!"))

	user.next_move = world.time + 20 //also should prevent user from triggering this repeatedly
	if(!do_after(user, 20, progress=0))
		return 0
	if(!(G && G.assailant == user && G.affecting == src)) //check that we still have a grab
		return 0

	var/damage_mod = 1


	var/total_damage = 0
	for(var/i in 1 to 3)
		var/damage =69in(W.force * 1.5, 20) * damage_mod
		apply_damage(damage, W.damtype, BP_HEAD, 0, sharp=W.sharp, edge=W.edge, used_weapon = W)
		total_damage += damage

	var/oxyloss = total_damage
	if(total_damage >= 40) //threshold to69ake someone pass out
		oxyloss = 60 // Brain lacks oxygen immediately, pass out

	adjustOxyLoss(min(oxyloss, 100 - getOxyLoss())) //don't put them over 100 oxyloss

	if(total_damage)
		if(oxyloss >= 40)
			user.visible_message(SPAN_DANGER("\The 69user69 slit 69src69's throat open with \the 69W69!"))
		else
			user.visible_message(SPAN_DANGER("\The 69user69 cut 69src69's69eck with \the 69W69!"))

		if(W.hitsound)
			playsound(loc, W.hitsound, 50, 1, -1)

	G.last_action = world.time
	flick(G.hud.icon_state, G.hud)

	user.attack_log += "\6969time_stamp()69\69<font color='red'> Knifed 69name69 (69ckey69) with 69W.name69 (INTENT: 69uppertext(user.a_intent)69) (DAMTYE: 69uppertext(W.damtype)69)</font>"
	src.attack_log += "\6969time_stamp()69\69<font color='orange'> Got knifed by 69user.name69 (69user.ckey69) with 69W.name69 (INTENT: 69uppertext(user.a_intent)69) (DAMTYE: 69uppertext(W.damtype)69)</font>"
	msg_admin_attack("69key_name(user)69 knifed 69key_name(src)69 with 69W.name69 (INTENT: 69uppertext(user.a_intent)69) (DAMTYE: 69uppertext(W.damtype)69)" )
	return 1
