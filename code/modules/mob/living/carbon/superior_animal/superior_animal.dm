/mob/living/carbon/superior_animal
	name = "superior animal"
	desc = "You should not see this."

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_size = MOB_SMALL //MOB_MINISCULE MOB_TINY MOB_SMALL MOB_MEDIUM MOB_LARGE
	a_intent = I_HURT

	icon = 'icons/mob/animal.dmi'
	icon_state = "tomato"
	// AI activation for players is handled in sanity , if it has sanity damage it activates AI.
	sanity_damage = 0.5

	var/icon_living
	var/icon_dead
	var/icon_rest //resting/unconscious animation
	var/icon_gib //gibbing animation
	var/icon_dust //dusting animation
	var/dust_remains = /obj/effect/decal/cleanable/ash //what remains if mob turns to dust
	var/randpixel = 9 //Mob may be offset randomly on both axes by this much

	var/overkill_gib = 17 //0 to disable, gib when at maxhealth*2 brute loss and hit with at least overkill_gib brute damage
	var/overkill_dust = 20 //0 to disable, dust when at maxhealth*2 fire loss and hit with at least overkill_dust fire damage, or from 2*max_bodytemperature

	var/emote_see = list() //chat emotes
	var/speak_chance = 2 //percentage chance of speaking a line from 'emote_see'

	var/turns_per_move = 3 //number of life ticks per random movement
	var/turns_since_move = 0 //number of life ticks since last random movement
	var/wander = 1 //perform automated random movement when idle
	var/stop_automated_movement = 0 //use this to temporarely stop random movement
	var/stop_automated_movement_when_pulled = 0

	var/contaminant_immunity = FALSE //if TRUE, mob is immune to harmful contaminants in air (plasma), skin contact, does not relate to breathing
	var/cold_protection = 0 //0 to 1 value, which corresponds to the percentage of protection, affects only bodytemperature
	var/heat_protection = 0
	var/breath_required_type = "oxygen" //0 to disable, oxyloss if absent in sufficient quantity
	var/breath_poison_type = "plasma" //0 to disable, toxloss if present in sufficient quantity
	var/min_breath_required_type = 16 //minimum portion of gas in a single breath
	var/min_breath_poison_type = 0.2 //minimum portion of gas in a single breath
	var/light_dam = 0 //0 to disable, minimum amount of lums to cause damage, otherwise heals in darkness
	var/hunger_factor = 0 //0 to disable, how much nutrition is consumed per life tick


	var/min_air_pressure = 50 //below this, brute damage is dealt
	var/max_air_pressure = 300 //above this, brute damage is dealt
	var/min_bodytemperature = 200 //below this, burn damage is dealt
	var/max_bodytemperature = 360 //above this, burn damage is dealt

	var/deathmessage = "dies."
	var/attacktext = "bitten"
	var/attack_sound = 'sound/weapons/spiderlunge.ogg'
	var/attack_sound_chance = 33
	var/attack_sound_volume = 20

	var/meat_type = /obj/item/reagent_containers/food/snacks/meat/roachmeat
	var/meat_amount = 3

	var/melee_damage_lower = 0
	var/melee_damage_upper = 10

	var/list/objectsInView //memoization for getObjectsInView()
	var/viewRange = 7 //how far the mob AI can see
	var/acceptableTargetDistance = 1 //consider all targets within this range equally

	var/stance = HOSTILE_STANCE_IDLE //current mob AI state
	var/atom/target_mob //currently chased target
	var/attack_same = 0 //whether mob AI should target own faction members for attacks
	var/list/friends = list() //list of mobs to consider friends, not types
	var/environment_smash = 1
	var/destroy_surroundings = 1
	var/break_stuff_probability = 100
	can_burrow = TRUE
	var/extra_burrow_chance = 1 //The chance that this animal will spawn another burrow in its vicinity
	//This is in addition to the single guaranteed burrow that always exists in sight of any burrowing mob

	var/bad_environment = FALSE //Briefly set true whenever anything in the atmosphere damages this mob
	//When this is true, mobs will attempt to evacuate via the nearest burrow

	var/busy = 0 // status of the animal, if it is doing a special task (eating, spinning web) we still want it
	// in HOSTILE_STANCE_IDLE to react to threat but we don't want stop_automated_movement set back to 0 in Life()

	var/fleshcolor = "#666600"
	var/bloodcolor = "#666600"

	var/ranged = 0 //will it shoot?
	var/rapid = 0 //will it shoot fast?
	var/projectiletype
	var/projectilesound
	var/casingtype
	var/ranged_cooldown
	var/fire_verb //what does it do when it shoots?
	var/kept_distance //how far away will it be before it stops moving closer

	var/grabbed_by_friend = FALSE //is this superior_animal being wrangled?
	var/ticks_processed = 0

