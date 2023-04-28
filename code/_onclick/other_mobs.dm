// Generic damage proc (slimes and monkeys).
/atom/proc/attack_generic(mob/user as mob)
	return 0

/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/human/UnarmedAttack(atom/A, proximity)

	if(!..())
		return

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	if(istype(G) && G.Touch(A, 1))
		return

	A.attack_hand(src)

/atom/proc/attack_hand(mob/user)
	. = FALSE
	// if(!(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND))
	// 	add_fingerprint(user)
	// if(SEND_SIGNAL_OLD(src, COMSIG_ATOM_ATTACK_HAND, user, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
	// 	. = TRUE
	// if(interaction_flags_atom & INTERACT_ATOM_ATTACK_HAND)
	. = _try_interact(user)

//Return a non FALSE value to cancel whatever called this from propagating, if it respects it.
/atom/proc/_try_interact(mob/user)
	if(is_admin(user) && isghost(user)) //admin abuse
		return interact(user)
	if(can_interact(user))
		return interact(user)
	return FALSE

/atom/proc/can_interact(mob/user, require_adjacent_turf = TRUE)
	// if(!user.can_interact_with(src, interaction_flags_atom & INTERACT_ATOM_ALLOW_USER_LOCATION))
	// 	return FALSE
	// if((interaction_flags_atom & INTERACT_ATOM_REQUIRES_DEXTERITY) && !ISADVANCEDTOOLUSER(user))
	// 	to_chat(user, span_warning("You don't have the dexterity to do this!"))
	// 	return FALSE
	// BANAID: advanced tool usrs can only interact uis
	if(!user.IsAdvancedToolUser())
		to_chat(user, span_warning("You don't have the dexterity to do this!"))
		return FALSE

	// if(!(interaction_flags_atom & INTERACT_ATOM_IGNORE_INCAPACITATED))
	// 	var/ignore_flags = NONE
	// 	if(interaction_flags_atom & INTERACT_ATOM_IGNORE_RESTRAINED)
	// 		ignore_flags |= IGNORE_RESTRAINTS
	// 	if(!(interaction_flags_atom & INTERACT_ATOM_CHECK_GRAB))
	// 		ignore_flags |= IGNORE_GRAB

	// 	if(user.incapacitated(ignore_flags))
	// 		return FALSE
	return TRUE

/atom/ui_status(mob/user)
	. = ..()
	//Check if both user and atom are at the same location
	if(!can_interact(user))
		. = min(., UI_UPDATE)

/atom/movable/can_interact(mob/user)
	. = ..()
	if(!.)
		return
	// if(!anchored && (interaction_flags_atom & INTERACT_ATOM_REQUIRES_ANCHORED))
	// 	return FALSE

/atom/proc/interact(mob/user)
	// Eugh. Wont implement interaction_flags_atom yet so here u go.
	add_fingerprint(user)
	return ui_interact(user)

	// if(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_INTERACT)
	// 	add_hiddenprint(user)
	// else
	// 	add_fingerprint(user)
	// if(interaction_flags_atom & INTERACT_ATOM_UI_INTERACT)
	// 	SEND_SIGNAL_OLD(src, COMSIG_ATOM_UI_INTERACT, user)
	// 	return ui_interact(user)
	// return FALSE

