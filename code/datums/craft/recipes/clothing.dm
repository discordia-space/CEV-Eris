/datum/craft_recipe/clothing
	category = "Clothing"
	time = 50
	related_stats = list(STAT_COG)

/datum/craft_recipe/clothing/dusters
	name = "steel knuckle dusters"
	result = /obj/item/clothing/gloves/dusters
	steps = list(
		list(CRAFT_MATERIAL, 3, MATERIAL_STEEL), //Grab some steel
		list(QUALITY_WELDING, 10, "time" = 30), //Weld it into basic form
		list(QUALITY_HAMMERING, 15, 10) //Harden into shape
	)

/datum/craft_recipe/clothing/dusters/silver
	name = "silver knuckle dusters"
	result = /obj/item/clothing/gloves/dusters/silver
	steps = list(
		list(CRAFT_MATERIAL, 3, MATERIAL_SILVER), //Grab some silver
		list(QUALITY_WELDING, 10, "time" = 30), //Weld it into basic form
		list(QUALITY_HAMMERING, 15, 10) //Harden into shape
	)

/datum/craft_recipe/clothing/dusters/plasteel
	name = "plasteel knuckle dusters"
	result = /obj/item/clothing/gloves/dusters/plasteel
	steps = list(
		list(CRAFT_MATERIAL, 3, MATERIAL_PLASTEEL), //Grab some plasteel
		list(QUALITY_WELDING, 10, "time" = 30), //Weld it into basic form
		list(QUALITY_HAMMERING, 15, 10) //Harden into shape
	)

/datum/craft_recipe/clothing/dusters/gold
	name = "golden knuckle dusters"
	result = /obj/item/clothing/gloves/dusters/gold
	steps = list(
		list(CRAFT_MATERIAL, 3, MATERIAL_GOLD), //Grab some gold
		list(CRAFT_MATERIAL, 3, MATERIAL_PLASTEEL), //Grab some plasteel as well
		list(QUALITY_WELDING, 10, "time" = 30), //Weld it into basic form
		list(QUALITY_HAMMERING, 15, 10) //Harden into shape
	)

/datum/craft_recipe/clothing/dusters/platinum
	name = "spiked platinum knuckle dusters"
	result = /obj/item/clothing/gloves/dusters/platinum
	steps = list(
		list(CRAFT_MATERIAL, 3, MATERIAL_PLATINUM), //Grab some platinum
		list(QUALITY_WELDING, 10, "time" = 30), //Weld it into basic form
		list(QUALITY_HAMMERING, 15, 10), //Harden into shape
		list(/obj/item/tool_upgrade/augment/spikes, 1, "time" = 10) //Put 'spiked' in the name
	)

/datum/craft_recipe/clothing/dusters/gloves
	name = "weighted knuckle gloves"
	result = /obj/item/clothing/gloves/dusters/gloves
	steps = list(
		list(/obj/item/clothing/gloves/knuckles, 1, "time" = 5), //Tear up the gloves
		list(CRAFT_MATERIAL, 3, MATERIAL_PLASTEEL), //Grab some plasteel
		list(QUALITY_HAMMERING, 15, 10), //Harden into powder
		list(QUALITY_HAMMERING, 15, 10), //Harden into FINE powder
		list(/obj/item/stack/medical/bruise_pack/handmade, 2, "time" = 10) //Cover the holes up
	)

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

/datum/craft_recipe/clothing/accessory/cloak
	name = "oversized poncho"
	result = /obj/item/clothing/accessory/cloak
	steps = list(
		list(/obj/item/bedsheet, 1),
		list(QUALITY_WIRE_CUTTING, 20, "time" = 30))

/datum/craft_recipe/clothing/accessory/cloak/ponchoblue
	name = "blue oversized poncho"
	result = /obj/item/clothing/accessory/cloak/ponchoblue
	steps = list(
		list(/obj/item/bedsheet, 1),
		list(QUALITY_WIRE_CUTTING, 20, "time" = 30))

