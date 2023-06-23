/mob/living/silicon/robot/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
		return
	health = maxHealth - (getBruteLoss() + getFireLoss())
	return

/mob/living/silicon/robot/getBruteLoss()
	var/amount = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 0) amount += C.brute_damage
	return amount

/mob/living/silicon/robot/getFireLoss()
	var/amount = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 0) amount += C.electronics_damage
	return amount

/mob/living/silicon/robot/adjustBruteLoss(amount)
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)

/mob/living/silicon/robot/adjustFireLoss(amount)
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)

/mob/living/silicon/robot/proc/get_damaged_components(brute, burn, destroyed = 0)
	var/list/datum/robot_component/parts = list()
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1 || (C.installed == -1 && destroyed))
			if((brute && C.brute_damage) || (burn && C.electronics_damage) || (!C.toggled) || (!C.powered && C.toggled))
				parts += C
	return parts

/mob/living/silicon/robot/proc/get_damageable_components()
	var/list/rval = new
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1) rval += C
	return rval

/mob/living/silicon/robot/proc/get_armour()

	if(!components.len) return FALSE
	var/datum/robot_component/C = components["armour"]
	if(C && C.installed == 1)
		return C
	return FALSE

/mob/living/silicon/robot/heal_organ_damage(var/brute, var/burn)
	var/list/datum/robot_component/parts = get_damaged_components(brute,burn)
	if(!parts.len)	return
	var/datum/robot_component/picked = pick(parts)
	picked.heal_damage(brute,burn)

/mob/living/silicon/robot/take_organ_damage(var/brute = 0, var/burn = 0, var/sharp = FALSE, var/edge = FALSE, var/emp = 0)
	var/list/components = get_damageable_components()
	if(!components.len)
		return

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	if(module_active && istype(module_active,/obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = module_active
		//Shields absorb a certain percentage of damage based on their power setting.
		var/absorb_brute_cost = (brute*shield.shield_level)*100
		var/absorb_burn_cost = (burn*shield.shield_level)*100

		if(cell.is_empty())
			to_chat(src, "\red Your shield has overloaded!")
		else
			var/absorb_brute = cell.use(absorb_brute_cost)/100
			var/absorb_burn = cell.use(absorb_burn_cost)/100
			brute -= absorb_brute
			burn -= absorb_burn
			to_chat(src, "\red Your shield absorbs some of the impact!")

	if(!emp)
		var/datum/robot_component/armour/A = get_armour()
		if(A)
			A.take_damage(brute,burn,sharp,edge)
			return

	var/datum/robot_component/C = pick(components)
	C.take_damage(brute,burn,sharp,edge)

/mob/living/silicon/robot/heal_overall_damage(var/brute, var/burn)
	var/list/datum/robot_component/parts = get_damaged_components(brute,burn)

	while(parts.len && (brute>0 || burn>0) )
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage

		picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_damage)
		burn -= (burn_was-picked.electronics_damage)

		parts -= picked

/mob/living/silicon/robot/take_overall_damage(brute = 0, burn = 0, sharp = FALSE, used_weapon = null)
	if(status_flags & GODMODE)	return	//godmode
	var/list/datum/robot_component/parts = get_damageable_components()

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	if(module_active && istype(module_active,/obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = module_active
		//Shields absorb a certain percentage of damage based on their power setting.
		var/absorb_brute_cost = (brute*shield.shield_level)*100
		var/absorb_burn_cost = (burn*shield.shield_level)*100

		if(cell.is_empty())
			to_chat(src, "\red Your shield has overloaded!")
		else
			var/absorb_brute = cell.use(absorb_brute_cost)/100
			var/absorb_burn = cell.use(absorb_burn_cost)/100
			brute -= absorb_brute
			burn -= absorb_burn
			to_chat(src, "\red Your shield absorbs some of the impact!")

	var/datum/robot_component/armour/A = get_armour()
	if(A)
		A.take_damage(brute,burn,sharp)
		return

	while(parts.len && (brute>0 || burn>0) )
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage

		picked.take_damage(brute,burn)

		brute	-= (picked.brute_damage - brute_was)
		burn	-= (picked.electronics_damage - burn_was)

		parts -= picked

/mob/living/silicon/robot/emp_act(severity)
	uneq_all()
	..() //Damage is handled at /silicon/ level.



/mob/living/silicon/robot/get_fall_damage(turf/from, turf/dest)
	//Robots should not be falling! Their bulky inarticulate frames lack shock absorbers, and gravity turns their armor plating against them
	//Falling down a floor is extremely painful for robots, and for anything under them, including the floor

	var/damage = maxHealth*0.49 //Just under half of their health
	//A percentage is used here to simulate different robots having different masses. The bigger they are, the harder they fall

	//Falling two floors is not an instakill, but it almost is
	if (from && dest)
		damage *= abs(from.z - dest.z)

	return damage


//On impact, robots will damage everything in the tile and surroundings
/mob/living/silicon/robot/fall_impact(turf/from, turf/dest)
	take_overall_damage(get_fall_damage(from, dest))

	Stun(5)
	updatehealth()
	//Wreck the contents of the tile
	for (var/atom/movable/AM in dest)
		if (AM != src)
			AM.explosion_act(50, null)

	//Damage the tile itself
	dest.explosion_act(100,null)

	//Damage surrounding tiles
	for (var/turf/T in range(1, src))
		if (T == dest)
			continue

		T.explosion_act(50, null)

	//And do some screenshake for everyone in the vicinity
	for (var/mob/M in range(20, src))
		var/dist = get_dist(M, src)
		dist *= 0.5
		if (dist <= 1)
			dist = 1 //Prevent runtime errors

		shake_camera(M, 10/dist, 2.5/dist, 0.12)

	playsound(src, 'sound/weapons/heavysmash.ogg', 100, 1, 20,20)
	spawn(1)
		playsound(src, 'sound/weapons/heavysmash.ogg', 100, 1, 20,20)
	spawn(2)
		playsound(src, 'sound/weapons/heavysmash.ogg', 100, 1, 20,20)
	playsound(src, pick(robot_talk_heavy_sound), 100, 1, 5,5)

