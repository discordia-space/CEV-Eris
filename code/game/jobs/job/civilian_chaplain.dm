//Due to how large this one is it gets its own file
/datum/job/chaplain
	title = "Monochurch Preacher"
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

	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0

		var/obj/item/weapon/storage/bible/B = new /obj/item/weapon/storage/bible(H) //BS12 EDIT
		H.equip_to_slot_or_del(B, slot_l_hand)
		return 1
