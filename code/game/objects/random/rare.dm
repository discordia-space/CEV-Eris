//Rare loot. The rare spawner appears as a subset in other lists
//Mostly it includes the cream of the crop from other lists, and some unique things
/obj/random/rare
	name = "rare spawn"

/obj/random/rare/item_to_spawn()
	return pickweight(list(
	/obj/random/material_rare = 3,\
	/obj/random/tool/advanced = 5,\
	/obj/item/weapon/disk/autolathe_disk/fs_kinetic_guns = 1,\
	/obj/item/weapon/disk/autolathe_disk/fs_energy_guns = 1,\
	/obj/item/weapon/disk/autolathe_disk/lethal_ammo = 1,\
	/obj/item/weapon/cell/small/moebius/nuclear = 2,\
	/obj/item/weapon/cell/medium/moebius/hyper = 1,\
	/obj/item/weapon/tank/emergency_oxygen/double = 2,\
	/obj/random/rig = 2,\
	/obj/random/voidsuit = 4
	))