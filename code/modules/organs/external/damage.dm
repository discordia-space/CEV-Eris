/****************************************************
			   DAMAGE PROCS
****************************************************/

/obj/item/organ/external/proc/is_damageable(var/additional_damage = 0)
	return (vital || brute_dam + burn_dam + additional_damage < max_damage)

/obj/item/organ/external/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list())
	brute = round(brute * brute_mod, 0.1)
	burn = round(burn * burn_mod, 0.1)
	if((brute <= 0) && (burn <= 0))
		return 0

	// High brute damage or sharp objects may damage internal organs
	if(internal_organs && (brute_dam >= max_damage || (((sharp && brute >= 5) || brute >= 10) && prob(5))))
		// Damage an internal organ
		if(internal_organs && internal_organs.len)
			var/obj/item/organ/internal/I = pick(internal_organs)
			I.take_damage(brute / 2)
			brute -= brute / 2

	if(status & ORGAN_BROKEN && prob(40) && brute)
		if (!(owner.species && (owner.species.flags & NO_PAIN)))
			owner.emote("scream")	//getting hit on broken hand hurts
	if(used_weapon)
		add_autopsy_data("[used_weapon]", brute + burn)

	var/can_cut = (prob(brute*2) || sharp) && robotic < ORGAN_ROBOT

	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	// Non-vital organs are limited to max_damage. You can't kill someone by bludeonging their arm all the way to 200 -- you can
	// push them faster into paincrit though, as the additional damage is converted into shock.
	if(is_damageable(brute + burn) || !config.limbs_can_break)
		if(brute)
			if(can_cut)
				if(sharp && !edge)
					createwound( PIERCE, brute )
				else
					createwound( CUT, brute )
			else
				createwound( BRUISE, brute )
		if(burn)
			createwound( BURN, burn )
	else
		//If we can't inflict the full amount of damage, spread the damage in other ways
		//How much damage can we actually cause?
		var/can_inflict = max_damage * ORGAN_HEALTH_MULTIPLIER - (brute_dam + burn_dam)
		var/spillover = 0
		if(can_inflict)
			if (brute > 0)
				//Inflict all burte damage we can
				if(can_cut)
					if(sharp && !edge)
						createwound( PIERCE, min(brute,can_inflict) )
					else
						createwound( CUT, min(brute,can_inflict) )
				else
					createwound( BRUISE, min(brute,can_inflict) )
				var/temp = can_inflict
				//How much mroe damage can we inflict
				can_inflict = max(0, can_inflict - brute)
				//How much brute damage is left to inflict
				spillover += max(0, brute - temp)

			if (burn > 0 && can_inflict)
				//Inflict all burn damage we can
				createwound(BURN, min(burn,can_inflict))
				//How much burn damage is left to inflict
				spillover += max(0, burn - can_inflict)

		//If there are still hurties to dispense
		if (spillover)
			owner.shock_stage += spillover * config.organ_damage_spillover_multiplier

	// sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth() //droplimb will call updatehealth() again if it does end up being called

	//If limb took enough damage, try to cut or tear it off
	if(owner && loc == owner && !is_stump())
		if(!cannot_amputate && config.limbs_can_break && (brute_dam + burn_dam) >= (max_damage * ORGAN_HEALTH_MULTIPLIER))
			//organs can come off in three cases
			//1. If the damage source is edge_eligible and the brute damage dealt exceeds the edge threshold, then the organ is cut off.
			//2. If the damage amount dealt exceeds the disintegrate threshold, the organ is completely obliterated.
			//3. If the organ has already reached or would be put over it's max damage amount (currently redundant),
			//   and the brute damage dealt exceeds the tearoff threshold, the organ is torn off.

			//Check edge eligibility
			var/edge_eligible = 0
			if(edge)
				if(istype(used_weapon,/obj/item))
					var/obj/item/W = used_weapon
					if(W.w_class >= w_class)
						edge_eligible = 1
				else
					edge_eligible = 1

			if(edge_eligible && brute >= max_damage / DROPLIMB_THRESHOLD_EDGE && prob(brute))
				droplimb(0, DROPLIMB_EDGE)
			else if(burn >= max_damage / DROPLIMB_THRESHOLD_DESTROY && prob(burn/3))
				droplimb(0, DROPLIMB_BURN)
			else if(brute >= max_damage / DROPLIMB_THRESHOLD_DESTROY && prob(brute))
				droplimb(0, DROPLIMB_BLUNT)
			else if(brute >= max_damage / DROPLIMB_THRESHOLD_TEAROFF && prob(brute/3))
				droplimb(0, DROPLIMB_EDGE)

	return update_damstate()

/obj/item/organ/external/proc/heal_damage(brute, burn, internal = 0, robo_repair = 0)
	if(robotic >= ORGAN_ROBOT && !robo_repair)
		return

	//Heal damage on the individual wounds
	for(var/datum/wound/W in wounds)
		if(brute == 0 && burn == 0)
			break

		// heal brute damage
		if(W.damage_type == BURN)
			burn = W.heal_damage(burn)
		else
			brute = W.heal_damage(brute)

	if(internal)
		status &= ~ORGAN_BROKEN
		perma_injury = 0

	//Sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth()

	return update_damstate()

