/obj/random/ammo
	name = "random ammunition"
	icon_state = "ammo-green"

/obj/random/ammo/item_to_spawn()
	return pickweight(list(
				/obj/item/weapon/storage/box/shotgunammo/beanbags = 3,
				/obj/item/weapon/storage/box/shotgunammo/slug = 2,
				/obj/item/weapon/storage/box/shotgunammo = 1,
				/obj/item/weapon/storage/box/shotgunammo/buckshot = 3,
				/obj/item/ammo_magazine/ammobox/magnum = 1,
				/obj/item/ammo_magazine/ammobox/clrifle = 1,
				/obj/item/ammo_magazine/ammobox/clrifle/rubber = 2,
				/obj/item/ammo_magazine/ammobox/pistol = 1,
				/obj/item/ammo_magazine/ammobox/pistol/rubber = 2,
				/obj/item/ammo_magazine/smg = 1,
				/obj/item/ammo_magazine/smg/rubber = 1,
				/obj/item/ammo_magazine/pistol = 2,
				/obj/item/ammo_magazine/pistol/rubber = 4,
				/obj/item/ammo_magazine/pistol/practice = 4,
				/obj/item/ammo_magazine/hpistol = 1,
				/obj/item/ammo_magazine/hpistol/rubber = 2,
				/obj/item/ammo_magazine/hpistol/practice = 2,
				/obj/item/ammo_magazine/slmagnum = 2,
				/obj/item/ammo_magazine/slpistol = 3,
				/obj/item/ammo_magazine/slpistol/rubber = 4))


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
				/obj/item/weapon/storage/box/shotgunammo = 1,
				/obj/item/weapon/storage/box/shotgunammo/buckshot = 3))

/obj/random/ammo/shotgun/low_chance
	name = "low chance random shotgun ammunition"
	icon_state = "ammo-orange-low"
	spawn_nothing_percentage = 60




/obj/random/ammo_ihs
	name = "random ironhammer ammunition"
	icon_state = "ammo-blue"

/obj/random/ammo_ihs/item_to_spawn()
	return pick(/obj/item/ammo_magazine/ihclrifle/rubber,
				/obj/item/ammo_magazine/ihclrifle,
				/obj/item/ammo_magazine/ammobox/clrifle,
				/obj/item/ammo_magazine/ammobox/clrifle/rubber,
				/obj/item/ammo_magazine/magnum/rubber,
				/obj/item/ammo_magazine/slmagnum,
				/obj/item/ammo_magazine/magnum/rubber,
				/obj/item/ammo_magazine/magnum,
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
				/obj/item/ammo_magazine/ammobox/pistol = 1,
				/obj/item/ammo_magazine/ammobox/pistol/rubber = 6,
				/obj/item/weapon/cell/medium = 1))

/obj/random/ammo_lowcost/low_chance
	name = "low chance random low tier ammunition"
	icon_state = "ammo-grey-low"
	spawn_nothing_percentage = 60
