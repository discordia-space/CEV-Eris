/decl/hierarchy/outfit/job/security
	hierarchy_type = /decl/hierarchy/outfit/job/security
	l_ear = /obj/item/device/radio/headset/headset_sec
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/jackboots
	id_type = /obj/item/weapon/card/id/sec
	pda_type = /obj/item/modular_computer/pda/security
	backpack_contents = list(/obj/item/weapon/handcuffs = 1)

/decl/hierarchy/outfit/job/security/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/security/ihc
	name = OUTFIT_JOB_NAME("Ironhammer Commander")
	l_ear = /obj/item/device/radio/headset/heads/hos
	uniform = /obj/item/clothing/under/rank/ih_commander
	suit = /obj/item/clothing/suit/armor/hos
	l_pocket = /obj/item/device/flash
	gloves = /obj/item/clothing/gloves/stungloves
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical
	belt = /obj/item/weapon/gun/projectile/lamia
	id_type = /obj/item/weapon/card/id/hos
	head = /obj/item/clothing/head/HoS
	pda_type = /obj/item/modular_computer/pda/heads/hos
	backpack_contents = list(/obj/item/weapon/handcuffs = 1,/obj/item/ammo_magazine/cl44/rubber = 1,/obj/item/device/lighting/toggleable/flashlight/seclite = 1, /obj/item/weapon/cell/small/high = 2, /obj/item/weapon/gun/energy/gun/martin = 1)

/decl/hierarchy/outfit/job/security/gunserg
	name = OUTFIT_JOB_NAME("Ironhammer Gunnery Sergeant")
	uniform = /obj/item/clothing/under/rank/warden
	suit = /obj/item/clothing/suit/armor/vest/security
	head = /obj/item/clothing/head/beret/sec/navy/warden
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical
	l_pocket = /obj/item/device/flash
	gloves = /obj/item/clothing/gloves/stungloves
	backpack_contents = list(/obj/item/weapon/handcuffs = 1, /obj/item/device/lighting/toggleable/flashlight/seclite = 1, /obj/item/weapon/cell/small/high = 2, /obj/item/weapon/gun/energy/gun/martin = 1)

/decl/hierarchy/outfit/job/security/inspector
	name = OUTFIT_JOB_NAME("Ironhammer Inspector")
	head = /obj/item/clothing/head/det
	uniform = /obj/item/clothing/under/rank/inspector
	suit = /obj/item/clothing/suit/storage/insp_trench
	head = /obj/item/clothing/head/det
	gloves = /obj/item/clothing/gloves/stungloves
	l_pocket = /obj/item/device/flash
	shoes = /obj/item/clothing/shoes/reinforced
	belt = /obj/item/weapon/gun/energy/gun/martin
	r_hand = /obj/item/weapon/storage/briefcase/crimekit
	id_type = /obj/item/weapon/card/id/det
	pda_type = /obj/item/modular_computer/pda/forensics
	backpack_contents = list(/obj/item/weapon/handcuffs = 1, /obj/item/ammo_magazine/sl44/rubber = 2, /obj/item/device/lighting/toggleable/flashlight/seclite = 1, /obj/item/weapon/cell/small/high = 2)

/decl/hierarchy/outfit/job/security/detective/New()
	..()
	backpack_overrides.Cut()

/decl/hierarchy/outfit/job/security/medspec
	name = OUTFIT_JOB_NAME("Ironhammer Medical Specialist")
	l_pocket = /obj/item/device/flash
	id_type = /obj/item/weapon/card/id/medcpec
	uniform = /obj/item/clothing/under/rank/medspec
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/medspec
	pda_type = /obj/item/modular_computer/pda/forensics
	belt = /obj/item/weapon/storage/belt/medical
	l_hand = /obj/item/weapon/storage/briefcase/crimekit
	backpack_contents = list(/obj/item/weapon/gun/energy/gun/martin = 1, /obj/item/weapon/cell/small/high = 1)

/decl/hierarchy/outfit/job/security/ihoper
	name = OUTFIT_JOB_NAME("Ironhammer Operative")
	l_pocket = /obj/item/device/flash
	uniform = /obj/item/clothing/under/rank/security
	suit = /obj/item/clothing/suit/armor/vest/security
	mask = /obj/item/clothing/mask/balaclava/tactical
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical
	head = /obj/item/clothing/head/helmet
	gloves = /obj/item/clothing/gloves/stungloves
	backpack_contents = list(/obj/item/weapon/handcuffs = 1, /obj/item/device/lighting/toggleable/flashlight/seclite = 1, /obj/item/weapon/cell/small/high = 2, /obj/item/weapon/gun/energy/gun/martin = 1)
