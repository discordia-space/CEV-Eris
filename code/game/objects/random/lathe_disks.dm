/obj/random/lathe_disk
	name = "random lathe disk"
	icon_state = "box-blue"

/obj/random/lathe_disk/item_to_spawn()
	return pickweight(list(/obj/item/weapon/disk/autolathe_disk/basic = 10,
				/obj/item/weapon/disk/autolathe_disk/devices = 8,
				/obj/item/weapon/disk/autolathe_disk/toolpack = 3,
				/obj/item/weapon/disk/autolathe_disk/component = 5,
				/obj/item/weapon/disk/autolathe_disk/advtoolpack = 2,
				/obj/item/weapon/disk/autolathe_disk/circuitpack = 3,
				/obj/item/weapon/disk/autolathe_disk/medical = 4,
				/obj/item/weapon/disk/autolathe_disk/security = 3,
				/obj/item/weapon/disk/autolathe_disk/fs_cheap_guns = 2,
				/obj/item/weapon/disk/autolathe_disk/fs_kinetic_guns = 1,
				/obj/item/weapon/disk/autolathe_disk/fs_energy_guns = 1,
				/obj/item/weapon/disk/autolathe_disk/nt_old_guns = 1,
				/obj/item/weapon/disk/autolathe_disk/nt_new_guns = 0.5,
				/obj/item/weapon/disk/autolathe_disk/nonlethal_ammo = 5,
				/obj/item/weapon/disk/autolathe_disk/lethal_ammo = 2))


/obj/random/lathe_disk/advanced/item_to_spawn()
	return pickweight(list(
				/obj/item/weapon/disk/autolathe_disk/advtoolpack = 2,
				/obj/item/weapon/disk/autolathe_disk/security = 3,
				/obj/item/weapon/disk/autolathe_disk/fs_kinetic_guns = 1,
				/obj/item/weapon/disk/autolathe_disk/fs_energy_guns = 1,
				/obj/item/weapon/disk/autolathe_disk/nt_old_guns = 1,
				/obj/item/weapon/disk/autolathe_disk/nt_new_guns = 0.5,
				/obj/item/weapon/disk/autolathe_disk/lethal_ammo = 2))