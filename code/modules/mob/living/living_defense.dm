#define ARMOR_HALLOS_COEFFICIENT 0.4


//This calculation replaces old run_armor_check in favor of more complex and better system
//If you need to do something else with armor - just use getarmor() proc and do with those numbers all you want
//Random absorb system was a cancer, and was removed from all across the codebase. Don't recreate it. Clockrigger 2019
#define ARMOR_MESSAGE_COOLDOWN 0.5 SECONDS

/mob/living/var/last_armor_message

/mob/living/proc/armor_message(msg1, msg2)
	if(world.time < last_armor_message)
		return FALSE
	last_armor_message = world.time + ARMOR_MESSAGE_COOLDOWN
	if(msg2)
		visible_message(msg1, msg2)
	else
		show_message(msg1, 1)
/*
ArmorToDam has the following format
	list[armorType]= list(
		list(damType, damValue),
		list(damType2, damValue2),
		...
		)
armorType defines the armorType that will block all the damTypes that it has associated with it.
*/

#define DAMTYPE 1
#define DAMVALUE 2

/mob/living/proc/damage_through_armor(list/armorToDam, defZone, usedWeapon, armorDiv = 1, woundMult = 1, return_continuation = FALSE)
	if(armor_divisor <= 0)
		armor_divisor = 1
		log_debug("[usedWeapon] applied damage to [name] with a nonpositive armor divisor")

	var/totalDmg = 0
	var/dealtDamage = 0

	for(var/armorType in armorToDam)
		for(var/list/damageElement in armorToDam[armorType])
			totalDmg += damageElement[DAMVALUE]

	var/list/atdCopy = deepCopyList(armorToDam)

	if(totalDmg <= 0)
		return FALSE

	/// If we have a def zone.
	if(defZone)
		var/list/atom/damageBlockers = list()
		/// Retrieve all relevanta damage blockers , its why we give them the dmgtypes list
		damageBlockers = getDamageBlockers(armorToDam, armorDiv, woundMult, defZone)

		for(var/atom in damageBlockers)
		/// We are going to order the list to be traversed from right to left , right representing the outermost layers and left the innermost
		/// List for insertion-sort. Upper objects are going to be last , lower ones are going to be first when blocking
		var/list/blockersTemp = list(
			/atom, /// Fallbacks
			/obj/item/organ/internal, /// For when i rework applyDamage
			/mob,
			/obj/item,
			/obj/item/organ/external,
			/obj/item/clothing,
			/obj/item/armor_component,
			/obj/item/robot_parts/robot_component/armour,
		)

		var/list/atom/newBlockers = list()
		for(var/i = length(blockersTemp); i > 1; i--)
			var/path = blockersTemp[i]
			for(var/atom/blocker in damageBlockers)
				if(istype(blocker, path))
					newBlockers |= blocker

		for(var/atom/blocker in newBlockers)
			blocker.blockDamages(armorToDam, armorDiv, woundMult, defZone)
			//message_admins("Using blocker, blocker:[blocker]")
	/// handling for averaging out all armor values
	else
		var/list/relevantTypes = list()
		for(var/armorType in armorToDam)
			relevantTypes.Add(armorType)
		var/list/receivedArmor = getDamageBlockerRatings(relevantTypes)
		for(var/armorType in armorToDam)
			for(var/list/damageElement in armorToDam[armorType])
				damageElement[DAMVALUE] = max(damageElement[DAMVALUE] - receivedArmor[armorType], 0)

	for(var/armorType in armorToDam)
		for(var/i=1 to length(armorToDam[armorType]))
			var/list/damageElement = armorToDam[armorType][i]
			var/blocked = atdCopy[armorType][i][DAMVALUE] - damageElement[DAMVALUE]
			//message_admins("BLOCKED=[blocked]")
			if(damageElement[DAMTYPE] == HALLOSS)
				adjustHalLoss(damageElement[DAMVALUE] + blocked/4)
			else
				// Just a little bit of agony
				adjustHalLoss(blocked/3)
			// too small to be relevant
			if(blocked > damageElement[DAMVALUE] - 1)
				continue
			apply_damage(damageElement[DAMVALUE], damageElement[DAMTYPE], defZone, armorDiv, woundMult, armorType == ARMOR_SLASH, armorType == ARMOR_SLASH, usedWeapon)
			dealtDamage += damageElement[DAMVALUE]



	var/effective_armor = (1 - dealtDamage / totalDmg) * 100

	if(effective_armor > 90)
		armor_message(SPAN_NOTICE("[src] armor absorbs the blow!"), SPAN_NOTICE("Your armor absorbed the impact!"))
		playsound(loc, 'sound/weapons/shield/shieldblock.ogg', 75, 7)
	else if(effective_armor > 74)
		armor_message(SPAN_NOTICE("[src] armor absorbs the blow!"), SPAN_NOTICE("Your armor absorbed the impact!"))
		playsound(loc, 'sound/weapons/shield/shieldblock.ogg', 75, 7)
	else if(effective_armor > 49)
		armor_message(SPAN_NOTICE("[src] armor absorbs most of the damage!"), SPAN_NOTICE("Your armor protects you from the impact!"))
	else if(effective_armor > 24)
		armor_message(SPAN_NOTICE("[src] armor reduces the impact by a little."), SPAN_NOTICE("Your armor reduced the impact a little."))

	if(return_continuation)
		var/obj/item/projectile/P = usedWeapon
		if(istype(P, /obj/item/projectile/bullet/pellet)) // Pellets should never penetrate
			return PROJECTILE_STOP
		P.damage = armorToDam
		if(is_sharp(P))
			var/remaining_dmg = P.get_total_damage()
			return ((totalDmg / 2 < remaining_dmg && remaining_dmg > mob_size) ? PROJECTILE_CONTINUE : PROJECTILE_STOP)
		else
			return PROJECTILE_STOP

	return dealtDamage