/mob/living/carbon/superior_animal/New()
	..()

	GLOB.superior_animal_list += src

	if(!icon_living)
		icon_living = icon_state
	if(!icon_dead)
		icon_dead = "[icon_state]_dead"

	objectsInView = new

	verbs -= /mob/verb/observe
	pixel_x = RAND_DECIMAL(-randpixel, randpixel)
	pixel_y = RAND_DECIMAL(-randpixel, randpixel)


/mob/living/carbon/superior_animal/Initialize(var/mapload)
	.=..()
	if (mapload && can_burrow)
		find_or_create_burrow(get_turf(src))
		if (prob(extra_burrow_chance))
			create_burrow(get_turf(src))

/mob/living/carbon/superior_animal/Destroy()
	GLOB.superior_animal_list -= src
	. = ..()

/mob/living/carbon/superior_animal/u_equip(obj/item/W)
	return

/mob/living/carbon/superior_animal/proc/visible_emote(message)
	if(islist(message))
		message = safepick(message)
	if(message)
		visible_message("<span class='name'>[src]</span> [message]")

/mob/living/carbon/superior_animal/update_icons()
	. = ..()
	transform = null
	if (stat == DEAD)
		icon_state = icon_dead
	else if ((stat == UNCONSCIOUS) || resting || lying)
		if (icon_rest)
			icon_state = icon_rest
		else
			if (icon_living)
				icon_state = icon_living
			var/matrix/M = matrix()
			M.Turn(180)
			//M.Translate(1,-6)
			transform = M
	else if (icon_living)
		icon_state = icon_living



/mob/living/carbon/superior_animal/regenerate_icons()
	. = ..()
	update_icons()

/mob/living/carbon/superior_animal/updateicon()
	. = ..()
	update_icons()

// Same as breath but with innecesarry code removed and damage tripled. Environment pressure damage moved here since we handle moles.
/mob/living/carbon/superior_animal/proc/handle_cheap_breath(datum/gas_mixture/breath as anything)
	if(!(breath.total_moles))
		adjustBruteLoss(6)
		if(breath_required_type)
			adjustOxyLoss(6)
		bad_environment = TRUE
		return FALSE // in either cases , no breath poison type to handle
	var/breath_pressure = (breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME
	if(breath_required_type)
		var/inhaling = breath.gas[breath_required_type]
		var/inhale_pp = (inhaling/breath.total_moles)*breath_pressure
		if(inhale_pp < min_breath_required_type)
			adjustOxyLoss(6)
			bad_environment = TRUE
	if(breath_poison_type)
		var/poison = breath.gas[breath_poison_type]
		var/toxins_pp = (poison/breath.total_moles)*breath_pressure
		if(toxins_pp > min_breath_poison_type)
			adjustToxLoss(6)

	return TRUE

/mob/living/carbon/superior_animal/proc/handle_cheap_environment(datum/gas_mixture/environment as anything)
	if((bodytemperature > max_bodytemperature) || (bodytemperature < min_bodytemperature)) // its like this to avoid extra processing further below without using goto
		bad_environment = TRUE
		adjustFireLoss(15)
	if(istype(get_turf(src), /turf/space))
		if(bodytemperature > 1)
			bodytemperature = max(1,bodytemperature - 30*(1-get_cold_protection(0)))
		if(min_air_pressure)
			adjustBruteLoss(6)
		if(breath_required_type)
			adjustOxyLoss(6)
		bad_environment = TRUE
		return FALSE
	bad_environment = FALSE
	if (!contaminant_immunity)
		for(var/g in environment.gas)
			if(gas_data.flags[g] & XGM_GAS_CONTAMINANT && environment.gas[g] > gas_data.overlay_limit[g] + 1)
				pl_effects()
				break

	var/loc_temp = T0C
	loc_temp = environment.temperature
	var/pressure = environment.return_pressure()
	if(pressure < min_air_pressure || pressure > max_air_pressure)
		adjustBruteLoss(6)
	//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection (convection)
	var/temp_adj = 0
	var/thermal_protection = 0
	var/relative_density = environment.total_moles / MOLES_CELLSTANDARD
	if(loc_temp < bodytemperature) //Place is colder than we are
		thermal_protection = get_cold_protection(loc_temp) //0 to 1 value, which corresponds to the percentage of protection
		temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR)//this will be negative
	else if(loc_temp > bodytemperature) //Place is hotter than we are
		thermal_protection = get_heat_protection(loc_temp) //0 to 1 value, which corresponds to the percentage of protection
		temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR)
	bodytemperature += between(BODYTEMP_COOLING_MAX, 3*temp_adj*relative_density, BODYTEMP_HEATING_MAX)*3 // Multiplied by 3 because of reduced frequency

	if (overkill_dust && (getFireLoss() >= maxHealth*2))
		dust()
		return FALSE

	//If we're unable to breathe, lets get out of here
	if (can_burrow && !stat && bad_environment)
		evacuate()

