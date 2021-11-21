
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
    burrow_interval = 15
    golem_spawn = 2
    spawn_interval = 5
    special_interval = 0
    mineral_multiplier = 1.0

/datum/golem_wave/negligible
    burrow_count = 4
    burrow_interval = 15
    golem_spawn = 3
    spawn_interval = 5
    special_interval = 4
    mineral_multiplier = 1.1

/datum/golem_wave/typical
    burrow_count = 4
    burrow_interval = 12
    golem_spawn = 3
    spawn_interval = 4
    special_interval = 3
    mineral_multiplier = 1.2

/datum/golem_wave/substantial
    burrow_count = 6
    burrow_interval = 10
    golem_spawn = 3
    spawn_interval = 4
    special_interval = 3
    mineral_multiplier = 1.35

/datum/golem_wave/major
    burrow_count = 8
    burrow_interval = 8
    golem_spawn = 4
    spawn_interval = 4
    special_interval = 3
    mineral_multiplier = 1.5

/datum/golem_wave/abnormal
    burrow_count = 10
    burrow_interval = 6
    golem_spawn = 4
    spawn_interval = 3
    special_interval = 2
    mineral_multiplier = 2.0
