//Regular syndicate space suit
/obj/item/clothing/head/space/syndicate
	name = "red space helmet"
	icon_state = "syndicate"
	item_state = "syndi_helm"	//not sure why this isn't working, will try to fix before merge, but looks like a deep issue
	desc = "A clasic crimson helmet sporting clean lines and durable plating."
	light_overlay = "helmet_light_syndi_soft"
	armor = list(
		melee = 8,
		bullet = 9,
		energy = 8,
		bomb = 150,
		bio = 100,
		rad = 50
	)
	siemens_coefficient = 0.4
	spawn_blacklisted = TRUE

/obj/item/clothing/suit/space/syndicate
	name = "red space suit"
	icon_state = "syndicate"
	item_state = "space_suit_syndicate"
	desc = "A clasic crimson spacesuit sporting clean lines and durable plating."
	w_class = ITEM_SIZE_NORMAL
	armor = list(
		melee = 8,
		bullet = 9,
		energy = 8,
		bomb = 150,
		bio = 100,
		rad = 50
	)
	siemens_coefficient = 0.4
	can_breach = FALSE
	supporting_limbs = list()
	spawn_blacklisted = TRUE
	accompanying_object = /obj/item/clothing/head/space/syndicate
	slowdown = LIGHT_SLOWDOWN

///////////////////////Black Market//////////////////////////////

/obj/item/clothing/head/space/syndicate/uplink
	name = "tan space helmet"
	icon_state = "syndicate_tan"
	item_state = "syndi_helm_tan"
	desc = "A knockoff tan helmet sporting clean lines and durable plating."

/obj/item/clothing/suit/space/syndicate/uplink
	name = "tan space suit"
	icon_state = "syndicate_tan"
	item_state = "space_suit_syndicate_tan"
	desc = "A knockoff tan spacesuit sporting clean lines and durable plating."
	accompanying_object = /obj/item/clothing/head/space/syndicate/uplink

