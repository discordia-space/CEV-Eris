
//The Dallas
/obj/item/computer_hardware/hard_drive/portable/design/guns/dallas
	disk_name = "PAR - .25 Dallas"
	icon_state = "black"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/dallas = 3, // "PAR .25 CS \"Dallas\""
		/datum/design/autolathe/ammo/c10x24,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/scaramanga
	disk_name = "\"Scaramanga\" gold set"
	icon_state = "onestar"
	rarity_value = 40
	license = 15
	designs = list(
		/datum/design/autolathe/sec/gold = 3,
		/datum/design/autolathe/gun/colt = 3,
		/datum/design/autolathe/gun/atreides = 6,
		/datum/design/autolathe/gun/avasarala = 6
	)

// ARMOR
/obj/item/computer_hardware/hard_drive/portable/design/armor
	bad_type = /obj/item/computer_hardware/hard_drive/portable/design/armor

/obj/item/computer_hardware/hard_drive/portable/design/guns
	bad_type = /obj/item/computer_hardware/hard_drive/portable/design/guns