/mob/living/carbon/superior_animal/proc/cheap_update_lying_buckled_and_verb_status_()

	if(!resting && cannot_stand() && can_stand_overridden())
		lying = 0
		canmove = TRUE //TODO: Remove this
	else if(buckled)
		anchored = TRUE
		if(istype(buckled))
			if(buckled.buckle_lying == -1)
				lying = incapacitated(INCAPACITATION_KNOCKDOWN)
			else
				lying = buckled.buckle_lying
			if(buckled.buckle_movable)
				anchored = FALSE
		canmove = FALSE //TODO: Remove this
	else
		lying = incapacitated(INCAPACITATION_KNOCKDOWN)
		canmove = FALSE //TODO: Remove this

	if(lying)
		set_density(FALSE)
	else
		canmove = TRUE
		set_density(initial(density))
	reset_layer()
	if(update_icon)	//forces a full overlay update
		update_icon = FALSE
		regenerate_icons()

/mob/living/carbon/superior_animal/proc/handle_ai()

	objectsInView = null

	//CONSCIOUS UNCONSCIOUS DEAD

	if (!check_AI_act())
		return FALSE
	. = TRUE
	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			if (!busy) // if not busy with a special task
				stop_automated_movement = FALSE
			target_mob = findTarget()
			if (target_mob)
				stance = HOSTILE_STANCE_ATTACK

		if(HOSTILE_STANCE_ATTACK)
			if(destroy_surroundings)
				destroySurroundings()

			stop_automated_movement = TRUE
			stance = HOSTILE_STANCE_ATTACKING
			set_glide_size(DELAY2GLIDESIZE(move_to_delay))
			if(!kept_distance)
				walk_to(src, target_mob, 1, move_to_delay)
			else
				step_to(src, target_mob, kept_distance)

		if(HOSTILE_STANCE_ATTACKING)
			if(destroy_surroundings)
				destroySurroundings()

			prepareAttackOnTarget()

	//random movement
	if(wander && !stop_automated_movement && !anchored)
		if(isturf(loc) && !resting && !buckled && canmove)
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				if(!(stop_automated_movement_when_pulled && pulledby))
					var/moving_to = pick(cardinal)
					set_dir(moving_to)
					step_glide(src, moving_to, DELAY2GLIDESIZE(0.5 SECONDS))
					turns_since_move = 0

	//Speaking
	if(speak_chance && prob(speak_chance))
		visible_emote(emote_see)

// Same as overridden proc but -3 instead of -1 since its 3 times less frequently envoked
/mob/living/carbon/superior_animal/handle_status_effects()
	if(paralysis)
		paralysis = max(paralysis-3,0)
	if(stunned)
		stunned = max(stunned-3,0)
	if(weakened)
		weakened = max(weakened-3,0)

/mob/living/carbon/superior_animal/proc/handle_cheap_regular_status_updates()
	health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss
	if(health <= 0 && stat != DEAD)
		death()
		// STOP_PROCESSING(SSmobs, src) This is handled in Superior animal Life().
		blinded = TRUE
		silent = FALSE
		return TRUE
	return FALSE

/mob/living/carbon/superior_animal/proc/handle_cheap_chemicals_in_body()
	if(reagents)
		chem_effects.Cut()
		if(touching)
			touching.metabolize()
		if(bloodstr)
			bloodstr.metabolize()

	/*
	if(light_dam)
		var/light_amount = 0
		if(isturf(loc))
			var/turf/T = loc
			light_amount = round((T.get_lumcount()*10)-5)

		if(light_amount > light_dam) //if there's enough light, start dying
			take_overall_damage(1,1)
		else //heal in the dark
			heal_overall_damage(1,1)

	// nutrition decrease
	if (hunger_factor && (nutrition > 0) && (stat != DEAD))
		nutrition = max (0, nutrition - hunger_factor)

	updatehealth()
	*/

/mob/living/carbon/superior_animal/Life()
	ticks_processed++
	handle_fire()
	handle_regular_hud_updates()
	handle_cheap_chemicals_in_body()
	if(!(ticks_processed%3))
		handle_status_effects()
		cheap_update_lying_buckled_and_verb_status_()
		var/datum/gas_mixture/breath = get_breath_from_environment()
		if(breath)
			handle_cheap_breath(breath)
		var/datum/gas_mixture/environment = loc.return_air_for_internal_lifeform()
		handle_cheap_environment(environment)
		updateicon()
		ticks_processed = 0
	if(handle_cheap_regular_status_updates()) // They have died after all of this, do not scan or do not handle AI anymore.
		return PROCESS_KILL

	if(!AI_inactive)
		handle_ai()
	if(life_cycles_before_sleep)
		life_cycles_before_sleep--
		return TRUE
	if(!(AI_inactive && life_cycles_before_sleep))
		AI_inactive = TRUE

	if(life_cycles_before_scan)
		life_cycles_before_scan--
		return FALSE
	if(check_surrounding_area(7))
		activate_ai()
		life_cycles_before_scan = initial(life_cycles_before_scan)/6 //So it doesn't fall asleep just to wake up the next tick
		return TRUE
	life_cycles_before_scan = initial(life_cycles_before_scan)
	return FALSE

