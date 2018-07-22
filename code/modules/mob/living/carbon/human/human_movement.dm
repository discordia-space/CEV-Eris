/mob/living/carbon/human/movement_delay()

	var/tally = 0

	if(species.slowdown)
		tally = species.slowdown

	if (istype(loc, /turf/space)) return -1 // It's hard to be slowed down in space by... anything

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	if(CE_SPEEDBOOST in chem_effects)
		return -1

	var/health_deficiency = (maxHealth - health)
	if(health_deficiency >= 40) tally += (health_deficiency / 25)

	if (!(species && (species.flags & NO_PAIN)))
		if(halloss >= 10) tally += (halloss / 10) //halloss shouldn't slow you down if you can't even feel it

	var/hungry = (500 - nutrition)/5 // So overeat would be 100 and default level would be 80
	if (hungry >= 70) tally += hungry/50

	if(wear_suit)
		tally += wear_suit.slowdown

	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list(BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E)
				tally += 4
			else
				tally += E.get_tally()
	else
		if(shoes)
			tally += shoes.slowdown

		for(var/organ_name in BP_LEGS)
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E)
				tally += 4
			else
				tally += E.get_tally()


	if(shock_stage >= 10) tally += 3

	if(aiming && aiming.aiming_at) tally += 5 // Iron sights make you slower, it's a well-known fact.

	if(FAT in src.mutations)
		tally += 1.5
	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow

	if(mRun in mutations)
		tally = 0

	return (tally+config.human_delay)

/mob/living/carbon/human/Process_Spacemove(var/check_drift = 0)
	//Can we act?
	if(restrained())	return 0

	//Do we have a working jetpack?
	var/obj/item/weapon/tank/jetpack/thrust
	if(back)
		if(istype(back,/obj/item/weapon/tank/jetpack))
			thrust = back
		else if(istype(back,/obj/item/weapon/rig))
			var/obj/item/weapon/rig/rig = back
			for(var/obj/item/rig_module/maneuvering_jets/module in rig.installed_modules)
				thrust = module.jets
				break

	if(thrust)
		if(((!check_drift) || (check_drift && thrust.stabilization_on)) && (!lying) && (thrust.allow_thrust(0.01, src)))
			inertia_dir = 0
			return 1

	//If no working jetpack then use the other checks
	if(..())
		return 1
	return 0


/mob/living/carbon/human/slip_chance(var/prob_slip = 5)
	if(!..())
		return 0

	//Check hands and mod slip
	if(!l_hand)
		prob_slip -= 2
	else if(l_hand.w_class <= ITEM_SIZE_SMALL)
		prob_slip -= 1
	if (!r_hand)
		prob_slip -= 2
	else if(r_hand.w_class <= ITEM_SIZE_SMALL)
		prob_slip -= 1

	return prob_slip

/mob/living/carbon/human/Check_Shoegrip()
	if(species.flags & NO_SLIP)
		return 1
	if(shoes && (shoes.item_flags & NOSLIP) && istype(shoes, /obj/item/clothing/shoes/magboots))  //magboots + dense_object = no floating
		return 1
	return 0

/mob/living/carbon/human/handle_footstep(atom/T)
	if(..())

		if(m_intent == "run")
			if(!(step_count % 2)) //every other turf makes a sound
				return

		if(istype(shoes, /obj/item/clothing/shoes))
			var/obj/item/clothing/shoes/footwear = shoes
			if(footwear.silence_steps)
				return //silent

		if(!has_organ(BP_L_FOOT) && !has_organ(BP_R_FOOT))
			return //no feet no footsteps

		if(buckled || lying || throwing)
			return //people flying, lying down or sitting do not step

		if(!has_gravity(src))
			if(step_count % 3) //this basically says, every three moves make a noise
				return //1st - none, 1%3==1, 2nd - none, 2%3==2, 3rd - noise, 3%3==0

		if(species.silent_steps)
			return //species is silent


		var/S = T.get_footstep_sound("human")
		if(S)
			var/range = -(world.view - 2)
			if(m_intent == "walk")
				range -= 0.333
			if(!shoes)
				range -= 0.333

			var/volume = 90
			if(m_intent == "walk")
				volume -= 55
			if(!shoes)
				volume -= 70

			playsound(T, S, volume, 1, range)
			return
