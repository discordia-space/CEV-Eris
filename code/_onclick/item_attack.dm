/*
=== Item Click Call Sequences ===
These are the default click code call sequences used when clicking on stuff with an item.

Atoms:

mob/ClickOn() calls the item's resolve_attackby() proc.
item/resolve_attackby() calls the target atom's attackby() proc.

Mobs:

mob/living/attackby() after checking for surgery, calls the item's attack() proc.
item/attack() generates attack logs, sets click cooldown and calls the mob's attacked_with_item() proc. If you override this, consider whether you need to set a click cooldown, play attack animations, and generate logs yourself.
mob/attacked_with_item() should then do mob-type specific stuff (like determining hit/miss, handling shields, etc) and then possibly call the item's apply_hit_effect() proc to actually apply the effects of being hit.

Item Hit Effects:

item/apply_hit_effect() can be overriden to do whatever you want. However "standard" physical damage based weapons should make use of the target mob's hit_with_weapon() proc to
avoid code duplication. This includes items that may sometimes act as a standard weapon in addition to having other effects (e.g. stunbatons on harm intent).
*/

// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	return


// Called at the start of resolve_attackby(), before the actual attack.
// Return a nonzero value to abort the attack
/obj/item/proc/pre_attack(atom/a, mob/user, var/params)
	return

//I would prefer to rename this to attack(), but that would involve touching hundreds of files.
/obj/item/proc/resolve_attackby(atom/A, mob/user, params)
	if(item_flags & ABSTRACT)//Abstract items cannot be interacted with. They're not real.
		return 1
	if (pre_attack(A, user, params))
		return 1 //Returning 1 passes an abort signal upstream
	add_fingerprint(user)
	if(ishuman(user))//monkeys can use items, unfortunately
		var/mob/living/carbon/human/H = user
		if(H.blocking)
			H.stop_blocking()
	if(ishuman(user) && !(user == A) && !(user.loc == A) && (w_class >=  ITEM_SIZE_NORMAL) && wielded && user.a_intent == I_HURT && !istype(src, /obj/item/gun) && !istype(A, /obj/structure) && !istype(A, /turf/simulated/wall) && A.loc != user)
		swing_attack(A, user, params)
		if(istype(A, /turf/simulated/floor)) // shitty hack so you can attack floors while wielding a large weapon
			return A.attackby(src, user, params)
		return 1 //Swinging calls its own attacks
	return A.attackby(src, user, params)

//Returns TRUE if attack is to be carried out, FALSE otherwise.
/obj/item/proc/double_tact(mob/user, atom/atom_target, adjacent)
	if(atom_target.loc == user)//putting stuff in your backpack, or something else on your person?
		return TRUE //regular bags won't even be able to hold items this big, but who knows
	if((w_class >= ITEM_SIZE_HUGE || (w_class == ITEM_SIZE_BULKY && !wielded)) && !abstract && !istype(src, /obj/item/gun) && !no_double_tact)//grabs have colossal w_class. You can't raise something that does not exist.
		if(!adjacent || istype(atom_target, /turf) || istype(atom_target, /mob) || user.a_intent == I_HURT)//guns have the point blank privilege
			if(!ready)
				user.visible_message(SPAN_DANGER("[user] raises [src]!"))
				ready = TRUE
				var/obj/effect/effect/melee/alert/A = new()
				user.vis_contents += A
				qdel(A)
				var/unready_time = world.time + (10 SECONDS)
				while(world.time < unready_time)
					sleep(1)
					if(!(ready))
						user.vis_contents -= A
						return FALSE
					if(!(is_equipped()))
						ready = FALSE
						user.vis_contents -= A
						return FALSE
				user.visible_message(SPAN_NOTICE("[user] lowers \his [src]."))
				ready = FALSE
				user.vis_contents -= A
				return FALSE
			else
				ready = FALSE
				return TRUE
		else
			return TRUE
	else
		return TRUE


