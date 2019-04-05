/obj/random/cluster/slimes
	name = "cluster of slimes"
	icon_state = "hostilemob-cyan-cluster"
	alpha = 128
	min_amount = 1
	max_amount = 3
	spread_range = 2

/obj/random/cluster/slimes/rainbow
	name = "cluster of colored slimes"
	has_postspawn = TRUE

/obj/random/cluster/slimes/rainbow/post_spawn(var/list/spawns)
	var/list/colors = list("grey" = 10,
	"purple" = 4,
	"metal" = 4,
	"orange" = 4,
	"blue" = 4,
	"dark blue" = 2,
	"dark purple" = 2,
	"yellow" = 2,
	"silver" = 2,
	"pink" = 1,
	"red" = 1,
	"gold" = 1,
	"green" = 1)
	for (var/mob/living/carbon/slime/S in spawns)
		S.set_mutation(pickweight(colors))

/obj/random/cluster/slimes/item_to_spawn()
	return /mob/living/carbon/slime

/obj/random/cluster/slimes/low_chance
	name = "low chance cluster of slimes"
	icon_state = "hostilemob-cyan-cluster-low"
	spawn_nothing_percentage = 60

//Single Spawners
/obj/random/slime
	name = "a slime"
	icon_state = "hostilemob-cyan-cluster"
	alpha = 128
	min_amount = 1
	max_amount = 1
	spread_range = 0

/obj/random/slime/rainbow
	name = "cluster of colored slimes"
	has_postspawn = TRUE

/obj/random/slime/item_to_spawn()
	return /mob/living/carbon/slime

/obj/random/slime/rainbow/post_spawn(var/list/spawns)
	var/list/colors = list("grey" = 10,
	"purple" = 4,
	"metal" = 4,
	"orange" = 4,
	"blue" = 4,
	"dark blue" = 2,
	"dark purple" = 2,
	"yellow" = 2,
	"silver" = 2,
	"pink" = 1,
	"red" = 1,
	"gold" = 1,
	"green" = 1)
	for (var/mob/living/carbon/slime/S in spawns)
		S.set_mutation(pickweight(colors))
