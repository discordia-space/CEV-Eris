/obj/random/gun_upgrade
	name = "random gun upgrade"
	icon_state = "ammo-orange"

/obj/random/gun_cheap/item_to_spawn()
	return pickweight(list(/obj/item/weapon/gun_upgrade/trigger/dangerzone = 4,
				/obj/item/weapon/gun_upgrade/trigger/cop_block = 4,
				/obj/item/weapon/gun_upgrade/mechanism/overshooter = 2,
				/obj/item/weapon/gun_upgrade/barrel/excruciator = 1,
				/obj/item/weapon/gun_upgrade/barrel/mag_accel = 2,
				/obj/item/weapon/gun_upgrade/barrel/overheat = 2,
				/obj/item/weapon/gun_upgrade/muzzle/silencer = 3,
				/obj/item/weapon/gun_upgrade/mechanism/glass_widow = 1,
				/obj/item/weapon/gun_upgrade/mechanism/weintraub = 2,
				/obj/item/weapon/gun_upgrade/barrel/forged = 5))

/obj/random/gun_cheap/low_chance
	name = "low chance random gun upgrade"
	icon_state = "ammo-orange-low"
	spawn_nothing_percentage = 70
