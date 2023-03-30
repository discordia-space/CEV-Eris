/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEM_SIZE_GARGANTUAN
	spawn_frequency = 10
	rarity_value = 10
	//spawn_tags = SPAWN_TAG_STRUCTURE
	bad_type = /obj/structure
	var/health = 100
	var/maxHealth = 100
	var/explosion_coverage = 0
	var/climbable
	var/breakable
	var/parts
	var/list/climbers = list()

/obj/structure/proc/get_health_ratio()
	if(health)
		return health/maxHealth
	else
		return 1/maxHealth

// Should  always return the amount of damage done
/obj/structure/proc/take_damage(damage)
	// Blocked amount
	. = health - damage < 0 ? damage - (damage - health) : damage
	. *= explosion_coverage
	health -= damage
	if(health < 0)
		qdel(src)
	return



/**
 * An overridable proc used by SSfalling to determine whether if the object deals
 * mimimal dmg or their w_class * 10
 *
 * @return	ITEM_SIZE_TINY * 10 	if w_class is not defined in subtypes structures
 *			w_class * 10 			if w_class is set
 *
 * Values are found in code/__defines/inventory_sizes.dm
 */
/obj/structure/get_fall_damage(var/turf/from, var/turf/dest)
	var/damage = w_class * 10 * get_health_ratio()

	if (from && dest)
		damage *= abs(from.z - dest.z)

	return damage

/obj/structure/Destroy()
	if(parts)
		new parts(loc)
	. = ..()

/obj/structure/attack_hand(mob/user)
	if(breakable)
//		if(HULK in user.mutations)
//			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
//			attack_generic(user,1,"smashes")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")

	if(climbers.len && !(user in climbers))
		user.visible_message(SPAN_WARNING("[user.name] shakes \the [src]."), \
					SPAN_NOTICE("You shake \the [src]."))
		structure_shaken()

	return ..()

/obj/structure/attack_tk()
	return

/obj/structure/explosion_act(target_power, explosion_handler/handler)
	var/absorbed = take_damage(target_power)
	return absorbed

/obj/structure/New()
	..()
	if(climbable)
		verbs += /obj/structure/proc/climb_on

/obj/structure/proc/climb_on()

	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set category = "Object"
	set src in oview(1)

	do_climb(usr)

/obj/structure/MouseDrop_T(mob/target, mob/user)

	var/mob/living/H = user
	if(istype(H) && can_climb(H) && target == user)
		do_climb(target)
	else
		return ..()

/obj/structure/proc/can_climb(var/mob/living/user, post_climb_check=0)
	if (!climbable || !can_touch(user) || (!post_climb_check && (user in climbers)))
		return 0

	if (!user.Adjacent(src))
		to_chat(user, SPAN_DANGER("You can't climb there, the way is blocked."))
		return 0

	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(user, SPAN_DANGER("There's \a [occupied] in the way."))
		return 0
	return 1

/obj/structure/proc/turf_is_crowded()
	var/turf/T = get_turf(src)
	if(!T || !istype(T))
		return 0
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			var/obj/structure/S = O
			if(S.climbable) continue
		//ON_BORDER structures are handled by the Adjacent() check.
		if(O && O.density && !(O.flags & ON_BORDER))
			return O
	return 0

/obj/structure/proc/neighbor_turf_passable()
	var/turf/T = get_step(src, src.dir)
	if(!T || !istype(T))
		return 0
	if(T.density)
		return 0
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			if(istype(O,/obj/structure/railing))
				return 1
			else if(O.density)
				return 0
	return 1

/obj/structure/proc/do_climb(mob/living/user)
	if (!can_climb(user))
		return

	user.visible_message(SPAN_WARNING("[user] starts climbing onto \the [src]!"))
	climbers |= user

	var/delay = (issmall(user) ? 20 : 34) * user.mod_climb_delay
	var/duration = max(delay * user.stats.getMult(STAT_VIG, STAT_LEVEL_EXPERT), delay * 0.66)
	if(!do_after(user, duration, src))
		climbers -= user
		return

	if (!can_climb(user, post_climb_check=1))
		climbers -= user
		return

	user.forceMove(get_turf(src))

	if (get_turf(user) == get_turf(src))
		user.visible_message(SPAN_WARNING("[user] climbs onto \the [src]!"))
	climbers -= user
	add_fingerprint(user)

/obj/structure/proc/structure_shaken()
	for(var/mob/living/M in climbers)
		M.Weaken(1)
		to_chat(M, SPAN_DANGER("You topple as you are shaken off \the [src]!"))
		climbers.Cut(1,2)

	for(var/mob/living/M in get_turf(src))
		if(M.lying) return //No spamming this on people.

		M.Weaken(3)
		to_chat(M, SPAN_DANGER("You topple as \the [src] moves under you!"))

		if(prob(25))

			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, SPAN_DANGER("You land heavily!"))
				M.adjustBruteLoss(damage)
				return

			var/obj/item/organ/external/affecting

			switch(pick(list("head","knee","elbow")))
				if("knee")
					affecting = H.get_organ(pick(BP_L_LEG , BP_R_LEG))
				if("elbow")
					affecting = H.get_organ(pick(BP_L_ARM, BP_R_ARM))
				if("head")
					affecting = H.get_organ(BP_HEAD)

			if(affecting)
				to_chat(M, SPAN_DANGER("You land heavily on your [affecting.name]!"))
				affecting.take_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				to_chat(H, SPAN_DANGER("You land heavily!"))
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/obj/structure/proc/can_touch(var/mob/user)
	if (!user)
		return 0
	if(!Adjacent(user))
		return 0
	if (user.restrained() || user.buckled)
		to_chat(user, SPAN_NOTICE("You need your hands and legs free for this."))
		return 0
	if (user.stat || user.paralysis || user.sleeping || user.lying || user.weakened)
		return 0
	if (issilicon(user))
		to_chat(user, SPAN_NOTICE("You need hands for this."))
		return 0
	return 1

/obj/structure/attack_generic(var/mob/user, var/damage, var/attack_verb, var/wallbreaker)
	if(!breakable || !damage || !wallbreaker)
		return 0
	visible_message(SPAN_DANGER("[user] [attack_verb] the [src] apart!"))
	attack_animation(user)
	spawn(1) qdel(src)
	return 1
