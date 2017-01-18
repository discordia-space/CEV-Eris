//Food
/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_bar)
	uniform = /obj/item/clothing/under/rank/bartender
	pda = /obj/item/device/pda/bar
	ear = /obj/item/device/radio/headset/headset_service

	equip(var/mob/living/carbon/human/H)
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



/datum/job/chef
	title = "Chef"
	flag = CHEF
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_kitchen)
	alt_titles = list("Cook")
	idtype = /obj/item/weapon/card/id/ltgrey

	uniform = /obj/item/clothing/under/rank/chef
	shoes = /obj/item/clothing/shoes/black
	pda = /obj/item/device/pda/chef
	hat = /obj/item/clothing/head/chefhat
	suit = /obj/item/clothing/suit/chef
	ear = /obj/item/device/radio/headset/headset_service



/datum/job/hydro
	title = "Gardener"
	flag = BOTANIST
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics)
	alt_titles = list("Hydroponicist")
	idtype = /obj/item/weapon/card/id/hydro

	uniform = /obj/item/clothing/under/rank/hydroponics
	pda = /obj/item/device/pda/botanist
	suit = /obj/item/clothing/suit/apron
	gloves = /obj/item/clothing/gloves/botanic_leather
	ear = /obj/item/device/radio/headset/headset_service

	backpacks = list(
		/obj/item/weapon/storage/backpack/,\
		///obj/item/weapon/storage/backpack/hydroponics,\
		/obj/item/weapon/storage/backpack/satchel_hyd,\
		/obj/item/weapon/storage/backpack/satchel
		)

	put_in_backpack = list(\
		/obj/item/device/analyzer/plant_analyzer
		)


//Cargo
/datum/job/qm
	title = "Quartermaster"
	flag = QUARTERMASTER
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	idtype = /obj/item/weapon/card/id/car
	ideal_character_age = 40


	uniform = /obj/item/clothing/under/rank/cargotech
	suit = /obj/item/clothing/suit/storage/qm_coat
	shoes = /obj/item/clothing/shoes/color/brown
	pda = /obj/item/device/pda/quartermaster
	gloves = /obj/item/clothing/gloves/thick
	ear = /obj/item/device/radio/headset/headset_cargo
	hand = /obj/item/weapon/clipboard
	glasses = /obj/item/clothing/glasses/sunglasses



/datum/job/cargo_tech
	title = "Cargo Technician"
	flag = CARGOTECH
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the quartermaster and the First Officer"
	selection_color = "#dddddd"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)
	idtype = /obj/item/weapon/card/id/car

	uniform = /obj/item/clothing/under/rank/cargotech
	suit = /obj/item/clothing/suit/storage/cargo_jacket
	pda = /obj/item/device/pda/cargo
	ear = /obj/item/device/radio/headset/headset_cargo



/datum/job/mining
	title = "Shaft Miner"
	flag = MINER
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster and the First Officer"
	selection_color = "#dddddd"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)
	alt_titles = list("Drill Technician","Prospector")
	idtype = /obj/item/weapon/card/id/car

	uniform = /obj/item/clothing/under/rank/miner
	pda = /obj/item/device/pda/shaftminer
	ear = /obj/item/device/radio/headset/headset_cargo
	survival_gear = /obj/item/weapon/storage/box/engineer

	put_in_backpack = list(\
		/obj/item/weapon/crowbar,\
		/obj/item/weapon/storage/bag/ore
		)



/datum/job/clown
	title = "Clown"
	flag = CLOWN
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels, access_theatre)

	uniform = /obj/item/clothing/under/rank/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	pda = /obj/item/device/pda/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	ear = /obj/item/device/radio/headset/headset_service

	put_in_backpack = list(\
		/obj/item/weapon/bananapeel,\
		/obj/item/weapon/bikehorn,\
		//obj/item/toy/crayon/rainbow,\
		/obj/item/weapon/storage/fancy/crayons,\
		/obj/item/toy/waterflower,\
		/obj/item/weapon/stamp/clown
		)

	backpacks = list(
		/obj/item/weapon/storage/backpack/clown,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)

	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0
		H.mutations.Add(CLUMSY)
		return 1


/datum/job/mime
	title = "Mime"
	flag = MIME
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels, access_theatre)

	uniform = /obj/item/clothing/under/mime
	pda = /obj/item/device/pda/mime
	hat = /obj/item/clothing/head/beret
	gloves = /obj/item/clothing/gloves/color/white
	mask = /obj/item/clothing/mask/gas/mime
	ear = /obj/item/device/radio/headset/headset_service

/*
	put_in_backpack = list(\
		/obj/item/toy/crayon/mime,\
		/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing
	)
*/

	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0
//		H.verbs += /client/proc/mimespeak
//		H.verbs += /client/proc/mimewall
//		H.mind.special_verbs += /client/proc/mimespeak
//		H.mind.special_verbs += /client/proc/mimewall
		H.miming = 1
		return 1


/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	access = list(access_janitor, access_maint_tunnels)
	minimal_access = list(access_janitor, access_maint_tunnels)

	uniform = /obj/item/clothing/under/rank/janitor
	pda = /obj/item/device/pda/janitor
	ear = /obj/item/device/radio/headset/headset_service



//More or less assistants
/datum/job/librarian
	title = "Librarian"
	flag = LIBRARIAN
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	access = list(access_library, access_maint_tunnels)
	minimal_access = list(access_library)
	alt_titles = list("Journalist")


	uniform = /obj/item/clothing/under/librarian
	pda = /obj/item/device/pda/librarian
	hand = /obj/item/weapon/barcodescanner



//var/global/lawyer = 0//Checks for another lawyer //This changed clothes on 2nd lawyer, both IA get the same dreds.
///datum/job/lawyer
//	title = "Lawyer"
//	flag = LAWYER
//	department = "Civilian"
//	department_flag = CIVILIAN
//	faction = "Station"
//	total_positions = 1
//	spawn_positions = 1
//	supervisors = "the captain"
//	selection_color = "#dddddd"
//	economic_modifier = 7
//	access = list(access_lawyer, access_sec_doors, access_maint_tunnels, access_heads)
//	minimal_access = list(access_lawyer, access_sec_doors, access_heads)
//
//	uniform = /obj/item/clothing/under/rank/internalaffairs
//	shoes = /obj/item/clothing/shoes/color/brown
//	pda = /obj/item/device/pda/lawyer
//	ear = /obj/item/device/radio/headset/headset_sec
//	hand = /obj/item/weapon/storage/briefcase
//	glasses = /obj/item/clothing/glasses/sunglasses/big

