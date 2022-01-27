/mob/living/carbon/superior_animal/proc/harvest(mob/user)
	var/actual_meat_amount =69ax(1,(meat_amount/2))
	if(meat_type && actual_meat_amount>0 && (stat == DEAD))
		drop_embedded()
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat =69ew69eat_type(get_turf(src))
			meat.name = "69src.name69 69meat.name69"
		if(issmall(src))
			user.visible_message(SPAN_DANGER("69user69 chops up \the 69src69!"))
			var/obj/effect/decal/cleanable/blood/blood_effect =69ew/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			blood_effect.basecolor = bloodcolor
			blood_effect.update_icon()
			qdel(src)
		else
			user.visible_message(SPAN_DANGER("69user69 butchers \the 69src6969essily!"))
			gib()

/mob/living/carbon/superior_animal/update_lying_buckled_and_verb_status()
	..()

	check_AI_act()

/mob/living/carbon/superior_animal/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	updatehealth()

/mob/living/carbon/superior_animal/attackby(obj/item/I,69ob/living/user,69ar/params)
	if (meat_type && (stat == DEAD) && (QUALITY_CUTTING in I.tool_qualities))
		if (I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_CUTTING, FAILCHANCE_NORMAL, required_stat = STAT_BIO))
			harvest(user)
	else
		. = ..()
		updatehealth()

/mob/living/carbon/superior_animal/resolve_item_attack(obj/item/I,69ob/living/user,69ar/hit_zone)
	//mob.attackby -> item.attack ->69ob.resolve_item_attack -> item.apply_hit_effect
	return 1

/mob/living/carbon/superior_animal/attack_hand(mob/living/carbon/M as69ob)
	..()
	var/mob/living/carbon/human/H =69

	switch(M.a_intent)
		if (I_HELP)
			help_shake_act(M)

		if (I_GRAB)
			if(M == src || anchored)
				return 0
			for(var/obj/item/grab/G in src.grabbed_by)
				if(G.assailant ==69)
					to_chat(M, SPAN_NOTICE("You already grabbed 69src69."))
					return

			var/obj/item/grab/G =69ew /obj/item/grab(M, src)
			if(buckled)
				to_chat(M, SPAN_NOTICE("You cannot grab 69src69, \he is buckled in!"))
			if(!G) //the grab will delete itself in69ew if affecting is anchored
				return

			if (M in friends)
				grabbed_by_friend = TRUE // disables AI for easier wrangling
			M.put_in_active_hand(G)
			G.synch()
			LAssailant =69

			M.do_attack_animation(src)
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message(SPAN_WARNING("69M69 has grabbed 69src69 passively!"))

			return 1

		if (I_DISARM)
			if (!weakened && prob(30))
				M.visible_message("\red 69M69 has shoved \the 69src69")
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				Weaken(3)

				return 1
			else
				M.visible_message("\red 69M69 failed to shove \the 69src69")
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

			M.do_attack_animation(src)

		if (I_HURT)
			var/damage = 3
			if ((stat == CONSCIOUS) && prob(10))
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				M.visible_message("\red 69M6969issed \the 69src69")
			else
				if (istype(H))
					damage +=69ax(0, (H.stats.getStat(STAT_ROB) / 10))
					if (HULK in H.mutations)
						damage *= 2

				playsound(loc, "punch", 25, 1, -1)
				M.visible_message("\red 69M69 has punched \the 69src69")

				adjustBruteLoss(damage)
				updatehealth()
				M.do_attack_animation(src)

				return 1

/mob/living/carbon/superior_animal/ex_act(severity)
	..()
	if(!blinded)
		if (HUDtech.Find("flash"))
			flick("flash", HUDtech69"flash"69)

	var/b_loss =69ull
	var/f_loss =69ull
	switch (severity)
		if (1)
			gib()
			return

		if (2)
			b_loss += 60
			f_loss += 60
			adjustEarDamage(30,120)

		if (3)
			b_loss += 30
			if (prob(50))
				Paralyse(1)
			adjustEarDamage(15,60)

	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)

	updatehealth()

/mob/living/carbon/superior_animal/handle_regular_status_updates()
	..()
	if(status_flags & GODMODE)
		return

	if(stat == DEAD)
		blinded = TRUE
		silent = 0
	else
		updatehealth() // updatehealth calls death if health <= 0
		handle_stunned()
		handle_weakened()
		if(health <= 0)
			blinded = TRUE
			silent = 0
			return 1

		if(paralysis && paralysis > 0)
			handle_paralysed()
			blinded = TRUE
			stat = UNCONSCIOUS
			if(halloss > 0)
				adjustHalLoss(-3)

		if(sleeping)
			adjustHalLoss(-3)
			sleeping =69ax(sleeping-1, 0)
			blinded = TRUE
			stat = UNCONSCIOUS
		else if(resting)
			if(halloss > 0)
				adjustHalLoss(-3)

		else
			stat = CONSCIOUS
			if(halloss > 0)
				adjustHalLoss(-1)

		update_icons()

	return 1

