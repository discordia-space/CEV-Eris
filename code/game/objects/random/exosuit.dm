/obj/spawner/exosuit
	name = "random exosuit"
	icon_state = "machine-red"
	tags_to_spawn = list(SPAWN_MECH_PREMADE)

/obj/spawner/exosuit/low_chance
	name = "low chance random lathe disk"
	icon_state = "machine-red-low"
	spawn_nothing_percentage = 90

/obj/spawner/exosuit/post_spawn(list/things)
	if(!damaged)
		return FALSE
	for (var/obj/a in things)
		a.make_old()

/obj/spawner/exosuit/damaged
	name = "random damaged exosuit"
	icon_state = "machine-red"
	damaged = TRUE

/obj/spawner/exosuit/damaged/low_chance
	name = "low chance random damaged exosuit"
	icon_state = "machine-red-low"
	spawn_nothing_percentage = 90

/obj/spawner/exosuit_equipment
	name = "random exosuit equipment"
	icon_state = "tech-red"
	tags_to_spawn = list(SPAWN_MECH_QUIPMENT)

/obj/spawner/mech_equipment/low_chance
	name = "low chance random exosuit equipment"
	icon_state = "tech-red-low"
	spawn_nothing_percentage = 80
