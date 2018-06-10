/datum/job/cmo
	title = "Moebius Biolab Officer"
	flag = MBO
	head_position = 1
	department = "Medical"
	department_flag = MEDSCI
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Moebius Expedition Overseer"
	selection_color = "#ffddf0"
	idtype = /obj/item/weapon/card/id/cmo
	req_admin_notify = 1
	economic_modifier = 10
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)
	access = list(
		access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
		access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
		access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks
	)

	ideal_character_age = 50

	stat_modifers = list(
		STAT_BIO = 30,
	)

	uniform = /obj/item/clothing/under/rank/moebius_biolab_officer
	shoes = /obj/item/clothing/shoes/reinforced
	pda = /obj/item/device/pda/heads/cmo
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	ear = /obj/item/device/radio/headset/heads/cmo
	hand = /obj/item/weapon/storage/firstaid/adv

	backpacks = list(
		/obj/item/weapon/storage/backpack/medic,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)

	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0
		H.equip_to_slot_or_del(new /obj/item/device/lighting/toggleable/flashlight/pen(H), slot_s_store)
		return 1

/obj/landmark/join/start/cmo
	name = "Moebius Biolab Officer"
	icon_state = "player-green-officer"
	join_tag = /datum/job/cmo


/datum/job/doctor
	title = "Moebius Doctor"
	flag = DOCTOR
	department = "Medical"
	department_flag = MEDSCI
	faction = "CEV Eris"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#ffeef0"
	economic_modifier = 7
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)
	access = list(
		access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology,
		access_genetics
	)
	idtype = /obj/item/weapon/card/id/med

	stat_modifers = list(
		STAT_BIO = 20,
	)

	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/reinforced
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	pda = /obj/item/device/pda/medical
	ear = /obj/item/device/radio/headset/headset_med
	hand = /obj/item/weapon/storage/firstaid/adv

	backpacks = list(
		/obj/item/weapon/storage/backpack/medic,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)

/obj/landmark/join/start/doctor
	name = "Moebius Doctor"
	icon_state = "player-green"
	join_tag = /datum/job/doctor



/datum/job/chemist
	title = "Moebius Chemist"
	flag = CHEMIST
	department = "Medical"
	department_flag = MEDSCI
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#ffeef0"
	economic_modifier = 5
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)
	access = list(
		access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology,
		access_genetics
	)
	idtype = /obj/item/weapon/card/id/chem

	stat_modifers = list(
		STAT_COG = 10,
		STAT_BIO = 20,
	)

	uniform = /obj/item/clothing/under/rank/chemist
	shoes = /obj/item/clothing/shoes/reinforced
	pda = /obj/item/device/pda/chemist
	ear = /obj/item/device/radio/headset/headset_med
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/chemist

	backpacks = list(
		/obj/item/weapon/storage/backpack,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)

/obj/landmark/join/start/chemist
	name = "Moebius Chemist"
	icon_state = "player-green"
	join_tag = /datum/job/chemist


/datum/job/psychiatrist
	title = "Moebius Psychiatrist"
	flag = PSYCHIATRIST
	department = "Medical"
	department_flag = MEDSCI
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	economic_modifier = 5
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#ffeef0"
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)
	access = list(
		access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology,
		access_genetics, access_psychiatrist
	)

	stat_modifers = list(
		STAT_BIO = 10,
	)

	uniform = /obj/item/clothing/under/rank/psych
	pda = /obj/item/device/pda/medical
	ear = /obj/item/device/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/reinforced
	suit = /obj/item/clothing/suit/storage/toggle/labcoat

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		return ..()

/obj/landmark/join/start/psychiatrist
	name = "Moebius Psychiatrist"
	icon_state = "player-green"
	join_tag = /datum/job/psychiatrist


/datum/job/paramedic
	title = "Moebius Paramedic"
	flag = PARAMEDIC
	department = "Medical"
	department_flag = MEDSCI
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#ffeef0"
	economic_modifier = 4
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)
	access = list(
		access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology,
		access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist
	)

	stat_modifers = list(
		STAT_BIO = 10,
		STAT_PHY = 10,
		STAT_ROB = 10,
	)

	pda = /obj/item/device/pda/medical
	ear = /obj/item/device/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/weapon/storage/belt/medical/emt
	hand = /obj/item/weapon/storage/firstaid/adv

	backpacks = list(
		/obj/item/weapon/storage/backpack/medic,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)

/obj/landmark/join/start/paramedic
	name = "Moebius Paramedic"
	icon_state = "player-green"
	join_tag = /datum/job/paramedic

