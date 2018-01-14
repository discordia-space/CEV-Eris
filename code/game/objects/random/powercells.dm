/obj/random/powercell
	name = "random powercell"
	icon_state = "battery-green"

/obj/random/powercell/item_to_spawn()
	return pick(prob(30);/obj/item/weapon/cell/large,\
				prob(30);/obj/item/weapon/cell/large/high,\
				prob(9);/obj/item/weapon/cell/large/super,\
				prob(3);/obj/item/weapon/cell/large/hyper,\
				prob(20);/obj/item/weapon/cell/large/moebius,\
				prob(20);/obj/item/weapon/cell/large/moebius/high,\
				prob(10);/obj/item/weapon/cell/large/moebius/super,\
				prob(4);/obj/item/weapon/cell/large/moebius/hyper,\
				prob(3);/obj/item/weapon/cell/large/moebius/nuclear,\
				prob(30);/obj/item/weapon/cell/medium,\
				prob(30);/obj/item/weapon/cell/medium/high,\
				prob(12);/obj/item/weapon/cell/medium/super,\
				prob(3);/obj/item/weapon/cell/medium/hyper,\
				prob(20);/obj/item/weapon/cell/medium/moebius,\
				prob(20);/obj/item/weapon/cell/medium/moebius/high,\
				prob(10);/obj/item/weapon/cell/medium/moebius/super,\
				prob(4);/obj/item/weapon/cell/medium/moebius/hyper,\
				prob(3);/obj/item/weapon/cell/medium/moebius/nuclear,\
				prob(30);/obj/item/weapon/cell/small,\
				prob(30);/obj/item/weapon/cell/small/high,\
				prob(12);/obj/item/weapon/cell/small/super,\
				prob(3);/obj/item/weapon/cell/small/hyper,\
				prob(20);/obj/item/weapon/cell/small/moebius,\
				prob(20);/obj/item/weapon/cell/small/moebius/high,\
				prob(10);/obj/item/weapon/cell/small/moebius/super,\
				prob(4);/obj/item/weapon/cell/small/moebius/hyper,\
				prob(3);/obj/item/weapon/cell/small/moebius/nuclear)

/obj/random/powercell/low_chance
	name = "low chance random tool"
	icon_state = "battery-green-low"
	spawn_nothing_percentage = 60
