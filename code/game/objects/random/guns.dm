/obj/spawner/gun
	name = "random gun"
	icon_state = "gun-grey"
	tags_to_spawn = list(SPAWN_GUN)

/obj/spawner/gun/handmade
	name = "random handmade gun"
	icon_state = "gun-grey"
	tags_to_spawn = list(SPAWN_GUN_HANDMADE)

/obj/spawner/gun/cheap
	name = "random cheap gun"
	icon_state = "gun-grey"
	top_price = GUN_CHEAP_PRICE

/obj/spawner/gun/cheap/low_chance
	name = "low chance random cheap gun"
	icon_state = "gun-grey-low"
	spawn_nothing_percentage = 75

/obj/spawner/gun/normal
	name = "random normal gun"
	icon_state = "gun-green"
	low_price = GUN_CHEAP_PRICE

/obj/spawner/gun/normal/low_chance
	name = "low chance random normal gun"
	icon_state = "gun-green-low"
	spawn_nothing_percentage = 75

/obj/spawner/gun/energy_cheap
	name = "random cheap energy weapon"
	icon_state = "gun-blue"
	tags_to_spawn = list(SPAWN_GUN_ENERGY)
	top_price = 2500

/obj/spawner/gun/energy_cheap/low_chance
	name = "low chance random cheap energy weapon"
	icon_state = "gun-blue-low"
	spawn_nothing_percentage = 75

/obj/spawner/gun/shotgun
	name = "random shotgun"
	icon_state = "gun-red"
	tags_to_spawn = list(SPAWN_GUN_SHOTGUN)

/obj/spawner/gun/shotgun/low_chance
	name = "low chance random shotgun"
	icon_state = "gun-red-low"
	spawn_nothing_percentage = 75

/obj/spawner/gun_parts
	name = "random gun part"
	icon_state = "gun-black"
	tags_to_spawn = list(SPAWN_PART_GUN)

/obj/spawner/gun_parts/low_chance
	name = "low chance random gun part"
	icon_state = "gun-black-low"
	spawn_nothing_percentage = 75
