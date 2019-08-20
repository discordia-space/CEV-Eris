/obj/random/ammo
	name = "random ammunition"
	icon_state = "ammo-green"

/obj/random/ammo/item_to_spawn()
	return pickweight(list(
				/obj/item/weapon/storage/box/shotgunammo/beanbags = 3,
				/obj/item/weapon/storage/box/shotgunammo/slug = 2,
				/obj/item/weapon/storage/box/shotgunammo/stunshells = 1,
				/obj/item/weapon/storage/box/shotgunammo/buckshot = 3,
				/obj/item/ammo_magazine/ammobox/c357 = 1,
				/obj/item/ammo_magazine/ammobox/c65mm = 1,
				/obj/item/ammo_magazine/ammobox/c65mm/rubber = 2,
				/obj/item/ammo_magazine/ammobox/c38 = 1,
				/obj/item/ammo_magazine/ammobox/c38/rubber = 2,
				/obj/item/ammo_magazine/ammobox/cl32 = 1,
				/obj/item/ammo_magazine/ammobox/cl32/rubber = 2,
				/obj/item/ammo_magazine/ammobox/c9mm = 1,
				/obj/item/ammo_magazine/ammobox/c9mm/rubber = 2,
				/obj/item/ammo_magazine/a10mm = 2,
				/obj/item/ammo_magazine/a10mm/rubber = 2,
				/obj/item/ammo_magazine/c45smg = 1,
				/obj/item/ammo_magazine/c45smg/rubber = 1,
				/obj/item/ammo_magazine/smg9mm = 1,
				/obj/item/ammo_magazine/smg9mm/rubber = 1,
				/obj/item/ammo_magazine/c45m = 2,
				/obj/item/ammo_magazine/c45m/rubber = 4,
				/obj/item/ammo_magazine/c45m/flash = 4,
				/obj/item/ammo_magazine/sl357 = 2,
				/obj/item/ammo_magazine/sl38 = 3,
				/obj/item/ammo_magazine/sl38/rubber = 4))


/obj/random/ammo/low_chance
	name = "low chance random ammunition"
	icon_state = "ammo-green-low"
	spawn_nothing_percentage = 60




/obj/random/ammo/shotgun
	name = "random shotgun ammunition"
	icon_state = "ammo-orange"

/obj/random/ammo/shotgun/item_to_spawn()
	return pickweight(list(
				/obj/item/weapon/storage/box/shotgunammo/beanbags = 4,
				/obj/item/weapon/storage/box/shotgunammo/slug = 2,
				/obj/item/weapon/storage/box/shotgunammo/stunshells = 1,
				/obj/item/weapon/storage/box/shotgunammo/buckshot = 3))

/obj/random/ammo/shotgun/low_chance
	name = "low chance random shotgun ammunition"
	icon_state = "ammo-orange-low"
	spawn_nothing_percentage = 60




/obj/random/ammo_ihs
	name = "random ironhammer ammunition"
	icon_state = "ammo-blue"

/obj/random/ammo_ihs/item_to_spawn()
	return pick(/obj/item/ammo_magazine/sol65/rubber,
				/obj/item/ammo_magazine/sol65,
				/obj/item/ammo_magazine/ammobox/c65mm,
				/obj/item/ammo_magazine/ammobox/c65mm/rubber,
				/obj/item/ammo_magazine/sl44/rubber,
				/obj/item/ammo_magazine/sl44,
				/obj/item/ammo_magazine/cl44/rubber,
				/obj/item/ammo_magazine/cl44,
				/obj/item/weapon/cell/medium/high)

/obj/random/ammo_ihs/low_chance
	name = "low chance random random ironhammer ammunition"
	icon_state = "ammo-blue-low"
	spawn_nothing_percentage = 60




/obj/random/ammo_lowcost
	name = "random low tier ammunition"
	icon_state = "ammo-grey"

/obj/random/ammo_lowcost/item_to_spawn()
	return pickweight(list(/obj/item/weapon/storage/box/shotgunammo/beanbags = 4,
				/obj/item/weapon/storage/box/shotgunammo = 2,
				/obj/item/weapon/storage/box/shotgunammo/slug = 1,
				/obj/item/ammo_magazine/ammobox/c38 = 1,
				/obj/item/ammo_magazine/ammobox/c38/rubber = 2,
				/obj/item/ammo_magazine/ammobox/cl32 = 1,
				/obj/item/ammo_magazine/ammobox/cl32/rubber = 2,
				/obj/item/ammo_magazine/sl38/rubber = 2,
				/obj/item/weapon/cell/medium = 1,
				/obj/item/ammo_magazine/cl32/rubber = 6,
				/obj/item/ammo_magazine/cl32 = 1))

/obj/random/ammo_lowcost/low_chance
	name = "low chance random low tier ammunition"
	icon_state = "ammo-grey-low"
	spawn_nothing_percentage = 60
