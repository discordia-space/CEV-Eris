/datum/job/medical
	department = "Medical"
	department_flag = MEDSCI
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#ffeef0"

	ear = /obj/item/device/radio/headset/headset_med

	backpacks = list(
		/obj/item/weapon/storage/backpack/medic,
		/obj/item/weapon/storage/backpack/satchel_norm,
		/obj/item/weapon/storage/backpack/satchel
		)


/datum/job/medical/cmo
	title = JOB_MBO
	flag = MBO
	head_position = 1
	supervisors = "the Moebius Expedition Overseer"
	selection_color = "#ffddf0"
	idtype = /obj/item/weapon/card/id/cmo
	req_admin_notify = 1
	economic_modifier = 10
	access = list(
		access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
		access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
		access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks
	)

	ideal_character_age = 50

	uniform = /obj/item/clothing/under/rank/moebius_biolab_officer
	shoes = /obj/item/clothing/shoes/laceup
	pda = /obj/item/device/pda/heads/cmo
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	ear = /obj/item/device/radio/headset/heads/cmo
	hand = /obj/item/weapon/storage/firstaid/adv
	suit_store = /obj/item/device/lighting/toggleable/flashlight/pen


/datum/job/medical/doctor
	title = JOB_DOCTOR
	flag = DOCTOR
	total_positions = 5
	spawn_positions = 3
	economic_modifier = 7
	access = list(
		access_medical, access_medical_equip, access_morgue, access_surgery, access_virology,
		access_chemistry, access_genetics
	)
	idtype = /obj/item/weapon/card/id/med

	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	pda = /obj/item/device/pda/medical
	hand = /obj/item/weapon/storage/firstaid/adv


/datum/job/medical/chemist
	title = JOB_CHEMIST
	flag = CHEMIST
	total_positions = 2
	spawn_positions = 2
	economic_modifier = 5
	access = list(
		access_medical, access_medical_equip, access_chemistry, access_morgue, access_surgery,
		access_virology, access_genetics
	)
	idtype = /obj/item/weapon/card/id/chem

	uniform = /obj/item/clothing/under/rank/chemist
	shoes = /obj/item/clothing/shoes/laceup
	pda = /obj/item/device/pda/chemist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/chemist

	backpacks = list(
		/obj/item/weapon/storage/backpack,
		/obj/item/weapon/storage/backpack/satchel_norm,
		/obj/item/weapon/storage/backpack/satchel
	)


/datum/job/medical/psychiatrist
	title = JOB_PSYCH
	flag = PSYCHIATRIST
	economic_modifier = 5
	access = list(
		access_medical, access_medical_equip, access_psychiatrist, access_morgue, access_surgery,
		access_chemistry, access_virology, access_genetics
	)

	uniform = /obj/item/clothing/under/rank/psych
	pda = /obj/item/device/pda/medical
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/storage/toggle/labcoat

	backpacks = list(
		/obj/item/weapon/storage/backpack,
		/obj/item/weapon/storage/backpack/satchel_norm,
		/obj/item/weapon/storage/backpack/satchel
	)


/datum/job/medical/paramedic
	title = JOB_PARAMEDIC
	flag = PARAMEDIC
	total_positions = 2
	spawn_positions = 2
	economic_modifier = 4
	access = list(
		access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels,
		access_external_airlocks, access_psychiatrist, access_surgery, access_chemistry, access_virology
	)

	pda = /obj/item/device/pda/medical
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/weapon/storage/belt/medical/emt
	hand = /obj/item/weapon/storage/firstaid/adv