#undef DAMVALUE
#undef DAMTYPE


//if null is passed for def_zone, then this should return something appropriate for all zones (e.g. area effect damage)
/mob/living/proc/getarmor(var/def_zone, var/type)
	return FALSE

/mob/living/proc/getarmorablative(var/def_zone, var/type)
	return FALSE

/mob/living/proc/damageablative(var/def_zone, var/damage)
	return FALSE

/mob/living/proc/hit_impact(damage, dir)
	if(incapacitated(INCAPACITATION_DEFAULT|INCAPACITATION_BUCKLED_PARTIALLY))
		return
	shake_animation(damage)

 // return PROJECTILE_CONTINUE if bullet should continue flying
/mob/living/bullet_act(obj/item/projectile/P, var/def_zone_hit)
	var/hit_dir = get_dir(P, src)

	if (P.is_hot() >= HEAT_MOBIGNITE_THRESHOLD)
		IgniteMob()

	if(config.z_level_shooting && P.height) // If the bullet came from above or below, limit what bodyparts can be hit for consistency
		if(resting || lying)
			return PROJECTILE_CONTINUE // Bullet flies overhead

		switch(P.height)
			if(HEIGHT_HIGH)
				def_zone_hit = pick(list(BP_CHEST, BP_HEAD, BP_L_ARM, BP_R_ARM))
			if(HEIGHT_LOW)
				def_zone_hit = pick(list(BP_CHEST, BP_GROIN, BP_L_LEG, BP_R_LEG))

	//Being hit while using a deadman switch
	if(istype(get_active_hand(),/obj/item/device/assembly/signaler))
		var/obj/item/device/assembly/signaler/signaler = get_active_hand()
		if(signaler.deadman && prob(80))
			log_and_message_admins("has triggered a signaler deadman's switch")
			src.visible_message(SPAN_WARNING("[src] triggers their deadman's switch!"))
			signaler.signal()

	var/agony = P.getAllDamType(HALLOSS)
	//Stun Beams
	if(P.taser_effect)
		stun_effect_act(0, agony, def_zone_hit, P)
		to_chat(src, SPAN_WARNING("You have been hit by [P]!"))
		qdel(P)
		return TRUE

	if(P.knockback && hit_dir)
		throw_at(get_edge_target_turf(src, hit_dir), P.knockback, P.knockback)

	P.on_hit(src, def_zone_hit)

	//Armor and damage
	if(!P.nodamage)
		hit_impact(P.get_structure_damage(), hit_dir)
		return damage_through_armor(P.damage, def_zone_hit, P, P.armor_divisor, P.wounding_mult, FALSE)

	return PROJECTILE_CONTINUE

//Handles the effects of "stun" weapons
/mob/living/proc/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone, var/used_weapon)
	flash_pain()

	//For not bloating damage_through_armor here is simple armor calculation for stun time
	var/armor_coefficient = max(0, 1 - getarmor(def_zone, ARMOR_ENERGY) / 100)

	//If armor is 100 or more, we just skeeping it
	if (stun_amount && armor_coefficient)

		Stun(stun_amount * armor_coefficient)
		Weaken(stun_amount * armor_coefficient)
		apply_effect(STUTTER, stun_amount * armor_coefficient)
		apply_effect(EYE_BLUR, stun_amount * armor_coefficient)
		SEND_SIGNAL_OLD(src, COMSIG_LIVING_STUN_EFFECT)

	if (agony_amount && armor_coefficient)

		apply_damage(agony_amount * armor_coefficient, HALLOSS, def_zone, FALSE, FALSE, FALSE, used_weapon)
		apply_effect(STUTTER, agony_amount * armor_coefficient)
		apply_effect(EYE_BLUR, agony_amount * armor_coefficient)