/datum/craft_recipe/clothing/accessory/cloak/ponchored
	name = "red oversized poncho"
	result = /obj/item/clothing/accessory/cloak/ponchored
	steps = list(
		list(/obj/item/bedsheet, 1),
		list(QUALITY_WIRE_CUTTING, 20, "time" = 30))

/datum/craft_recipe/clothing/accessory/cloak/ponchogreen
	name = "green oversized poncho"
	result = /obj/item/clothing/accessory/cloak/ponchogreen
	steps = list(
		list(/obj/item/bedsheet, 1),
		list(QUALITY_WIRE_CUTTING, 20, "time" = 30))

/datum/craft_recipe/clothing/accessory/cloak/ponchopurple
	name = "purple oversized poncho"
	result = /obj/item/clothing/accessory/cloak/ponchopurple
	steps = list(
		list(/obj/item/bedsheet, 1),
		list(QUALITY_WIRE_CUTTING, 20, "time" = 30))

/datum/craft_recipe/clothing/accessory/cloak/ponchoash
	name = "ash oversized poncho"
	result = /obj/item/clothing/accessory/cloak/ponchoash
	steps = list(
		list(/obj/item/bedsheet, 1),
		list(QUALITY_WIRE_CUTTING, 20, "time" = 30))

/datum/craft_recipe/clothing/accessory/cloak/ponchowhite
	name = "white oversized poncho"
	result = /obj/item/clothing/accessory/cloak/ponchowhite
	steps = list(
		list(/obj/item/bedsheet, 1),
		list(QUALITY_WIRE_CUTTING, 20, "time" = 30))

/datum/craft_recipe/clothing/accessory/cloak/clowncho
	name = "clown poncho"
	result = /obj/item/clothing/accessory/cloak/clowncho
	steps = list(
		list(/obj/item/bedsheet, 1),
		list(QUALITY_WIRE_CUTTING, 20, "time" = 30))

/datum/craft_recipe/clothing/sandals
	name = "wooden sandals"
	result = /obj/item/clothing/shoes/sandal
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_WOOD)
	)

