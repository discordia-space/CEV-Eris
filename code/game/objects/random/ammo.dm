/obj/random/ammo
	name = "random ammunition"
	icon_state = "ammo-green"

/obj/random/ammo/item_to_spawn()
	return pick(prob(6);/obj/item/weapon/storage/box/shotgunammo/beanbags,\
				prob(2);/obj/item/weapon/storage/box/shotgunammo,\
				prob(4);/obj/item/weapon/storage/box/shotgunammo/slug,\
				prob(1);/obj/item/weapon/storage/box/shotgunammo/stunshells,\
				prob(2);/obj/item/ammo_magazine/c45m,\
				prob(4);/obj/item/ammo_magazine/c45m/rubber,\
				prob(4);/obj/item/ammo_magazine/c45m/flash,\
				prob(2);/obj/item/ammo_magazine/mc9mmt,\
				prob(6);/obj/item/ammo_magazine/mc9mmt/rubber)

/obj/random/ammo/low_chance
	name = "low chance random random ammunition"
	icon_state = "ammo-green-low"
	spawn_nothing_percentage = 60

/obj/random/ammo_ihs
	name = "random ironhammer ammunition"
	icon_state = "ammo-blue"

/obj/random/ammo_ihs/item_to_spawn()
	return pick(/obj/item/ammo_magazine/SMG_sol/rubber,\
				/obj/item/ammo_magazine/SMG_sol/brute,\
				/obj/item/ammo_magazine/sl/cl44/rubber,\
				/obj/item/ammo_magazine/sl/cl44/brute,\
				/obj/item/ammo_magazine/mg/cl44/rubber,\
				/obj/item/ammo_magazine/mg/cl44/brute,\
				/obj/item/weapon/cell/medium/high)

/obj/random/ammo_ihs/low_chance
	name = "low chance random random ironhammer ammunition"
	icon_state = "ammo-blue-low"
	spawn_nothing_percentage = 60

/obj/random/ammo_lowcost
	name = "random low tier ammunition"
	icon_state = "ammo-grey"

/obj/random/ammo_lowcost/item_to_spawn()
	return pick(prob(4);/obj/item/weapon/storage/box/shotgunammo/beanbags,\
				prob(2);/obj/item/weapon/storage/box/shotgunammo,\
				prob(1);/obj/item/weapon/storage/box/shotgunammo/slug,\
				prob(1);/obj/item/weapon/cell/medium,\
				prob(6);/obj/item/ammo_magazine/mg/cl32/rubber,\
				prob(1);/obj/item/ammo_magazine/mg/cl32/brute)

/obj/random/ammo_lowcost/low_chance
	name = "low chance random low tier ammunition"
	icon_state = "ammo-grey-low"
	spawn_nothing_percentage = 60
