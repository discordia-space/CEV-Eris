/obj/random/structures
	name = "random structure"
	icon_state = "machine-black"

/obj/random/structures/item_to_spawn()
	return pickweight(list(/obj/spawner/structures/salvageable = 47,\
				/obj/spawner/structures/frame = 10,\
				/obj/spawner/structures/reagent_dispensers = 20,\
				/obj/structure/largecrate = 2,\
				/obj/structure/ore_box = 2,\
				/obj/structure/dispenser/oxygen = 1))

/obj/random/structures/low_chance
	name = "low chance random structures"
	icon_state = "machine-black-low"
	spawn_nothing_percentage = 60

/obj/spawner/structures/salvageable
	name = "random reagent dispensers"
	icon_state = "machine-black"
	tags_to_spawn = list(SPAWN_SALVAGEABLE)

/obj/spawner/structures/reagent_dispensers
	name = "random reagent dispensers"
	icon_state = "machine-black"
	tags_to_spawn = list(SPAWN_REAGENT_DISPENSER)


/obj/random/structures/os/item_to_spawn()
	return pickweight(list(/obj/spawner/structures/os = 40,\
				/obj/structure/salvageable/autolathe = 10,\
				/obj/spawner/structures/frame = 4))

/obj/spawner/structures/os
	name = "random os structure"
	allow_blacklist = TRUE
	tags_to_spawn = list(SPAWN_SALVAGEABLE_OS)

/obj/spawner/structures/frame
	tags_to_spawn = list(SPAWN_MACHINE_FRAME)