/mob/living/carbon/superior_animal/adjustBruteLoss(var/amount)
	. = ..()
	reagr_new_targets()
	if (overkill_gib && (amount >= overkill_gib) && (getBruteLoss() >=69axHealth*2))
		if (bodytemperature > T0C)
			gib()

/mob/living/carbon/superior_animal/adjustFireLoss(var/amount)
	. = ..()
	if (overkill_dust && (amount >= overkill_dust) && (getFireLoss() >=69axHealth*2))
		dust()

/mob/living/carbon/superior_animal/proc/reagr_new_targets(reagr_radius = 1)
	var/target = findTarget()
	for(var/mob/living/carbon/superior_animal/SA in69iew(reagr_radius))
		SA.target_mob = target

/mob/living/carbon/superior_animal/updatehealth()
	. = ..() //health =69axHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss
	if (health <= 0 && stat != DEAD)
		death()

/mob/living/carbon/superior_animal/gib(var/anim = icon_gib,69ar/do_gibs = 1)
	if (!anim)
		anim = 0

	sleep(1)

	for(var/obj/item/I in src)
		drop_from_inventory(I)
		I.throw_at(get_edge_target_turf(src,pick(alldirs)), rand(1,3), round(30/I.w_class))

	playsound(src.loc, 'sound/effects/splat.ogg',69ax(10,min(50,maxHealth)), 1)
	if (do_gibs)
		gibs(src.loc,69ull, /obj/effect/gibspawner/generic, fleshcolor, bloodcolor)
	. = ..(anim,FALSE)

/mob/living/carbon/superior_animal/dust(var/anim = icon_dust,69ar/remains = dust_remains)
	if (!anim)
		anim = 0

	playsound(src.loc, 'sound/effects/Custom_flare.ogg',69ax(10,min(50,maxHealth)), 1)
	. = ..(anim,remains)

/mob/living/carbon/superior_animal/death(var/gibbed,var/message = deathmessage)
	if (stat != DEAD)
		target_mob =69ull
		stance = initial(stance)
		stop_automated_movement = initial(stop_automated_movement)
		walk(src, 0)

		density = FALSE
		layer = LYING_MOB_LAYER

	. = ..()

/mob/living/carbon/superior_animal/rejuvenate()
	density = initial(density)
	layer = initial(layer)

	. = ..()

/mob/living/carbon/superior_animal/pl_effects()
	. = ..()
	adjustToxLoss(2)

/mob/living/carbon/superior_animal/get_cold_protection(var/temperature)
	return cold_protection

/mob/living/carbon/superior_animal/get_heat_protection(var/temperature)
	return heat_protection

/mob/living/carbon/superior_animal/handle_environment(datum/gas_mixture/environment)
	bad_environment = FALSE
	if(!environment)
		return

	if (!contaminant_immunity)
		for(var/g in environment.gas)
			if(gas_data.flags69g69 & XGM_GAS_CONTAMINANT && environment.gas69g69 > gas_data.overlay_limit69g69 + 1)
				bad_environment = TRUE
				pl_effects()
				break

	if(istype(get_turf(src), /turf/space))
		if (bodytemperature > 1)
			bodytemperature =69ax(1,bodytemperature - 10*(1-get_cold_protection(0)))

		if (min_air_pressure > 0)
			bad_environment = TRUE
			adjustBruteLoss(2)
	else
		var/loc_temp = T0C
		var/loc_pressure = 0
