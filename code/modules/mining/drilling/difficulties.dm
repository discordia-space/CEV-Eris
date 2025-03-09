/datum/cave_difficulty_level //using a datum here lets me simplify the spawn pool logic and declutter cave_generator.dm in the process
	var/golem_ore_mult = 1

	//number of golems to spawn *per squad*
	var/golem_count_melee = 0
	var/golem_count_ranged = 0
	var/golem_count_mixed = 0 // the "mixed" pool is the concatenation of the melee and ranged pools

	//lists of types and weights
	var/list/golem_weights_melee = list()
	var/list/golem_weights_ranged = list()

/datum/cave_difficulty_level/proc/get_golem_spawns()
	var/list/golems_to_spawn = list() //list of golem types to spawn
	if(golem_count_melee)
		for(var/c = 0, c < golem_count_melee, c++)
			golems_to_spawn += pickweight(golem_weights_melee)

	if(golem_count_ranged)
		for(var/c = 0, c < golem_count_ranged, c++)
			golems_to_spawn += pickweight(golem_weights_ranged)

	if(golem_count_mixed)
		var/list/golem_weights_mixed = golem_weights_melee + golem_weights_ranged
		for(var/c = 0, c < golem_count_mixed, c++)
			golems_to_spawn += pickweight(golem_weights_mixed)

	return golems_to_spawn

//Seismic Level 1
//Easy enough to figure out the basics, but not very rewarding.
/datum/cave_difficulty_level/beginner
	golem_count_mixed = 3

	golem_weights_melee = list(
		/mob/living/carbon/superior_animal/golem/iron = 3,
		/mob/living/carbon/superior_animal/golem/coal = 2)

//Seismic Level 2
//Tougher, more rewarding.
/datum/cave_difficulty_level/novice
	golem_ore_mult = 1.75

	golem_count_mixed = 3

	golem_weights_melee = list(
		/mob/living/carbon/superior_animal/golem/iron = 3,
		/mob/living/carbon/superior_animal/golem/coal = 2)

	golem_weights_ranged = list(
		/mob/living/carbon/superior_animal/golem/silver = 2)

//Seismic Level 3
//Ever harder. The golems introduced here are hard to fight alone. This is the limit for a solo miner on their roundstart gear.
/datum/cave_difficulty_level/adept
	golem_ore_mult = 2.5

	golem_count_melee = 1
	golem_count_ranged = 1
	golem_count_mixed = 3

	golem_weights_melee = list(
		/mob/living/carbon/superior_animal/golem/iron = 4,
		/mob/living/carbon/superior_animal/golem/coal = 2,
		/mob/living/carbon/superior_animal/golem/platinum = 3)

	golem_weights_ranged = list(
		/mob/living/carbon/superior_animal/golem/silver = 3,
		/mob/living/carbon/superior_animal/golem/uranium = 1)

//Seismic Level 4
//Teams should start to have trouble here; graphite golems make plasma and platinum golems very dangerous.
/datum/cave_difficulty_level/experienced
	golem_ore_mult = 3.25

	golem_count_melee = 1
	golem_count_ranged = 1
	golem_count_mixed = 3

	golem_weights_melee = list(
		/mob/living/carbon/superior_animal/golem/iron = 4,
		/mob/living/carbon/superior_animal/golem/coal/enhanced = 2,
		/mob/living/carbon/superior_animal/golem/platinum = 3,
		/mob/living/carbon/superior_animal/golem/plasma = 2)

	golem_weights_ranged = list(
		/mob/living/carbon/superior_animal/golem/silver = 3,
		/mob/living/carbon/superior_animal/golem/uranium = 1)

//Seismic Level 5
//All the lethal golems are out now. A lot of prep or a lot of manpower is necessary to survive this.
/datum/cave_difficulty_level/expert
	golem_ore_mult = 4

	golem_count_melee = 2
	golem_count_ranged = 2
	golem_count_mixed = 1

	golem_weights_melee = list(
		/mob/living/carbon/superior_animal/golem/iron = 3,
		/mob/living/carbon/superior_animal/golem/coal/enhanced = 2,
		/mob/living/carbon/superior_animal/golem/platinum = 3,
		/mob/living/carbon/superior_animal/golem/plasma = 2)
	golem_weights_ranged = list(
		/mob/living/carbon/superior_animal/golem/silver/enhanced = 3,
		/mob/living/carbon/superior_animal/golem/gold = 3,
		/mob/living/carbon/superior_animal/golem/uranium = 2)

//Seismic Level 6
//Hell. Ansibles will rip teams apart and diamonds are walking tanks unless you've invested in ballistics.
/datum/cave_difficulty_level/nightmare
	golem_ore_mult = 4

	golem_count_melee = 2
	golem_count_ranged = 2
	golem_count_mixed = 1

	golem_weights_melee = list(
		/mob/living/carbon/superior_animal/golem/iron = 3,
		/mob/living/carbon/superior_animal/golem/coal/enhanced = 2,
		/mob/living/carbon/superior_animal/golem/platinum = 3,
		/mob/living/carbon/superior_animal/golem/plasma = 2,
		/mob/living/carbon/superior_animal/golem/diamond = 2)
	golem_weights_ranged = list(
		/mob/living/carbon/superior_animal/golem/silver/enhanced = 3,
		/mob/living/carbon/superior_animal/golem/gold = 3,
		/mob/living/carbon/superior_animal/golem/uranium = 2,
		/mob/living/carbon/superior_animal/golem/ansible = 2)
