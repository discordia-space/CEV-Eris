/obj/spawner/ammo
	name = "random ammunition"
	icon_state = "ammo-green"
	tags_to_spawn = list(SPAWN_AMMO_S)

/obj/spawner/ammo/low_chance
	name = "low chance random ammunition"
	icon_state = "ammo-green-low"
	spawn_nothing_percentage = 60

/obj/spawner/ammo/shotgun
	name = "random shotgun ammunition"
	icon_state = "ammo-orange"
	tags_to_spawn = list(SPAWN_AMMO_SHOTGUN)

/obj/spawner/ammo/shotgun/low_chance
	name = "low chance random shotgun ammunition"
	icon_state = "ammo-orange-low"
	spawn_nothing_percentage = 60

/obj/spawner/ammo/ihs
	name = "random ironhammer ammunition"
	icon_state = "ammo-blue"
	tags_to_spawn = list(SPAWN_AMMO_IH)

/obj/spawner/ammo/ihs/low_chance
	name = "low chance random random ironhammer ammunition"
	icon_state = "ammo-blue-low"
	spawn_nothing_percentage = 60

/obj/spawner/ammo/lowcost
	name = "random low tier ammunition"
	icon_state = "ammo-grey"
	tags_to_spawn = list(SPAWN_AMMO_COMMON)

/obj/spawner/ammo/lowcost/low_chance
	name = "low chance random low tier ammunition"
	icon_state = "ammo-grey-low"
	spawn_nothing_percentage = 60
