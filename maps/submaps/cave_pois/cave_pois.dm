#define PROB_HIGH 15
#define PROB_MID 10
#define PROB_LOW 5

/datum/map_template/cave_pois
	name = null
	var/description = "Cave point of interest."

	var/prefix = "maps/submaps/cave_pois/"
	var/suffix = null
	template_flags = 0 // No duplicates by default

	var/spawn_prob = 0
	var/min_seismic_lvl = 1  // Minimal seismic level for the poi to spawn
	var/size_x = 0
	var/size_y = 0

/datum/map_template/cave_pois/New()
	mappath += (prefix + suffix)

	..()

// Neutral rooms

/datum/map_template/cave_pois/neutral
	spawn_prob = PROB_HIGH
	min_seismic_lvl = 1
	size_x = 5
	size_y = 5

	name = "neutral 1"
	id = "cave_neutral1"
	suffix = "neutral1.dmm"

/datum/map_template/cave_pois/neutral/neutral2
	name = "neutral 2"
	id = "cave_neutral2"
	suffix = "neutral2.dmm"

/datum/map_template/cave_pois/neutral/neutral3
	name = "neutral 3"
	id = "cave_neutral3"
	suffix = "neutral3.dmm"

/datum/map_template/cave_pois/neutral/neutral4
	name = "neutral 4"
	id = "cave_neutral4"
	suffix = "neutral4.dmm"

/datum/map_template/cave_pois/neutral/neutral5
	name = "neutral 5"
	id = "cave_neutral5"
	suffix = "neutral5.dmm"

// Huts

/datum/map_template/cave_pois/hut
	spawn_prob = PROB_MID
	min_seismic_lvl = 3
	size_x = 7
	size_y = 7

	name = "hut 1"
	id = "cave_hut1"
	suffix = "hut1.dmm"

/datum/map_template/cave_pois/hut/hut2
	name = "hut 2"
	id = "cave_hut2"
	suffix = "hut2.dmm"

/datum/map_template/cave_pois/hut/hut3
	name = "hut 3"
	id = "cave_hut3"
	suffix = "hut3.dmm"

// Crashed pod

/datum/map_template/cave_pois/crashed_pod
	name = "crashed pod"
	id = "cave_crashed_pod"
	suffix = "crashed_pod.dmm"
	spawn_prob = PROB_MID
	min_seismic_lvl = 4
	size_x = 12
	size_y = 16

#undef PROB_HIGH
#undef PROB_MID
#undef PROB_LOW
