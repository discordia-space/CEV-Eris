// NeoTheology

/obj/item/computer_hardware/hard_drive/portable/design/nt
	disk_name = "NeoTheology Armory"
	icon_state = "neotheology"
	license = -1

/obj/item/computer_hardware/hard_drive/portable/design/nt/pouches
	disk_name = "NeoTheology Armory - Pouches Pack"
	license = -1
	designs = list(
		/datum/design/bioprinter/leather/holster,
		/datum/design/bioprinter/leather/holster/baton,
		/datum/design/bioprinter/leather/holster/belt,
		/datum/design/bioprinter/leather/holster/sheath,
		/datum/design/bioprinter/small_generic,
		/datum/design/bioprinter/medium_generic,
		/datum/design/bioprinter/large_generic,
		/datum/design/bioprinter/medical_supply,
		/datum/design/bioprinter/engineering_tools,
		/datum/design/bioprinter/engineering_supply,
		/datum/design/bioprinter/engineering_material,
		/datum/design/bioprinter/ammo,
		/datum/design/bioprinter/tubular,
		/datum/design/bioprinter/tubular/vial,
		/datum/design/bioprinter/part
	)

// Batteries that printed fully charged, at the cost of some biomatter or plasma being non-refundable
/obj/item/computer_hardware/hard_drive/portable/design/nt/cells
	disk_name = "NeoTheology Armory - Power Cells Pack"
	license = -1
	designs = list(
		/datum/design/bioprinter/nt_cells/large,
		/datum/design/bioprinter/nt_cells/large/plasma,
		/datum/design/bioprinter/nt_cells/medium,
		/datum/design/bioprinter/nt_cells/medium/plasma,
		/datum/design/bioprinter/nt_cells/small,
		/datum/design/bioprinter/nt_cells/small/plasma
	)

// Laser pistol
/obj/item/computer_hardware/hard_drive/portable/design/nt/nt_svalinn
	disk_name = "NeoTheology Armory - NT LP \"Svalinn\""
	license = -1
	designs = list(
		/datum/design/autolathe/gun/nt_svalinn,
		/datum/design/bioprinter/nt_cells/small
	)

// Javelins & bucklers, speed upgrade TODO: light armor
/obj/item/computer_hardware/hard_drive/portable/design/nt/velite
	disk_name = "NeoTheology Armory - \"Velite Arms\""
	license = 12
	designs = list(
		/datum/design/autolathe/nt/sword/nt_verutum,
		/datum/design/autolathe/nt/shield/nt_buckler,
		/datum/design/autolathe/cruciform_upgrade/speed_of_the_chosen
	)

// Grenade launcher with stinger
/obj/item/computer_hardware/hard_drive/portable/design/nt/nt_protector
	disk_name = "NeoTheology Armory - NT GL \"Protector\""
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/grenade_launcher = 6, // "NT GL \"Protector\""
		/datum/design/autolathe/ammo/nt_stinger
	)

// Greatshields & greatswords, space-worthy armor, protection upgrade
/obj/item/computer_hardware/hard_drive/portable/design/nt/principes
	disk_name = "NeoTheology Armory - \"Principes Arms\""
	license = 16
	designs = list(
		/datum/design/bioprinter/leather/holster/sheath = 0,
		/datum/design/autolathe/nt/sword/nt_longsword,
		/datum/design/autolathe/nt/shield/nt_shield,
		/datum/design/autolathe/clothing/NTvoid = 2,
		/datum/design/autolathe/cruciform_upgrade/faiths_shield
	)

// First aid kits, TODO: proximity healing/stabilizing cruciform upgrade
/obj/item/computer_hardware/hard_drive/portable/design/nt/medicii
	disk_name = "NeoTheology Armory - \"Medicii Supplies\""
	license = 12
	designs = list(
		/datum/design/autolathe/firstaid/nt,
		/datum/design/autolathe/cruciform_upgrade/natures_blessing
	)

// Plasma assault rifle
/obj/item/computer_hardware/hard_drive/portable/design/nt/nt_dominion
	disk_name = "NeoTheology Armory - NT PR \"Dominion\""
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 50
	license = 6
	spawn_blacklisted = FALSE
	designs = list(
		/datum/design/autolathe/gun/plasma/dominion = 3, //"NT PR \"Dominion\""
		/datum/design/bioprinter/nt_cells/medium
	)

