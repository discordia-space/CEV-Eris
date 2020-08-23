/obj/spawner/slime
	name = "a slime"
	icon_state = "hostilemob-cyan-cluster"
	alpha = 128
	tags_to_spawn = list(SPAWN_SLIME)

/obj/spawner/slimes/cluster
	name = "cluster of slimes"
	alpha = 128
	min_amount = 1
	max_amount = 3
	spread_range = 23

/obj/spawner/slimes/cluster/low_chance
	name = "low chance cluster of slimes"
	icon_state = "hostilemob-cyan-cluster-low"
	spawn_nothing_percentage = 60

/obj/spawner/slime/rainbow
	name = "cluster of colored slimes"

/obj/spawner/slime/rainbow/post_spawn(list/spawns)
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

/obj/spawner/slimes/rainbow/cluster
	name = "cluster of colored slimes"
	alpha = 128
	min_amount = 1
	max_amount = 3
	spread_range = 23