/mob/living/proc/electrocute_act(var/shock_damage, obj/source, var/siemens_coeff = 1)
	  return 0 //only carbon liveforms have this proc

/mob/living/emp_act(severity)
	var/list/L = src.get_contents()
	for(var/obj/O in L)
		O.emp_act(severity)
	..()

/mob/living/proc/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)
	return target_zone

//Called when the mob is hit with an item in combat.
/mob/living/proc/hit_with_weapon(obj/item/I, mob/living/user, list/damages, var/hit_zone)
	visible_message(SPAN_DANGER("[src] has been [I.attack_verb.len? pick(I.attack_verb) : "attacked"] with [I.name] by [user]!"))
	standard_weapon_hit_effects(I, user, damages, hit_zone)
	return

//returns 0 if the effects failed to apply for some reason, 1 otherwise.
/mob/living/proc/standard_weapon_hit_effects(obj/item/I, mob/living/user, list/damages, var/hit_zone)
	if(dhTotalDamage(damages) <= 0)
		return FALSE

	//Hulk modifier
//	if(HULK in user.mutations)
//		effective_force *= 2

	if (damage_through_armor(damages, hit_zone, I, I.armor_divisor, 1, FALSE))
		return TRUE
	else
		return FALSE

//this proc handles being hit by a thrown atom
/mob/living/hitby(atom/movable/AM as mob|obj,var/speed = THROWFORCE_SPEED_DIVISOR)//Standardization and logging -Sieve
	if(istype(AM,/obj))
		var/obj/O = AM
		var/throw_damage = O.throwforce
		var/miss_chance = 15
		if (O.throw_source)
			var/distance = get_dist(O.throw_source, loc)
			miss_chance = max(15*(distance-2), 0)

		if (prob(miss_chance))
			visible_message("\blue \The [O] misses [src] narrowly!")
			playsound(src, "miss_sound", 50, 1, -6)
			return

		if (O.is_hot() >= HEAT_MOBIGNITE_THRESHOLD)
			IgniteMob()

		src.visible_message(SPAN_WARNING("[src] has been hit by [O]."))

		damage_through_armor(list(ARMOR_BLUNT = list(DELEM(BRUTE, throw_damage))), BP_CHEST, AM, O.armor_divisor, 1, FALSE)

		O.throwing = 0		//it hit, so stop moving

		if(ismob(O.thrower))
			var/mob/M = O.thrower
			var/client/assailant = M.client
			if(assailant)
				src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with a [O], thrown by [M.name] ([assailant.ckey])</font>")
				M.attack_log += text("\[[time_stamp()]\] <font color='red'>Hit [src.name] ([src.ckey]) with a thrown [O]</font>")
				if(!ismouse(src))
					msg_admin_attack("[src.name] ([src.ckey]) was hit by a [O], thrown by [M.name] ([assailant.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

		// Begin BS12 momentum-transfer code.
		var/mass = 1.5
		if(istype(O, /obj/item))
			var/obj/item/I = O
			mass = I.volumeClass/THROWNOBJ_KNOCKBACK_DIVISOR
		var/momentum = speed*mass

		if(O.throw_source && momentum >= THROWNOBJ_KNOCKBACK_SPEED)
			var/dir = get_dir(O.throw_source, src)

			visible_message(SPAN_WARNING("[src] staggers under the impact!"),SPAN_WARNING("You stagger under the impact!"))
			src.throw_at(get_edge_target_turf(src,dir),1,momentum)

			if(!O || !src) return

			if(O.sharp) //Projectile is suitable for pinning.
				//Handles embedding for non-humans and simple_animals.
				embed(O)

				var/turf/T = near_wall(dir,2)

				if(T)
					forceMove(T)
					visible_message(SPAN_WARNING("[src] is pinned to the wall by [O]!"),SPAN_WARNING("You are pinned to the wall by [O]!"))
					src.anchored = TRUE
					src.pinned += O

/mob/living/proc/embed(obj/item/O, var/def_zone)
	if(O.wielded)
		return
	if(ismob(O.loc))
		var/mob/living/L = O.loc
		if(!L.unEquip(O, src))
			return
	O.forceMove(src)
	src.embedded += O
	src.visible_message(SPAN_DANGER("\The [O] embeds in the [src]!"))
	src.verbs += /mob/proc/yank_out_object
	O.on_embed(src)

//This is called when the mob is thrown into a dense turf
/mob/living/proc/turf_collision(var/turf/T, var/speed)
	src.take_organ_damage(speed*5)

/mob/living/proc/near_wall(var/direction,var/distance=1)
	var/turf/T = get_step(get_turf(src),direction)
	var/turf/last_turf = src.loc
	var/i = 1

	while(i>0 && i<=distance)
		if(T.density) //Turf is a wall!
			return last_turf
		i++
		last_turf = T
		T = get_step(T,direction)

	return 0

// End BS12 momentum-transfer code.

/mob/living/attack_generic(mob/user, var/damage, var/attack_message)

	if(!damage || !istype(user))
		return

	adjustBruteLoss(damage)
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
	src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [user.name] ([user.ckey])</font>")
	src.visible_message(SPAN_DANGER("[user] has [attack_message] [src]!"))
	user.do_attack_animation(src)
	spawn(1) updatehealth()
	return 1

/mob/living/proc/IgniteMob()
	if(fire_stacks > 0 && !on_fire)
		on_fire = TRUE
		set_light(light_range + 3, l_color = COLOR_RED)
		update_fire()

/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = FALSE
		fire_stacks = 0
		set_light(max(0, light_range - 3))
		update_fire()

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(add_fire_stacks) //Adjusting the amount of fire_stacks we have on person
    fire_stacks = CLAMP(fire_stacks + add_fire_stacks, FIRE_MIN_STACKS, FIRE_MAX_STACKS)

/mob/living/proc/handle_fire()
	if(fire_stacks < 0)
		fire_stacks = min(0, ++fire_stacks) //If we've doused ourselves in water to avoid fire, dry off slowly

	if(!on_fire)
		return 1
	else if(fire_stacks <= 0)
		ExtinguishMob() //Fire's been put out.
		return 1

	var/datum/gas_mixture/G = loc.return_air() // Check if we're standing in an oxygenless environment
	if(G.gas["oxygen"] < 1)
		ExtinguishMob() //If there's no oxygen in the tile we're on, put out the fire
		return 1

	var/turf/location = get_turf(src)
	location.hotspot_expose(fire_burn_temperature(), 50, 1)

/mob/living/fire_act()
	adjust_fire_stacks(2)
	IgniteMob()

/mob/living/proc/get_cold_protection()
	return 0

/mob/living/proc/get_heat_protection()
	return 0

//Finds the effective temperature that the mob is burning at.
/mob/living/proc/fire_burn_temperature()
	if (fire_stacks <= 0)
		return FALSE

	//Scale quadratically so that single digit numbers of fire stacks don't burn ridiculously hot.
	//lower limit of 700 K, same as matches and roughly the temperature of a cool flame.
	return FIRESTACKS_TEMP_CONV(fire_stacks)

/mob/living/proc/reagent_permeability()
	return 1

/mob/living/proc/handle_actions()
	//Pretty bad, i'd use picked/dropped instead but the parent calls in these are nonexistent
	for(var/datum/action/A in actions)
		if(A.CheckRemoval(src))
			A.Remove(src)
	for(var/obj/item/I in src)
		if(I.action_button_name)
			if(!I.action)
				if(I.action_button_is_hands_free)
					I.action = new/datum/action/item_action/hands_free
				else
					I.action = new/datum/action/item_action
				I.action.name = I.action_button_name
				I.action.target = I
				if(I.action_button_proc)
					I.action.action_type = AB_ITEM_PROC
					I.action.procname = I.action_button_proc
					if(I.action_button_arguments)
						I.action.arguments = I.action_button_arguments
			I.action.Grant(src)
	return

/mob/living/update_action_buttons()
	if(!hud_used) return
	if(!client) return

	//if(hud_used.hud_shown != 1)	//Hud toggled to minimal
	//	return

	//client.screen -= hud_used.hide_actions_toggle
	for(var/datum/action/A in actions)
		if(A.button)
			client.screen -= A.button

	/*if(hud_used.action_buttons_hidden)
		if(!hud_used.hide_actions_toggle)
			hud_used.hide_actions_toggle = new(hud_used)
			hud_used.hide_actions_toggle.UpdateIcon()

		if(!hud_used.hide_actions_toggle.moved)
			hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(1)
			//hud_used.SetButtonCoords(hud_used.hide_actions_toggle,1)

		client.screen += hud_used.hide_actions_toggle
		return
*/
	var/button_number = 0
	for(var/datum/action/A in actions)
		button_number++
		if(A.button == null)
			var/obj/screen/movable/action_button/N = new(hud_used)
			N.owner = A
			A.button = N

		var/obj/screen/movable/action_button/B = A.button

		B.UpdateIcon()

		B.name = A.UpdateName()

		client.screen += B

		if(!B.moved)
			B.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number)
			//hud_used.SetButtonCoords(B,button_number)

//	if(button_number > 0)
		/*if(!hud_used.hide_actions_toggle)
			hud_used.hide_actions_toggle = new(hud_used)
			hud_used.hide_actions_toggle.InitialiseIcon(src)
		if(!hud_used.hide_actions_toggle.moved)
			hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number+1)
			//hud_used.SetButtonCoords(hud_used.hide_actions_toggle,button_number+1)
		client.screen += hud_used.hide_actions_toggle*/
