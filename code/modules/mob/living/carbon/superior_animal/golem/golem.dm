#define GOLEM_HEALTH_LOW 20
#define GOLEM_HEALTH_MED 40
#define GOLEM_HEALTH_HIGH 60
#define GOLEM_HEALTH_ULTRA 80

#define GOLEM_ARMOR_LOW 5
#define GOLEM_ARMOR_MED 8
#define GOLEM_ARMOR_HIGH 12
#define GOLEM_ARMOR_ULTRA 18

#define GOLEM_DMG_FEEBLE 5
#define GOLEM_DMG_LOW 15
#define GOLEM_DMG_MED 25
#define GOLEM_DMG_HIGH 40
#define GOLEM_DMG_ULTRA 55

#define GOLEM_SPEED_SLUG 9
#define GOLEM_SPEED_LOW 7
#define GOLEM_SPEED_MED 5
#define GOLEM_SPEED_HIGH 3

#define GOLEM_REGENERATION 10  // Healing by special ability of uranium golems

/mob/living/carbon/superior_animal/golem
	icon = 'icons/mob/golems.dmi'

	mob_size = MOB_MEDIUM

	//spawn_values
	rarity_value = 37.5
	spawn_frequency = 10
	spawn_tags = SPAWN_TAG_MOB_GOLEM
	faction = "golem"

	deathmessage = "shatters in a pile of rubbles."
	attacktext = list("bonked")
	attack_sound = 'sound/weapons/smash.ogg'
	speak_emote = list("rattles")
	emote_see = list("makes a deep rattling sound")
	speak_chance = 5

	see_in_dark = 10
	meat_type = null
	meat_amount = 0
	stop_automated_movement_when_pulled = 0
	wander = FALSE
	viewRange = 8
	kept_distance = 0

	destroy_surroundings = TRUE

	contaminant_immunity = TRUE
	cold_protection = 1
	heat_protection = 1
	breath_required_type = 0
	breath_poison_type = 0
	min_breath_required_type = 0
	min_breath_poison_type = 0
	min_air_pressure = 0 //below this, brute damage is dealt
	max_air_pressure = 10000 //above this, brute damage is dealt
	min_bodytemperature = 0 //below this, burn damage is dealt
	max_bodytemperature = 10000 //above this, burn damage is dealt

	// Damage multiplier when destroying surroundings
	var/surrounds_mult = 0.5

	// Ore datum the golem holds.
	var/ore/mineral
	var/mineral_name
	var/oremult = 1

	var/targetrecievedtime = -250

/mob/living/carbon/superior_animal/golem/Initialize(mapload, var/datum/cave_difficulty_level/difficulty)
	if(mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]

	if(difficulty)
		oremult = difficulty.golem_ore_mult
	. = ..()

/mob/living/carbon/superior_animal/golem/Destroy()
	mineral = null
	..()

/mob/living/carbon/superior_animal/golem/death(gibbed, message = deathmessage)
	. = ..()

	// Spawn ores
	if(mineral)
		var/nb_ores =  CEILING((mineral.result_amount + rand(-3, 3)) * oremult, 1)
		for(var/i in 1 to nb_ores)
			new mineral.ore(loc)

		if(prob(20))
			new /obj/item/golem_core(loc)

	// Poof
	qdel(src)

/mob/living/carbon/superior_animal/golem/gib(anim = icon_gib, do_gibs = FALSE)
	. = ..(anim, FALSE)  // No gibs when gibbing a golem (no blood)

/mob/living/carbon/superior_animal/golem/destroySurroundings()
	// Get next turf the golem wants to walk on
	var/turf/T = get_step_towards(src, target_mob)

	if(iswall(T))  // Wall breaker attack
		T.attack_generic(src, rand(surrounds_mult * melee_damage_lower, surrounds_mult * melee_damage_upper), pick(attacktext), TRUE)
	else
		var/obj/structure/obstacle = locate(/obj/structure) in T
		if(obstacle)
			obstacle.attack_generic(src, rand(surrounds_mult * melee_damage_lower, surrounds_mult * melee_damage_upper), pick(attacktext), TRUE)

/mob/living/carbon/superior_animal/golem/handle_ai()

	objectsInView = null

	//CONSCIOUS UNCONSCIOUS DEAD

	if(!check_AI_act())
		return FALSE

	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			if(!busy) // if not busy with a special task
				stop_automated_movement = FALSE
			target_mob = findTarget()
			if(target_mob)
				stance = HOSTILE_STANCE_ATTACK
				for(var/mob/living/carbon/superior_animal/golem/ally in getMobsInRangeChunked(src, 5, TRUE))
					if(!ally.target_mob)
						ally.stance = HOSTILE_STANCE_ATTACK
						ally.target_mob = target_mob
						ally.targetrecievedtime = world.time
						ally.try_activate_ai() // otherwise we attack alone even if a target is set

		if(HOSTILE_STANCE_ATTACK)
			if(destroy_surroundings)
				destroySurroundings()

			stop_automated_movement = TRUE
			stance = HOSTILE_STANCE_ATTACKING

			updatePathFinding()

		if(HOSTILE_STANCE_ATTACKING)
			if(destroy_surroundings)
				destroySurroundings()

			if(retreat_on_too_close)
				updatePathFinding() //retreating enemies need to update their pathfinding way more often

			if(((targetrecievedtime + 5 SECONDS) > world.time) && (target_mob.z == z)) // golems will disregard target validity temporarily after another golem gives them a target, so that they don't immediately lose their target
				attemptAttackOnTarget()
			else
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

	return TRUE

/mob/living/carbon/superior_animal/golem/prepareAttackOnTarget()
	stop_automated_movement = 1

	if(!target_mob || !isValidAttackTarget(target_mob))
		loseTarget()
		return

	if((get_dist(src, target_mob) >= (viewRange + kept_distance)) || src.z != target_mob.z) //golems with a kept distance need to be further away to lose their gargets, to avoid losing targets by trying to keep distance
		loseTarget()
		return

	attemptAttackOnTarget()

/mob/living/carbon/superior_animal/golem/proc/updatePathFinding() // moved to a separate proc to avoid code repeats
	set_glide_size(DELAY2GLIDESIZE(move_to_delay))
	if(!retreat_on_too_close || (get_dist(loc, target_mob.loc) > kept_distance)) // if this AI doesn't retreat or the target is further than our retreat distance, walk to them.
		walk_to(src, target_mob, kept_distance + 1, move_to_delay)
	else
		walk_away(src,target_mob,kept_distance,move_to_delay) // warning: mobs will strafe nonstop if they can't get far enough awaye)