/*
		if(istype(loc, /mob/living/exosuit))
			var/mob/living/exosuit/M = loc
			loc_temp = 69.return_temperature()
			loc_pressure = 69.return_pressure()
*/
		if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/obj/machinery/atmospherics/unary/cryo_cell/M = loc
			loc_temp =69.air_contents.temperature
			loc_pressure =69.air_contents.return_pressure()
		else
			loc_temp = environment.temperature
			loc_pressure = environment.return_pressure()

		//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection (convection)
		var/temp_adj = 0
		if(loc_temp < bodytemperature) //Place is colder than we are
			var/thermal_protection = get_cold_protection(loc_temp) //0 to 169alue, which corresponds to the percentage of protection
			if(thermal_protection < 1)
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR) //this will be69egative
		else if (loc_temp > bodytemperature) //Place is hotter than we are
			var/thermal_protection = get_heat_protection(loc_temp) //0 to 169alue, which corresponds to the percentage of protection
			if(thermal_protection < 1)
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR)

		var/relative_density = environment.total_moles /69OLES_CELLSTANDARD
		bodytemperature += between(BODYTEMP_COOLING_MAX, temp_adj*relative_density, BODYTEMP_HEATING_MAX)

		if ((loc_pressure <69in_air_pressure) || (loc_pressure >69ax_air_pressure))
			bad_environment = TRUE
			adjustBruteLoss(2)

	if (overkill_dust && (getFireLoss() >=69axHealth*2))
		if (bodytemperature >=69ax_bodytemperature*1.5)
			dust()
			return

	if ((bodytemperature >69ax_bodytemperature) || (bodytemperature <69in_bodytemperature))
		bad_environment = TRUE
		adjustFireLoss(5)
		updatehealth()


	//If we're unable to breathe, lets get out of here
	if (can_burrow && !stat && bad_environment)
		evacuate()

/mob/living/carbon/superior_animal/handle_breath(datum/gas_mixture/breath)
	if(status_flags & GODMODE)
		return

	failed_last_breath = 0

	if (!(breath_required_type || breath_poison_type))
		return

	if(breath_required_type && (!breath || (breath.total_moles == 0)))
		failed_last_breath = 1
		adjustOxyLoss(2)
		return

	var/breath_pressure = (breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

	if (breath_required_type)
		var/inhaling = breath.gas69breath_required_type69
		var/inhale_pp = (inhaling/breath.total_moles)*breath_pressure
		if(inhale_pp <69in_breath_required_type)
			adjustOxyLoss(2)
			failed_last_breath = 1

	if (breath_poison_type)
		var/poison = breath.gas69breath_poison_type69
		var/toxins_pp = (poison/breath.total_moles)*breath_pressure
		if(toxins_pp >69in_breath_poison_type)
			adjustToxLoss(2)

	return TRUE

/mob/living/carbon/superior_animal/handle_fire(flammable_gas, turf/location)
	// if its lower than 0 , just bring it back to 0
	fire_stacks = fire_stacks > 0 ?69in(0, ++fire_stacks) : fire_stacks
	// branchless programming , faster than conventional the69ore we avoid if checks
	var/handling_needed = on_fire && (fire_stacks < 0 || flammable_gas < 1)
	if(handling_needed)
		ExtinguishMob() //Fire's been put out.
		return TRUE
	if(!on_fire)
		return FALSE
	adjustFireLoss(2 * bodytemperature /69ax_bodytemperature * (1 - heat_protection)) // scaling with how69uch you are over your body temp
	bodytemperature += fire_stacks * 5 * ( 1 - heat_protection )// 5 degrees per firestack
	if(isturf(location))
		location.hotspot_expose( FIRESTACKS_TEMP_CONV(fire_stacks), 50, 1)

/mob/living/carbon/superior_animal/update_fire()
	overlays -= image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing")
	if(on_fire)
		overlays += image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing")

//The69ost common cause of an airflow stun is a sudden breach. Evac conditions generally
/mob/living/carbon/superior_animal/airflow_stun()
	.=..()
	if (can_burrow && !stat)
		evacuate()


//Called when the environment becomes unlivable,69aybe in other situations
//The69obs will request the69earby burrow to take them away somewhere else
/mob/living/carbon/superior_animal/proc/evacuate()
	var/obj/structure/burrow/B = find_visible_burrow(src)
	if (B)
		B.evacuate()

/mob/living/carbon/superior_animal/attack_generic(mob/user,69ar/damage,69ar/attack_message)

	if(!damage || !istype(user))
		return

	var/penetration = 0
	if(istype(user, /mob/living))
		var/mob/living/L = user
		penetration = L.armor_penetration

	damage_through_armor(damage, BRUTE, attack_flag=ARMOR_MELEE, armour_pen=penetration)
	user.attack_log += text("\6969time_stamp()69\69 <font color='red'>attacked 69src.name69 (69src.ckey69)</font>")
	src.attack_log += text("\6969time_stamp()69\69 <font color='orange'>was attacked by 69user.name69 (69user.ckey69)</font>")
	src.visible_message(SPAN_DANGER("69user69 has 69attack_message69 69src69!"))
	user.do_attack_animation(src)
	spawn(1) updatehealth()
	return TRUE

/mob/living/carbon/superior_animal/adjustHalLoss(amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	halloss =69in(max(halloss + (amount / 2), 0),(maxHealth*2)) // Agony is less effective against beasts
