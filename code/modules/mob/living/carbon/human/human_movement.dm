/mob/living/carbon/human/update_movement_delays()
	..()
	var/value = 0
	if(species.slowdown)
		value += species.slowdown
	if (istype(loc, /turf/space)) // It's hard to be slowed down in space by... anything
		return value

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.
	if(CE_SPEEDBOOST in chem_effects)
		value -= chem_effects[CE_SPEEDBOOST]




	var/health_deficiency = (maxHealth - health)
	var/hunger_deficiency = (max_nutrition - nutrition) //400 = max for humans.
	if(hunger_deficiency >= 200) value += (hunger_deficiency / 100) //If youre starving, movement slowdown can be anything up to 4.
	if(health_deficiency >= 40) value += (health_deficiency / 25)

	if (!(species && (species.flags & NO_PAIN)))
		if(halloss >= 10) value += (halloss / 10) //halloss shouldn't slow you down if you can't even feel it
	
	if(wear_suit)
		value += wear_suit.slowdown
	if(shoes)
		value += shoes.slowdown

	if(shock_stage >= 10) value += 3

	if (bodytemperature < 283.222)
		value += (283.222 - bodytemperature) / 10 * 1.75
	value += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow

	for(var/obj/item/grab/G in src)
		value += max(0, G.grab_slowdown())
		if (G.assailant_reverse_facing())
			value += max(0, G.grab_slowdown()/3)

	adjust_movement_delay(DELAY_HUMAN, value)


/mob/living/carbon/human/allow_spacemove()
	//Can we act?
	if(restrained())	return 0

	//Do we have a working jetpack?
	var/obj/item/weapon/tank/jetpack/thrust = get_jetpack()

	if(thrust)
		if(thrust.allow_thrust(JETPACK_MOVE_COST, src))
			if (thrust.stabilization_on)
				return TRUE
			return -1

	//If no working jetpack then use the other checks
	return ..()

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

/mob/living/carbon/human/check_shoegrip()
	if(species.flags & NO_SLIP)
		return 1
	if(shoes && (shoes.item_flags & NOSLIP) && istype(shoes, /obj/item/clothing/shoes/magboots))  //magboots + dense_object = no floating
		return 1
	return 0

