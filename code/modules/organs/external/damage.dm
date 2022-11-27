/****************************************************
			   DAMAGE PROCS
****************************************************/

/obj/item/organ/external/proc/is_damageable(additional_damage = 0)
	return (vital || brute_dam + burn_dam + additional_damage < max_damage)

/obj/item/organ/external/take_damage(amount, damage_type, armor_divisor = 1, wounding_multiplier = 1, sharp, edge, used_weapon = null, list/forbidden_limbs = list(), silent)
	var/prev_brute = brute_dam	//We'll record how much damage the limb already had, before we apply the damage from this incoming hit
	var/prev_burn = burn_dam

	switch(damage_type)
		if(BRUTE)
			amount = round(amount * brute_mod, 0.1)
		if(BURN)
			amount = round(amount * burn_mod, 0.1)

	// High damage is transferred to internal organs
	if(internal_organs && LAZYLEN(internal_organs))
		var/obj/item/organ/internal/I = pick(internal_organs)
		var/transferred_damage_amount
		switch(damage_type)
			if(BRUTE)
				transferred_damage_amount = (amount - (max_damage - brute_dam) / armor_divisor) / 2
			if(BURN)
				transferred_damage_amount = (amount - (max_damage - burn_dam) / armor_divisor) / 2
			else
				transferred_damage_amount = amount	// PSY, CLONE, TOX, and OXY are special

		if(transferred_damage_amount > 0)
			I.take_damage(transferred_damage_amount, damage_type, wounding_multiplier, sharp, edge, FALSE)
			amount -= transferred_damage_amount

	if(amount <= 0)
		return FALSE

	if(used_weapon)
		add_autopsy_data("[used_weapon]", amount)

	// Brute-specific behavior
	var/can_cut = FALSE
	if(damage_type == BRUTE)
		if(should_fracture() && prob(brute_dam + amount))
			fracture()

		if(status & ORGAN_BROKEN && prob(40))
			if(owner && !(owner.species && (owner.species.flags & NO_PAIN)))
				owner.emote("scream")	//getting hit on broken hand hurts

		can_cut = ((prob(amount*2) || sharp) && !BP_IS_ROBOTIC(src))

	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	// Non-vital organs are limited to max_damage. You can't kill someone by bludeonging their arm all the way to 200 -- you can
	// push them faster into paincrit though, as the additional damage is converted into shock.
	if(is_damageable(amount) || !config.limbs_can_break)
		if(damage_type == BRUTE)
			if(can_cut)
				if(sharp && !edge)
					createwound(PIERCE, amount)
				else
					createwound(CUT, amount)
			else
				createwound(BRUISE, amount)
		if(damage_type == BURN)
			createwound(BURN, amount)
	else
		//If we can't inflict the full amount of damage, spread the damage in other ways
		//How much damage can we actually cause?
		var/can_inflict = max_damage * ORGAN_HEALTH_MULTIPLIER - (brute_dam + burn_dam)
		var/spillover = 0
		if(can_inflict)
			if(damage_type == BRUTE)
				//Inflict all burte damage we can
				if(can_cut)
					if(sharp && !edge)
						createwound(PIERCE, min(amount,can_inflict))
					else
						createwound(CUT, min(amount,can_inflict))
				else
					createwound(BRUISE, min(amount,can_inflict))
				var/temp = can_inflict
				//How much mroe damage can we inflict
				can_inflict = max(0, can_inflict - amount)
				//How much brute damage is left to inflict
				spillover += max(0, amount - temp)
			if(damage_type == BURN)
				//Inflict all burn damage we can
				createwound(BURN, min(amount,can_inflict))
				//How much burn damage is left to inflict
				spillover += max(0, amount - can_inflict)

	// sync the organ's damage with its wounds
	update_damages()
	owner?.updatehealth() //droplimb will call updatehealth() again if it does end up being called

	//If limb took enough damage, try to cut or tear it off
	if(owner && loc == owner && !is_stump())
		if(!cannot_amputate && config.limbs_can_break && (brute_dam + burn_dam) >= (max_damage * ORGAN_HEALTH_MULTIPLIER))
			//organs can come off in four cases
			//1. If the damage source is edge_eligible and the brute damage dealt exceeds the edge threshold, then the organ is cut off.
			//2. If the damage amount dealt exceeds the disintegrate threshold, the organ is completely obliterated.
			//3. If the organ has already reached or would be put over it's max damage amount (currently redundant),
			//   and the brute damage dealt exceeds the tearoff threshold, the organ is torn off.
			//4. If the organ is robotic, and it has reached its max damage threshold, it will either drop off, or blow up.
			//Check edge eligibility
			var/edge_eligible = 0
			if(edge)
				if(istype(used_weapon,/obj/item))
					var/obj/item/W = used_weapon
					if(W.w_class >= w_class)
						edge_eligible = 1
				else
					edge_eligible = 1

			switch(damage_type)
				if(BRUTE)
					if(edge_eligible && (amount + prev_brute) >= max_damage * DROPLIMB_THRESHOLD_EDGE && prob(amount))
						droplimb(0, DROPLIMB_EDGE)
					else if((amount + prev_brute) >= max_damage * DROPLIMB_THRESHOLD_DESTROY && prob(amount/3))
						droplimb(0, DROPLIMB_BLUNT)
					else if((amount + prev_brute) >= max_damage * DROPLIMB_THRESHOLD_TEAROFF && prob(amount/5))
						droplimb(0, DROPLIMB_EDGE)
					else if(brute_dam && BP_IS_ROBOTIC(src) && (status & ORGAN_BROKEN) && prob(amount*2))
						droplimb(prob(50), pick(DROPLIMB_EDGE, DROPLIMB_BLUNT))
				if(BURN)
					if((amount + prev_burn) >= max_damage * DROPLIMB_THRESHOLD_DESTROY && prob(amount/3))
						droplimb(0, DROPLIMB_BURN)

	return update_damstate()

/obj/item/organ/external/heal_damage(brute, burn, robo_repair = 0)
	if(BP_IS_ROBOTIC(src) && !robo_repair)
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

	//Sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth()

	return update_damstate()