/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/human/RangedAttack(var/atom/A)
	if((istype(A, /turf/simulated/floor) || istype(A, /obj/structure/catwalk)) && isturf(loc) && shadow && !is_physically_disabled()) //Climbing through openspace
		var/turf/T = get_turf(A)
		if(T.Adjacent(shadow))
			for(var/obj/structure/S in shadow.loc)
				if(S.density)
					return

			var/list/objects_to_stand_on = list(
				/obj/item/stool,
				/obj/structure/bed,
				/obj/structure/table,
				/obj/structure/closet/crate
			)
			var/atom/helper
			var/area/location = get_area(loc)
			if(!location.has_gravity)
				helper = src
			else
				for(var/type in objects_to_stand_on)
					helper = locate(type) in src.loc
					if(helper)
						break
				if(!helper)
					return

			visible_message(SPAN_WARNING("[src] starts climbing onto \the [A]!"))
			shadow.visible_message(SPAN_WARNING("[shadow] starts climbing onto \the [A]!"))
			var/delay = 50
			if(do_after(src, max(delay * src.stats.getMult(STAT_VIG, STAT_LEVEL_EXPERT), delay * 0.66), helper))
				visible_message(SPAN_WARNING("[src] climbs onto \the [A]!"))
				shadow.visible_message(SPAN_WARNING("[shadow] climbs onto \the [A]!"))
				src.Move(T)
			else
				visible_message(SPAN_WARNING("[src] gives up on trying to climb onto \the [A]!"))
				shadow.visible_message(SPAN_WARNING("[shadow] gives up on trying to climb onto \the [A]!"))
			return

	//PERK_ABSOLUTE_GRAB
	if(get_dist_euclidian(get_turf(A), get_turf(src)) < 4 && ishuman(A))
		if(stats.getPerk(PERK_ABSOLUTE_GRAB) && a_intent == I_GRAB)
			leap(A)
			return

//	if((LASER in mutations) && a_intent == I_HURT)
//		LaserEyes(A) // moved into a proc below
	if(get_active_mutation(src, MUTATION_TELEKINESIS))
		A.attack_tk(src)

/mob/living/RestrainedClickOn(var/atom/A)
	return

/*
	Slimes
	Nothing happening here
*/

/mob/living/carbon/slime/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/slime/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return

	// Eating
	if(Victim)
		if (Victim == A)
			Feedstop()
		return

	var/mob/living/M = A
	if (istype(M))

		switch(src.a_intent)
			if (I_HELP) // We just poke the other
				M.visible_message(SPAN_NOTICE("[src] gently pokes [M]!"), SPAN_NOTICE("[src] gently pokes you!"))
			if (I_DISARM) // We stun the target, with the intention to feed
				var/stunprob = 1
				var/power = max(0, min(10, (powerlevel + rand(0, 3))))
				if (powerlevel > 0 && !isslime(A))
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						stunprob *= H.species.siemens_coefficient


					switch(power * 10)
						if(0) stunprob *= 10
						if(1 to 2) stunprob *= 20
						if(3 to 4) stunprob *= 30
						if(5 to 6) stunprob *= 40
						if(7 to 8) stunprob *= 60
						if(9) 	   stunprob *= 70
						if(10) 	   stunprob *= 95

				if(prob(stunprob))
					powerlevel = max(0, powerlevel-3)
					M.visible_message(SPAN_DANGER("[src] has shocked [M]!"), SPAN_DANGER("[src] has shocked you!"))
					M.Weaken(power)
					M.Stun(power)
					M.stuttering = max(M.stuttering, power)

					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, M)
					s.start()

					if(prob(stunprob) && powerlevel >= 8)
						M.adjustFireLoss(powerlevel * rand(6, 10))
				else if(prob(40))
					M.visible_message(SPAN_DANGER("[src] has pounced at [M]!"), SPAN_DANGER("[src] has pounced at you!"))
					M.Weaken(power)
				else
					M.visible_message(SPAN_DANGER("[src] has tried to pounce at [M]!"), SPAN_DANGER("[src] has tried to pounce at you!"))
				M.updatehealth()
			if (I_GRAB) // We feed
				Wrap(M)
			if (I_HURT) // Attacking
				A.attack_generic(src, (is_adult ? rand(20, 40) : rand(5, 25)), "glomped")
	else
		A.attack_generic(src, (is_adult ? rand(20, 40) : rand(5, 25)), "glomped") // Basic attack.
/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/new_player/ClickOn()
	return

/*
	Animals
*/
/mob/living/simple_animal/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return

	if(melee_damage_upper == 0 && isliving(A))
		custom_emote(1, "[friendly] [A]!")
		return

	var/damage = rand(melee_damage_lower, melee_damage_upper)
	if(A.attack_generic(src, damage, attacktext, environment_smash) && loc && attack_sound)
		playsound(loc, attack_sound, 50, 1, 1)
