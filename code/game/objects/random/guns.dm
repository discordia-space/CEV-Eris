/obj/random/gun_cheap
	name = "random cheap gun"
	icon_state = "gun-grey"

/obj/random/gun_cheap/item_to_spawn()
	return pickweight(list(/obj/item/weapon/gun/projectile/mk58 = 3,\
				/obj/item/weapon/gun/projectile/mk58/wood = 1,\
				/obj/item/weapon/gun/projectile/revolver/detective = 1,\
				/obj/item/weapon/gun/projectile/giskard = 4,\
				/obj/item/weapon/gun/projectile/shotgun/pump = 2,\
				/obj/item/weapon/gun/projectile/olivaw = 2))

/obj/random/gun_cheap/low_chance
	name = "low chance random cheap gun"
	icon_state = "gun-grey-low"
	spawn_nothing_percentage = 80

/obj/random/gun_normal
	name = "random normal gun"
	icon_state = "gun-green"

/obj/random/gun_normal/item_to_spawn()
	return pickweight(list(/obj/item/weapon/gun/projectile/lamia = 2,\
				/obj/item/weapon/gun/projectile/automatic/idaho = 1,\
				/obj/item/weapon/gun/projectile/automatic/atreides = 1,\
				/obj/item/weapon/gun/projectile/deagle = 2,\
				/obj/item/weapon/gun/projectile/colt = 4,\
				/obj/item/weapon/gun/projectile/revolver/consul = 4,\
				/obj/item/weapon/gun/projectile/revolver = 4))

/obj/random/gun_normal/low_chance
	name = "low chance random normal gun"
	icon_state = "gun-green-low"
	spawn_nothing_percentage = 80

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
