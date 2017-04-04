/datum/job/cmo
	title = "Chief Medical Officer"
	flag = CMO
	head_position = 1
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddf0"
	idtype = /obj/item/weapon/card/id/cmo
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks)

	minimal_player_age = 10
	ideal_character_age = 50

	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	shoes = /obj/item/clothing/shoes/laceup
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
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)
		return 1

/datum/job/doctor
	title = "Medical Doctor"
	flag = DOCTOR
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	economic_modifier = 7
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_virology)
	alt_titles = list("Surgeon","Emergency Physician","Virologist")
	idtype = /obj/item/weapon/card/id/med

	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	pda = /obj/item/device/pda/medical
	ear = /obj/item/device/radio/headset/headset_med
	hand = /obj/item/weapon/storage/firstaid/adv

	backpacks = list(
		/obj/item/weapon/storage/backpack/medic,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		if (H.mind && H.mind.role_alt_title)
			switch(H.mind.role_alt_title)
				if("Emergency Physician")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), slot_w_uniform)
				if("Surgeon")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
					H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/blue(H), slot_head)
				if("Virologist")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/virologist(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(H), slot_wear_suit)
					H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), slot_wear_mask)
					switch(H.backbag)
						if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
						if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
						if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
					job_master.spawnId(H, H.mind.assigned_role, H.mind.role_alt_title, /obj/item/weapon/card/id/viro)
		return ..()



//Chemist is a medical job damnit	//YEAH FUCK YOU SCIENCE	-Pete	//Guys, behave -Erro
/datum/job/chemist
	title = "Chemist"
	flag = CHEMIST
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	economic_modifier = 5
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_chemistry)
	alt_titles = list("Pharmacist")
	idtype = /obj/item/weapon/card/id/chem


	uniform = /obj/item/clothing/under/rank/chemist
	shoes = /obj/item/clothing/shoes/laceup
	pda = /obj/item/device/pda/chemist
	ear = /obj/item/device/radio/headset/headset_med
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/chemist

	backpacks = list(
		/obj/item/weapon/storage/backpack,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)



/datum/job/geneticist
	title = "Geneticist"
	flag = GENETICIST
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "the chief medical officer and research director"
	selection_color = "#ffeef0"
	economic_modifier = 7
	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_research)
	minimal_access = list(access_medical, access_morgue, access_genetics, access_research)
	idtype = /obj/item/weapon/card/id/gene

	uniform = /obj/item/clothing/under/rank/geneticist
	pda = /obj/item/device/pda/geneticist
	ear = /obj/item/device/radio/headset/headset_medsci
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/genetics
	shoes = /obj/item/clothing/shoes/laceup

	backpacks = list(
		/obj/item/weapon/storage/backpack,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)


	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)
		return 1

/datum/job/psychiatrist
	title = "Psychiatrist"
	flag = PSYCHIATRIST
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	economic_modifier = 5
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_psychiatrist)
	alt_titles = list("Psychologist")

	uniform = /obj/item/clothing/under/rank/psych/turtleneck
	pda = /obj/item/device/pda/medical
	ear = /obj/item/device/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/storage/toggle/labcoat

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		return ..()

/datum/job/virologist
	title = "Virologist"
	flag = VIROLOGIST
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "the research director"
	selection_color = "#ffeef0"
	idtype = /obj/item/weapon/card/id/viro
	economic_modifier = 5
	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_virology)

	uniform = /obj/item/clothing/under/rank/virologist
	pda = /obj/item/device/pda/viro
	ear = /obj/item/device/radio/headset/headset_med
	mask = /obj/item/clothing/mask/surgical
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/virologist

	backpacks = list(
		/obj/item/weapon/storage/backpack/medic,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)

	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)


/datum/job/Paramedic
	title = "Paramedic"
	flag = PARAMEDIC
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	economic_modifier = 4
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks)

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
