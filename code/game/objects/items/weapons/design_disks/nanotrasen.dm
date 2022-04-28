// Nanotrasen
/obj/item/computer_hardware/hard_drive/portable/design/oldnt
	disk_name = "NanoTrasen Security"
	desc = "this shouldnt spawn, if it does i fucked up"
	icon_state = "nanotrasen"
	license = -1

/obj/item/computer_hardware/hard_drive/portable/design/guns/nt_regulator/old
	disk_name = "NanoTrasen Security - .50 Regulator Shotgun"
	desc = "A old NanoTrasen design disk. this one is labelled Regulator 1000 Shotgun. on the back there is a warning label saying authorized NT personell only, its ID scanner has been burned off"
	icon_state = "nanotrasen"
	rarity_value = 17
	license = 12
	designs = list(
		/datum/design/autolathe/gun/regulator = 3, // "NT SG \"Regulator 1000\""
		/datum/design/autolathe/ammo/shotgun_pellet,
		/datum/design/autolathe/ammo/shotgun,
		/datum/design/autolathe/ammo/shotgun_beanbag,
		/datum/design/autolathe/ammo/shotgun_blanks,
		/datum/design/autolathe/ammo/shotgun_flash,
		)

/obj/item/computer_hardware/hard_drive/portable/design/guns/nt_mk58/old
	disk_name = "NanoTrasen Security - .35 MK58 Handgun Pack"
	desc = "An old NanoTrasen design disk. this one is labelled MK58 Handgun. on the back there is a warning label saying authorized NT personell only, its ID scanner has been burned off"
	icon_state = "nanotrasen"
	rarity_value = 9
	license = 12
	designs = list(
		/datum/design/autolathe/gun/mk58 = 3,
		/datum/design/autolathe/ammo/magazine_pistol,
		/datum/design/autolathe/ammo/magazine_pistol/practice = 0,
		/datum/design/autolathe/ammo/magazine_pistol/rubber,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/nt/nt_counselor/old
	disk_name = "NanoTrasen Security - Councelor PDW E"
	desc = "An old NanoTrasen design disk. this one is labelled Counselor Disabler Pistol. on the back there is a warning label saying authorized NT personell only, its ID scanner has been burned off"
	icon_state = "nanotrasen"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 10
	license = 12
	designs = list(
		/datum/design/autolathe/gun/taser = 3, // "NT SP \"Counselor\""
		/datum/design/autolathe/cell/medium/high
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/nt_valkyrie/old
	disk_name = "Nanotrasen Security - Valkyrie Energy Rifle"
	desc = "An old NanoTrasen design disk. this one is labelled PROTOYPE:Project Valkyrie, on the back there is a warning label stating any non authorized NT personell in possession of this disk is to be arrested. the ID scanner has been burned off"
	icon_state = "nanotrasen"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 50
	license = 12
	designs = list(
		/datum/design/autolathe/gun/sniperrifle = 3, //"NT MER \"Valkyrie\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/nt_valkyrie/old
	disk_name = "Nanotrasen Security - Destiny Laser Pistol"
	desc = "An old NanoTrasen design disk. this one is labelled Destiny Laser Gun. on the back there is a warning label saying authorized NT personell only, its ID scanner has been burned off"
	icon_state = "nanotrasen"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 65
	license = 9
	designs = list(
		/datum/design/autolathe/gun/destiny = 3, //"NT LG \"Destiny\""
	)