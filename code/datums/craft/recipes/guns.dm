
/obj/item/gun_parts//evan, termina esto
	name = "gun part"
	desc = "una parte de arma"
	icon ='icons/obj/crafts.dmi'
	icon_state = "gun"

/datum/craft_recipe/gun
	category = "Guns"
	icon_state = "gun_frame"//EVAN CHANGE IT
	time = 100
	related_stats = list(STAT_MEC)

/datum/craft_recipe/gun/pistol
	name = "handmade gun"
	result = /obj/item/weapon/gun/projectile/handmade_pistol
	steps = list(
		list(CRAFT_MATERIAL, 5, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, "time" = 30),
		list(CRAFT_MATERIAL, 5, MATERIAL_WOOD),
		list(QUALITY_SCREW_DRIVING, 10, 70,"time" = 3),
	)

/datum/craft_recipe/gun/handmaderevolver
	name = "handmade Revolver"
	result = /obj/item/weapon/gun/projectile/revolver/handmaderevolver
	steps = list(
		list(
			, 2),
		list(QUALITY_ADHESIVE, 15, 70),
		list(CRAFT_MATERIAL, 15, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, "time" = 15),
		list(CRAFT_MATERIAL, 10, MATERIAL_PLASTIC),
		list(QUALITY_SCREW_DRIVING, 10)
	)

/datum/craft_recipe/gun/handmaderifle
	name = "handmade bolt action rifle"
	result = /obj/item/weapon/gun/projectile/boltgun/handmaderifle
	steps = list(
		list(/obj/item/gun_parts, 2),
		list(QUALITY_ADHESIVE, 15, 70),
		list(CRAFT_MATERIAL, 10, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, "time" = 15),
		list(CRAFT_MATERIAL, 5, MATERIAL_PLASTIC),
		list(QUALITY_SCREW_DRIVING, 10)
	)

/datum/craft_recipe/gun/makeshiftgl
	name = "makeshift china lake"
	result = /obj/item/weapon/gun/launcher/grenade/makeshiftgl
	steps = list(
		list(/obj/item/gun_parts, 2),
		list(QUALITY_ADHESIVE, 15, 70),
		list(CRAFT_MATERIAL, 20, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, "time" = 15),
		list(CRAFT_MATERIAL, 10, MATERIAL_WOOD),
		list(QUALITY_SCREW_DRIVING, 10)
	)

/datum/craft_recipe/gun/slidebarrelshotgun
	name = "slide barrel Shotgun"
	result = /obj/item/weapon/gun/projectile/shotgun/slidebarrelshotgun
	steps = list(
		list(/obj/item/gun_parts, 3),
		list(QUALITY_ADHESIVE, 15, 70),
		list(CRAFT_MATERIAL, 20, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, "time" = 15),
		list(CRAFT_MATERIAL, 10, MATERIAL_WOOD),
		list(QUALITY_SCREW_DRIVING, 10)
	)

/datum/craft_recipe/gun/motherfucker
	name = "HM Motherfucker .35 \"Punch Hole\""
	result = /obj/item/weapon/gun/projectile/automatic/motherfucker
	steps = list(
		list(/obj/item/gun_parts, 5),
		list(QUALITY_ADHESIVE, 15, 70),
		list(CRAFT_MATERIAL, 20, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, "time" = 15),
		list(CRAFT_MATERIAL, 15, MATERIAL_WOOD),
		list(QUALITY_SCREW_DRIVING, 10)
	)

/datum/craft_recipe/gun/makeshiftlaser
	name = "makeshift laser carbine"
	result = /obj/item/weapon/gun/energy/makeshiftlaser
	steps = list(
		list(/obj/item/gun_parts, 4),
		list(QUALITY_ADHESIVE, 15, 70),
		list(CRAFT_MATERIAL, 20, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, "time" = 15),
		list(CRAFT_MATERIAL, 15, MATERIAL_PLASTIC),
		list(/obj/item/weapon/stock_parts/micro_laser , 4),
		list(QUALITY_SCREW_DRIVING, 10)
	)
