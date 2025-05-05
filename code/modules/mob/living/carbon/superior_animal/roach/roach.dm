/mob/living/carbon/superior_animal/roach
	name = "Kampfer Roach"
	desc = "A monstrous, dog-sized cockroach. These huge mutants can be everywhere where humans are, on ships, planets and stations."

	icon_state = "roach"

	mob_size = MOB_SMALL

	density = FALSE //Swarming roaches! They also more robust that way.

	attack_sound = 'sound/voice/insect_battle_bite.ogg'
	emote_see = list("chirps loudly.", "cleans its whiskers with forelegs.")
	turns_per_move = 4
	turns_since_move = 0

	meat_type = /obj/item/reagent_containers/food/snacks/meat/roachmeat/kampfer
	meat_amount = 2

	maxHealth = 10
	health = 10

	var/blattedin_revives_left = 1 // how many times blattedin can get us back to life (as num for adminbus fun).

	melee_damage_lower = 4
	melee_damage_upper = 8
	wound_mult = WOUNDING_WIDE

	min_breath_required_type = 3
	min_air_pressure = 15 //below this, brute damage is dealt

	faction = "roach"
	pass_flags = PASSTABLE
	acceptableTargetDistance = 3 //consider all targets within this range equally
	randpixel = 12
	overkill_gib = 16

	sanity_damage = 0.5

	//spawn_values
	spawn_tags = SPAWN_TAG_ROACH
	rarity_value = 5

	var/atom/eat_target // target that the roach wants to eat
	var/fed = 0 // roach gets fed after eating a corpse
	var/probability_egg_laying = 25 // probability to lay an egg
	var/taming_window = 30 //How long you have to tame this roach, once it's pacified.
	var/busy_time // how long it will take to eat/lay egg
	var/busy_start_time // when it started eating/laying egg

	var/datum/overmind/roachmind/overseer

	// Armor related variables
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 25,
		rad = 50
	)

/mob/living/carbon/superior_animal/roach/New()
	. = ..()
	findOverseer()

/mob/living/carbon/superior_animal/roach/Destroy()
	clearEatTarget()
	leaveOvermind()
	return ..()

//When roaches die near a leader, the leader may call for reinforcements
/mob/living/carbon/superior_animal/roach/death()
	.=..()
	if(.)
		for(var/mob/living/carbon/superior_animal/roach/fuhrer/F in range(src,8))
			if(!F.stat)
				F.distress_call()

		layer = BELOW_MOB_LAYER // Below stunned roaches

		if(prob(3))
			visible_message(SPAN_DANGER("\the [src] hacks up a tape!"))
			new /obj/item/music_tape(get_turf(src))

	else if(prob(10))
		visible_message(SPAN_DANGER("\the [src] drops behind a gift basket!"))

	if(!blattedin_revives_left)
		leaveOvermind()
	else
		overseer?.casualties |= src

/mob/living/carbon/superior_animal/roach/updatehealth()
	. = ..()
	if(overseer)
		overseer.awaken()


/mob/living/carbon/superior_animal/roach/commandchain(mob/potentialally) // this proc bypasses the 33 roach limit.
	. = ..()
	if(.)
		if(istype(potentialally, /mob/living/carbon/superior_animal/roach/))
			var/mob/living/carbon/superior_animal/roach/comrade = potentialally
			switch(type)
				if(/mob/living/carbon/superior_animal/roach/fuhrer) // two possibilities that matter with fuhrer
					if(istype(comrade, /mob/living/carbon/superior_animal/roach/fuhrer))
						if(!overseer && comrade.overseer) // if one of us was abandoned, join up.
							joinOvermind(comrade.overseer)
						else if(overseer && !comrade.overseer)
							comrade.joinOvermind(overseer)
						else if(!overseer && !comrade.overseer)
							var/datum/overmind/roachmind/newmind = new() // team up to make a two fuhrer overmind, with the caller being the leader
							newmind.leader = comrade
							comrade.joinOvermind(newmind)
							joinOvermind(newmind)
					else if(istype(comrade, /mob/living/carbon/superior_animal/roach/kaiser))
						if(overseer && comrade.overseer)
							overseer.rearrangeOverminds(comrade.overseer)
						else if(overseer && overseer.leader == src) // replace the leader
							comrade.joinOvermind(overseer)
							overseer.leader = comrade
						else if(!overseer && comrade.overseer) // or if they have an overmind and we don't, we join
							joinOvermind(overseer)
				if(/mob/living/carbon/superior_animal/roach/kaiser) // only one possibility requires code with kaiser
					if(istype(comrade, /mob/living/carbon/superior_animal/roach/fuhrer))
						if(overseer && comrade.overseer)
							overseer.rearrangeOverminds(comrade.overseer)
						else if(comrade.overseer && comrade.overseer.leader == comrade) // replace the leader
							joinOvermind(comrade.overseer)
							comrade.overseer.leader = src
						else if(overseer && !comrade.overseer)
							comrade.joinOvermind(overseer)
				else
					if(!overseer && istype(comrade, /mob/living/carbon/superior_animal/roach/fuhrer) || istype(comrade, /mob/living/carbon/superior_animal/roach/kaiser) && comrade.overseer)
						joinOvermind(comrade.overseer)
