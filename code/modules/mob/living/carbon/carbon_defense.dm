
//Called when the mob is hit with an item in combat.
/mob/living/carbon/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)
	for (var/obj/item/grab/G in grabbed_by)
		if(G.resolve_item_attack(user, I, target_zone))
			return null
	if (!target_zone)
		target_zone = "chest"
	return ..(I, user, target_zone)

/mob/living/carbon/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/hit_zone)
	if(!effective_force || blocked >= 2)
		return 0

	//Hulk modifier
	if(HULK in user.mutations)
		effective_force *= 2

	//Apply weapon damage
	var/weapon_sharp = is_sharp(I)
	var/weapon_edge = has_edge(I)
	if(prob(getarmor(hit_zone, "melee"))) //melee armour provides a chance to turn sharp/edge weapon attacks into blunt ones
		weapon_sharp = 0
		weapon_edge = 0

	apply_damage(effective_force, I.damtype, hit_zone, blocked, sharp=weapon_sharp, edge=weapon_edge, used_weapon=I)

/*Its entirely possible that we were gibbed or dusted by the above. Check if we still exist before
continuing. Being gibbed or dusted has a 1.5 second delay, during which it sets the transforming var to
true, and the mob is not yet deleted, so we need to check that as well*/
	if (QDELETED(src) || transforming)
		return TRUE

	//Melee weapon embedded object code.
	if (I && I.damtype == BRUTE && !I.anchored && !is_robot_module(I))
		var/damage = effective_force
		if (blocked)
			damage /= blocked+1

		//blunt objects should really not be embedding in things unless a huge amount of force is involved

		var/embed_threshold = weapon_sharp? 5*I.w_class : 15*I.w_class

		//The user's robustness stat adds to the threshold, allowing you to use more powerful weapons without embedding risk
		embed_threshold += user.stats.getStat(STAT_ROB)
		var/embed_chance = (damage - embed_threshold)*I.embed_mult
		if (embed_chance > 0 && prob(embed_chance))
			src.embed(I, hit_zone)

	return 1
