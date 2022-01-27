/obj/spawner/mob/slime
	name = "a slime"
	icon_state = "hostilemob-cyan"
	alpha = 128
	ta69s_to_spawn = list(SPAWN_SLIME)
	has_postspawn = FALSE

/obj/spawner/mob/slime/post_spawn(list/spawns)
	var/list/colors = list("69rey" = 10,
	"purple" = 4,
	"metal" = 4,
	"oran69e" = 4,
	"blue" = 4,
	"dark blue" = 2,
	"dark purple" = 2,
	"yellow" = 2,
	"silver" = 2,
	"pink" = 1,
	"red" = 1,
	"69old" = 1,
	"69reen" = 1)
	for (var/mob/livin69/carbon/slime/S in spawns)
		S.set_mutation(pickwei69ht(colors))

/obj/spawner/mob/slime/cluster
	name = "cluster of slimes"
	icon_state = "hostilemob-cyan-cluster"
	alpha = 128
	min_amount = 1
	max_amount = 3
	spread_ran69e = 2

/obj/spawner/mob/slime/cluster/low_chance
	name = "low chance cluster of slimes"
	icon_state = "hostilemob-cyan-cluster-low"
	spawn_nothin69_percenta69e = 60
	spawn_blacklisted = TRUE

/obj/spawner/mob/slime/rainbow
	name = "cluster of colored slimes"
	has_postspawn = TRUE


/obj/spawner/mob/slime/cluster/rainbow
	name = "cluster of colored slimes"
	icon_state = "hostilemob-cyan-cluster"
	alpha = 128
	has_postspawn = TRUE
