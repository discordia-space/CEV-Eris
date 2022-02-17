#define SEISMIC_MIN 1
#define SEISMIC_MAX 6
GLOBAL_LIST_INIT(golem_waves, list(/datum/golem_wave/dormant,
                                   /datum/golem_wave/negligible,
                                   /datum/golem_wave/typical,
                                   /datum/golem_wave/substantial,
                                   /datum/golem_wave/major,
                                   /datum/golem_wave/abnormal))

/datum/golem_wave
	var/burrow_count  // Total number of burrows spawned over the course of drilling
	var/burrow_interval  // Number of seconds that pass between each new burrow spawns
	var/golem_spawn  // Number of golems spawned by each burrow on spawn event
	var/spawn_interval  // Number of seconds that pass between spawn events of burrows
	var/special_probability  // Probability of a golem being a special one instead of a normal one
	var/mineral_multiplier  // A multiplier of materials excavated by the drill
	// Active NT obelisk reduces golem_spawn by 1
	// Active NT obelisk reduces special_probability by 10 percent

/datum/golem_wave/dormant
	burrow_count = 2
	burrow_interval = 15 SECONDS
	golem_spawn = 2
	spawn_interval = 12 SECONDS
	special_probability = 0
	mineral_multiplier = 1.0

/datum/golem_wave/negligible
	burrow_count = 2
	burrow_interval = 12 SECONDS
	golem_spawn = 2
	spawn_interval = 10 SECONDS
	special_probability = 0
	mineral_multiplier = 1.1

/datum/golem_wave/typical
	burrow_count = 3
	burrow_interval = 12 SECONDS
	golem_spawn = 3
	spawn_interval = 9 SECONDS
	special_probability = 10
	mineral_multiplier = 1.2

/datum/golem_wave/substantial
	burrow_count = 3
	burrow_interval = 12 SECONDS
	golem_spawn = 3
	spawn_interval = 9 SECONDS
	special_probability = 20
	mineral_multiplier = 1.35

/datum/golem_wave/major
	burrow_count = 4
	burrow_interval = 10 SECONDS
	golem_spawn = 4
	spawn_interval = 7 SECONDS
	special_probability = 30
	mineral_multiplier = 1.5

/datum/golem_wave/abnormal
	burrow_count = 5
	burrow_interval = 9 SECONDS
	golem_spawn = 4
	spawn_interval = 6 SECONDS
	special_probability = 30
	mineral_multiplier = 2.0
