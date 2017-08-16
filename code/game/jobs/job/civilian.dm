/datum/job/civilian

	department = "Civilian"
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"

	ear = /obj/item/device/radio/headset/headset_service


//Food
/datum/job/civilian/bartender
	title = JOB_BARTENDER
	flag = BARTENDER
	minimal_access = list(access_bar)
	additional_access = list(access_hydroponics, access_kitchen)
	uniform = /obj/item/clothing/under/rank/bartender
	pda = /obj/item/device/pda/bar

/datum/job/civilian/bartender/equip(var/mob/living/carbon/human/H)
	if(!..())	return 0
	var/obj/item/weapon/storage/box/survival/Barpack = null
	if(H.back)
		Barpack = locate() in H.back
		if(!Barpack)
			Barpack = new(H)
			H.equip_to_slot_or_del(Barpack, slot_in_backpack)

	else //TODO: check both hands
		if(!H.r_hand)
			Barpack = new /obj/item/weapon/storage/box/survival(H)
			H.equip_to_slot_or_del(Barpack, slot_r_hand)
		else if(istype(H.r_hand, /obj/item/weapon/storage/box))
			Barpack = H.r_hand

	if(Barpack)
		new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
		new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
		new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
		new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
	return 1



/datum/job/civilian/chef
	title = JOB_CHEF
	flag = CHEF
	total_positions = 2
	spawn_positions = 2
	minimal_access = list(access_kitchen)
	additional_access = list(access_hydroponics, access_bar)
	idtype = /obj/item/weapon/card/id/ltgrey

	uniform = /obj/item/clothing/under/rank/chef
	shoes = /obj/item/clothing/shoes/black
	pda = /obj/item/device/pda/chef
	hat = /obj/item/clothing/head/chefhat
	suit = /obj/item/clothing/suit/chef



/datum/job/civilian/hydro
	title = JOB_GARDENER
	flag = BOTANIST
	total_positions = 2
	minimal_access = list(access_hydroponics)
	additional_access = list(access_bar, access_kitchen)
	idtype = /obj/item/weapon/card/id/hydro

	uniform = /obj/item/clothing/under/rank/hydroponics
	pda = /obj/item/device/pda/botanist
	suit = /obj/item/clothing/suit/apron
	gloves = /obj/item/clothing/gloves/botanic_leather
	put_in_backpack = list(
		/obj/item/device/analyzer/plant_analyzer
	)


/datum/job/civilian/actor
	title = JOB_ACTOR
	flag = ACTOR
	total_positions = 2
	spawn_positions = 2
	minimal_access = list(access_maint_tunnels, access_theatre)

	uniform = /obj/item/clothing/under/rank/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	pda = /obj/item/device/pda/clown
	mask = /obj/item/clothing/mask/gas/clown_hat

	put_in_backpack = list(
		/obj/item/weapon/bananapeel,
		/obj/item/weapon/bikehorn,
	)

	backpacks = list(
		/obj/item/weapon/storage/backpack/clown,
		/obj/item/weapon/storage/backpack/satchel_norm,
		/obj/item/weapon/storage/backpack/satchel
	)

	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0
		H.mutations.Add(CLUMSY)
		return 1



/datum/job/civilian/janitor
	title = JOB_JANITOR
	flag = JANITOR
	minimal_access = list(access_janitor, access_maint_tunnels)

	uniform = /obj/item/clothing/under/rank/janitor
	pda = /obj/item/device/pda/janitor
