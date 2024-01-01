/mob/living/carbon/human/movement_delay()

	var/tally = ..()
	if(species.slowdown)
		tally += species.slowdown

	/// yes becauses we used to have -1 on shoes
	tally -= 1.2

	var/weightTally = (weight - initial(weight) - 20000 - statusEffects[SE_WEIGHT_OFFLOAD]) / 1000
	if(weightTally > 0)
		if(weightTally > 50)
			tally += weightTally*0.02
		tally += weightTally*0.03
	/// Slower if underenergized
	var/energyTally = getEnergyRatio()
	/// No boosts
	if(energyTally > 0)
		energyTally = 0
	tally -= energyTally

	if (istype(loc, /turf/space)) // It's hard to be slowed down in space by... anything
		return tally
	/// No slowdown for mech pilots , mech already handles movement.
	if(ismech(loc))
		return 0

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.
	if(CE_SPEEDBOOST in chem_effects)
		tally -= chem_effects[CE_SPEEDBOOST]
	if(isturf(loc))
		var/turf/T = loc
		if(T.get_lumcount() < 0.6)
			if(stats.getPerk(PERK_NIGHTCRAWLER))
				tally -= 0.5
			else if(see_invisible != SEE_INVISIBLE_NOLIGHTING)
				tally += 0.5
	if(stats.getPerk(PERK_FAST_WALKER))
		tally -= 0.5
	if(blocking)
		tally += 1

	if(recoil)
		var/obj/item/gun/GA = get_active_hand()
		var/obj/item/gun/GI = get_inactive_hand()

		var/brace_recoil = 0
		if(istype(GA))
			var/datum/recoil/R = GA.recoil
			brace_recoil = R.getRating(RECOIL_TWOHAND)
		if(istype(GI))
			var/datum/recoil/R = GI.recoil
			brace_recoil = max(brace_recoil, R.getRating(RECOIL_TWOHAND))

		if(brace_recoil)
			tally += CLAMP(round(recoil) / (60 / brace_recoil), 0, 8) // Scales with the size of the gun - bigger guns slow you more
		else
			tally += CLAMP(round(recoil) / 20, 0, 8) // Lowest possible while holding a gun

	var/obj/item/implant/core_implant/cruciform/C = get_core_implant(/obj/item/implant/core_implant/cruciform)
	if(C && C.active)
		var/obj/item/cruciform_upgrade/upgrade = C.upgrade
		if(upgrade && upgrade.active && istype(upgrade, CUPGRADE_SPEED_OF_THE_CHOSEN))
			var/obj/item/cruciform_upgrade/speed_of_the_chosen/sotc = upgrade
			tally -= sotc.speed_increase

	var/hunger_deficiency = (MOB_BASE_MAX_HUNGER - nutrition)
	if(hunger_deficiency >= 200) tally += (hunger_deficiency / 100) //If youre starving, movement slowdown can be anything up to 4.

	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		//Not porting bay's silly organ checking code here
		tally += 1 //Small slowdown so wheelchairs aren't turbospeed

	/*
	else
		if(wear_suit)
			tally += wear_suit.slowdown
		if(shoes)
			tally += shoes.slowdown
	*/

	//tally += min((shock_stage / 100) * 3, 3) //Scales from 0 to 3 over 0 to 100 shock stage
	tally += clamp((get_dynamic_pain() - get_painkiller()) / 40, 0, 3) // Scales from 0 to 3,

	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75
	tally += stance_damage // missing/damaged legs or augs affect speed

	if(slowdown)
		tally += 1

	tally += (r_hand?.slowdown_hold + l_hand?.slowdown_hold)

	return tally


/mob/living/carbon/human/allow_spacemove()
	//Can we act?
	if(restrained())	return 0

	//Do we have a working jetpack?
	var/obj/item/tank/jetpack/thrust = get_jetpack()

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
	else if(l_hand.volumeClass <= ITEM_SIZE_SMALL)
		prob_slip -= 1
	if (!r_hand)
		prob_slip -= 2
	else if(r_hand.volumeClass <= ITEM_SIZE_SMALL)
		prob_slip -= 1

	return prob_slip

/mob/living/carbon/human/check_shoegrip()
	if(species.flags & NO_SLIP)
		return 1
	if(shoes && (shoes.item_flags & NOSLIP) && istype(shoes, /obj/item/clothing/shoes/magboots))  //magboots + dense_object = no floating
		return 1
	return 0

/mob/living/carbon/human/add_momentum(direction)
	if(momentum_dir == direction)
		momentum_speed++
	else if(momentum_dir == reverse_dir[direction])
		momentum_speed = 0
		momentum_dir = direction
	else
		momentum_speed--
		momentum_dir = direction
	momentum_speed = CLAMP(momentum_speed, 0, 10)
	update_momentum()

/mob/living/carbon/human/proc/update_momentum()
	if(momentum_speed)
		momentum_reduction_timer = addtimer(CALLBACK(src, PROC_REF(calc_momentum)), 1 SECONDS, TIMER_STOPPABLE)
	else
		momentum_speed = 0
		deltimer(momentum_reduction_timer)

/mob/living/carbon/human/proc/calc_momentum()
	momentum_speed--
	update_momentum()

/mob/living/carbon/human/Move(NewLoc, Dir, step_x, step_y, glide_size_override, initiator = src)
	var/oldLoc = loc
	. = ..()
	if(oldLoc != NewLoc)
		/// 1000 From KG,  25 from conversion rate
		var/adjustment = (weight - initial(weight) - 20000) / 1000 / 25
		if(adjustment > 0)
			adjustEnergy(-adjustment)



