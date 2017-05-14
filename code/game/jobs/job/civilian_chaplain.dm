//Due to how large this one is it gets its own file
/datum/job/chaplain
	title = "Cyberchristian priest"
	flag = CHAPLAIN
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Officer and God"
	selection_color = "#dddddd"
	access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels)
	minimal_access = list(access_morgue, access_chapel_office, access_crematorium)
	idtype = /obj/item/weapon/card/id/chaplain
	uniform = /obj/item/clothing/under/rank/chaplain
	pda = /obj/item/device/pda/chaplain

/datum/job/chaplain/equip(var/mob/living/carbon/human/H)
	var/obj/item/core_implant/cruciform/priest/C = new /obj/item/core_implant/cruciform/priest(H)
	C.install(H)
	C.enable()

	H.religion = "Christianity"

	if(!..())	return FALSE

	var/obj/item/weapon/book/bible/B = new /obj/item/weapon/book/bible(H)
	H.equip_to_slot_or_del(B, slot_l_hand)
	return TRUE