/obj/item/proc/swing_attack(atom/A, mob/user, params)
	var/holdinghand = user.get_inventory_slot(src)
	var/turf/R
	var/turf/C
	var/turf/L
	if(A.x == 0 && A.y == 0 && A.z == 0) //Attacking equipped items results in them getting forwarded
		C = get_turf(user)
	else
		C = get_turf(A)
	var/_dir
	if(C == get_turf(user)) //If turf matches with user, move the attack towards where the user is facing
		_dir = user.dir
		C = get_step(C, _dir)
	else
		_dir = get_dir(user, A)
	switch(_dir)
		if(NORTH)
			R = get_step(C, EAST)
			L = get_step(C, WEST)
		if(SOUTH)
			R = get_step(C, WEST)
			L = get_step(C, EAST)
		if(EAST)
			R = get_step(C, SOUTH)
			L = get_step(C, NORTH)
		if(WEST)
			R = get_step(C, NORTH)
			L = get_step(C, SOUTH)
		if(NORTHEAST)
			R = get_step(C, SOUTH)
			L = get_step(C, WEST)
		if(NORTHWEST)
			R = get_step(C, EAST)
			L = get_step(C, SOUTH)
		if(SOUTHEAST)
			R = get_step(C, WEST)
			L = get_step(C, NORTH)
		if(SOUTHWEST)
			R = get_step(C, NORTH)
			L = get_step(C, EAST)
	var/obj/effect/effect/melee/swing/S = new(user.loc)
	S.dir = _dir
	user.visible_message(SPAN_DANGER("[user] swings \his [src]"))
	playsound(loc, 'sound/effects/swoosh.ogg', 50, 1, -1)
	switch(holdinghand)
		if(slot_l_hand)
			flick("left_swing", S)
			var/dmg_modifier = 1
			dmg_modifier = tileattack(user, L, modifier = 1)
			dmg_modifier = tileattack(user, C, modifier = dmg_modifier, original_target = A)
			tileattack(user, R, modifier = dmg_modifier)
			QDEL_IN(S, 2 SECONDS)
		if(slot_r_hand)
			flick("right_swing", S)
			var/dmg_modifier = 1
			dmg_modifier = tileattack(user, R, modifier = 1)
			dmg_modifier = tileattack(user, C, modifier = dmg_modifier, original_target = A)
			tileattack(user, L, modifier = dmg_modifier)
			QDEL_IN(S, 2 SECONDS)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/atom/proc/attackby(obj/item/W, mob/user, params)
	return

/atom/movable/attackby(obj/item/I, mob/living/user)
	if(!(I.flags & NOBLUDGEON))
		if(user.client && user.a_intent == I_HELP)
			return

		user.do_attack_animation(src)
		if (I.hitsound)
			playsound(loc, I.hitsound, 50, 1, -1)
		visible_message(SPAN_DANGER("[src] has been hit by [user] with [I]."))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

// meant for handling stuff when destroyed
/obj/proc/nt_sword_handle()
	return FALSE

/obj/proc/nt_sword_attack(obj/item/I, mob/living/user)//for sword of truth
	. = FALSE
	if(!istype(I, /obj/item/tool/sword/nt_sword))
		return FALSE
	var/obj/item/tool/sword/nt_sword/NT = I
	if(user.a_intent != I_HURT)
		to_chat(user, SPAN_NOTICE("You need to be in a harming stance."))
		return FALSE
	if(NT.isBroken)
		return FALSE
	if(!(NT.flags & NOBLUDGEON))
		if(user.a_intent == I_HELP)
			return FALSE
		user.do_attack_animation(src)
		if (NT.hitsound)
			playsound(loc, I.hitsound, 50, 1, -1)
		visible_message(SPAN_DANGER("[src] has been hit by [user] with [NT]."))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		for(var/mob/living/carbon/human/H in viewers(user))
			SEND_SIGNAL_OLD(H, SWORD_OF_TRUTH_OF_DESTRUCTION, src)
		if(eotp)
			eotp.addObservation(200)
			eotp.power_gaine *= 2
			eotp.max_observation *= 1.25
			eotp.armaments_rate *= 2
			eotp.max_armaments_points *= 2
		nt_sword_handle()
		qdel(src)

		. = TRUE


/obj/item/attackby(obj/item/I, mob/living/user, var/params)
	return

/mob/living/attackby(obj/item/I, mob/living/user, var/params)
	if(!ismob(user))
		return FALSE
	var/surgery_check = can_operate(src, user)
	if(surgery_check && do_surgery(src, user, I, surgery_check)) //Surgery
		return TRUE
	else
		return I.attack(src, user, user.targeted_organ)

//Used by Area of effect attacks, if it returns FALSE, it failed
/obj/item/proc/attack_with_multiplier(mob/living/user, var/atom/target, var/modifier = 1)
	if(!wielded && modifier > 0)
		return FALSE
	var/original_force = force
	var/original_unwielded_force = force_wielded_multiplier ? force / force_wielded_multiplier : force / 1.3
	force *= modifier
	target.attackby(src, user)
	force = wielded ? original_force : round(original_unwielded_force, 1)
	return TRUE

