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

//Handles double tact weapons, returns TRUE if attack is to be carried out, FALSE otherwise
/obj/item/proc/double_tact(mob/user)
	if(doubletact)
		if(!(ready))
			user.visible_message(SPAN_DANGER("[user] raises \his [src]"))
			ready = TRUE
			var/obj/effect/effect/melee/alerts/A = new()
			user.vis_contents += A
			qdel(A)
			var/endtime = world.time + (10 SECONDS)
			while(world.time < endtime)
				sleep(1)
				if(!(ready))
					user.vis_contents -= A
					return FALSE
				if(!(is_equipped()))
					ready = FALSE
					user.vis_contents -= A
					return FALSE
			user.visible_message(SPAN_DANGER("[user] lowers \his [src]"))
			ready = FALSE
			user.vis_contents -= A
			return FALSE
		else
			ready = FALSE
			return TRUE
	else
		return TRUE


//I would prefer to rename this to attack(), but that would involve touching hundreds of files.
/obj/item/proc/resolve_attackby(atom/A, mob/user, params)
	if(item_flags & ABSTRACT)//Abstract items cannot be interacted with. They're not real.
		return 1
	if (pre_attack(A, user, params))
		return 1 //Returning 1 passes an abort signal upstream
	add_fingerprint(user)

	if(ishuman(user) && !(user == A)) //Swinging
		var/mob/living/carbon/human/H = user
		if(can_swing)
			if(wielded)
				if(H.a_intent == I_HURT)
					if(!double_tact(user))
						return
					var/holdinghand = user.get_inventory_slot(src)
					var/turf/R
					var/turf/C
					var/turf/L
					C = locate(A.x, A.y, A.z)
					var/dir = get_dir(H, A)
					switch(dir)
						if(NORTH, SOUTH)
							R = locate((A.x + 1), A.y, A.z)
							L = locate((A.x - 1), A.y, A.z)
						if(EAST)
							R = locate(A.x, (A.y - 1), A.z)
							L = locate(A.x, (A.y + 1), A.z)
						if(NORTHEAST)
							R = locate(A.x, (A.y - 1), A.z)
							L = locate((A.x - 1), A.y, A.z)
						if(SOUTHEAST)
							R = locate((A.x - 1), A.y, A.z)
							L = locate(A.x, (A.y + 1), A.z)
						if(WEST)
							R = locate(A.x, (A.y + 1), A.z)
							L = locate(A.x, (A.y - 1), A.z)
						if(NORTHWEST)
							R = locate((A.x + 1), A.y, A.z)
							L = locate(A.x, (A.y - 1), A.z)
						if(SOUTHWEST)
							R = locate(A.x, (A.y + 1), A.z)
							L = locate((A.x + 1), A.y, A.z)
					var/obj/effect/effect/melee/swing/S = new(locate(H.x, H.y, H.z))
					S.dir = dir
					user.visible_message(SPAN_DANGER("[user] swings \his [src]"))
					playsound(loc, 'sound/effects/swoosh.ogg', 50, 1, -1)
					if(holdinghand == slot_l_hand)
						flick("left_swing", S)
						tileattack(user, L, modifier = 1)
						tileattack(user, C, modifier = 0.8)
						tileattack(user, R, modifier = 0.6)
						QDEL_IN(S, 20)
						return
					else if(holdinghand == slot_r_hand)
						flick("right_swing", S)
						tileattack(user, R, modifier = 1)
						tileattack(user, C, modifier = 0.8)
						tileattack(user, L, modifier = 0.6)
						QDEL_IN(S, 20)
						return

	return A.attackby(src, user, params)

// No comment
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

/obj/proc/nt_sword_attack(obj/item/I, mob/living/user)//for sword of truth
	. = FALSE
	if(!istype(I, /obj/item/tool/sword/nt_sword))
		return FALSE
	var/obj/item/tool/sword/nt_sword/NT = I
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
		if(prob(10))
			for(var/mob/living/carbon/human/H in viewers(user))
				SEND_SIGNAL(H, SWORD_OF_TRUTH_OF_DESTRUCTION, src)
				if(eotp)
					eotp.addObservation(200)
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
	if(!I.double_tact(user))
		return
	return I.attack(src, user, user.targeted_organ)

//Handles AOE attacking on tiles
/obj/item/proc/tileattack(mob/living/user, turf/targetarea, modifier = 1)
	var/original_force = force
	force *= modifier
	if(istype(targetarea, /turf/simulated/wall))
		var/turf/simulated/W = targetarea
		W.attackby(src, user)
		force = original_force
		return
	for(var/obj/S in targetarea)
		if (S.density && !istype(S, /obj/structure/table) && !istype(S, /obj/machinery/disposal))
			S.attackby(src, user)
	var/list/T = new/list()
	for(var/mob/living/M in targetarea)
		if(M.stat != DEAD)
			T.Add(M)
	if(T.len)
		var/target = pick(T)
		attack(target, user, user.targeted_organ)
		force = original_force
		return
	else
		for(var/mob/living/M in targetarea)
			T.Add(M)
		if(T.len)
			var/target = pick(T)
			attack(target, user, user.targeted_organ)
		force = original_force

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, params)
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
//	if(HULK in user.mutations)
//		power *= 2
	target.hit_with_weapon(src, user, power, hit_zone)
	return
