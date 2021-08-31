/obj/spawner/mob/slime
	name = "a slime"
	icon_state = "hostilemob-cyan"
	alpha = 128
	tags_to_spawn = list(SPAWN_SLIME)
	has_postspawn = FALSE

/obj/spawner/mob/slime/post_spawn(list/spawns)
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

/obj/spawner/mob/slime/cluster
	name = "cluster of slimes"
	icon_state = "hostilemob-cyan-cluster"
	alpha = 128
	min_amount = 1
	max_amount = 3
	spread_range = 2

/obj/spawner/mob/slime/cluster/low_chance
	name = "low chance cluster of slimes"
	icon_state = "hostilemob-cyan-cluster-low"
	spawn_nothing_percentage = 60
	spawn_blacklisted = TRUE

/obj/spawner/mob/slime/rainbow
	name = "cluster of colored slimes"
	has_postspawn = TRUE


/obj/spawner/mob/slime/cluster/rainbow
	name = "cluster of colored slimes"
	icon_state = "hostilemob-cyan-cluster"
	alpha = 128
	has_postspawn = TRUE