/datum/craft_recipe/clothing/armorvest
	name = "Makeshift armor vest"
	result = /obj/item/clothing/suit/armor/vest/handmade
	steps = list(
		list(/obj/item/clothing/under, 1),
		list(CRAFT_MATERIAL, 5, MATERIAL_STEEL),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/clothing/armorvest/fullbody
	name = "Makeshift fullbody armor vest"
	result = /obj/item/clothing/suit/armor/vest/handmade/full
	steps = list(
		list(/obj/item/clothing/suit/armor/vest/handmade, 1),
		list(CRAFT_MATERIAL, 10, MATERIAL_STEEL),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/clothing/combat_helmet
	name = "combat helmet"
	result = /obj/item/clothing/head/armor/helmet/handmade
	steps = list(
		list(/obj/item/reagent_containers/glass/bucket, 1, "time" = 30),
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
	name = "Makeshift armored void suit"
	result = /obj/item/clothing/suit/space/void/riggedvoidsuit
	steps = list(
		list(/obj/item/clothing/under, 1),
		list(/obj/item/part/armor, 3),
		list(CRAFT_MATERIAL, 10, MATERIAL_PLASTEEL),
		list(CRAFT_MATERIAL, 20, MATERIAL_PLASTIC),
		list(QUALITY_ADHESIVE, 15, 15),
		list(CRAFT_MATERIAL, 10, MATERIAL_GLASS),
		list(QUALITY_WELDING, 10, 20),
	)

/datum/craft_recipe/clothing/scavengerhelmet
	name = "Scavenger helmet"
	result = /obj/item/clothing/head/armor/helmet/scavengerhelmet
	steps = list(
		list(/obj/item/part/armor, 1),
		list(CRAFT_MATERIAL, 2, MATERIAL_PLASTEEL),
		list(CRAFT_MATERIAL, 2, MATERIAL_PLASTIC),
		list(QUALITY_ADHESIVE, 15, 15),
		list(QUALITY_WELDING, 10, 20),
	)

/datum/craft_recipe/clothing/scavengerarmor
	name = "Scavenger armor"
	result = /obj/item/clothing/suit/storage/scavengerarmor
	steps = list(
		list(/obj/item/part/armor, 5),
		list(CRAFT_MATERIAL, 5, MATERIAL_PLASTEEL),
		list(CRAFT_MATERIAL, 10, MATERIAL_PLASTIC),
		list(QUALITY_ADHESIVE, 15, 15),
		list(QUALITY_WELDING, 10, 20),
	)

/datum/craft_recipe/clothing/armor_attach
	name = "Armor plates"
	result = /obj/item/clothing/accessory/armor
	steps = list(
		list(/obj/item/clothing/suit/armor/vest, 1),
		list(/obj/item/part/armor, 1),
		list(QUALITY_ADHESIVE, 15, 15)
	)

/datum/craft_recipe/clothing/armor_attach/bullet
	name = "Bulletproof armor plates"
	result = /obj/item/clothing/accessory/armor/bullet
	steps = list(
		list(/obj/item/clothing/suit/armor/bulletproof, 1),
		list(/obj/item/part/armor, 2),
		list(QUALITY_ADHESIVE, 15, 15)
	)

/datum/craft_recipe/clothing/armor_attach/platecarrier
	name = "Platecarrier armor plates"
	result = /obj/item/clothing/accessory/armor/platecarrier
	steps = list(
		list(/obj/item/clothing/suit/armor/platecarrier, 1),
		list(/obj/item/part/armor, 2),
		list(QUALITY_ADHESIVE, 15, 15)
	)

/datum/craft_recipe/clothing/armor_attach/bullet/riot
	name = "Padded armor plates"
	result = /obj/item/clothing/accessory/armor/riot
	steps = list(
		list(/obj/item/clothing/suit/armor/heavy/riot, 1),
		list(/obj/item/part/armor, 2),
		list(QUALITY_ADHESIVE, 15, 15)
	)

/datum/craft_recipe/clothing/armor_attach/bullet/laser
	name = "Ablative armor plates"
	result = /obj/item/clothing/accessory/armor/laser
	steps = list(
		list(/obj/item/clothing/suit/armor/laserproof/full, 1),
		list(/obj/item/part/armor, 2),
		list(QUALITY_ADHESIVE, 15, 15)
	)

/datum/craft_recipe/clothing/holster
	name = "throwing knife pouch"
	result = /obj/item/clothing/accessory/holster/knife
	steps = list (
		list(/obj/item/storage/pouch/tubular, 1, "time" = 5),
		list(QUALITY_WIRE_CUTTING, 10, "time" = 5)
	)

/datum/craft_recipe/clothing/sheath
	name = "Makeshift sheath"
	result = /obj/item/storage/pouch/holster/belt/sheath/improvised
	steps = list (
		list(CRAFT_MATERIAL, 2, MATERIAL_STEEL), //steel for the frame, since 5 makes a chair I'm assuming 2 is enough for a sheath
		list(QUALITY_ADHESIVE, 30, 70), //duct tape to line the inside of the sheath
		list(QUALITY_WELDING, 10, "time" = 30), //weld and bend it into a decent shape
		list(/obj/item/stack/cable_coil, 5, "time" = 10)) //cable coil for the sheath belt, it's gotta hang on you somehow

/datum/craft_recipe/clothing/sheath/scabbard
	name = "Makeshift scabbard"
	result = /obj/item/clothing/accessory/holster/scabbard/improvised

/datum/craft_recipe/clothing/accessory/ring_sheath
	name = "Ring sheath"
	result = /obj/item/clothing/accessory/holster/scabbard/ring
	steps = list (
		list(CRAFT_MATERIAL, 2, MATERIAL_STEEL), //steel for the frame, since 5 makes a chair I'm assuming 2 is enough for a sheath
		list(QUALITY_ADHESIVE, 30, 70), //duct tape to line the inside of the ring
		list(QUALITY_WELDING, 10, "time" = 30), //weld and bend it into a decent shape
		list(/obj/item/stack/cable_coil, 5, "time" = 10)) //cable coil for the sheath belt, it's gotta hang on you somehow



