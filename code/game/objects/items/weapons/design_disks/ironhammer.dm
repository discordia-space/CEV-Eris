// Ironhammer

/obj/item/computer_hardware/hard_drive/portable/design/security
	disk_name = "Ironhammer Miscellaneous Pack"
	icon_state = "ironhammer"
	rarity_value = 5
	license = 20
	designs = list(
		/datum/design/autolathe/sec/secflashlight,
		/datum/design/research/item/flash,
		/datum/design/autolathe/sec/handcuffs,
		/datum/design/autolathe/sec/zipties,
		/datum/design/autolathe/sec/electropack,
		/datum/design/autolathe/misc/taperecorder,
		/datum/design/autolathe/tool/tacknife,
		/datum/design/autolathe/sec/beartrap,
		/datum/design/autolathe/device/landmine = 2,
		/datum/design/autolathe/sec/silencer,
		/datum/design/autolathe/sec/hailer
	)
/obj/item/computer_hardware/hard_drive/portable/design/armor/generic
	disk_name = "Ironhammer Combat Equipment - Standard Armor"
	icon_state = "ironhammer"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED_COMMON
	rarity_value = 12 // one of the more common advanced disks
	license = 6 // 6 pieces, or 3 sets if you use helm + vest
	designs = list(
		/datum/design/autolathe/clothing/generic_helmet_basic,
		/datum/design/autolathe/clothing/generic_vest,
		/datum/design/autolathe/clothing/generic_vest_full = 2
	)