//Same as above but for mobs
/obj/item/proc/attack_with_multiplier_mob(mob/living/user, var/mob/living/target, var/modifier = 1)
	if(!wielded && modifier > 0)
		return FALSE
	var/original_force = force
	var/original_unwielded_force = force_wielded_multiplier ? force / force_wielded_multiplier : force / 1.3
	force *= modifier
	attack(target, user, user.targeted_organ)
	force = wielded ? original_force : round(original_unwielded_force, 1)
	return TRUE

//Area of effect attacks (swinging), return remaining damage
/obj/item/proc/tileattack(mob/living/user, turf/targetarea, var/modifier = 1, var/swing_degradation = 0.2, var/original_target)
	if(istype(targetarea, /turf/simulated/wall))
		var/turf/simulated/W = targetarea
		if(attack_with_multiplier(user, W, modifier))
			return (modifier - swing_degradation) // We hit a static object, prevents hitting anything underneath
	var/successful_hit = FALSE
	for(var/obj/S in targetarea)
		if (S.density && !istype(S, /obj/structure/table) && !istype(S, /obj/machinery/disposal) && !istype(S, /obj/structure/closet))
			if(attack_with_multiplier(user, S, modifier))
				successful_hit = TRUE // Livings or targeted mobs can still be hit
	if(successful_hit)
		modifier -= swing_degradation // Only deduct damage once for dense objects
	var/list/living_mobs = new/list()
	var/list/dead_mobs = new/list()
	for(var/mob/living/M in targetarea)
		if(M != user)
			if(M.stat == DEAD)
				dead_mobs.Add(M)
			else
				living_mobs.Add(M)
	var/mob/living/target
	if(original_target && istype(original_target, /mob/living)) // Check if original target is a mob
		if(LAZYFIND(living_mobs, original_target) || LAZYFIND(dead_mobs, original_target)) // Check if original target is a mob on this tile
			target = original_target
			if(attack_with_multiplier_mob(user, target, modifier))
				modifier -= swing_degradation
			if(target.density) // If the original target was dense, the rest of the mobs are shielded
				return modifier

	while(living_mobs.len && modifier > 0)
		target = pick_n_take(living_mobs)
		if(attack_with_multiplier_mob(user, target, modifier))
			modifier -= swing_degradation
		successful_hit = TRUE
		if(target.density) // If we hit a dense target, the rest of the mobs are shielded
			return modifier
	if(!successful_hit && dead_mobs.len) // If we hit nothing, try to hit dead mobs
		target = pick(dead_mobs)
		if(attack_with_multiplier_mob(user, target, modifier))
			modifier -= swing_degradation
	return modifier
// modifying force after calling attack() here is a bad idea, as the force can be changed by means of embedding in a target, which leads to unwielding a weapon.
//This code replicates the damage reduction caused by unwielding something, but it will likely cause problems elsewhere.

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/A as mob|obj|turf|area, mob/user, proximity, params)
	if((!proximity && !ismob(A)) || !wielded || !extended_reach)//extended reach is only for mobs when you wield the spear
		return
	if(get_dist(user.loc, A.loc) < 3)//okay, we are in reach, now we need to check if there is anything dense in our path
		var/turf/T = get_step(user.loc, get_dir(user, A))
		if(T.Enter(user))
			resolve_attackby(A, user, params)
	return

//I would prefer to rename this attack_as_weapon(), but that would involve touching hundreds of files.
/obj/item/proc/attack(mob/living/M, mob/living/user, target_zone)
	if(!force || (flags & NOBLUDGEON))
		return FALSE

	if(!user)
		return FALSE

	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	if(!no_attack_log)
		user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
		msg_admin_attack("[key_name(user)] attacked [key_name(M)] with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])" )
	/////////////////////////

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	var/hit_zone = M.resolve_item_attack(src, user, target_zone)
	if(hit_zone)
		apply_hit_effect(M, user, hit_zone)

	return TRUE

//Called when a weapon is used to make a successful melee attack on a mob. Returns the blocked result
/obj/item/proc/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(hitsound)
		playsound(loc, hitsound, 50, 1, -1)

	if (is_hot() >= HEAT_MOBIGNITE_THRESHOLD)
		target.IgniteMob()

	var/power = force
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		power *= H.damage_multiplier
		if(H.holding_back)
			power /= 2
//	if(HULK in user.mutations)
//		power *= 2
	target.hit_with_weapon(src, user, power, hit_zone)
	return
