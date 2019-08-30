/obj/item/clothing/head/helmet/space/void/excelsior
	name = "Excelsior helmet"
	desc = "A deceptively well armored space helmet. Ancient design, but advanced manufacturing."
	icon_state = "cosmo"
	item_state = "cosmo"

	//The excelsior armors cost small amounts of rare materials that they can teleport in.
	//This means they can either build up materials over time, or make it go faster by scavenging rare mats
	matter = list(MATERIAL_PLASTIC = 20,
	MATERIAL_GLASS = 10,
	MATERIAL_PLASTEEL = 3)

	armor = list(melee = 45, bullet = 45, energy = 55, bomb = 25, bio = 100, rad = 90)
	siemens_coefficient = 0
	species_restricted = list("Human")
	//camera_networks = list(NETWORK_EXCELSIOR) //Todo future: Excelsior camera network and monitoring console
	light_overlay = "helmet_light_green"

/obj/item/clothing/suit/space/void/excelsior

	name = "Excelsior armor"
	desc = "An ancient space suit design, remade with advanced materials. Provides good protection, especially against energy discharges"
	icon_state = "soviet_skaf"
	item_state = "soviet_skaf"
	slowdown = 0.8
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
	w_class = ITEM_SIZE_NORMAL
	//Decent all around, but less ballistic resistance
	armor = list(melee = 45, bullet = 45, energy = 35, bomb = 25, bio = 100, rad = 90)
	siemens_coefficient = 0 //Shockproof!
	matter = list(MATERIAL_PLASTIC = 30,
	MATERIAL_STEEL = 10,
	MATERIAL_PLASTEEL = 5)
