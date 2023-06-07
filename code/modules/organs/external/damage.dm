/****************************************************
			   DAMAGE PROCS
****************************************************/

/obj/item/organ/external/proc/is_damageable(additional_damage = 0)
	return (vital || brute_dam + burn_dam + additional_damage < max_damage)

/obj/item/organ/external/take_damage(amount, damage_type, armor_divisor = 1, wounding_multiplier = 1, sharp, edge, used_weapon = null, list/forbidden_limbs = list(), silent)
	var/prev_brute = brute_dam	//We'll record how much damage the limb already had, before we apply the damage from this incoming hit
	var/prev_burn = burn_dam

	var/external_wounding_multiplier = wounding_multiplier
	switch(damage_type)
		if(BRUTE)
			amount = round(amount * brute_mod, 0.1)
			external_wounding_multiplier = wound_check(species.injury_type, wounding_multiplier, edge, sharp)
		if(BURN)
			amount = round(amount * burn_mod, 0.1)
			external_wounding_multiplier = wound_check(species.injury_type, wounding_multiplier, edge, sharp)

	// Damage is transferred to internal organs. Chest and head must be broken before transferring unless they're slime limbs.
	if(LAZYLEN(internal_organs))
		var/can_transfer = FALSE	// Only applies to brute and burn
		if((organ_tag != BP_CHEST && organ_tag != BP_HEAD) || status & ORGAN_BROKEN || cannot_break)
			can_transfer = TRUE
		var/obj/item/organ/internal/I = pick(internal_organs)
		var/transferred_damage_amount
		switch(damage_type)
			if(BRUTE)
				transferred_damage_amount = can_transfer ? (amount - (max_damage - brute_dam) / armor_divisor) / 2 : 0
			if(BURN)
				var/damage_divisor = can_transfer ? 2 : 4
				transferred_damage_amount = (amount - (max_damage - burn_dam) / armor_divisor) / damage_divisor
			if(HALLOSS)
				transferred_damage_amount = 0
			else
				transferred_damage_amount = amount

		if(transferred_damage_amount > 0)
			if(I.take_damage(transferred_damage_amount, damage_type, wounding_multiplier, sharp, edge, FALSE))
				amount = round(max(amount / 2, amount - transferred_damage_amount), 0.1)

	if(amount <= 0)
		return FALSE

	if(used_weapon)
		add_autopsy_data("[used_weapon]", amount)

	// Handle remaining limb damage
	switch(damage_type)
		if(BRUTE)
			if(should_fracture())
				fracture()

			if(status & ORGAN_BROKEN && prob(40))
				if(owner && !(owner.species && (owner.species.flags & NO_PAIN)))
					owner.emote("scream")	//getting hit on broken hand hurts

			if(sharp && !BP_IS_ROBOTIC(src))
				if(!edge)
					createwound(PIERCE, amount * external_wounding_multiplier)
				else
					createwound(CUT, amount * external_wounding_multiplier)
			else
				createwound(BRUISE, amount * external_wounding_multiplier)
		if(BURN)
			if(status & ORGAN_BLEEDING)
				status &= ~ORGAN_BLEEDING

			createwound(BURN, amount * external_wounding_multiplier)

	// sync the organ's damage with its wounds
	update_damages()
	owner?.updatehealth() //droplimb will call updatehealth() again if it does end up being called

//If limb took enough damage and is broken, try to cut or tear it off
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
					if(status & ORGAN_BROKEN)
						if(edge_eligible && (amount + prev_brute) >= max_damage * DROPLIMB_THRESHOLD_EDGE)
							droplimb(TRUE, DROPLIMB_EDGE)
						else if((amount + prev_brute) >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
							droplimb(FALSE, DROPLIMB_BLUNT)
						else if((amount + prev_brute) >= max_damage * DROPLIMB_THRESHOLD_TEAROFF)
							droplimb(FALSE, DROPLIMB_EDGE)
				if(BURN)
					if(edge_eligible && (amount + prev_burn) >= max_damage * DROPLIMB_THRESHOLD_EDGE)
						droplimb(TRUE, DROPLIMB_EDGE_BURN)
					else if((amount + prev_burn) >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
						droplimb(TRUE, DROPLIMB_BURN)

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
