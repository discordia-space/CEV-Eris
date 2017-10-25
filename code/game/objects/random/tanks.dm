/obj/random/tank
	name = "random tanks"
	icon_state = "cannister-blue"

/obj/random/tank/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/tank/air,\
				prob(2);/obj/item/weapon/tank/anesthetic,\
				prob(2);/obj/item/weapon/tank/emergency_oxygen,\
				prob(2);/obj/item/weapon/tank/emergency_oxygen/double,\
				prob(2);/obj/item/weapon/tank/oxygen/yellow,\
				prob(2);/obj/item/weapon/tank/nitrogen)

/obj/random/tank/low_chance
	name = "low chance random tank"
	icon_state = "cannister-blue-low"
	spawn_nothing_percentage = 60
