/obj/random/ammo
	name = "random ammunition"
	icon_state = "ammo-green"

/obj/random/ammo/item_to_spawn()
	return pick(prob(6);/obj/item/weapon/storage/box/shotgunammo/beanbags,\
				prob(2);/obj/item/weapon/storage/box/shotgunammo,\
				prob(4);/obj/item/weapon/storage/box/shotgunammo/slug,\
				prob(1);/obj/item/weapon/storage/box/shotgunammo/stunshells,\
				prob(1);/obj/item/ammo_magazine/ammobox/c357,\
				prob(1);/obj/item/ammo_magazine/ammobox/c65mm,\
				prob(2);/obj/item/ammo_magazine/ammobox/c65mm/rubber,\
				prob(1);/obj/item/ammo_magazine/ammobox/c38,\
				prob(2);/obj/item/ammo_magazine/ammobox/c38/rubber,\
				prob(1);/obj/item/ammo_magazine/ammobox/cl32,\
				prob(2);/obj/item/ammo_magazine/ammobox/cl32/rubber,\
				prob(1);/obj/item/ammo_magazine/ammobox/c9mm,\
				prob(2);/obj/item/ammo_magazine/ammobox/c9mm/rubber,\
				prob(2);/obj/item/ammo_magazine/c45m,\
				prob(4);/obj/item/ammo_magazine/c45m/rubber,\
				prob(4);/obj/item/ammo_magazine/c45m/flash,\
				prob(2);/obj/item/ammo_magazine/sl357,\
				prob(3);/obj/item/ammo_magazine/sl38,\
				prob(4);/obj/item/ammo_magazine/sl38/rubber,\
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
	return pick(/obj/item/ammo_magazine/sol65/rubber,\
				/obj/item/ammo_magazine/sol65,\
				/obj/item/ammo_magazine/ammobox/c65mm,\
				/obj/item/ammo_magazine/ammobox/c65mm/rubber,\
				/obj/item/ammo_magazine/sl44/rubber,\
				/obj/item/ammo_magazine/sl44,\
				/obj/item/ammo_magazine/cl44/rubber,\
				/obj/item/ammo_magazine/cl44,\
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
				prob(1);/obj/item/ammo_magazine/ammobox/c38,\
				prob(2);/obj/item/ammo_magazine/ammobox/c38/rubber,\
				prob(1);/obj/item/ammo_magazine/ammobox/cl32,\
				prob(2);/obj/item/ammo_magazine/ammobox/cl32/rubber,\
				prob(2);/obj/item/ammo_magazine/sl38/rubber,\
				prob(1);/obj/item/weapon/cell/medium,\
				prob(6);/obj/item/ammo_magazine/cl32/rubber,\
				prob(1);/obj/item/ammo_magazine/cl32)

/obj/random/ammo_lowcost/low_chance
	name = "low chance random low tier ammunition"
	icon_state = "ammo-grey-low"
	spawn_nothing_percentage = 60