// Heavy weapons, heavy armor
/obj/item/computer_hardware/hard_drive/portable/design/nt/triarii
	disk_name = "NeoTheology Armory - \"Triarii Arms\""
	license = 24 // Chonky disk, chonky prices
	designs = list(
		/datum/design/bioprinter/leather/holster/sheath = 0,
		/datum/design/autolathe/nt/sword/nt_scourge,
		/datum/design/autolathe/nt/sword/nt_halberd = 2,
		/datum/design/autolathe/nt/sword/nt_spear,
		/datum/design/autolathe/nt/helmet/crusader,
		/datum/design/autolathe/nt/armor/crusader = 2,
		/datum/design/autolathe/cruciform_upgrade/wrath_of_god
	)

// Grenades - includes heatwave for launchers
/obj/item/computer_hardware/hard_drive/portable/design/nt/grenades
	disk_name = "NeoTheology Armory - Grenades Pack"
	license = 24
	designs = list(
		/datum/design/autolathe/nt/grenade/nt_heatwave = 2,
		/datum/design/autolathe/nt/grenade/nt_flashbang,
		/datum/design/autolathe/nt/grenade/nt_smokebomb,
		/datum/design/autolathe/ammo/shell_heatwave,
		/datum/design/autolathe/ammo/nt_stinger
	)

// Laser rifle
/obj/item/computer_hardware/hard_drive/portable/design/nt/nt_lightfall
	disk_name = "NeoTheology Armory - Lightfall Laser Gun"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/laser = 3, // "NT LG \"Lightfall\""
		/datum/design/bioprinter/nt_cells/medium
	)

// GIGA lenses
/obj/item/computer_hardware/hard_drive/portable/design/nt/excruciator
	disk_name = "NeoTheology Armory - NT \"EXCRUCIATOR\" giga lens"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/excruciator
	)


// Roundstart disks

// Foodstuffs, fertilizers, medical and cleaning utilities
/obj/item/computer_hardware/hard_drive/portable/design/nt_bioprinter
	disk_name = "NeoTheology Bioprinter Products and Utilities"
	icon_state = "neotheology"

	license = -1
	designs = list(
		/datum/design/bioprinter/meat,
		/datum/design/bioprinter/milk,
		/datum/design/bioprinter/soap,

		/datum/design/bioprinter/ez,
		/datum/design/bioprinter/l4z,
		/datum/design/bioprinter/rh,

		/datum/design/bioprinter/medical/bruise,
		/datum/design/bioprinter/medical/splints,
		/datum/design/bioprinter/medical/ointment,
		/datum/design/bioprinter/medical/advanced/bruise,
		/datum/design/bioprinter/medical/advanced/ointment,

		/datum/design/autolathe/gun/nt_sprayer,
		/datum/design/autolathe/device/grenade/nt_cleaner,
		/datum/design/autolathe/device/grenade/nt_weedkiller,

		/datum/design/bioprinter/holyvacuum

	)

// Clothes, armor and accesories
/obj/item/computer_hardware/hard_drive/portable/design/nt_bioprinter_clothes
	disk_name = "NeoTheology Bio-Fabric Designs"
	icon_state = "neotheology"

	license = -1
	designs = list(
		/datum/design/bioprinter/nt_clothes/acolyte_armor,
		/datum/design/bioprinter/nt_clothes/agrolyte_armor,
		/datum/design/bioprinter/nt_clothes/custodian_armor,

		/datum/design/bioprinter/nt_clothes/acolyte_armor_head,
		/datum/design/bioprinter/nt_clothes/agrolyte_armor_head,
		/datum/design/bioprinter/nt_clothes/custodian_armor_head,

		/datum/design/bioprinter/nt_clothes/preacher_coat,
		/datum/design/bioprinter/nt_clothes/acolyte_jacket,
		/datum/design/bioprinter/nt_clothes/sports_jacket,

		/datum/design/bioprinter/nt_clothes/acolyte_uniform,
		/datum/design/bioprinter/nt_clothes/sports_uniform,
		/datum/design/bioprinter/nt_clothes/church_uniform,

		/datum/design/bioprinter/shoes,
		/datum/design/bioprinter/jackboots,

		/datum/design/bioprinter/belt/security,
		/datum/design/bioprinter/belt/utility,

		/datum/design/bioprinter/satchel,
		/datum/design/bioprinter/backpack,
		/datum/design/bioprinter/wallet,
		/datum/design/bioprinter/botanic_leather,

		/datum/design/bioprinter/belt/medical,
		/datum/design/bioprinter/belt/medical/emt,

   		/datum/design/autolathe/device/headset_church
	)

