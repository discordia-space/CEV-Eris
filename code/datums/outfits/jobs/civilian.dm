/decl/hierarchy/outfit/job/assistant
	name = OUTFIT_JOB_NAME(ASSISTANT_TITLE)
	suit = /obj/item/clothing/suit/storage/ass_jacket
	uniform = /obj/item/clothing/under/rank/assistant
	r_pocket = /obj/item/weapon/spacecash/bundle/vagabond

/decl/hierarchy/outfit/job/service
	l_ear = /obj/item/device/radio/headset/headset_service
	hierarchy_type = /decl/hierarchy/outfit/job/service

/decl/hierarchy/outfit/job/service/bartender
	name = OUTFIT_JOB_NAME("Bartender")
	uniform = /obj/item/clothing/under/rank/bartender
	head = /obj/item/clothing/head/that
	id_type = /obj/item/weapon/card/id/white
	pda_type = /obj/item/modular_computer/pda/club_worker
	backpack_contents = list(/obj/item/ammo_casing/shotgun/beanbag = 4)


/decl/hierarchy/outfit/job/service/waiter
	name = OUTFIT_JOB_NAME("Waiter")
	uniform = /obj/item/clothing/under/waiter
	id_type = /obj/item/weapon/card/id/white
	pda_type = /obj/item/modular_computer/pda/club_worker

/decl/hierarchy/outfit/job/service/chef
	name = OUTFIT_JOB_NAME("Chef")
	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	id_type = /obj/item/weapon/card/id/ltgrey
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/service/actor/clown
	name = OUTFIT_JOB_NAME("Clown")
	uniform = /obj/item/clothing/under/rank/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	l_pocket = /obj/item/weapon/bikehorn
	backpack_contents = list(/obj/item/weapon/bananapeel = 1, /obj/item/weapon/storage/fancy/crayons = 1, /obj/item/toy/waterflower = 1, /obj/item/weapon/stamp/clown = 1, /obj/item/weapon/handcuffs/fake = 1)

/decl/hierarchy/outfit/job/service/actor/clown/New()
	..()
	backpack_overrides[/decl/backpack_outfit/backpack] = /obj/item/weapon/storage/backpack/clown
	backpack_overrides[/decl/backpack_outfit/satchel] = /obj/item/weapon/storage/backpack/satchel/leather


/decl/hierarchy/outfit/job/service/actor/clown/post_equip(var/mob/living/carbon/human/H)
	..()
	H.mutations.Add(CLUMSY)