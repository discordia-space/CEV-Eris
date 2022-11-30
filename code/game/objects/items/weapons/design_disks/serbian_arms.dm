
/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_pug
	disk_name = "Serbian Arms - .50 Pug Auto Shotgun"
	icon_state = "serbian"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/bojevic = 3, // "SA SG \"Bojevic\""
		/datum/design/autolathe/ammo/m12beanbag, // Never add tazershells, for love of god
		/datum/design/autolathe/ammo/m12pellet,
		/datum/design/autolathe/ammo/m12slug,
		)

/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_zoric
	disk_name = "Serbian Arms - .40 Zoric SMG"
	icon_state = "serbian"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/zoric = 3, // "SA SMG .40 \"Zoric\""
		/datum/design/autolathe/ammo/msmg,
		/datum/design/autolathe/ammo/msmg/practice = 0,
		/datum/design/autolathe/ammo/msmg/rubber,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_boltgun
	disk_name = "Serbian Arms - .30  Novakovic Rifle"
	icon_state = "serbian"
	rarity_value = 7
	license = 12
	designs = list(
		/datum/design/autolathe/gun/boltgun_serbian = 3, // "SA BR .30 \"Novakovic\""
		/datum/design/autolathe/ammo/sl_lrifle,
		/datum/design/autolathe/ammo/lrifle_ammobox_small,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_heavysniper
	disk_name = "Serbian Arms - .60 Hristov AMR"
	icon_state = "serbian"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/heavysniper = 3, // "SA AMR .60 \"Hristov\""
		/datum/design/autolathe/ammo/antim,
		/datum/design/autolathe/ammo/box_antim,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_pk
	disk_name = "Serbian Arms - .30 Pulemyot Kalashnikova MG"
	icon_state = "serbian"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/mg_pk = 3, // "SA MG .30 \"Pulemyot Kalashnikova\""
		/datum/design/autolathe/ammo/lrifle_pk,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_ak
	disk_name = "Serbian Arms - .30 Krinkov Car"
	icon_state = "serbian"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 50
	license = 12
	designs = list(
		/datum/design/autolathe/gun/ak47_sa = 3, // "SA Car .30 \"Krinkov\""
		/datum/design/autolathe/ammo/lrifle,
	)

/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_br
	disk_name = "Serbian Arms - .30 Kovacs"
	icon_state = "serbian"
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED
	rarity_value = 80
	license = 12
	designs = list(
		/datum/design/autolathe/gun/kovacs = 3, // "SA BR .30 \"Kovacs\""
		/datum/design/autolathe/ammo/lrifle
	)
