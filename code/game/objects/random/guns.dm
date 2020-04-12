/obj/random/gun_cheap
	name = "random cheap gun"
	icon_state = "gun-grey"

/obj/random/gun_cheap/item_to_spawn()
	return pickweight(list(/obj/item/weapon/gun/projectile/mk58 = 5,\
				/obj/item/weapon/gun/projectile/mk58/wood = 2,\
				/obj/item/weapon/gun/projectile/clarissa = 3,\
				/obj/item/weapon/gun/projectile/paco = 2,\
				/obj/item/weapon/gun/projectile/revolver/havelock = 2,\
				/obj/item/weapon/gun/projectile/giskard = 7,\
				/obj/item/weapon/gun/projectile/shotgun/pump = 3,\
				/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn = 2,\
				/obj/item/weapon/gun/projectile/olivaw = 4,\
				/obj/item/weapon/gun/energy/gun/martin = 2,\
				/obj/item/weapon/gun/launcher/crossbow = 1,\
				/obj/item/weapon/gun/projectile/boltgun/serbian = 1))

/obj/random/gun_cheap/low_chance
	name = "low chance random cheap gun"
	icon_state = "gun-grey-low"
	spawn_nothing_percentage = 75




/obj/random/gun_normal
	name = "random normal gun"
	icon_state = "gun-green"

/obj/random/gun_normal/item_to_spawn()
	return pickweight(list(/obj/item/weapon/gun/projectile/lamia = 2,\
				/obj/item/weapon/gun/projectile/automatic/zoric = 1,\
				/obj/item/weapon/gun/projectile/automatic/atreides = 1,\
				/obj/item/weapon/gun/projectile/avasarala = 2,\
				/obj/item/weapon/gun/projectile/shotgun/pump/gladstone = 2,\
				/obj/item/weapon/gun/projectile/colt = 3,\
				/obj/item/weapon/gun/projectile/avasarala = 1,\
				/obj/item/weapon/gun/projectile/revolver/consul = 3,\
				/obj/item/weapon/gun/projectile/revolver = 3,\
				/obj/item/weapon/gun/projectile/revolver/deckard = 2,\
				/obj/item/weapon/gun/projectile/automatic/wintermute = 1,\
				/obj/item/weapon/gun/projectile/automatic/sol = 1,\
				/obj/item/weapon/gun/projectile/automatic/sts35 = 1,\
				/obj/item/weapon/gun/projectile/automatic/molly = 2,\
				/obj/item/weapon/gun/projectile/automatic/straylight = 1,\
				/obj/item/weapon/gun/energy/gun = 2,\
				/obj/item/weapon/gun/energy/laser = 2,\
				/obj/item/weapon/gun/energy/plasma/cassad = 2))

/obj/random/gun_normal/low_chance
	name = "low chance random normal gun"
	icon_state = "gun-green-low"
	spawn_nothing_percentage = 75




/obj/random/gun_energy_cheap
	name = "random cheap energy weapon"
	icon_state = "gun-blue"

/obj/random/gun_energy_cheap/item_to_spawn()
	return pickweight(list(/obj/item/weapon/gun/energy/gun/martin = 2,\
				/obj/item/weapon/gun/energy/gun = 2,\
				/obj/item/weapon/gun/energy/retro = 1))

/obj/random/gun_energy_cheap/low_chance
	name = "low chance random cheap energy weapon"
	icon_state = "gun-blue-low"
	spawn_nothing_percentage = 80




/obj/random/gun_shotgun
	name = "random shotgun"
	icon_state = "gun-red"

/obj/random/gun_shotgun/item_to_spawn()
	return pickweight(list(
				/obj/item/weapon/gun/projectile/shotgun/pump = 2,
				/obj/item/weapon/gun/projectile/shotgun/bull = 2,
				/obj/item/weapon/gun/projectile/shotgun/doublebarrel = 2,
				/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn = 2,
				/obj/item/weapon/gun/projectile/shotgun/pump/regulator = 1,
				/obj/item/weapon/gun/projectile/shotgun/pump/gladstone = 1))

/obj/random/gun_shotgun/low_chance
	name = "low chance random shotgun"
	icon_state = "gun-red-low"
	spawn_nothing_percentage = 80
