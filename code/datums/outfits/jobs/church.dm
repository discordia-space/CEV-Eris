/decl/hierarchy/outfit/job/chaplain
	name = OUTFIT_JOB_NAME("Neotheology Preacher")
	id_type = /obj/item/weapon/card/id/chaplain
	uniform = /obj/item/clothing/under/rank/chaplain
	suit = /obj/item/clothing/suit/chaplain_hoodie
	shoes = /obj/item/clothing/shoes/reinforced
	gloves = /obj/item/clothing/gloves/thick
	id_type = /obj/item/weapon/card/id/chaplain
	pda_type = /obj/item/modular_computer/pda/medical
	backpack_contents = list(/obj/item/weapon/book/ritual/cruciform/priest = 1)

/decl/hierarchy/outfit/job/chaplain/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/weapon/implant/core_implant/cruciform/C = new /obj/item/weapon/implant/core_implant/cruciform(H)
	C.install(H)
	C.activate()
	C.add_module(new CRUCIFORM_PRIEST)
	C.add_module(new CRUCIFORM_REDLIGHT)
	H.religion = "Christianity"