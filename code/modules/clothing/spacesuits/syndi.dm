//Regular syndicate space suit
/obj/item/clothing/head/space/syndicate
	name = "red space helmet"
	icon_state = "syndicate"
	item_state = "syndi_helm"	//not sure why this isn't working, will try to fix before merge, but looks like a deep issue
	desc = "A crimson helmet sporting clean lines and durable plating. Engineered to look menacing."
	light_overlay = "helmet_light_syndi_soft"
	armor = list(
		melee = 35,
		bullet = 35,
		energy = 35,
		bomb = 30,
		bio = 100,
		rad = 50
	)
	siemens_coefficient = 0.4
	spawn_blacklisted = TRUE

/obj/item/clothing/suit/space/syndicate
	name = "red space suit"
	icon_state = "syndicate"
	item_state = "space_suit_syndicate"
	desc = "A crimson spacesuit sporting clean lines and durable plating. Robust, reliable, and slightly suspicious."
	w_class = ITEM_SIZE_NORMAL
	slowdown = 0.5
	armor = list(
		melee = 35,
		bullet = 35,
		energy = 35,
		bomb = 30,
		bio = 100,
		rad = 50
	)
	siemens_coefficient = 0.4
	can_breach = FALSE
	supporting_limbs = list()
	spawn_blacklisted = TRUE
	accompanying_object = /obj/item/clothing/head/space/syndicate

//Black
/obj/item/clothing/head/space/syndicate/black
	name = "black space helmet"
	icon_state = "syndicate_black"
	item_state = "syndi_helm_black"
	desc = "A black helmet sporting clean lines and durable plating. Engineered to look menacing."

/obj/item/clothing/suit/space/syndicate/black
	name = "black space suit"
	icon_state = "syndicate_black"
	item_state = "space_suit_syndicate_black"
	desc = "A black spacesuit sporting clean lines and durable plating. Robust, reliable, and slightly suspicious."
	accompanying_object = /obj/item/clothing/head/space/syndicate/black

//Engi
/obj/item/clothing/head/space/syndicate/engi
	name = "black engi space helmet"
	icon_state = "syndicate_engi"
	item_state = "syndi_helm_engi"
	desc = "A black helmet sporting clean lines and durable plating. Engineered to look menacing."

/obj/item/clothing/suit/space/syndicate/engi
	name = "black engi space suit"
	icon_state = "syndicate_engi"
	item_state = "space_suit_syndicate_engi"
	desc = "A black spacesuit sporting clean lines and durable plating. Robust, reliable, and slightly suspicious."
	accompanying_object = /obj/item/clothing/head/space/syndicate/engi

//medical
/obj/item/clothing/head/space/syndicate/medical
	name = "black medical space helmet"
	icon_state = "syndicate_medical"
	item_state = "syndi_helm_medical"
	desc = "A black helmet sporting clean lines and durable plating. Engineered to look menacing."

/obj/item/clothing/suit/space/syndicate/medical
	name = "black medical space suit"
	icon_state = "syndicate_medical"
	item_state = "space_suit_syndicate_medical"
	desc = "A black spacesuit sporting clean lines and durable plating. Robust, reliable, and slightly suspicious."
	accompanying_object = /obj/item/clothing/head/space/syndicate/medical


///////////////////////Black Market//////////////////////////////

/obj/item/clothing/head/space/syndicate/bm
	name = "tan space helmet"
	icon_state = "syndicate_bm"
	item_state = "syndi_helm_bm"
	desc = "A tan helmet sporting clean lines and durable plating. Engineered to look menacing."

/obj/item/clothing/suit/space/syndicate/bm
	name = "tan space suit"
	icon_state = "syndicate_bm"
	item_state = "space_suit_syndicate_bm"
	desc = "A tan spacesuit sporting clean lines and durable plating. Robust, reliable, and slightly suspicious."
	accompanying_object = /obj/item/clothing/head/space/syndicate/bm

/obj/item/clothing/suit/space/syndicate/bm/Initialize()
	. = ..()
	var/random_icon = rand(1,3)	//33.33% chance to be just tan, 66.66% chance to be black and tan
	if(random_icon == 3)
		icon_state = "syndicate_bm"
		item_state = "space_suit_syndicate_bm"
	else
		icon_state = "syndicate_bm_black"
		item_state = "space_suit_syndicate_bm_black"
