proc/heatwave(turf/epicenter, heavy_range, light_range, damage, fire_stacks, penetration = 1, log=FALSE)
	if(!epicenter) return

	if(!istype(epicenter, /turf))
		epicenter = get_turf(epicenter.loc)

	if(log)
		message_admins("Heatwave with size ([heavy_range], [light_range]) in area [epicenter.loc.name]")
		log_game("Heatwave with size ([heavy_range], [light_range]) in area [epicenter.loc.name]")

	if(heavy_range > 1)
		var/obj/effect/overlay/pulse/heatwave/HW = new(epicenter)
		spawn(20)
			qdel(HW)

	if(heavy_range > light_range)
		light_range = heavy_range

	for(var/atom/T in range(light_range, epicenter))

		if(istype(T, /mob/living))
			var/mob/living/L = T
			playsound(L, 'sound/effects/gore/sear.ogg', 40, 1)

			var/distance = get_dist(epicenter, L)

			var/isLight_range = FALSE
			if(distance < 0)
				distance = 0

			if(!distance <= heavy_range)
				isLight_range = TRUE


			if(L.stat == CONSCIOUS)
				to_chat(L, SPAN_WARNING("You feel your skin boiling!"))

			if(damage[HEAT])
				var/heat_damage = isLight_range ? damage[HEAT] / 2 : damage[HEAT]
				L.damage_through_armor(heat_damage, HEAT, attack_flag = ARMOR_ENERGY, armour_pen = penetration)

			if(damage[BURN])
				var/burn_damage = isLight_range ? damage[BURN] / 2 : damage[BURN]


				var/organ_hit = BP_CHEST //Chest is hit first
				var/loc_damage
				while (burn_damage > 0)
					burn_damage -= loc_damage = rand(1, burn_damage)
					L.damage_through_armor(loc_damage, BURN, organ_hit, ARMOR_ENERGY, penetration)
					organ_hit = ran_zone()  //We determine some other body parts that should be hit

			if(fire_stacks)
				L.adjust_fire_stacks(fire_stacks)
			L.IgniteMob()
			return TRUE

		if(fire_stacks)
			T.fire_act()
	return TRUE
