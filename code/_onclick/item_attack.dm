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

/**
 * This is the proc that handles the order of an item_attack.
 *
 * The order of procs called is:
 * * [/atom/proc/tool_act] on the target. If it returns TOOL_ACT_TOOLTYPE_SUCCESS or TOOL_ACT_SIGNAL_BLOCKING, the chain will be stopped.
 * * [/obj/item/proc/pre_attack] on src. If this returns TRUE, the chain will be stopped.
 * * [/atom/proc/attackby] on the target. If it returns TRUE, the chain will be stopped.
 * * [/obj/item/proc/afterattack]. The return value does not matter.
 */
/obj/item/proc/melee_attack_chain(mob/user, atom/target, params)
	// if(tool_behaviour && (target.tool_act(user, src, tool_behaviour, FALSE) & TOOL_ACT_MELEE_CHAIN_BLOCKING))
	// 	return TRUE

	var/pre_attack_result = pre_attack(target, user, params)

	if(pre_attack_result)
		return TRUE

	var/attackby_result = target.attackby(src, user, params)

	if (attackby_result)
		return TRUE

	if(QDELETED(src) || QDELETED(target))
		attack_qdeleted(target, user, TRUE, params)
		return TRUE

	return afterattack(target, user, TRUE, params)

/// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user, modifiers)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	interact(user)


/**
 * Called on the item before it hits something
 *
 * Arguments:
 * * atom/A - The atom about to be hit
 * * mob/living/user - The mob doing the htting
 * * params - click params such as alt/shift etc
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/obj/item/proc/pre_attack(atom/A, mob/living/user, params) //do stuff before attackby!
	if(SEND_SIGNAL(src, COMSIG_ITEM_PRE_ATTACK, A, user, params) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	return FALSE //return TRUE to avoid calling attackby after this proc does stuff

//I would prefer to rename this to attack(), but that would involve touching hundreds of files.
/obj/item/proc/resolve_attackby(atom/A, mob/user, params)
	if(item_flags & ABSTRACT)//Abstract items cannot be interacted with. They're not real.
		return 1
	if (pre_attack(A, user, params))
		return 1 //Returning 1 passes an abort signal upstream
	add_fingerprint(user)
	return A.attackby(src, user, params)

/**
 * Called on an object being hit by an item
 *
 * Arguments:
 * * obj/item/W - The item hitting this atom
 * * mob/user - The wielder of this item
 * * params - click params such as alt/shift etc
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/atom/proc/attackby(obj/item/W, mob/user, params)
	// if(SEND_SIGNAL(src, COMSIG_PARENT_ATTACKBY, W, user, params) & COMPONENT_NO_AFTERATTACK)
	// 	return TRUE
	return FALSE

/atom/movable/attackby(obj/item/I, mob/living/user)
	if(!(I.flags & NOBLUDGEON))
		if(user.client && user.a_intent == I_HELP)
			return

		user.do_attack_animation(src)
		if (I.hitsound)
			playsound(loc, I.hitsound, 50, 1, -1)
		visible_message(SPAN_DANGER("[src] has been hit by [user] with [I]."))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/attackby(obj/item/I, mob/living/user, params)
	return ..() // || ((obj_flags & CAN_BE_HIT) && I.attack_obj(src, user, params))

/mob/living/attackby(obj/item/I, mob/living/user, params)
	if(..())
		return TRUE
	var/surgery_check = can_operate(src, user)
	if(surgery_check && do_surgery(src, user, I, surgery_check)) //Surgery
		return TRUE
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	return I.attack(src, user, user.targeted_organ)

/obj/proc/nt_sword_attack(obj/item/I, mob/living/user)//for sword of truth
	. = FALSE
	if(!istype(I, /obj/item/weapon/tool/sword/nt_sword))
		return FALSE
	var/obj/item/weapon/tool/sword/nt_sword/NT = I
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
			qdel(src)
		. = TRUE

/**
 * Last proc in the [/obj/item/proc/melee_attack_chain]
 *
 * Arguments:
 * * atom/target - The thing that was hit
 * * mob/user - The mob doing the hitting
 * * proximity_flag - is 1 if this afterattack was called on something adjacent, in your square, or on your person.
 * * click_parameters - is the params string from byond [/atom/proc/Click] code, see that documentation.
 */
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target, user, proximity_flag, click_parameters)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_AFTERATTACK, target, user, proximity_flag, click_parameters)

/// Called if the target gets deleted by our attack
/obj/item/proc/attack_qdeleted(atom/target, mob/user, proximity_flag, click_parameters)
	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_QDELETED, target, user, proximity_flag, click_parameters)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK_QDELETED, target, user, proximity_flag, click_parameters)


/**
 * Called from [/mob/living/proc/attackby]
 *
 * Arguments:
 * * mob/living/M - The mob being hit by this item
 * * mob/living/user - The mob hitting with this item
 * * params - Click params of this attack
 */
/obj/item/proc/attack(mob/living/M, mob/living/user, target_zone)
	// var/signal_return = SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, M, user, params)
	// if(signal_return & COMPONENT_CANCEL_ATTACK_CHAIN)
	// 	return TRUE
	// if(signal_return & COMPONENT_SKIP_ATTACK)
	// 	return

	// SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, M, user, params)

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

	user.do_attack_animation(M)

	var/hit_zone = M.resolve_item_attack(src, user, target_zone)
	if(hit_zone)
		apply_hit_effect(M, user, hit_zone)

	// log_combat(user, M, "attacked", src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
	add_fingerprint(user)

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
	if(HULK in user.mutations)
		power *= 2
	target.hit_with_weapon(src, user, power, hit_zone)
	return
