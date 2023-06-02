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

/mob/living/proc/damage_through_armor(damage = 0, damagetype = BRUTE, def_zone, attack_flag = ARMOR_MELEE, armor_divisor = 1, used_weapon, sharp = FALSE, edge = FALSE, wounding_multiplier, list/dmg_types = list(), return_continuation = FALSE)
	if(damage) // If damage is defined, we add it to the list
		if(!dmg_types[damagetype])
			dmg_types += damagetype
		dmg_types[damagetype] += damage

	if(armor_divisor <= 0)
		armor_divisor = 1
		log_debug("[used_weapon] applied damage to [name] with a nonpositive armor divisor")

	var/total_dmg = 0
	var/dealt_damage = 0

	for(var/dmg_type in dmg_types)
		total_dmg += dmg_types[dmg_type]

	if(!total_dmg)
		return FALSE

	// Determine DR and ADR, armour divisor reduces it
	var/armor = getarmor(def_zone, attack_flag) / armor_divisor
	if(!(attack_flag in list(ARMOR_MELEE, ARMOR_BULLET, ARMOR_ENERGY))) // Making sure BIO and other armor types are handled correctly
		armor /= 5
	var/ablative_armor = getarmorablative(def_zone, attack_flag) / armor_divisor

	var/remaining_armor = armor
	var/remaining_ablative = ablative_armor

	for(var/dmg_type in dmg_types)
		var/dmg = dmg_types[dmg_type]
		if(dmg)
			var/used_armor = 0 // Used for agony calculation, as well as reduction in armour before follow-up attacks

			if(dmg_type in list(BRUTE, BURN, TOX, BLAST)) // Some damage types do not help penetrate armor
				if(remaining_armor)
					var/dmg_armor_difference = dmg - remaining_armor
					var/is_difference_positive = dmg_armor_difference > 0
					used_armor += is_difference_positive ? dmg - dmg_armor_difference : dmg
					remaining_armor = is_difference_positive ? 0 : -dmg_armor_difference
					dmg = is_difference_positive ? dmg_armor_difference : 0
				if(remaining_ablative && dmg)
					var/ablative_difference
					ablative_difference = dmg - remaining_ablative
					var/is_difference_positive = ablative_difference > 0
					used_armor += is_difference_positive ? dmg - ablative_difference : dmg
					remaining_ablative = is_difference_positive ? 0 : -ablative_difference
					dmg = is_difference_positive ? ablative_difference : 0
			else
				dmg = max(dmg - remaining_armor - remaining_ablative, 0)

			if(!(dmg_type == HALLOSS)) // Determine pain from impact
				adjustHalLoss(used_armor * (wounding_multiplier ? wounding_multiplier : 1) * ARMOR_HALLOS_COEFFICIENT * max(0.5, (get_specific_organ_efficiency(OP_NERVE, def_zone) / 100)))

			dmg_types[dmg_type] = dmg // Finally, we adjust the damage passing through
			if(dmg)
				dealt_damage += dmg

				if(dmg_type == HALLOSS)
					dmg = round(dmg * max(0.5, (get_specific_organ_efficiency(OP_NERVE, def_zone) / 100)))
				if(dmg_type == BRUTE)

					if ( (sharp || edge) && prob ( (1 - dmg / dmg_types[dmg_type]) * 100 ) ) // If enough of the brute damage is blocked, sharpness is lost from all followup attacks, this converts damage into crushing as well
						if(wounding_multiplier)
							wounding_multiplier = step_wounding_double(wounding_multiplier) // Implied piercing damage, degrade by two steps (prevents damage duping from <1 multiplier)
						else
							wounding_multiplier = 1 // Crushing multiplier forced
						sharp = FALSE
						edge = FALSE
						armor_message(SPAN_NOTICE("[src] armor deflected the strike!"), // No cut (strike), only bash
										SPAN_NOTICE("Your armor deflects the strike!"))

					if(ishuman(src) && isitem(used_weapon))
						var/mob/living/carbon/human/H = src
						var/obj/item/I = used_weapon
						if((is_carrion(H) || active_mutations.len) && (SANCTIFIED in I.aspects))
							apply_damage(dmg / 2, BURN, def_zone, armor_divisor, wounding_multiplier, sharp, edge, used_weapon)

				apply_damage(dmg, dmg_type, def_zone, armor_divisor, wounding_multiplier, sharp, edge, used_weapon)
				if(ishuman(src) && def_zone && dmg >= 20)
					var/mob/living/carbon/human/H = src
					var/obj/item/organ/external/o = H.get_organ(def_zone)
					if (o && o.status & ORGAN_SPLINTED)
						visible_message(SPAN_WARNING("The splints break off [src] after being hit!"),
								SPAN_WARNING("Your splints break off after being hit!"))
						o.status &= ~ORGAN_SPLINTED
	var/effective_armor = (1 - dealt_damage / total_dmg) * 100


	//Feedback
	//In order to show both target and everyone around that armor is actually working, we are going to send message for both of them
	//Goon/tg chat should take care of spam issue on this one
	switch(effective_armor)
		if(INFINITY to 90)
			armor_message(SPAN_NOTICE("[src] armor absorbs the blow!"),
							SPAN_NOTICE("Your armor absorbed the impact!"))
		if(90 to 74)
			armor_message(SPAN_NOTICE("[src] armor easily absorbs the blow!"),
							SPAN_NOTICE("Your armor reduced the impact greatly!"))
		if(74 to 49)
			armor_message(SPAN_NOTICE("[src] armor absorbs most of the damage!"),
							SPAN_NOTICE("Your armor protects you from the impact!"))
		if(49 to 24)
			armor_message(SPAN_NOTICE("[src] armor reduces the impact by a little."),
							SPAN_NOTICE("Your armor reduced the impact a little."))

	// Deal damage to ablative armour based on how much was used, we multiply armour divisor back so high AP doesn't decrease damage dealt to ADR
	if(ablative_armor)
		damageablative(def_zone, (ablative_armor - remaining_ablative) * armor_divisor)

	//If we have a grab in our hands and get hit with melee damage type, there is a chance we lower our grab's state
	if(attack_flag == ARMOR_MELEE && ishuman(src) && isitem(used_weapon))
		var/mob/living/carbon/human/H = src
		var/obj/item/I = used_weapon
		var/toughness_val = H.stats.getStat(STAT_TGH)

		if(dealt_damage > 10 && prob((dealt_damage - toughness_val * (sharp && edge ? 1 : 0.5) * (I.w_class < ITEM_SIZE_BULKY ? 1 : 0.5))))
			for(var/obj/item/grab/G in get_both_hands(H))
				visible_message(SPAN_NOTICE("[H]'s grab has been weakened!"), SPAN_WARNING("Your grab has been weakened!"))
				G.state--

	// Returns if a projectile should continue travelling
	if(return_continuation)
		var/obj/item/projectile/P = used_weapon
		if(istype(P, /obj/item/projectile/bullet/pellet)) // Pellets should never penetrate
			return PROJECTILE_STOP
		P.damage_types = dmg_types
		if(sharp)
			var/remaining_dmg = 0
			for(var/dmg_type in dmg_types)
				remaining_dmg += dmg_types[dmg_type]
			return ((total_dmg / 2 < remaining_dmg && remaining_dmg > mob_size) ? PROJECTILE_CONTINUE : PROJECTILE_STOP)
		else return PROJECTILE_STOP

	return dealt_damage

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

	var/agony = P.damage_types[HALLOSS] ? P.damage_types[HALLOSS] : 0
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
		return damage_through_armor(def_zone = def_zone_hit, attack_flag = P.check_armour, armor_divisor = P.armor_divisor, used_weapon = P, sharp = is_sharp(P), edge = has_edge(P), wounding_multiplier = P.wounding_mult, dmg_types = P.damage_types, return_continuation = TRUE)

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
/mob/living/proc/hit_with_weapon(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	visible_message(SPAN_DANGER("[src] has been [I.attack_verb.len? pick(I.attack_verb) : "attacked"] with [I.name] by [user]!"))

	standard_weapon_hit_effects(I, user, effective_force, hit_zone)

	if(I.damtype == BRUTE && prob(33)) // Added blood for whacking non-humans too
		var/turf/simulated/location = get_turf(src)
		if(istype(location)) location.add_blood_floor(src)

	return

//returns 0 if the effects failed to apply for some reason, 1 otherwise.
/mob/living/proc/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	if(!effective_force)
		return FALSE

	//Hulk modifier
//	if(HULK in user.mutations)
//		effective_force *= 2

	//Apply weapon damage
	if (damage_through_armor(effective_force, I.damtype, hit_zone, ARMOR_MELEE, I.armor_divisor, used_weapon = I, sharp = is_sharp(I), edge = has_edge(I)))
		return TRUE
	else
		return FALSE

//this proc handles being hit by a thrown atom
/mob/living/hitby(atom/movable/AM as mob|obj,var/speed = THROWFORCE_SPEED_DIVISOR)//Standardization and logging -Sieve
	if(istype(AM,/obj))
		var/obj/O = AM
		var/dtype = O.damtype
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

		damage_through_armor(throw_damage, dtype, null, ARMOR_MELEE, O.armor_divisor, used_weapon = O, sharp = is_sharp(O), edge = has_edge(O))

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
			mass = I.w_class/THROWNOBJ_KNOCKBACK_DIVISOR
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
					src.loc = T
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
