/decl/hierarchy/outfit/job/cargo
	l_ear = /obj/item/device/radio/headset/headset_cargo
	hierarchy_type = /decl/hierarchy/outfit/job/cargo

/decl/hierarchy/outfit/job/cargo/merchant
	name = OUTFIT_JOB_NAME("Guild Merchant")
	uniform = /obj/item/clothing/under/rank/cargotech
	shoes = /obj/item/clothing/shoes/color/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	suit = /obj/item/clothing/suit/storage/qm_coat
	l_hand = /obj/item/weapon/clipboard
	id_type = /obj/item/weapon/card/id/car
	pda_type = /obj/item/modular_computer/pda/cargo
	l_ear = /obj/item/device/radio/headset/heads/merchant

/decl/hierarchy/outfit/job/cargo/cargo_tech
	name = OUTFIT_JOB_NAME("Guild Technician")
	uniform = /obj/item/clothing/under/rank/cargotech
	suit = /obj/item/clothing/suit/storage/cargo_jacket
	belt = /obj/item/weapon/storage/belt/utility
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/job/cargo/mining
	name = OUTFIT_JOB_NAME("Guild Miner")
	uniform = /obj/item/clothing/under/rank/miner
	pda_type = /obj/item/modular_computer/pda/moebius/science
	belt = /obj/item/weapon/storage/belt/utility
	backpack_contents = list(/obj/item/weapon/tool/crowbar = 1, /obj/item/weapon/storage/bag/ore = 1)
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/cargo/mining/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/cargo/mining/void
	name = OUTFIT_JOB_NAME("Guild Miner - Voidsuit")
	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/void/mining
