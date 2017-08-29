//Due to how large this one is it gets its own file
/datum/job/civilian/chaplain
	title = JOB_PREACHER
	flag = CHAPLAIN
	supervisors = "the NeoTheology Church and God"
	access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels)

	idtype = /obj/item/weapon/card/id/chaplain
	uniform = /obj/item/clothing/under/rank/chaplain
	pda = /obj/item/device/pda/chaplain
	ear = /obj/item/device/radio/headset

/datum/job/civilian/chaplain/equip(var/mob/living/carbon/human/H)
	var/obj/item/weapon/implant/external/core_implant/cruciform/C = new (H)
	C.install(H)
	C.activate()
	C.add_module(new CRUCIFORM_PRIEST)

	H.religion = "Christianity"

	if(!..())	return FALSE

	var/obj/item/weapon/book/ritual/cruciform/B = new /obj/item/weapon/book/ritual/cruciform(H)
	H.equip_to_slot_or_del(B, slot_l_hand)
	return TRUE