// Basic melee
/obj/item/computer_hardware/hard_drive/portable/design/nt_melee
	disk_name = "NeoTheology Armory - \"Hastatii Arms\""
	icon_state = "neotheology"

	license = -1
	designs = list(
		/datum/design/autolathe/nt/sword/nt_sword,
		/datum/design/autolathe/nt/sword/nt_dagger,
		/datum/design/bioprinter/leather/holster/sheath,
		/datum/design/autolathe/nt/tool_upgrade/sanctifier
	)

// Kinda like the regular product NT disk, minus the grenades, soap and the cleaner carbine. Should spawn in public access bioprinters if they get added by any chance.
/obj/item/computer_hardware/hard_drive/portable/design/nt_bioprinter_public
	disk_name = "NeoTheology Bioprinter Pack"
	icon_state = "neotheology"

	license = -1
	designs = list(
		/datum/design/bioprinter/meat,
		/datum/design/bioprinter/milk,

		/datum/design/bioprinter/ez,
		/datum/design/bioprinter/l4z,
		/datum/design/bioprinter/rh,

		/datum/design/bioprinter/wallet,
		/datum/design/bioprinter/botanic_leather,
		/datum/design/bioprinter/satchel,
		/datum/design/bioprinter/backpack,
		/datum/design/bioprinter/belt/utility,
		/datum/design/bioprinter/belt/medical,
		/datum/design/bioprinter/belt/security,
		/datum/design/bioprinter/belt/medical/emt,

		/datum/design/bioprinter/leather/holster,
		/datum/design/bioprinter/leather/holster/baton,
		/datum/design/bioprinter/leather/holster/belt,
		/datum/design/bioprinter/leather/holster/sheath,

		/datum/design/autolathe/device/headset_church
	)

// Various gun disks not accessible via EOTP

/obj/item/computer_hardware/hard_drive/portable/design/guns/nt_nemesis
	disk_name = "NeoTheology Armory - Nemesis Energy Crossbow"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 50
	license = -1
	designs = list(
		/datum/design/autolathe/gun/energy_crossbow, // "NT EC \"Nemesis\"" - self charging, no cell needed
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/nt_valkyrie
	disk_name = "NeoTheology Armory - Valkyrie Energy Rifle"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 50
	license = -1
	designs = list(
		/datum/design/autolathe/gun/sniperrifle, //"NT MER \"Valkyrie\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/nt_halicon
	disk_name = "NeoTheology Armory - Halicon Ion Rifle"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 33.33
	license = -1
	designs = list(
		/datum/design/autolathe/gun/ionrifle, // "NT IR \"Halicon\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/nt/nt_counselor
	disk_name = "NeoTheology Armory - Councelor PDW E"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 17
	license = -1
	spawn_blacklisted = FALSE
	designs = list(
		/datum/design/autolathe/gun/taser, // "NT SP \"Counselor\""
		/datum/design/autolathe/cell/medium/high
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/nt_mk58
	disk_name = "NeoTheology Armory - .35 MK58 Handgun Pack"
	icon_state = "neotheology"
	rarity_value = 9
	license = 12
	designs = list(
		/datum/design/autolathe/gun/mk58 = 3,
		/datum/design/autolathe/gun/mk58_wood = 3,
		/datum/design/autolathe/ammo/magazine_pistol,
		/datum/design/autolathe/ammo/magazine_pistol/practice = 0,
		/datum/design/autolathe/ammo/magazine_pistol/rubber,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/nt_regulator
	disk_name = "NeoTheology Armory - .50 Regulator Shotgun"
	icon_state = "neotheology"
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

/obj/item/computer_hardware/hard_drive/portable/design/nt/cruciform_upgrade
	disk_name = "NeoTheology Armory - Cruciform Upgrades"
	icon_state = "neotheology"

/obj/item/computer_hardware/hard_drive/portable/design/guns/nt_purger
	disk_name = "NeoTheology Armory - Purger Plasma Rifle"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 90 // LMG level
	license = -1
	designs = list(
		/datum/design/autolathe/gun/plasma/destroyer, // "NT PR \"Purger\""
		/datum/design/autolathe/cell/medium/high
	)

/obj/item/computer_hardware/hard_drive/portable/design/nt/cruciform_upgrade/New()
	designs = subtypesof(/datum/design/autolathe/cruciform_upgrade)
	..()
