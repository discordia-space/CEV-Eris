/obj/random/knife
	name = "random knife"
	icon_state = "tool-red"

/obj/random/knife/item_to_spawn()
	return pickweight(list(/obj/item/weapon/material/butterfly = 1,
				/obj/item/weapon/material/butterfly/switchblade = 2,
				/obj/item/weapon/material/knife = 1,
				/obj/item/weapon/material/knife/boot = 0.5,
				/obj/item/weapon/material/knife/hook = 2,
				/obj/item/weapon/material/knife/ritual = 0.5,
				/obj/item/weapon/material/knife/butch = 2))

/obj/random/knife/low_chance
	name = "low chance random knife"
	icon_state = "tool-red-low"
	spawn_nothing_percentage = 80
