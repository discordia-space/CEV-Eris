/datum/job/ihc
	title = "Ironhammer Commander"
	flag = IHC
	head_position = 1
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffdddd"
	idtype = /obj/item/weapon/card/id/hos
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_player_age = 14

	implanted = 1
	uniform = /obj/item/clothing/under/rank/ih_commander
	suit = /obj/item/clothing/suit/armor/hos
	hat = /obj/item/clothing/head/beret/sec/navy/hos
	pda = /obj/item/device/pda/heads/hos
	ear = /obj/item/device/radio/headset/heads/hos
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/thick
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	belt = /obj/item/weapon/gun/projectile/lamia
	put_in_backpack = list(\
		/obj/item/ammo_magazine/mg/cl44/rubber,\
		/obj/item/ammo_magazine/mg/cl44/rubber,\
		/obj/item/weapon/handcuffs,\
		/obj/item/device/flashlight/seclite
	)

	backpacks = list(
		/obj/item/weapon/storage/backpack/security,\
		/obj/item/weapon/storage/backpack/satchel_sec,\
		/obj/item/weapon/storage/backpack/satchel
	)


/datum/job/gunserg
	title = "Gunnery Sergeant"
	flag = GUNSERG
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Ironhammer Commander"
	selection_color = "#ffeeee"
	economic_modifier = 5
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 5
	idtype = /obj/item/weapon/card/id/sec

	implanted = 1
	uniform = /obj/item/clothing/under/rank/warden
	suit = /obj/item/clothing/suit/armor/vest/serg
	hat = /obj/item/clothing/head/beret/sec/navy/warden
	pda = /obj/item/device/pda/warden
	ear = /obj/item/device/radio/headset/headset_sec
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/thick
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	belt = /obj/item/weapon/gun/projectile/automatic/SMG_sol
	put_in_backpack = list(\
		/obj/item/ammo_magazine/SMG_sol/rubber,\
		/obj/item/ammo_magazine/SMG_sol/rubber,\
		/obj/item/device/flash,\
		/obj/item/weapon/handcuffs,\
		/obj/item/device/flashlight/seclite
	)

	backpacks = list(
		/obj/item/weapon/storage/backpack/security,\
		/obj/item/weapon/storage/backpack/satchel_sec,\
		/obj/item/weapon/storage/backpack/satchel
	)


/datum/job/inspector
	title = "Inspector"
	flag = INSPECTOR
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Ironhammer Commander"
	selection_color = "#ffeeee"
	economic_modifier = 5
	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels)
	minimal_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels)
	minimal_player_age = 3
	idtype = /obj/item/weapon/card/id/det

	implanted = 1
	uniform = /obj/item/clothing/under/inspector
	pda = /obj/item/device/pda/detective
	ear = /obj/item/device/radio/headset/headset_sec
	shoes = /obj/item/clothing/shoes/inspector
	gloves = /obj/item/clothing/gloves/thick
	hat = /obj/item/clothing/head/det
	suit = /obj/item/clothing/suit/storage/insp_trench
	hand = /obj/item/weapon/storage/briefcase/crimekit
	belt = /obj/item/weapon/gun/projectile/revolver/consul

	put_in_backpack = list(\
		/obj/item/ammo_magazine/sl/cl44/rubber,\
		/obj/item/ammo_magazine/sl/cl44/rubber,\
		/obj/item/weapon/flame/lighter/zippo,\
		/obj/item/weapon/storage/box/evidence,\
	)


/datum/job/medspec
	title = "Medical Specialist"
	flag = MEDSPEC
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Ironhammer Commander"
	selection_color = "#ffeeee"
	economic_modifier = 5
	access = list(access_security, access_sec_doors, access_medspec, access_morgue, access_maint_tunnels)
	minimal_access = list(access_security, access_sec_doors, access_medspec, access_morgue, access_maint_tunnels)
	minimal_player_age = 3
	idtype = /obj/item/weapon/card/id/medcpec

	implanted = 1
	uniform = /obj/item/clothing/under/rank/medspec
	pda = /obj/item/device/pda/detective
	ear = /obj/item/device/radio/headset/headset_sec
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/thick
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/medspec
	hand = /obj/item/weapon/storage/briefcase/crimekit
	belt = /obj/item/weapon/gun/energy/gun/martin

	put_in_backpack = list(\
		/obj/item/weapon/storage/box/evidence,\
	)


/datum/job/ihoper
	title = "Ironhammer Operative"
	flag = IHOPER
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Ironhammer Commander"
	selection_color = "#ffeeee"
	economic_modifier = 4
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 3
	idtype = /obj/item/weapon/card/id/sec

	uniform = /obj/item/clothing/under/rank/security
	suit = /obj/item/clothing/suit/armor/vest/security
	hat = /obj/item/clothing/head/beret/sec/navy/officer
	pda = /obj/item/device/pda/security
	ear = /obj/item/device/radio/headset/headset_sec
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/thick
	belt = /obj/item/weapon/gun/projectile/automatic/SMG_sol

	put_in_backpack = list(\
		/obj/item/weapon/handcuffs,\
		/obj/item/weapon/handcuffs,\
		/obj/item/ammo_magazine/SMG_sol/rubber,\
		/obj/item/ammo_magazine/SMG_sol/rubber,\
		/obj/item/device/flash,\
		/obj/item/device/flashlight/seclite
	)

	backpacks = list(
		/obj/item/weapon/storage/backpack/security,\
		/obj/item/weapon/storage/backpack/satchel_sec,\
		/obj/item/weapon/storage/backpack/satchel
	)
