/obj/spawner/structures
	name = "random structure"
	icon_state = "machine-black"
	ta69s_to_spawn = list(SPAWN_STRUCTURE)

/obj/spawner/structures/common
	name = "random common structure"
	icon_state = "machine-black"
	ta69s_to_spawn = list(SPAWN_MACHINE_FRAME, SPAWN_STRUCTURE_COMMON, SPAWN_REA69ENT_DISPENSER, SPAWN_SALVA69EABLE)

/obj/spawner/structures/common/low_chance
	name = "low chance random structures"
	icon_state = "machine-black-low"
	spawn_nothin69_percenta69e = 60

/obj/spawner/structures/os
	name = "random os structure"
	allow_blacklist = TRUE
	ta69s_to_spawn = list(SPAWN_SALVA69EABLE_OS)

