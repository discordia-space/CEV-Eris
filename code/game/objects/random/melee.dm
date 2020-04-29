/obj/random/knife
	name = "random knife"
	icon_state = "tool-red"

/obj/random/knife/item_to_spawn()
	return pickweight(list(/obj/item/weapon/tool/knife/butterfly = 1,
				/obj/item/weapon/tool/knife/switchblade = 1,
				/obj/item/weapon/tool/knife = 1,
				/obj/item/weapon/tool/knife/boot = 0.5,
				/obj/item/weapon/tool/knife/hook = 2,
				/obj/item/weapon/tool/knife/ritual = 0.5,
				/obj/item/weapon/tool/scythe = 0.3,
				/obj/item/weapon/tool/sword = 0.2,
				/obj/item/weapon/tool/sword/katana = 0.2,
				/obj/item/weapon/tool/knife/butch = 2,
				/obj/item/weapon/tool/knife/dagger = 0.8))

/obj/random/knife/low_chance
	name = "low chance random knife"
	icon_state = "tool-red-low"
	spawn_nothing_percentage = 80
