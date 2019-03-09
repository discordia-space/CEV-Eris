/obj/random/powercell
	name = "random powercell"
	icon_state = "battery-green"

/obj/random/powercell/item_to_spawn()
	return pickweight(list(/obj/item/weapon/cell/large = 30,\
				/obj/item/weapon/cell/large/high = 30,\
				/obj/item/weapon/cell/large/super = 9,\
				/obj/item/weapon/cell/large/hyper = 3,\
				/obj/item/weapon/cell/large/moebius = 20,\
				/obj/item/weapon/cell/large/moebius/high = 20,\
				/obj/item/weapon/cell/large/moebius/super = 10,\
				/obj/item/weapon/cell/large/moebius/hyper = 4,\
				/obj/item/weapon/cell/large/moebius/nuclear = 2,\
				/obj/item/weapon/cell/large/excelsior  = 1,\
				/obj/item/weapon/cell/medium = 30,\
				/obj/item/weapon/cell/medium/high = 30,\
				/obj/item/weapon/cell/medium/super = 12,\
				/obj/item/weapon/cell/medium/hyper = 3,\
				/obj/item/weapon/cell/medium/moebius = 20,\
				/obj/item/weapon/cell/medium/moebius/high = 20,\
				/obj/item/weapon/cell/medium/moebius/super = 10,\
				/obj/item/weapon/cell/medium/moebius/hyper = 4,\
				/obj/item/weapon/cell/medium/moebius/nuclear = 2,\
				/obj/item/weapon/cell/medium/excelsior = 3,\
				/obj/item/weapon/cell/small = 40,\
				/obj/item/weapon/cell/small/high = 40,\
				/obj/item/weapon/cell/small/super = 16,\
				/obj/item/weapon/cell/small/hyper = 4,\
				/obj/item/weapon/cell/small/moebius = 30,\
				/obj/item/weapon/cell/small/moebius/high = 30,\
				/obj/item/weapon/cell/small/moebius/super = 16,\
				/obj/item/weapon/cell/small/moebius/hyper = 5,\
				/obj/item/weapon/cell/small/moebius/nuclear = 2,\
				/obj/item/weapon/cell/small/excelsior = 1))

/obj/random/powercell/low_chance
	name = "low chance random powercell"
	icon_state = "battery-green-low"
	spawn_nothing_percentage = 60
