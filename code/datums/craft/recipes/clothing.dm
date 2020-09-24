/datum/craft_recipe/clothing
	category = "Clothing"
	time = 50
	related_stats = list(STAT_COG)

/datum/craft_recipe/clothing/cardborg_suit
	name = "cardborg suit"
	result = /obj/item/clothing/suit/cardborg
	steps = list(
		list(CRAFT_MATERIAL, 3, MATERIAL_CARDBOARD)
	)

/datum/craft_recipe/clothing/cardborg_helmet
	name = "cardborg helmet"
	result = /obj/item/clothing/head/cardborg
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_CARDBOARD)
	)

/datum/craft_recipe/clothing/sandals
	name = "wooden sandals"
	result = /obj/item/clothing/shoes/sandal
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_WOOD)
	)

/datum/craft_recipe/clothing/armorvest
	name = "armor vest"
	result = /obj/item/clothing/suit/armor/vest/handmade
	steps = list(
		list(/obj/item/clothing/suit/storage/hazardvest, 1, "time" = 30),
		list(CRAFT_MATERIAL, 4, MATERIAL_STEEL),
		list(/obj/item/stack/cable_coil, 4)
	)

/datum/craft_recipe/clothing/combat_helmet
	name = "combat helmet"
	result = /obj/item/clothing/head/armor/helmet/handmade
	steps = list(
		list(/obj/item/weapon/reagent_containers/glass/bucket, 1, "time" = 30),
		list(CRAFT_MATERIAL, 4, MATERIAL_STEEL),
		list(/obj/item/stack/cable_coil, 2)
	)

/datum/craft_recipe/clothing/chest_rig
	name = "chest rig"
	result = /obj/item/clothing/suit/storage/vest/chestrig
	steps = list(
		list(/obj/item/stack/medical/bruise_pack/handmade, 3, "time" = 10),
		list(/obj/item/stack/rods, 2, "time" = 10),
		list(/obj/item/stack/cable_coil, 2),
	)

/datum/craft_recipe/clothing/riggedvoidsuit
	name = "Jury Rigged Voidsuit"
	result = /obj/item/clothing/suit/space/void/riggedvoidsuit
	steps = list(
		list(/obj/item/clothing/under, 1),
		list(/obj/item/armor_parts, 3),
		list(CRAFT_MATERIAL, 10, MATERIAL_PLASTEEL),
		list(CRAFT_MATERIAL, 20, MATERIAL_PLASTIC),
		list(/obj/item/weapon/tool/tape_roll, 10, "time" = 10),
		list(CRAFT_MATERIAL, 10, MATERIAL_GLASS),
		list(QUALITY_SCREW_DRIVING, 10),

	)

/datum/craft_recipe/clothing/scavengerarmor
	name = "Scavenger armor"
	result = /obj/item/clothing/suit/storage/scavengerarmor
	steps = list(
		list(/obj/item/armor_parts, 5),
		list(CRAFT_MATERIAL, 5, MATERIAL_PLASTEEL),
		list(CRAFT_MATERIAL, 10, MATERIAL_PLASTIC),
		list(/obj/item/weapon/tool/tape_roll, 10, "time" = 10),
		list(CRAFT_MATERIAL, 10, MATERIAL_GLASS),
		list(QUALITY_SCREW_DRIVING, 10),

	)
