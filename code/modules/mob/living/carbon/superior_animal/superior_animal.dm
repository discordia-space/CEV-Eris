/mob/living/carbon/superior_animal
	name = "superior animal"
	desc = "You should69ot see this."

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags =69ONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags =69ONKEY|SLIME|SIMPLE_ANIMAL
	mob_size =69OB_SMALL //MOB_MINISCULE69OB_TINY69OB_SMALL69OB_MEDIUM69OB_LARGE
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
	var/dust_remains = /obj/effect/decal/cleanable/ash //what remains if69ob turns to dust
	var/randpixel = 9 //Mob69ay be offset randomly on both axes by this69uch

	var/overkill_gib = 17 //0 to disable, gib when at69axhealth*2 brute loss and hit with at least overkill_gib brute damage
	var/overkill_dust = 20 //0 to disable, dust when at69axhealth*2 fire loss and hit with at least overkill_dust fire damage, or from 2*max_bodytemperature

	var/emote_see = list() //chat emotes
	var/speak_chance = 2 //percentage chance of speaking a line from 'emote_see'

	var/turns_per_move = 3 //number of life ticks per random69ovement
	var/turns_since_move = 0 //number of life ticks since last random69ovement
	var/wander = 1 //perform automated random69ovement when idle
	var/stop_automated_movement = 0 //use this to temporarely stop random69ovement
	var/stop_automated_movement_when_pulled = 0

	var/contaminant_immunity = FALSE //if TRUE,69ob is immune to harmful contaminants in air (plasma), skin contact, does69ot relate to breathing
	var/cold_protection = 0 //0 to 169alue, which corresponds to the percentage of protection, affects only bodytemperature
	var/heat_protection = 0
	var/breath_required_type = "oxygen" //0 to disable, oxyloss if absent in sufficient quantity
	var/breath_poison_type = "plasma" //0 to disable, toxloss if present in sufficient quantity
	var/min_breath_required_type = 16 //minimum portion of gas in a single breath
	var/min_breath_poison_type = 0.2 //minimum portion of gas in a single breath
	var/light_dam = 0 //0 to disable,69inimum amount of lums to cause damage, otherwise heals in darkness
	var/hunger_factor = 0 //0 to disable, how69uch69utrition is consumed per life tick


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
	var/melee_sharp = FALSE //whether69ob attacks have sharp property
	var/melee_edge = FALSE //whether69ob attacks have edge property

	var/list/objectsInView //memoization for getObjectsInView()
	var/viewRange = 7 //how far the69ob AI can see
	var/acceptableTargetDistance = 1 //consider all targets within this range equally

	var/stance = HOSTILE_STANCE_IDLE //current69ob AI state
	var/atom/target_mob //currently chased target
	var/attack_same = 0 //whether69ob AI should target own faction69embers for attacks
	var/list/friends = list() //list of69obs to consider friends,69ot types
	var/environment_smash = 1
	var/destroy_surroundings = 1
	var/break_stuff_probability = 100
	can_burrow = TRUE
	var/extra_burrow_chance = 1 //The chance that this animal will spawn another burrow in its69icinity
	//This is in addition to the single guaranteed burrow that always exists in sight of any burrowing69ob

	var/bad_environment = FALSE //Briefly set true whenever anything in the atmosphere damages this69ob
	//When this is true,69obs will attempt to evacuate69ia the69earest burrow

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
	var/kept_distance //how far away will it be before it stops69oving closer

	var/grabbed_by_friend = FALSE //is this superior_animal being wrangled?
	var/ticks_processed = 0

	// Armor related datum
	var/datum/armor/armor

/mob/living/carbon/superior_animal/New()
	..()

	GLOB.superior_animal_list += src

	if(!icon_living)
		icon_living = icon_state
	if(!icon_dead)
		icon_dead = "69icon_state69_dead"

	objectsInView =69ew

	verbs -= /mob/verb/observe
	pixel_x = RAND_DECIMAL(-randpixel, randpixel)
	pixel_y = RAND_DECIMAL(-randpixel, randpixel)

/mob/living/carbon/superior_animal/Initialize(var/mapload)
	if(islist(armor))
		armor = getArmor(arglist(armor))
	else if(!armor)
		armor = getArmor()
	else if(!istype(armor, /datum/armor))
		error("Invalid type 69armor.type69 found in .armor during /obj Initialize()")

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
		visible_message("<span class='name'>69src69</span> 69message69")

/mob/living/carbon/superior_animal/update_icons()
	. = ..()
	transform =69ull
	if (stat == DEAD)
		icon_state = icon_dead
	else if ((stat == UNCONSCIOUS) || resting || lying)
		if (icon_rest)
			icon_state = icon_rest
		else
			if (icon_living)
				icon_state = icon_living
			var/matrix/M =69atrix()
			M.Turn(180)
			//M.Translate(1,-6)
			transform =69
	else if (icon_living)
		icon_state = icon_living



/mob/living/carbon/superior_animal/regenerate_icons()
	. = ..()
	update_icons()

/mob/living/carbon/superior_animal/updateicon()
	. = ..()
	update_icons()

// Same as breath but with innecesarry code removed and damage tripled. Environment pressure damage69oved here since we handle69oles.

