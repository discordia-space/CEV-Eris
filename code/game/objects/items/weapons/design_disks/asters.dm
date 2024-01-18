// Asters
/obj/item/computer_hardware/hard_drive/portable/design/tools
	disk_name = "Asters Basic Tool Pack"
	icon_state = "guild"
	rarity_value = 5.5
	spawn_tags = SPAWN_TAG_DESIGN_COMMON
	license = -1
	designs = list(
		/datum/design/autolathe/tool/hatchet,
		/datum/design/autolathe/tool/minihoe,
		/datum/design/autolathe/tool/ducttape,
		/datum/design/autolathe/tool/knife,
		/datum/design/autolathe/misc/heavyflashlight,
		/datum/design/autolathe/tool/crowbar,
		/datum/design/autolathe/tool/screwdriver,
		/datum/design/autolathe/tool/wirecutters,
		/datum/design/autolathe/tool/pliers,
		/datum/design/autolathe/tool/wrench,
		/datum/design/autolathe/tool/hammer,
		/datum/design/autolathe/tool/saw,
		/datum/design/autolathe/tool/multitool,
		/datum/design/autolathe/tool/pickaxe,
		/datum/design/autolathe/tool/sledgehammer,
		/datum/design/autolathe/tool/shovel,
		/datum/design/autolathe/tool/spade,
		/datum/design/autolathe/device/t_scanner,
		/datum/design/autolathe/tool/weldertool,
		/datum/design/autolathe/tool/weldinggoggles,
		/datum/design/autolathe/tool/weldermask,
		/datum/design/autolathe/gun/flare_gun,
		/datum/design/autolathe/ammo/flare_shell,
		/datum/design/autolathe/device/flamethrower,
		/datum/design/autolathe/container/hcase_engi
	)

/obj/item/computer_hardware/hard_drive/portable/design/misc
	disk_name = "Asters Miscellaneous Pack"
	icon_state = "guild"
	rarity_value = 3.5
	spawn_tags = SPAWN_TAG_DESIGN_COMMON
	license = -1
	designs = list(
		/datum/design/autolathe/misc/flashlight,
		/datum/design/autolathe/tool/ducttape,
		/datum/design/autolathe/misc/extinguisher,
		/datum/design/autolathe/misc/radio_headset,
		/datum/design/autolathe/misc/radio_bounced,
		/datum/design/autolathe/misc/ashtray,
		/datum/design/autolathe/misc/mirror,
		/datum/design/autolathe/misc/earmuffs,
		/datum/design/autolathe/container/drinkingglass,
		/datum/design/autolathe/container/carafe,
		/datum/design/autolathe/container/insulated_pitcher,
		/datum/design/autolathe/container/bucket,
		/datum/design/autolathe/container/jar,
		/datum/design/autolathe/container/syringe,
		/datum/design/autolathe/container/vial,
		/datum/design/autolathe/container/beaker,
		/datum/design/autolathe/container/beaker_large,
		/datum/design/autolathe/container/mixingbowl,
		/datum/design/autolathe/container/pill_bottle,
		/datum/design/autolathe/container/spray,
		/datum/design/autolathe/container/freezer,
		/datum/design/autolathe/misc/cane,
		/datum/design/autolathe/misc/floor_light,
		/datum/design/autolathe/misc/tube,
		/datum/design/autolathe/misc/bulb,
		/datum/design/autolathe/device/floorpainter,
		/datum/design/autolathe/device/mechpainter,
		/datum/design/autolathe/container/hcase_engi,
		/datum/design/autolathe/container/hcase_parts,
		/datum/design/autolathe/device/spraypaint
	)

/obj/item/computer_hardware/hard_drive/portable/design/devices
	disk_name = "Asters Devices and Instruments"
	icon_state = "guild"
	rarity_value = 3
	spawn_tags = SPAWN_TAG_DESIGN_COMMON
	license = 10
	designs = list(
		/datum/design/autolathe/misc/flashlight,
		/datum/design/autolathe/device/analyzer,
		/datum/design/autolathe/device/plant_analyzer,
		/datum/design/autolathe/device/healthanalyzer,
		/datum/design/research/item/medical/mass_spectrometer,
		/datum/design/research/item/medical/reagent_scanner,
		/datum/design/research/item/medical/robot_scanner,
		/datum/design/autolathe/device/slime_scanner,
		/datum/design/autolathe/device/megaphone,
		/datum/design/autolathe/device/t_scanner,
		/datum/design/autolathe/device/gps,
		/datum/design/autolathe/device/destTagger,
		/datum/design/autolathe/device/export_scanner,
		/datum/design/autolathe/device/implanter,
		/datum/design/autolathe/device/hand_labeler,
		/datum/design/research/item/light_replacer,
		/datum/design/autolathe/sec/hailer,
	)

/obj/item/computer_hardware/hard_drive/portable/design/robustcells
	disk_name = "Asters Robustcells"
	icon_state = "guild"
	rarity_value = 3
	spawn_tags = SPAWN_TAG_DESIGN_COMMON
	license = 10
	designs = list(
		/datum/design/autolathe/cell/large,
		/datum/design/autolathe/cell/large/high = 2,
		/datum/design/autolathe/cell/medium,
		/datum/design/autolathe/cell/medium/high = 2,
		/datum/design/autolathe/cell/small,
		/datum/design/autolathe/cell/small/high = 2,
	)

/obj/item/computer_hardware/hard_drive/portable/design/armor/asters
	disk_name = "Asters Enforcement Armor Pack"
	icon_state = "guild"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED_COMMON
	rarity_value = 13 // between standard and bulletproof armor
	license = 6
	designs = list(
		/datum/design/autolathe/clothing/generic_vest_webbing = 2,
		/datum/design/autolathe/clothing/generic_vest_security,
		/datum/design/autolathe/clothing/generic_helmet_visored,
		/datum/design/autolathe/clothing/generic_vest_security_full = 2,
		/datum/design/autolathe/clothing/riot_helmet = 2,
	)
