/decl/hierarchy/outfit/job/medical
	hierarchy_type = /decl/hierarchy/outfit/job/medical
	l_ear = /obj/item/device/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/reinforced
	id_type = /obj/item/weapon/card/id/med
	pda_type = /obj/item/modular_computer/pda/moebius/medical
	pda_slot = slot_l_store

/decl/hierarchy/outfit/job/medical/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL

/decl/hierarchy/outfit/job/medical/cmo
	name = OUTFIT_JOB_NAME("Moebius Biolab Officer")
	l_ear  =/obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/rank/moebius_biolab_officer
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	l_hand = /obj/item/weapon/storage/firstaid/adv
	r_pocket = /obj/item/device/lighting/toggleable/flashlight/pen
	id_type = /obj/item/weapon/card/id/cmo
	pda_type = /obj/item/modular_computer/pda/heads/cmo

/decl/hierarchy/outfit/job/medical/doctor
	name = OUTFIT_JOB_NAME("Moebius Doctor")
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_hand = /obj/item/weapon/storage/firstaid/adv
	r_pocket = /obj/item/device/lighting/toggleable/flashlight/pen

/decl/hierarchy/outfit/job/medical/chemist
	name = OUTFIT_JOB_NAME("Moebius Chemist")
	uniform = /obj/item/clothing/under/rank/chemist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/chemist
	id_type = /obj/item/weapon/card/id/chem
	pda_type = /obj/item/modular_computer/pda/moebius/chemistry

/decl/hierarchy/outfit/job/medical/chemist/New()
	..()
	backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/weapon/storage/backpack/orange/chemist;
	backpack_overrides[/decl/backpack_outfit/backsport]     = /obj/item/weapon/storage/backpack/sport/orange;
	backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/weapon/storage/backpack/satchel/orange/chemist;

/decl/hierarchy/outfit/job/medical/psychiatrist
	name = OUTFIT_JOB_NAME("Moebius Psychiatrist")
	uniform = /obj/item/clothing/under/rank/psych
	suit = /obj/item/clothing/suit/storage/toggle/labcoat

/decl/hierarchy/outfit/job/medical/paramedic
	name = OUTFIT_JOB_NAME("Moebius Paramedic")
	uniform = /obj/item/clothing/under/rank/medical/green
	shoes = /obj/item/clothing/shoes/jackboots
	l_hand = /obj/item/weapon/storage/firstaid/adv
	belt = /obj/item/weapon/storage/belt/medical/emt
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
