
/obj/item/computer_hardware/hard_drive/portable/design/guns/or_silenced
	disk_name = "Oberth Republic - .25 Mandella"
	icon_state = "black"
	rarity_value = 13
	license = 12
	designs = list(
		/datum/design/autolathe/gun/mandella = 3, // "OR HG .25 Caseless \"Mandella\""
		/datum/design/autolathe/ammo/cspistol,
		/datum/design/autolathe/ammo/cspistol/practice = 0,
		/datum/design/autolathe/ammo/cspistol/rubber,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/fs_bulldog
	disk_name = "Oberth Republic - .20 Bulldog Carabine"
	icon_state = "black"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/z8 = 3, // "OR CAR .20 \"Z8 Bulldog\""
		/datum/design/autolathe/ammo/srifle,
		/datum/design/autolathe/ammo/srifle/practice = 0,
		/datum/design/autolathe/ammo/srifle/rubber,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/sts
	disk_name = "Oberth Republic - .30 STS Assault Rifle"
	icon_state = "black"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 65
	license = 12
	designs = list(
		/datum/design/autolathe/gun/sts35 = 3, // "OR STS"
		/datum/design/autolathe/ammo/lrifle,
		/datum/design/autolathe/ammo/lrifle/practice = 0,
		/datum/design/autolathe/ammo/lrifle/rubber,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/shellshock
	disk_name = "Oberth Republic - Shellshock Energy Shotgun"
	icon_state = "black"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 20
	license = 12
	designs = list(
		/datum/design/autolathe/gun/shellshock = 3, // "shellshock"
		/datum/design/autolathe/cell/medium/high
	)