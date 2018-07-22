/*
 * Job related
 */

//Assistant
/obj/item/clothing/suit/storage/ass_jacket
	name = "assistant jacket"
	desc = "Practical and comfortable jacket. It seems have a little protection from physical harm."
	icon_state = "ass_jacket"
	item_state = "ass_jacket"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(
		/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/lighting/toggleable/flashlight,
		/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,
		/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,
		/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/taperecorder
	)
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

//Guild Technician
/obj/item/clothing/suit/storage/cargo_jacket
	name = "guild technician jacket"
	desc = "Stylish jacket lined with pockets. It seems have a little protection from physical harm."
	icon_state = "cargo_jacket"
	item_state = "cargo_jacket"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list (
		/obj/item/device/scanner/analyzer, /obj/item/device/lighting/toggleable/flashlight, /obj/item/weapon/tool/multitool,
		/obj/item/device/pipe_painter, /obj/item/device/radio, /obj/item/device/t_scanner,
		/obj/item/weapon/tool/crowbar, /obj/item/weapon/tool/screwdriver, /obj/item/weapon/tool/weldingtool,
		/obj/item/weapon/tool/wirecutters, /obj/item/weapon/tool/wrench, /obj/item/weapon/tank/emergency_oxygen,
		/obj/item/clothing/mask/gas, /obj/item/taperoll/engineering
	)
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

//Quartermaster
/obj/item/clothing/suit/storage/qm_coat
	name = "guild merchant coat"
	desc = "An ideal choice for a smuggler. This coat seems have good impact resistant, and made from resistant and expensive materials.."
	icon_state = "qm_coat"
	item_state = "qm_coat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(
		/obj/item/device/lighting/toggleable/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,
		/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,
		/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/taperecorder,
		/obj/item/device/scanner/analyzer, /obj/item/weapon/tool/multitool, /obj/item/device/pipe_painter,
		/obj/item/device/radio, /obj/item/device/t_scanner, /obj/item/weapon/tool/crowbar,
		/obj/item/weapon/tool/screwdriver, /obj/item/weapon/tool/weldingtool, /obj/item/weapon/tool/wirecutters,
		/obj/item/weapon/tool/wrench, /obj/item/weapon/tank/emergency_oxygen, /obj/item/clothing/mask/gas,
		/obj/item/taperoll/engineering
	)
	armor = list(melee = 40, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)

//Botonist
/obj/item/clothing/suit/apron
	name = "apron"
	desc = "A basic blue apron."
	icon_state = "apron"
	item_state = "apron"
	blood_overlay_type = "armor"
	body_parts_covered = 0
	allowed = list (/obj/item/weapon/reagent_containers/spray/plantbgone,/obj/item/device/scanner/analyzer/plant_analyzer,/obj/item/seeds,/obj/item/weapon/reagent_containers/glass/fertilizer,/obj/item/weapon/material/minihoe)

//Chaplain
/obj/item/clothing/suit/chaplain_hoodie
	name = "preacher coat"
	desc = "This suit says to you 'hush'!"
	icon_state = "chaplain_hoodie"
	item_state = "chaplain_hoodie"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(
		/obj/item/device/lighting/toggleable/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,
		/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,
		/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/taperecorder,
		/obj/item/device/scanner/analyzer, /obj/item/weapon/tool/multitool, /obj/item/device/pipe_painter,
		/obj/item/device/radio, /obj/item/device/t_scanner, /obj/item/weapon/tool/crowbar,
		/obj/item/weapon/tool/screwdriver, /obj/item/weapon/tool/weldingtool, /obj/item/weapon/tool/wirecutters,
		/obj/item/weapon/tool/wrench, /obj/item/weapon/tank/emergency_oxygen, /obj/item/clothing/mask/gas,
		/obj/item/taperoll/engineering
	)
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)

