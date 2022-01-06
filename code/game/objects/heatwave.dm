proc/heatwave(turf/epicenter, heavy_range, light_range, damage, fire_stacks, penetration, log=0)
	if(!epicenter) return

	if(!istype(epicenter, /turf))
		epicenter = get_turf(epicenter.loc)

	if(log)
		message_admins("Heatwave with size ([heavy_range], [light_range]) in area [epicenter.loc.name] ")
		log_game("Heatwave with size ([heavy_range], [light_range]) in area [epicenter.loc.name] ")

	if(heavy_range > 1)
		var/obj/effect/overlay/pulse/heatwave/HW = new(epicenter)
		spawn(20)
			qdel(HW)

	if(heavy_range > light_range)
		light_range = heavy_range
	
	for(var/atom/T in range(heavy_range, epicenter))
		if(fire_stacks)
			T.fire_act()
		if(istype(T, /mob/living))
			var/mob/living/L = T
			L << 'sound/effects/gore/sear.ogg' // How do I replace this

			var/burn_damage = 0

			var/distance = get_dist(epicenter, L)
			if(distance < 0)
				distance = 0
			if(distance <= heavy_range)
				burn_damage = damage
			else if(distance <= light_range)
				burn_damage = damage*0.5

			if(burn_damage && L.stat == CONSCIOUS)
				to_chat(L, SPAN_WARNING("You feel your skin boiling!"))

			var/organ_hit = BP_CHEST //Chest is hit first
			var/loc_damage
			while (burn_damage > 0)
				burn_damage -= loc_damage = rand(0, burn_damage)
				L.damage_through_armor(loc_damage, BURN, organ_hit, ARMOR_ENERGY, penetration)
				organ_hit = pickweight(list(BP_HEAD = 0.2, BP_GROIN = 0.2, BP_R_ARM = 0.1, BP_L_ARM = 0.1, BP_R_LEG = 0.1, BP_L_LEG = 0.1))  //We determine some other body parts that should be hit
	return 1
