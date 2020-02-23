/datum/craft_recipe/weapon/homewrecker
	name = "homewrecker"
	result = /obj/item/weapon/tool/homewrecker
	steps = list(
		list(/obj/item/stack/rods, 12, "time" = 30),
		list(QUALITY_WELDING, 10, "time" = 30),
		list(CRAFT_MATERIAL, 30, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, "time" = 30)
	)