//Chaplain
/obj/item/clothing/suit/nun
	name = "nun robe"
	desc = "Maximum piety in this star system."
	icon_state = "nun"
	item_state = "nun"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT

//Chef
/obj/item/clothing/suit/chef
	name = "chef's apron"
	desc = "An apron used by a high class chef."
	icon_state = "chef"
	item_state = "chef"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list (/obj/item/weapon/material/knife)

//Chef
/obj/item/clothing/suit/chef/classic
	name = "A classic chef's apron."
	desc = "A basic, dull, white chef's apron."
	icon_state = "apronchef"
	item_state = "apronchef"
	blood_overlay_type = "armor"
	body_parts_covered = 0

//Detective
/obj/item/clothing/suit/storage/insp_trench
	name = "Inspector's armored trenchcoat"
	desc = "Brown and armored trenchcoat, designed and created by Ironhammer Security. The coat is externally impact resistant - perfect for your next act of autodefenestration!"
	icon_state = "insp_coat"
	item_state = "insp_coat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(
		/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/lighting/toggleable/flashlight,
		/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,
		/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,
		/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/taperecorder
	)
	armor = list(melee = 50, bullet = 10, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/det_trench
	name = "brown trenchcoat"
	desc = "A rugged canvas trenchcoat, designed and created by TX Fabrication Corp. The coat is externally impact resistant - perfect for your next act of autodefenestration!"
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(
		/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/lighting/toggleable/flashlight,
		/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,
		/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,
		/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,
		/obj/item/device/taperecorder
	)
	armor = list(melee = 50, bullet = 10, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)

//Engineering
/obj/item/clothing/suit/storage/hazardvest
	name = "hazard vest"
	desc = "A high-visibility vest used in work zones."
	icon_state = "hazard"
	item_state = "hazard"
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/device/scanner/analyzer, /obj/item/device/lighting/toggleable/flashlight, /obj/item/weapon/tool/multitool,
		/obj/item/device/pipe_painter, /obj/item/device/radio, /obj/item/device/t_scanner,
		/obj/item/weapon/tool/crowbar, /obj/item/weapon/tool/screwdriver, /obj/item/weapon/tool/weldingtool,
		/obj/item/weapon/tool/wirecutters, /obj/item/weapon/tool/wrench, /obj/item/weapon/tank/emergency_oxygen,
		/obj/item/clothing/mask/gas, /obj/item/taperoll/engineering
	)
	body_parts_covered = UPPER_TORSO

//Roboticist
/obj/item/clothing/suit/storage/robotech_jacket
	name = "robotech jacket"
	desc = "Jacket for those who like to get dirty in a machine oil."
	icon_state = "robotech_jacket"
	item_state = "robotech_jacket"
	blood_overlay_type = "coat"
	allowed = list(
		/obj/item/device/scanner/analyzer, /obj/item/device/lighting/toggleable/flashlight, /obj/item/weapon/tool/multitool,
		/obj/item/device/pipe_painter, /obj/item/device/radio, /obj/item/device/t_scanner,
		/obj/item/weapon/tool/crowbar, /obj/item/weapon/tool/screwdriver, /obj/item/weapon/tool/weldingtool,
		/obj/item/weapon/tool/wirecutters, /obj/item/weapon/tool/wrench, /obj/item/weapon/tank/emergency_oxygen,
		/obj/item/clothing/mask/gas, /obj/item/taperoll/engineering
	)
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/surgical_apron
	name = "surgical apron"
	desc = "Excelent blood collector."
	icon_state = "surgeon"
	item_state = "surgeon"
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/weapon/tool/bonesetter,
		/obj/item/weapon/tool/cautery,
		/obj/item/weapon/tool/saw/circular,
		/obj/item/weapon/tool/hemostat,
		/obj/item/weapon/tool/retractor,
		/obj/item/weapon/tool/scalpel,
		/obj/item/weapon/tool/surgicaldrill,
		/obj/item/stack/medical/advanced/bruise_pack
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO