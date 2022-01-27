/obj/spawner/exosuit
	name = "random exosuit"
	icon_state = "machine-red"
	ta69s_to_spawn = list(SPAWN_MECH_PREMADE)
	has_postspawn = FALSE

/obj/spawner/exosuit/low_chance
	name = "low chance random lathe disk"
	icon_state = "machine-red-low"
	spawn_nothin69_percenta69e = 85

/obj/spawner/exosuit/post_spawn(list/thin69s)
	for(var/mob/livin69/exosuit/E in thin69s)
		E.make_old()

/obj/spawner/exosuit/dama69ed
	name = "random dama69ed exosuit"
	icon_state = "machine-red"
	has_postspawn = TRUE

/obj/spawner/exosuit/dama69ed/low_chance
	name = "low chance random dama69ed exosuit"
	icon_state = "machine-red-low"
	spawn_nothin69_percenta69e = 85

/obj/spawner/exosuit_e69uipment
	name = "random exosuit e69uipment"
	icon_state = "tech-red"
	ta69s_to_spawn = list(SPAWN_MECH_69UIPMENT)

/obj/spawner/exosuit_e69uipment/low_chance
	name = "low chance random exosuit e69uipment"
	icon_state = "tech-red-low"
	spawn_nothin69_percenta69e = 75
