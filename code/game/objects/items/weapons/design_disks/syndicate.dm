// Syndicate
/obj/item/computer_hardware/hard_drive/portable/design/syndicate
	disk_name = "Hanza Syndicate"
	icon_state = "syndicate"
	license = -1

/obj/item/computer_hardware/hard_drive/portable/design/guns/c20m
	disk_name = "Hanza Syndicate - .35 C20-r submachine gun"
	icon_state = "syndicate"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 40
	license = 12
	designs = list(
		/datum/design/autolathe/gun/c20/ = 3, //Syndicate C20-r
		/datum/design/autolathe/ammo/smg,
		/datum/design/autolathe/ammo/smg/rubber,
		/datum/design/autolathe/ammo/smg/practice = 0
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/clarissa
	disk_name = "Hanza Syndicate - .35 Clarissa machine pistol"
	icon_state = "syndicate"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 15
	license = 12
	designs = list(
		/datum/design/autolathe/gun/clarissa = 3, //Clarissa
		/datum/design/autolathe/ammo/magazine_hpistol,
		/datum/design/autolathe/ammo/magazine_hpistol/rubber,
		/datum/design/autolathe/ammo/magazine_hpistol/practice = 0
	)