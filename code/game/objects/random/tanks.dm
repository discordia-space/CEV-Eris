/obj/random/tank
	name = "random tanks"
	icon_state = "cannister-blue"

/obj/random/tank/item_to_spawn()
	return pickweight(list(/obj/item/weapon/tank/air = 3,\
				/obj/item/weapon/tank/anesthetic = 1,\
				/obj/item/weapon/tank/emergency_oxygen = 2,\
				/obj/item/weapon/tank/emergency_oxygen/double = 2,\
				/obj/item/weapon/tank/oxygen/yellow = 2,\
				/obj/item/weapon/tank/nitrogen = 1))

/obj/random/tank/low_chance
	name = "low chance random tank"
	icon_state = "cannister-blue-low"
	spawn_nothing_percentage = 60
