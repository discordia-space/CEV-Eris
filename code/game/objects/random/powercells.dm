/obj/random/powercell
	name = "random powercell"
	icon_state = "battery-green"

/obj/random/powercell/item_to_spawn()
	return pick(prob(40);/obj/item/weapon/cell/large,\
				prob(40);/obj/item/weapon/cell/large/high,\
				prob(9);/obj/item/weapon/cell/large/super,\
				prob(1);/obj/item/weapon/cell/large/hyper,\
				prob(40);/obj/item/weapon/cell/medium,\
				prob(40);/obj/item/weapon/cell/medium/high,\
				prob(9);/obj/item/weapon/cell/medium/super,\
				prob(1);/obj/item/weapon/cell/medium/hyper,\
				prob(40);/obj/item/weapon/cell/small,\
				prob(40);/obj/item/weapon/cell/small/high,\
				prob(9);/obj/item/weapon/cell/small/super,\
				prob(1);/obj/item/weapon/cell/small/hyper)

/obj/random/powercell/low_chance
	name = "low chance random tool"
	icon_state = "battery-green-low"
	spawn_nothing_percentage = 60
