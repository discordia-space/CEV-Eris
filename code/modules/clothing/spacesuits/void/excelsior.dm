/obj/item/clothing/head/helmet/space/void/excelsior
	name = "Excelsior helmet"
	desc = "A deceptively well armored space helmet, based on an ancient design"
	icon_state = "cosmo"
	item_state = "cosmo"

	//The excelsior armors cost small amounts of rare materials that they can teleport in.
	//This means they can either build up materials over time, or make it go faster by scavenging rare mats
	matter = list(MATERIAL_PLASTIC = 20,
	MATERIAL_GLASS = 10,
	MATERIAL_SILVER = 0.5,
	MATERIAL_GOLD = 0.5,
	MATERIAL_URANIUM = 0.5,
	MATERIAL_PLASTEEL = 1)

	armor = list(melee = 60, bullet = 50, laser = 70, energy = 75, bomb = 55, bio = 100, rad = 90)
	siemens_coefficient = 1
	species_restricted = list("Human")
	//camera_networks = list(NETWORK_EXCELSIOR) //Todo future: Excelsior camera network and monitoring console
	light_overlay = "helmet_light_green"

/obj/item/clothing/suit/space/void/excelsior

	name = "Excelsior armor"
	desc = "An ancient space suit design, reworked to include significant protection, especially against energy discharges"
	icon_state = "soviet_skaf"
	item_state = "soviet_skaf"
	slowdown = 1.5
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
	w_class = ITEM_SIZE_NORMAL
	//Decent all around, but less ballistic resistance
	armor = list(melee = 60, bullet = 50, laser = 70, energy = 75, bomb = 55, bio = 100, rad = 90)
	siemens_coefficient = 1 //Shockproof!
	matter = list(MATERIAL_PLASTIC = 30,
	MATERIAL_STEEL = 10,
	MATERIAL_SILVER = 1,
	MATERIAL_GOLD = 1,
	MATERIAL_URANIUM = 1,
	MATERIAL_PLASTEEL = 2)
