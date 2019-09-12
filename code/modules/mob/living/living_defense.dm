#define ARMOR_AGONY_COEFFICIENT 0.6
#define ARMOR_GDR_COEFFICIENT 0.1

//This calculation replaces old run_armor_check in favor of more complex and better system
//If you need to do something else with armor - just use getarmor() proc and do with those numbers all you want
//Random absorb system was a cancer, and was removed from all across the codebase. Don't recreate it. Clockrigger 2019

/mob/living/proc/damage_through_armor(var/damage = 0, var/damagetype = BRUTE, var/def_zone = null, var/attack_flag = ARMOR_MELEE, var/armour_pen = 0, var/used_weapon = null, var/sharp = 0, var/edge = 0)

	if(damage == 0)
		return FALSE

	//GDR - guaranteed damage reduction. It's a value that deducted from damage before all calculations
	var/armor = getarmor(def_zone, attack_flag)
	var/guaranteed_damage_red = armor * ARMOR_GDR_COEFFICIENT
	var/armor_effectiveness = max(0, ( armor - armour_pen ) )
	var/effective_damage = damage - guaranteed_damage_red

	if(effective_damage <= 0)
		show_message(SPAN_NOTICE("Your armor absorbs the blow!"))
		return FALSE

	//Here we can remove edge or sharpness from the blow
	if ( (sharp || edge) && prob ( getarmor (def_zone, attack_flag) ) )
		sharp = 0
		edge = 0


	//Feedback
	//In order to show both target and everyone around that armor is actually working, we are going to send message for both of them
	//Goon/tg chat should take care of spam issue on this one

	if(armor_effectiveness >= 74)
		visible_message(SPAN_NOTICE("[src] armor easily absorbs the blow!"),
						SPAN_NOTICE("Your armor reduced the impact greatly!"))

	else if(armor_effectiveness >= 49)
		visible_message(SPAN_NOTICE("[src] armor abosrbs most of the damage!"),
						SPAN_NOTICE("Your armor protects you from impact!"))

	else if(armor_effectiveness >= 24)
		show_message(SPAN_NOTICE("Your armor reduced impact for a bit."))

	//No armor? Damage as usual
	if(armor_effectiveness == 0)
		apply_damage(effective_damage, damagetype, def_zone, used_weapon, sharp, edge)

	//Here we split damage in two parts, where armor value will determine how much damage will get through
	else
		//Pain part of the damage, that simulates impact from armor absorbtion
		//For balance purposes, it's lowered by ARMOR_AGONY_COEFFICIENT
		var/agony_gamage = round( ( effective_damage * armor_effectiveness * ARMOR_AGONY_COEFFICIENT ) / 100 )
		stun_effect_act(0, agony_gamage, def_zone)

		//Actual part of the damage that passed through armor
		var/actual_damage = round ( ( effective_damage * ( 100 - armor_effectiveness ) ) / 100 )
		apply_damage(actual_damage, damagetype, def_zone, used_weapon, sharp, edge)

	return TRUE


//if null is passed for def_zone, then this should return something appropriate for all zones (e.g. area effect damage)
/mob/living/proc/getarmor(var/def_zone, var/type)
	return 0


/mob/living/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if (P.is_hot() >= HEAT_MOBIGNITE_THRESHOLD)
		IgniteMob()

	//Being hit while using a deadman switch
	if(istype(get_active_hand(),/obj/item/device/assembly/signaler))
		var/obj/item/device/assembly/signaler/signaler = get_active_hand()
		if(signaler.deadman && prob(80))
			log_and_message_admins("has triggered a signaler deadman's switch")
			src.visible_message(SPAN_WARNING("[src] triggers their deadman's switch!"))
			signaler.signal()

	//Stun Beams
	if(P.taser_effect)
		stun_effect_act(0, P.agony, def_zone, P)
		to_chat(src, SPAN_WARNING("You have been hit by [P]!"))
		qdel(P)
		return TRUE

	//Armor and damage
	if(!P.nodamage)
		damage_through_armor(P.damage, P.damage_type, def_zone, P.check_armour, armour_pen = P.armor_penetration, used_weapon = P, sharp=is_sharp(P), edge=has_edge(P))

	return TRUE

//Handles the effects of "stun" weapons
/mob/living/proc/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone, var/used_weapon=null)
	flash_pain()

	//For not bloating damage_through_armor here is simple armor calculation for stun time
	var/armor_coefficient = max(0, 1 - getarmor(def_zone, ARMOR_ENERGY) / 100)

	//If armor is 100 or more, we just skeeping it
	if (stun_amount && armor_coefficient)

		Stun(stun_amount * armor_coefficient)
		Weaken(stun_amount * armor_coefficient)
		apply_effect(STUTTER, stun_amount * armor_coefficient)
		apply_effect(EYE_BLUR, stun_amount * armor_coefficient)

	if (agony_amount && armor_coefficient)

		apply_damage(agony_amount * armor_coefficient, HALLOSS, def_zone, 0, used_weapon)
		apply_effect(STUTTER, agony_amount * armor_coefficient)
		apply_effect(EYE_BLUR, agony_amount * armor_coefficient)

/mob/living/proc/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
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
	if(HULK in user.mutations)
		effective_force *= 2

	//Apply weapon damage
	if (damage_through_armor(effective_force, I.damtype, hit_zone, ARMOR_MELEE, I.armor_penetration, used_weapon = I, sharp = is_sharp(I), edge = has_edge(I)))
		return TRUE
	else
		return FALSE

//this proc handles being hit by a thrown atom
/mob/living/hitby(atom/movable/AM as mob|obj,var/speed = THROWFORCE_SPEED_DIVISOR)//Standardization and logging -Sieve
	if(istype(AM,/obj/))
		var/obj/O = AM
		var/dtype = O.damtype
		var/throw_damage = O.throwforce*(speed/THROWFORCE_SPEED_DIVISOR)

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

		damage_through_armor(throw_damage, dtype, null, ARMOR_MELEE, null, used_weapon = O, sharp = is_sharp(O), edge = has_edge(O))

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
					src.anchored = 1
					src.pinned += O

/mob/living/proc/embed(var/obj/O, var/def_zone=null)
	if(ismob(O.loc))
		var/mob/living/L = O.loc
		if(!L.unEquip(O, src))
			return
	O.forceMove(src)
	src.embedded += O
	src.visible_message("<span class='danger'>\The [O] embeds in the [src]!</span>")
	src.verbs += /mob/proc/yank_out_object

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

/mob/living/attack_generic(var/mob/user, var/damage, var/attack_message)

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
		on_fire = 1
		set_light(light_range + 3)
		update_fire()

/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = 0
		fire_stacks = 0
		set_light(max(0, light_range - 3))
		update_fire()

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(add_fire_stacks) //Adjusting the amount of fire_stacks we have on person
    fire_stacks = Clamp(fire_stacks + add_fire_stacks, FIRE_MIN_STACKS, FIRE_MAX_STACKS)

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
		return 0

	//Scale quadratically so that single digit numbers of fire stacks don't burn ridiculously hot.
	//lower limit of 700 K, same as matches and roughly the temperature of a cool flame.
	return min(5200,max(2.25*round(FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE*(fire_stacks/FIRE_MAX_FIRESUIT_STACKS)**2), 700))

/mob/living/proc/reagent_permeability()
	return 1
	return round(FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE*(fire_stacks/FIRE_MAX_FIRESUIT_STACKS)**2)

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