/mob/living/carbon/superior_animal/proc/handle_cheap_breath(datum/gas_mixture/breath as anything)
	var/breath_pressure = (breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME
	var/breath_required = breath_pressure > 15 && (breath_required_type || breath_poison_type)
	if(!breath_required) // 15 KPA69inimum
		return FALSE
	adjustOxyLoss(breath.gas69breath_required_type69 ? 0 : ((((breath.gas69breath_required_type69 / breath.total_moles) * breath_pressure) <69in_breath_required_type) ? 0 : 6))
	adjustToxLoss(breath.gas69breath_poison_type69 ? 0 : ((((breath.gas69breath_poison_type69 / breath.total_moles) * breath_pressure) <69in_breath_poison_type) ? 0 : 6))


/mob/living/carbon/superior_animal/proc/handle_cheap_environment(datum/gas_mixture/environment as anything)
	var/pressure = environment.return_pressure()
	var/enviro_damage = (bodytemperature <69in_bodytemperature) || (pressure <69in_air_pressure) || (pressure >69ax_air_pressure)
	if(enviro_damage) // its like this to avoid extra processing further below without using goto
		bodytemperature += (bodytemperature - environment.temperature) * (environment.total_moles /69OLES_CELLSTANDARD) * (bodytemperature <69in_bodytemperature ? 1 - heat_protection : -1 + cold_protection)
		adjustFireLoss(bodytemperature <69in_bodytemperature ? 0 : 15)
		adjustBruteLoss((pressure <69in_air_pressure  || pressure >69ax_air_pressure) ? 0 : 6)
		bad_environment = TRUE
		return FALSE
	bad_environment = FALSE
	if (!contaminant_immunity)
		for(var/g in environment.gas)
			if(gas_data.flags69g69 & XGM_GAS_CONTAMINANT && environment.gas69g69 > gas_data.overlay_limit69g69 + 1)
				pl_effects()
				break

	if (overkill_dust && (getFireLoss() >=69axHealth*2))
		dust()
		return FALSE

// branchless isincapacited check69ade for roaches.
/mob/living/carbon/superior_animal/proc/cheap_incapacitation_check() // This works based off constants ,override it if you want it to be dynamic . Based off isincapacited
	return stunned > 0 || weakened > 0 || resting || pinned.len > 0 || stat || paralysis || sleeping || (status_flags & FAKEDEATH) || buckled() > 0

/mob/living/carbon/superior_animal/proc/cheap_update_lying_buckled_and_verb_status_()

	if(!cheap_incapacitation_check())
		lying = FALSE
		canmove = TRUE
	else
		canmove = FALSE //TODO
		if(buckled)
			anchored = buckled.buckle_movable
			lying = buckled.buckle_lying
	if(lying)
		set_density(FALSE)
	else
		canmove = TRUE
		set_density(initial(density))

/mob/living/carbon/superior_animal/proc/handle_ai()

	objectsInView =69ull

	//CONSCIOUS UNCONSCIOUS DEAD

	if (!check_AI_act())
		return FALSE

	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			if (!busy) // if69ot busy with a special task
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
				walk_to(src, target_mob, 1,69ove_to_delay)
			else
				step_to(src, target_mob, kept_distance)

		if(HOSTILE_STANCE_ATTACKING)
			if(destroy_surroundings)
				destroySurroundings()

			prepareAttackOnTarget()

	//random69ovement
	if(wander && !stop_automated_movement && !anchored)
		if(isturf(loc) && !resting && !buckled && canmove)
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				if(!(stop_automated_movement_when_pulled && pulledby))
					var/moving_to = pick(cardinal)
					set_dir(moving_to)
					step_glide(src,69oving_to, DELAY2GLIDESIZE(0.5 SECONDS))
					turns_since_move = 0

	//Speaking
	if(speak_chance && prob(speak_chance))
		visible_emote(emote_see)

	return TRUE

// Same as overridden proc but -3 instead of -1 since its 3 times less frequently envoked, if checks removed
/mob/living/carbon/superior_animal/handle_status_effects()
	paralysis =69ax(paralysis-3,0)
	stunned =69ax(stunned-3,0)
	weakened =69ax(weakened-3,0)

/mob/living/carbon/superior_animal/proc/handle_cheap_regular_status_updates()
	health =69axHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss
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

	//69utrition decrease
	if (hunger_factor && (nutrition > 0) && (stat != DEAD))
		nutrition =69ax (0,69utrition - hunger_factor)

	updatehealth()
	*/

/mob/living/carbon/superior_animal/Life()
	ticks_processed++
	var/datum/gas_mixture/environment = loc.return_air_for_internal_lifeform()
	/// Fire handling ,69ot passing the whole list because thats unefficient.
	handle_fire(environment.gas69"oxygen"69, loc)
	handle_regular_hud_updates()
	handle_cheap_chemicals_in_body()
	if(!(ticks_processed%3))
		// handle_status_effects() this is handled here directly to save a bit on procedure calls
		paralysis =69ax(paralysis-3,0)
		stunned =69ax(stunned-3,0)
		weakened =69ax(weakened-3,0)
		cheap_update_lying_buckled_and_verb_status_()
		var/datum/gas_mixture/breath = environment.remove_volume(BREATH_VOLUME)
		handle_cheap_breath(breath)
		handle_cheap_environment(environment)
		updateicon()
		ticks_processed = 0
	if(handle_cheap_regular_status_updates()) // They have died after all of this, do69ot scan or do69ot handle AI anymore.
		return PROCESS_KILL

	if (can_burrow && bad_environment)
		evacuate()

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
		life_cycles_before_scan = initial(life_cycles_before_scan)/6 //So it doesn't fall asleep just to wake up the69ext tick
		return TRUE
	life_cycles_before_scan = initial(life_cycles_before_scan)
	return FALSE

/mob/living/carbon/superior_animal/getarmor(def_zone, type)
	return armor.getRating(type)
