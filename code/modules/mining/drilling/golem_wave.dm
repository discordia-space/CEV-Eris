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
	var/special_interval  // Number of spawn events between a Special is spawned
	var/mineral_multiplier  // A multiplier of materials excavated by the drill
	// Active NT obelisk reduces golem_spawn by 1
	// Active NT obelisk increases special_interval golem_spawn by 1

/datum/golem_wave/dormant
	burrow_count = 3
	burrow_interval = 15 SECONDS
	golem_spawn = 2
	spawn_interval = 5 SECONDS
	special_interval = 0
	mineral_multiplier = 1.0

/datum/golem_wave/negligible
	burrow_count = 4
	burrow_interval = 15 SECONDS
	golem_spawn = 3
	spawn_interval = 5 SECONDS
	special_interval = 4
	mineral_multiplier = 1.1

/datum/golem_wave/typical
	burrow_count = 4
	burrow_interval = 12 SECONDS
	golem_spawn = 3
	spawn_interval = 4 SECONDS
	special_interval = 3
	mineral_multiplier = 1.2

/datum/golem_wave/substantial
	burrow_count = 6
	burrow_interval = 10 SECONDS
	golem_spawn = 3
	spawn_interval = 4 SECONDS
	special_interval = 3
	mineral_multiplier = 1.35

/datum/golem_wave/major
	burrow_count = 8
	burrow_interval = 8 SECONDS
	golem_spawn = 4
	spawn_interval = 4 SECONDS
	special_interval = 3
	mineral_multiplier = 1.5

/datum/golem_wave/abnormal
	burrow_count = 10
	burrow_interval = 6 SECONDS
	golem_spawn = 4
	spawn_interval = 3 SECONDS
	special_interval = 2
	mineral_multiplier = 2.0
