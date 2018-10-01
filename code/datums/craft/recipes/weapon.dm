/datum/craft_recipe/weapon
	category = "Weapon"


/datum/craft_recipe/weapon/baseballbat
	name = "baseball bat"
	result = /obj/item/weapon/material/twohanded/baseballbat
	steps = list(
		list(/obj/item/stack/material/wood, 6, time = 20)
	)

/datum/craft_recipe/weapon/grenade_casing
	name = "grenade casing"
	result = /obj/item/weapon/grenade/chem_grenade
	steps = list(
		list(/obj/item/stack/material/steel, 2)
	)

/datum/craft_recipe/weapon/fork
	name = "fork"
	result = /obj/item/weapon/material/kitchen/utensil/fork
	steps = list(
		list(/obj/item/stack/material/steel, 1)
	)

/datum/craft_recipe/weapon/knife
	name = "steel knife"
	result = /obj/item/weapon/material/knife
	steps = list(
		list(/obj/item/stack/material/steel, 1)
	)

/datum/craft_recipe/weapon/spoon
	name = "spoon"
	result = /obj/item/weapon/material/kitchen/utensil/spoon
	steps = list(
		list(/obj/item/stack/material/steel, 1)
	)


/datum/craft_recipe/weapon/knife_blade
	name = "knife blade"
	result = /obj/item/weapon/material/butterflyblade
	steps = list(
		list(/obj/item/stack/material/steel, 6, time = 20)
	)

/datum/craft_recipe/weapon/knife_grip
	name = "knife grip"
	result = /obj/item/weapon/material/butterflyhandle
	steps = list(
		list(/obj/item/stack/material/plasteel, 4, time = 20)
	)

/datum/craft_recipe/weapon/crossbow_frame
	name = "crossbow frame"
	result = /obj/item/weapon/crossbowframe
	steps = list(
		list(/obj/item/stack/material/wood, 5, time = 25)
	)

/datum/craft_recipe/weapon/teleportation_spear
	name = "telespear"
	result = /obj/item/weapon/tele_spear
	steps = list(
		list(/obj/item/stack/rods, 2, time = 30),
		list(/obj/item/weapon/stock_parts/subspace/crystal, 1),
		list(/obj/item/device/assembly/igniter, 1),
		list(/obj/item/stack/cable_coil, 10, time = 10)
	)

/datum/craft_recipe/weapon/improvised_maul
	name = "robust maul"
	result = /obj/item/weapon/melee/toolbox_maul
	steps = list(
		list(/obj/item/weapon/mop, 1, time = 30),
		list(/obj/item/stack/cable_coil, 10, time = 10)
	)

/datum/craft_recipe/weapon/nailed_bat
	name = "nailed bat"
	result = /obj/item/weapon/melee/nailstick
	steps = list(
		list(/obj/item/stack/material/wood, 10, time = 30),
		list(/obj/item/stack/rods, 3, time = 50)
	)

/datum/craft_recipe/weapon/handmade_shield
	name = "handmade shield"
	result = /obj/item/weapon/shield/riot/handmade
	steps = list(
		list(/obj/item/stack/material/wood, 12, time = 40),
		list(/obj/item/stack/rods, 4, time = 10),
		list(/obj/item/stack/material/steel, 2, time = 20)
	)

/datum/craft_recipe/weapon/tray_shield
	name = "handmade tray shield"
	result = /obj/item/weapon/shield/riot/handmade/tray
	steps = list(
		list(/obj/item/weapon/tray, 1),
		list(/obj/item/weapon/storage/belt, 2, time = 10)
	)

/datum/craft_recipe/weapon/pistol
	name = "handmade gun"
	result = /obj/item/weapon/gun/projectile/handmade_pistol
	steps = list(
		list(/obj/item/pipe, 1, time = 60),
		list(/obj/item/weapon/crossbowframe, 1, time = 20),
		list(/obj/item/weapon/grenade/chem_grenade, 1, time = 20),
		list(/obj/item/device/assembly/igniter, 1),
		list(/obj/item/stack/cable_coil, 2, time = 10)
	)