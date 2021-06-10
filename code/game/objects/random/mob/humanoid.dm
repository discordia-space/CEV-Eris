/obj/spawner/mob/humanoid
	name = "random humanoid"
	icon_state = "hostilemob-black"
	alpha = 128
	tags_to_spawn = list(SPAWN_MOB_HUMANOID)

/obj/spawner/mob/humanoid/low_chance
	name = "low chance random humanoid"
	icon_state = "hostilemob-black-low"
	spawn_nothing_percentage = 60
	spawn_blacklisted = TRUE
