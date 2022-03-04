// One Star
/obj/item/computer_hardware/hard_drive/portable/design/onestar
	disk_name = "One Star Tool Pack"
	icon_state = "onestar"
	rarity_value = 70
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_DESIGN_OS
	license = 2
	designs = list(
		/datum/design/autolathe/tool/crowbar_onestar,
		/datum/design/autolathe/tool/combi_driver_onestar,
		/datum/design/autolathe/tool/jackhammer_onestar,
		/datum/design/autolathe/tool/drill_onestar,
		/datum/design/autolathe/tool/weldertool_onestar
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/retro
	disk_name = "OS LG \"Cog\""
	icon_state = "onestar"
	rarity_value = 5.5
	license = 12
	designs = list(
		/datum/design/autolathe/gun/retro = 3, //"OS LG \"Cog\""
		/datum/design/autolathe/cell/medium/high,
	)
